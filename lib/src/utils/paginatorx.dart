import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'default_configs.dart';
import 'enums.dart';

/// Signature for a function that loads one page of data.
///
/// [page] is the page index counted from [PaginatorX.firstPage], and [cursor]
/// is the `nextCursor` returned by the previous page — `null` for the first
/// page and for APIs that do not use cursors.
typedef PageFetcherX<T> = Future<PageX<T>> Function(int page, String? cursor);

/// Signature for a page fetcher that returns a plain list instead of a [PageX].
typedef SimplePageFetcherX<T> = Future<List<T>> Function(int page);

/// One page of results returned by a [PageFetcherX].
///
/// Example:
/// ```dart
/// return PageX(items: res.users, hasMore: res.page < res.lastPage);
/// ```
@immutable
class PageX<T> {
  /// The items belonging to this page.
  final List<T> items;

  /// Whether another page exists after this one.
  ///
  /// Leave `null` to let [PaginatorX] infer it — the list is then treated as
  /// finished as soon as a page returns fewer than `pageSize` items.
  final bool? hasMore;

  /// Opaque cursor or token used to request the page after this one.
  final String? nextCursor;

  /// Total number of items available on the server, when the API reports it.
  final int? totalCount;

  const PageX({required this.items, this.hasMore, this.nextCursor, this.totalCount});

  /// Returns an empty, final page — a convenient early return in a fetcher.
  factory PageX.empty() => PageX<T>(items: <T>[], hasMore: false);
}

/// A state-management-agnostic pagination controller.
///
/// It owns the accumulated items, the page and cursor bookkeeping, and the
/// loading and error state. It also guards the races a hand-rolled paginator
/// usually trips over: re-entrant page loads, responses that arrive after a
/// refresh, responses that arrive after disposal, duplicate rows across pages,
/// and servers that keep claiming `hasMore` while returning nothing new.
///
/// Being a [ChangeNotifier], it works with `ListenableBuilder`,
/// `AnimatedBuilder`, Provider, Bloc or plain `setState`.
/// [PaginatedListWidgetx] drives one of these for you.
///
/// Example:
/// ```dart
/// final paginator = PaginatorX<User>(
///   pageSize: 20,
///   itemId: (u) => u.id,
///   fetchPage: (page, cursor) async {
///     final res = await api.users(page: page, limit: 20);
///     return PageX(items: res.users, hasMore: res.hasNext);
///   },
/// );
///
/// await paginator.loadFirstPage();
/// await paginator.loadNextPage();
/// await paginator.refresh();
/// paginator.dispose();
/// ```
class PaginatorX<T> extends ChangeNotifier {
  /// Creates a paginator driven by a [PageFetcherX].
  PaginatorX({required this._fetchPage, int? pageSize, this.firstPage = 1, this.timeout, this.itemId})
    : pageSize = pageSize ?? defaultPaginationPageSizeGlobal {
    _page = firstPage;
  }

  /// Creates a paginator from a fetcher that returns a plain `List<T>`.
  ///
  /// `hasMore` is inferred: the list is finished as soon as a page returns
  /// fewer than [pageSize] items. Use the default constructor when the API
  /// reports `hasMore` explicitly or paginates by cursor.
  ///
  /// Example:
  /// ```dart
  /// PaginatorX.simple(fetch: (page) => api.getUsers(page: page, limit: 20));
  /// ```
  PaginatorX.simple({required SimplePageFetcherX<T> fetch, int? pageSize, this.firstPage = 1, this.timeout, this.itemId})
    : _fetchPage = ((page, _) async => PageX<T>(items: await fetch(page))),
      pageSize = pageSize ?? defaultPaginationPageSizeGlobal {
    _page = firstPage;
  }

  /// Expected number of items per page, used to infer `hasMore`.
  final int pageSize;

  /// The page index sent with the first request. Defaults to `1`.
  final int firstPage;

  /// Optional per-request timeout. A timed-out request fails like any other
  /// error, so the normal retry path applies.
  final Duration? timeout;

  /// Optional stable identity for an item, used to drop duplicates that arrive
  /// across pages — common when rows shift on the server between requests.
  ///
  /// Example: `itemId: (user) => user.id`
  final Object Function(T item)? itemId;

  PageFetcherX<T> _fetchPage;

  final List<T> _items = <T>[];
  final Set<Object> _seenIds = <Object>{};

  late int _page;
  String? _cursor;
  int? _totalCount;
  bool _hasMore = true;
  bool _isFetching = false;
  bool _isPaused = false;
  bool _isDisposed = false;
  bool _lastWasRefresh = false;
  int _generation = 0;
  Object? _error;
  StackTrace? _stackTrace;
  PaginationStatus _status = PaginationStatus.initial;

  /// The accumulated items across every loaded page.
  ///
  /// This is a live unmodifiable view, cheap to read from an `itemBuilder`.
  /// Use the mutation helpers ([addItem], [removeWhere], [updateWhere], …) to
  /// change it.
  late final UnmodifiableListView<T> items = UnmodifiableListView<T>(_items);

  /// Returns the number of loaded items.
  int get itemCount => _items.length;

  /// The current lifecycle state.
  PaginationStatus get status => _status;

  /// The error thrown by the most recent failed load, or `null`.
  Object? get error => _error;

  /// The stack trace of the most recent failed load, or `null`.
  StackTrace? get stackTrace => _stackTrace;

  /// Returns `true` while the server reports — or [pageSize] implies — that
  /// more pages remain.
  bool get hasMore => _hasMore;

  /// The page index that will be requested next.
  int get nextPage => _page;

  /// The cursor that will be sent with the next request, if any.
  String? get cursor => _cursor;

  /// Total items available on the server when the API reports it, else `null`.
  int? get totalCount => _totalCount;

  /// Returns `true` while auto-loading is suspended by [pause] — set when the
  /// user dismisses the error dialog with Cancel.
  bool get isPaused => _isPaused;

  /// Returns `true` while any page request is in flight.
  bool get isLoading => _status == PaginationStatus.loadingFirst || _status == PaginationStatus.loadingMore || _status == PaginationStatus.refreshing;

  /// Returns `true` while the first page is loading into an empty list.
  bool get isLoadingFirstPage => _status == PaginationStatus.loadingFirst;

  /// Returns `true` while a subsequent page is loading.
  bool get isLoadingMore => _status == PaginationStatus.loadingMore;

  /// Returns `true` while a [refresh] is in flight.
  bool get isRefreshing => _status == PaginationStatus.refreshing;

  /// Returns `true` when the most recent load failed and has not been retried.
  bool get hasError => _status == PaginationStatus.firstPageError || _status == PaginationStatus.loadMoreError;

  /// Returns `true` when a load succeeded and produced no items at all.
  bool get isEmpty => _status == PaginationStatus.empty;

  /// Returns `true` when another page may be requested right now.
  ///
  /// `false` while a request is in flight, after a failure until [retry] is
  /// called, once the end of the list is reached, and while [isPaused].
  bool get canLoadMore => !_isDisposed && _hasMore && !_isFetching && !_isPaused && !hasError;

  /// Loads the first page unless it has already been requested.
  ///
  /// Safe to call from `initState` and on every rebuild — it is a no-op once
  /// loading has started. Pass `force: true` to reload from scratch.
  Future<void> loadFirstPage({bool force = false}) {
    if (_isDisposed) return Future<void>.value();
    if (force) return refresh();
    if (_status != PaginationStatus.initial || _isFetching) {
      return Future<void>.value();
    }
    return _fetch(isRefresh: false);
  }

  /// Loads the next page. No-op unless [canLoadMore] is `true`.
  Future<void> loadNextPage() {
    if (!canLoadMore) return Future<void>.value();
    return _fetch(isRefresh: false);
  }

  /// Reloads from the first page, keeping the current items on screen until
  /// the new ones arrive. Wire this to a `RefreshIndicator`.
  ///
  /// A refresh pre-empts an in-flight page load: the older response is
  /// discarded when it lands, so items can never interleave across
  /// generations.
  Future<void> refresh() {
    if (_isDisposed) return Future<void>.value();
    return _fetch(isRefresh: true);
  }

  /// Retries whichever request failed last — page load or refresh — and clears
  /// the paused flag. No-op when there is no error.
  Future<void> retry() {
    if (_isDisposed || !hasError) return Future<void>.value();
    _isPaused = false;
    return _fetch(isRefresh: _lastWasRefresh);
  }

  /// Suspends automatic page loading until [retry] or [resume] is called.
  ///
  /// Used when the user cancels the error dialog, so that scrolling does not
  /// immediately re-trigger the request that just failed.
  void pause() {
    if (_isPaused) return;
    _isPaused = true;
    _safeNotify();
  }

  /// Clears the paused flag and the current error, optionally requesting the
  /// next page straight away.
  Future<void> resume({bool loadMore = true}) {
    if (_isDisposed) return Future<void>.value();
    _isPaused = false;
    if (hasError) {
      _status = _items.isEmpty ? PaginationStatus.initial : PaginationStatus.loaded;
    }
    _error = null;
    _stackTrace = null;
    _safeNotify();
    return loadMore ? loadNextPage() : Future<void>.value();
  }

  /// Clears every item and all pagination state, returning to
  /// [PaginationStatus.initial]. Any in-flight response is discarded.
  void reset({bool notify = true}) {
    _generation++;
    _isFetching = false;
    _items.clear();
    _seenIds.clear();
    _page = firstPage;
    _cursor = null;
    _totalCount = null;
    _hasMore = true;
    _isPaused = false;
    _error = null;
    _stackTrace = null;
    _status = PaginationStatus.initial;
    if (notify) _safeNotify();
  }

  /// Swaps the fetcher — for a changed search term or filter — and reloads
  /// from the first page by default.
  ///
  /// Example:
  /// ```dart
  /// onSearchChanged: (q) => paginator.updateFetcher(
  ///   (page, _) async => PageX(items: await api.search(q, page: page)),
  /// );
  /// ```
  Future<void> updateFetcher(PageFetcherX<T> fetchPage, {bool reload = true}) {
    if (_isDisposed) return Future<void>.value();
    _fetchPage = fetchPage;
    if (!reload) {
      _safeNotify();
      return Future<void>.value();
    }
    reset(notify: false);
    return _fetch(isRefresh: false);
  }

  // ── Local mutations ────────────────────────────────────────────────
  // Reflect an optimistic create / edit / delete without refetching.

  /// Appends [item] to the end of the list.
  void addItem(T item) => _mutate(() {
    if (_registerId(item)) _items.add(item);
  });

  /// Appends every item in [newItems], skipping duplicates when [itemId] is set.
  void addItems(Iterable<T> newItems) => _mutate(() {
    for (final item in newItems) {
      if (_registerId(item)) _items.add(item);
    }
  });

  /// Inserts [item] at [index], clamped into range.
  void insertItem(int index, T item) => _mutate(() {
    if (_registerId(item)) _items.insert(index.clamp(0, _items.length), item);
  });

  /// Removes the item at [index]. No-op when [index] is out of range.
  void removeAt(int index) => _mutate(() {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    _reindexIds();
  });

  /// Removes every item matching [test].
  void removeWhere(bool Function(T item) test) => _mutate(() {
    _items.removeWhere(test);
    _reindexIds();
  });

  /// Replaces the item at [index] with [item]. No-op when out of range.
  void replaceAt(int index, T item) => _mutate(() {
    if (index < 0 || index >= _items.length) return;
    _items[index] = item;
    _reindexIds();
  });

  /// Replaces every item matching [test] with the result of `update(item)`.
  ///
  /// Example:
  /// ```dart
  /// paginator.updateWhere((u) => u.id == id, (u) => u.copyWith(liked: true));
  /// ```
  void updateWhere(bool Function(T item) test, T Function(T item) update) => _mutate(() {
    var changed = false;
    for (var i = 0; i < _items.length; i++) {
      if (test(_items[i])) {
        _items[i] = update(_items[i]);
        changed = true;
      }
    }
    if (changed) _reindexIds();
  });

  /// Replaces the whole list, leaving page and cursor bookkeeping untouched.
  void setItems(Iterable<T> newItems) => _mutate(() {
    _items
      ..clear()
      ..addAll(newItems);
    _reindexIds();
  });

  /// Removes every item but keeps `hasMore`, the page index and the cursor, so
  /// the next [loadNextPage] continues where it left off. Use [reset] to start
  /// over instead.
  void clearItems() => _mutate(() {
    _items.clear();
    _seenIds.clear();
  });

  // ── Internals ──────────────────────────────────────────────────────

  Future<void> _fetch({required bool isRefresh}) async {
    if (_isDisposed) return;
    // A refresh pre-empts an in-flight load; a load never pre-empts anything.
    if (_isFetching && !isRefresh) return;

    final generation = ++_generation;
    _isFetching = true;
    _lastWasRefresh = isRefresh;
    _error = null;
    _stackTrace = null;
    if (_items.isEmpty) {
      _status = PaginationStatus.loadingFirst;
    } else {
      _status = isRefresh ? PaginationStatus.refreshing : PaginationStatus.loadingMore;
    }
    _safeNotify();

    try {
      final targetPage = isRefresh ? firstPage : _page;
      final targetCursor = isRefresh ? null : _cursor;
      final request = _fetchPage(targetPage, targetCursor);
      final page = timeout == null ? await request : await request.timeout(timeout!);

      // Discard a response a newer generation has superseded.
      if (_isDisposed || generation != _generation) return;

      if (isRefresh) {
        _items.clear();
        _seenIds.clear();
      }

      final added = _appendUnique(page.items);
      _cursor = page.nextCursor;
      _totalCount = page.totalCount ?? _totalCount;
      _hasMore = page.hasMore ?? (page.items.length >= pageSize);

      // Stop even if the server insists there is more: an empty page, or a page
      // that added nothing new and gave no fresh cursor, would loop forever.
      if (page.items.isEmpty || (added == 0 && page.nextCursor == null)) {
        _hasMore = false;
      }

      _page = isRefresh ? firstPage + 1 : _page + 1;
      _status = _items.isEmpty ? PaginationStatus.empty : PaginationStatus.loaded;
    } catch (e, st) {
      if (_isDisposed || generation != _generation) return;
      _error = e;
      _stackTrace = st;
      _status = _items.isEmpty ? PaginationStatus.firstPageError : PaginationStatus.loadMoreError;
    } finally {
      // Only the current generation owns the flag — a superseded response must
      // not clear it out from under the request that replaced it.
      if (!_isDisposed && generation == _generation) {
        _isFetching = false;
        _safeNotify();
      }
    }
  }

  int _appendUnique(List<T> incoming) {
    final selector = itemId;
    if (selector == null) {
      _items.addAll(incoming);
      return incoming.length;
    }
    var added = 0;
    for (final item in incoming) {
      if (_seenIds.add(selector(item))) {
        _items.add(item);
        added++;
      }
    }
    return added;
  }

  bool _registerId(T item) {
    final selector = itemId;
    if (selector == null) return true;
    return _seenIds.add(selector(item));
  }

  void _reindexIds() {
    final selector = itemId;
    if (selector == null) return;
    _seenIds
      ..clear()
      ..addAll(_items.map(selector));
  }

  void _mutate(VoidCallback action) {
    if (_isDisposed) return;
    action();
    if (_items.isEmpty && _status == PaginationStatus.loaded) {
      _status = PaginationStatus.empty;
    } else if (_items.isNotEmpty && _status == PaginationStatus.empty) {
      _status = PaginationStatus.loaded;
    }
    _safeNotify();
  }

  void _safeNotify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _generation++;
    super.dispose();
  }
}
