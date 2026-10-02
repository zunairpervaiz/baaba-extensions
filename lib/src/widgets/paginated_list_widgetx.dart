import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollCacheExtent;

import '../dialogx_extensions.dart';
import '../scrollx_extensions.dart';
import '../utils/default_configs.dart';
import '../utils/enums.dart';
import '../utils/paginatorx.dart';
import 'empty_state_widgetx.dart';
import 'skeleton_list_widgetx.dart';

/// Signature for building one row of a [PaginatedListWidgetx].
typedef PaginatedItemBuilderX<T> = Widget Function(BuildContext context, T item, int index);

/// Signature for building an error state, given the error and a retry action.
typedef PaginationErrorBuilderX = Widget Function(BuildContext context, Object? error, VoidCallback retry);

/// An infinite-scrolling list (or grid) that loads the next page before the
/// user reaches the bottom, with built-in loading, empty, and error states,
/// pull-to-refresh, and an optional Retry / Cancel dialog on failure.
///
/// Pass either a fetcher or your own [PaginatorX]:
///
/// ```dart
/// // 1 — simplest: a fetcher that returns a list.
/// PaginatedListWidgetx<User>(
///   fetchItems: (page) => api.getUsers(page: page, limit: 20),
///   itemBuilder: (context, user, index) => UserTile(user),
/// )
///
/// // 2 — cursor or hasMore aware.
/// PaginatedListWidgetx<Post>(
///   fetchPage: (page, cursor) async {
///     final res = await api.feed(cursor: cursor);
///     return PageX(items: res.posts, nextCursor: res.next, hasMore: res.hasMore);
///   },
///   itemBuilder: (context, post, index) => PostCard(post),
///   separator: const Divider(height: 1),
///   errorMode: PaginationErrorMode.dialogOnFirstPage,
/// )
///
/// // 3 — own the controller to mutate the list or refresh from elsewhere.
/// final paginator = PaginatorX<User>(fetchPage: ..., itemId: (u) => u.id);
/// PaginatedListWidgetx<User>(controller: paginator, itemBuilder: ...);
/// paginator.removeWhere((u) => u.id == deletedId); // no refetch
///
/// // 4 — a paginated grid.
/// PaginatedListWidgetx<Photo>(
///   fetchItems: (page) => api.photos(page),
///   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
///     crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8,
///   ),
///   itemBuilder: (context, photo, index) => PhotoTile(photo),
/// )
/// ```
///
/// The next page is requested when either trigger fires: the scroll position
/// comes within [prefetchThreshold] pixels of the end, or one of the last
/// [prefetchItemCount] items is built. The second trigger is what keeps a
/// too-short first page from stranding the list — it loads until the viewport
/// is actually scrollable, capped by [maxAutoFillPages].
///
/// **Changing the query** — when the widget builds its own paginator from
/// [fetchPage] or [fetchItems], a new fetcher passed on rebuild is picked up
/// for every later request, but does not by itself reload: an inline closure
/// is a new object on every build, so reloading on identity would refetch on
/// every parent rebuild. Pass the query or filter as [reloadOn] to reload
/// from the first page when it changes:
///
/// ```dart
/// PaginatedListWidgetx<User>(
///   fetchItems: (page) => api.searchUsers(query, page: page),
///   reloadOn: query,
///   itemBuilder: (context, user, index) => UserTile(user),
/// )
/// ```
///
/// With your own [controller], call [PaginatorX.updateFetcher] instead.
///
/// **Nested inside another scrollable** — with `shrinkWrap: true` and
/// `physics: NeverScrollableScrollPhysics()`, this widget cannot observe the
/// outer scroll view. Pass the outer controller as [parentScrollController] so
/// prefetching still works.
class PaginatedListWidgetx<T> extends StatefulWidget {
  /// Builds a row from its item and index.
  final PaginatedItemBuilderX<T> itemBuilder;

  /// An existing controller to drive. Mutually exclusive with [fetchPage] and
  /// [fetchItems]. When supplied, you own its lifecycle — including `dispose`.
  final PaginatorX<T>? controller;

  /// Loads one page, reporting `hasMore` / `nextCursor` through a [PageX].
  final PageFetcherX<T>? fetchPage;

  /// Loads one page as a plain list; `hasMore` is inferred from [pageSize].
  final SimplePageFetcherX<T>? fetchItems;

  /// Reloads from the first page, with the current [fetchPage] or
  /// [fetchItems], whenever this value changes between builds.
  ///
  /// Use it for a list whose request depends on a search query or filter.
  /// Ignored when a [controller] is supplied — call
  /// [PaginatorX.updateFetcher] on it instead.
  final Object? reloadOn;

  /// Items expected per page, used to infer `hasMore`.
  /// Defaults to `defaultPaginationPageSizeGlobal`.
  final int? pageSize;

  /// The page index sent with the first request.
  final int firstPage;

  /// Optional per-request timeout applied to every page load.
  final Duration? timeout;

  /// Stable item identity used to drop duplicates arriving across pages.
  final Object Function(T item)? itemId;

  /// Whether the first page loads automatically when the widget mounts.
  final bool autoLoad;

  /// Distance from the end of the list, in pixels, at which the next page is
  /// requested. Defaults to `defaultPaginationPrefetchThresholdGlobal`.
  final double? prefetchThreshold;

  /// Requests the next page once one of the last N items is built. Set to `0`
  /// to rely on [prefetchThreshold] alone.
  final int prefetchItemCount;

  /// Safety cap on consecutive pages loaded without any user scroll, so a list
  /// that never becomes scrollable cannot fetch forever.
  final int maxAutoFillPages;

  /// Whether a failure is also surfaced in a Retry / Cancel dialog.
  /// Inline retry is always available regardless of this setting.
  final PaginationErrorMode errorMode;

  /// Whether to wrap the list in a `RefreshIndicator`.
  final bool enableRefresh;

  /// Extra work to run after a pull-to-refresh completes.
  final Future<void> Function()? onRefresh;

  /// Called once per failure, for logging or crash reporting.
  final void Function(Object error, StackTrace? stackTrace)? onError;

  /// Called when the user dismisses the error dialog with Cancel.
  final VoidCallback? onErrorCancelled;

  /// Turns an error into the message shown in the dialog and default error
  /// state. Defaults to a generic connection message.
  final String Function(Object? error)? errorMessageBuilder;

  /// Replaces the first-page loading state. Defaults to a
  /// [SkeletonListWidgetx].
  final WidgetBuilder? loadingBuilder;

  /// Replaces the "loaded but no items" state. Defaults to an
  /// [EmptyStateWidgetx].
  final WidgetBuilder? emptyBuilder;

  /// Replaces the first-page error state. Defaults to an [EmptyStateWidgetx]
  /// with a retry button.
  final PaginationErrorBuilderX? errorBuilder;

  /// Replaces the footer shown while a subsequent page loads. Defaults to a
  /// centred spinner.
  final WidgetBuilder? loadMoreBuilder;

  /// Replaces the footer shown when a subsequent page fails. Defaults to an
  /// inline message with a retry button.
  final PaginationErrorBuilderX? loadMoreErrorBuilder;

  /// Builds a footer shown once every page has been loaded. `null` renders
  /// nothing.
  final WidgetBuilder? endBuilder;

  /// Pinned above the items, inside the scroll view.
  final Widget? header;

  /// Pinned below the items and the pagination footer.
  final Widget? footer;

  /// Grid layout for the items. When `null` a list is rendered.
  final SliverGridDelegate? gridDelegate;

  /// Builds the gap between rows. Ignored when [gridDelegate] is set.
  final IndexedWidgetBuilder? separatorBuilder;

  /// A fixed widget between rows — shorthand for [separatorBuilder].
  final Widget? separator;

  /// Padding around the items. [header] and [footer] sit outside it.
  final EdgeInsets padding;

  /// Scroll controller for this widget's own scroll view.
  final ScrollController? scrollController;

  /// Controller of an *outer* scroll view to observe, for when this list is
  /// nested with `shrinkWrap: true`. Only listened to, never attached.
  final ScrollController? parentScrollController;

  /// Scroll physics for the list.
  final ScrollPhysics? physics;

  /// Whether the list should size itself to its contents.
  final bool shrinkWrap;

  /// Axis the list scrolls along.
  final Axis scrollDirection;

  /// Whether the list is rendered in reverse order — useful for chat threads.
  final bool reverse;

  /// Whether this is the primary scroll view of its context.
  final bool? primary;

  /// Extra area, in pixels, kept built beyond the viewport.
  final double? cacheExtent;

  /// How dragging the list dismisses the on-screen keyboard.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Clip behaviour of the scroll view.
  final Clip clipBehavior;

  /// Restoration id for the scroll offset.
  final String? restorationId;

  /// Title of the error dialog and of the default error state.
  final String? errorTitle;

  /// Label of the retry action.
  final String? retryText;

  /// Label of the cancel action in the error dialog.
  final String? cancelText;

  /// Icon shown in the error dialog.
  final IconData errorDialogIcon;

  /// Icon shown in the default first-page error state.
  final IconData errorIcon;

  /// Colour of the dialog's retry button.
  final Color? retryColor;

  /// Colour of the dialog's cancel button.
  final Color? cancelColor;

  /// Title of the default empty state.
  final String? emptyTitle;

  /// Subtitle of the default empty state.
  final String? emptySubtitle;

  /// Icon of the default empty state.
  final IconData emptyIcon;

  /// Colour of the pull-to-refresh indicator.
  final Color? refreshIndicatorColor;

  const PaginatedListWidgetx({
    super.key,
    required this.itemBuilder,
    this.controller,
    this.fetchPage,
    this.fetchItems,
    this.reloadOn,
    this.pageSize,
    this.firstPage = 1,
    this.timeout,
    this.itemId,
    this.autoLoad = true,
    this.prefetchThreshold,
    this.prefetchItemCount = 3,
    this.maxAutoFillPages = 10,
    this.errorMode = PaginationErrorMode.inline,
    this.enableRefresh = true,
    this.onRefresh,
    this.onError,
    this.onErrorCancelled,
    this.errorMessageBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    this.loadMoreBuilder,
    this.loadMoreErrorBuilder,
    this.endBuilder,
    this.header,
    this.footer,
    this.gridDelegate,
    this.separatorBuilder,
    this.separator,
    this.padding = const EdgeInsets.all(16),
    this.scrollController,
    this.parentScrollController,
    this.physics,
    this.shrinkWrap = false,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.primary,
    this.cacheExtent,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.errorTitle,
    this.retryText,
    this.cancelText,
    this.errorDialogIcon = Icons.cloud_off_rounded,
    this.errorIcon = Icons.cloud_off_rounded,
    this.retryColor,
    this.cancelColor,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.refreshIndicatorColor,
  }) : assert(controller != null || fetchPage != null || fetchItems != null, 'PaginatedListWidgetx needs a controller, fetchPage, or fetchItems.'),
       assert(
         (controller != null ? 1 : 0) + (fetchPage != null ? 1 : 0) + (fetchItems != null ? 1 : 0) == 1,
         'Pass exactly one of controller, fetchPage, or fetchItems.',
       );

  @override
  State<PaginatedListWidgetx<T>> createState() => _PaginatedListWidgetxState<T>();
}

class _PaginatedListWidgetxState<T> extends State<PaginatedListWidgetx<T>> {
  late PaginatorX<T> _paginator;
  bool _ownsPaginator = false;

  bool _loadMoreScheduled = false;
  bool _dialogScheduled = false;
  bool _isDialogVisible = false;
  bool _wasError = false;
  int _errorSeq = 0;
  int _cancelledErrorSeq = -1;
  int _autoFillPages = 0;

  double get _threshold => widget.prefetchThreshold ?? defaultPaginationPrefetchThresholdGlobal;

  @override
  void initState() {
    super.initState();
    _paginator = _resolvePaginator();
    _paginator.addListener(_onPaginatorChanged);
    widget.parentScrollController?.addListener(_onParentScroll);
    if (widget.autoLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _paginator.loadFirstPage();
      });
    }
  }

  @override
  void didUpdateWidget(covariant PaginatedListWidgetx<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.parentScrollController != oldWidget.parentScrollController) {
      oldWidget.parentScrollController?.removeListener(_onParentScroll);
      widget.parentScrollController?.addListener(_onParentScroll);
    }

    // A paginator built from a fetcher takes the latest fetcher on every
    // rebuild, so later pages and refreshes see the current query. Swapping it
    // must not reload by itself — an inline closure differs on every build —
    // so only a changed reloadOn restarts from the first page.
    if (_ownsPaginator && widget.controller == null) {
      final fetcher = _currentFetcher();
      final reload = widget.reloadOn != oldWidget.reloadOn;
      if (fetcher != null && (reload || widget.fetchPage != oldWidget.fetchPage || widget.fetchItems != oldWidget.fetchItems)) {
        if (reload) {
          _autoFillPages = 0;
          _cancelledErrorSeq = -1;
        }
        _paginator.updateFetcher(fetcher, reload: reload);
      }
    }

    // Only an explicitly supplied controller can change identity; a fetcher
    // swap on a caller's controller is handled through
    // PaginatorX.updateFetcher by the caller.
    if (widget.controller != oldWidget.controller) {
      _paginator.removeListener(_onPaginatorChanged);
      if (_ownsPaginator) _paginator.dispose();
      // Dropping the caller's controller falls back to a paginator built from
      // the fetcher; the caller's controller is left for the caller to dispose.
      _paginator = widget.controller ?? _resolvePaginator();
      _ownsPaginator = widget.controller == null;
      _paginator.addListener(_onPaginatorChanged);
      _wasError = _paginator.hasError;
      _autoFillPages = 0;
      if (widget.autoLoad) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _paginator.loadFirstPage();
        });
      }
    }
  }

  @override
  void dispose() {
    widget.parentScrollController?.removeListener(_onParentScroll);
    _paginator.removeListener(_onPaginatorChanged);
    if (_ownsPaginator) _paginator.dispose();
    super.dispose();
  }

  /// The widget's fetcher as a [PageFetcherX], or `null` in controller mode.
  PageFetcherX<T>? _currentFetcher() {
    final fetchPage = widget.fetchPage;
    if (fetchPage != null) return fetchPage;
    final fetchItems = widget.fetchItems;
    if (fetchItems == null) return null;
    // Same adaptation as PaginatorX.simple, so hasMore is still inferred.
    return (page, _) async => PageX<T>(items: await fetchItems(page));
  }

  PaginatorX<T> _resolvePaginator() {
    final existing = widget.controller;
    if (existing != null) return existing;
    _ownsPaginator = true;
    final fetchPage = widget.fetchPage;
    if (fetchPage != null) {
      return PaginatorX<T>(
        fetchPage: fetchPage,
        pageSize: widget.pageSize,
        firstPage: widget.firstPage,
        timeout: widget.timeout,
        itemId: widget.itemId,
      );
    }
    return PaginatorX<T>.simple(
      fetch: widget.fetchItems!,
      pageSize: widget.pageSize,
      firstPage: widget.firstPage,
      timeout: widget.timeout,
      itemId: widget.itemId,
    );
  }

  // ── Triggers ───────────────────────────────────────────────────────

  void _scheduleLoadMore() {
    if (_loadMoreScheduled || !_paginator.canLoadMore) return;
    if (_autoFillPages >= widget.maxAutoFillPages) return;
    _loadMoreScheduled = true;
    // Deferred: this can be reached from inside a build (an item builder).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMoreScheduled = false;
      if (!mounted || !_paginator.canLoadMore) return;
      _autoFillPages++;
      _paginator.loadNextPage();
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // depth 0 keeps a nested scrollable — a horizontal carousel row inside the
    // list, for instance — from triggering our pagination.
    if (notification.depth != 0) return false;
    if (notification is! ScrollUpdateNotification && notification is! ScrollEndNotification) {
      return false;
    }
    final metrics = notification.metrics;
    if (metrics.axis != widget.scrollDirection) return false;
    _autoFillPages = 0;
    if (metrics.pixels >= metrics.maxScrollExtent - _threshold) {
      _scheduleLoadMore();
    }
    return false;
  }

  void _onParentScroll() {
    final controller = widget.parentScrollController;
    if (controller == null || !controller.hasClients) return;
    _autoFillPages = 0;
    if (controller.isNearBottom(threshold: _threshold)) _scheduleLoadMore();
  }

  Future<void> _handleRefresh() async {
    _autoFillPages = 0;
    _cancelledErrorSeq = -1;
    await _paginator.refresh();
    if (!mounted) return;
    await widget.onRefresh?.call();
  }

  // ── Error reporting ────────────────────────────────────────────────

  void _onPaginatorChanged() {
    final hasError = _paginator.hasError;
    if (hasError && !_wasError) {
      _errorSeq++;
      final error = _paginator.error;
      if (error != null) {
        widget.onError?.call(error, _paginator.stackTrace);
      }
    }
    _wasError = hasError;
    if (hasError) _scheduleErrorDialog();
  }

  void _scheduleErrorDialog() {
    if (widget.errorMode == PaginationErrorMode.inline) return;
    if (_isDialogVisible || _dialogScheduled) return;
    if (_cancelledErrorSeq == _errorSeq) return;
    if (widget.errorMode == PaginationErrorMode.dialogOnFirstPage && _paginator.status != PaginationStatus.firstPageError) {
      return;
    }
    _dialogScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _showErrorDialog());
  }

  Future<void> _showErrorDialog() async {
    _dialogScheduled = false;
    if (!mounted || _isDialogVisible || !_paginator.hasError) return;
    // Do not throw a dialog over a screen the user has already left.
    if (ModalRoute.of(context)?.isCurrent == false) return;

    final seq = _errorSeq;
    _isDialogVisible = true;
    final retryRequested = await context.showConfirmDialog(
      title: widget.errorTitle ?? defaultPaginationErrorTitleGlobal,
      message: _errorMessage(_paginator.error),
      confirmText: widget.retryText ?? defaultPaginationRetryTextGlobal,
      cancelText: widget.cancelText ?? defaultPaginationCancelTextGlobal,
      icon: widget.errorDialogIcon,
      barrierDismissible: false,
      confirmColor: widget.retryColor,
      cancelColor: widget.cancelColor,
    );
    _isDialogVisible = false;
    if (!mounted) return;
    if (retryRequested == true) {
      _autoFillPages = 0;
      _paginator.retry();
    } else {
      // Remember the dismissal so the dialog does not immediately reappear,
      // and stop auto-loading until the user retries deliberately.
      _cancelledErrorSeq = seq;
      widget.onErrorCancelled?.call();
      _paginator.pause();
    }
  }

  String _errorMessage(Object? error) {
    final builder = widget.errorMessageBuilder;
    if (builder != null) return builder(error);
    if (error is TimeoutException) return defaultPaginationTimeoutMessageGlobal;
    return defaultPaginationErrorMessageGlobal;
  }

  void _retry() {
    _autoFillPages = 0;
    _cancelledErrorSeq = -1;
    _paginator.retry();
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _paginator,
      builder: (context, _) {
        Widget child = _paginator.itemCount == 0 ? _buildPlaceholder(context) : _buildScrollView(context);

        child = NotificationListener<ScrollNotification>(onNotification: _onScrollNotification, child: child);

        if (!widget.enableRefresh) return child;
        return RefreshIndicator(onRefresh: _handleRefresh, color: widget.refreshIndicatorColor, child: child);
      },
    );
  }

  ScrollPhysics? get _resolvedPhysics => widget.physics ?? (widget.enableRefresh ? const AlwaysScrollableScrollPhysics() : null);

  Widget _buildPlaceholder(BuildContext context) {
    if (_paginator.hasError) {
      return _fillViewport(widget.errorBuilder?.call(context, _paginator.error, _retry) ?? _defaultErrorState(context));
    }
    if (_paginator.status == PaginationStatus.empty) {
      return _fillViewport(widget.emptyBuilder?.call(context) ?? _defaultEmptyState(context));
    }
    // Nothing has been requested and nothing will be until the caller asks —
    // a shimmer here would promise a load that is not happening.
    if (_paginator.status == PaginationStatus.initial && !widget.autoLoad) {
      return _fillViewport(const SizedBox.shrink());
    }
    return widget.loadingBuilder?.call(context) ?? SkeletonListWidgetx(padding: widget.padding);
  }

  /// Keeps the empty and error states centred and still pull-to-refreshable.
  Widget _fillViewport(Widget child) {
    if (widget.shrinkWrap) return child;
    return CustomScrollView(
      controller: widget.scrollController,
      physics: _resolvedPhysics,
      scrollDirection: widget.scrollDirection,
      primary: widget.primary,
      clipBehavior: widget.clipBehavior,
      slivers: [SliverFillRemaining(hasScrollBody: false, child: Center(child: child))],
    );
  }

  Widget _buildScrollView(BuildContext context) {
    final paginationFooter = _buildPaginationFooter(context);
    return CustomScrollView(
      controller: widget.scrollController,
      physics: _resolvedPhysics,
      shrinkWrap: widget.shrinkWrap,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      primary: widget.primary,
      scrollCacheExtent: widget.cacheExtent == null ? null : ScrollCacheExtent.pixels(widget.cacheExtent!),
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      clipBehavior: widget.clipBehavior,
      restorationId: widget.restorationId,
      slivers: [
        if (widget.header != null) SliverToBoxAdapter(child: widget.header),
        SliverPadding(padding: widget.padding, sliver: _buildItemsSliver()),
        if (paginationFooter != null) SliverToBoxAdapter(child: paginationFooter),
        if (widget.footer != null) SliverToBoxAdapter(child: widget.footer),
      ],
    );
  }

  Widget _buildItemsSliver() {
    final count = _paginator.itemCount;
    final gridDelegate = widget.gridDelegate;
    if (gridDelegate != null) {
      return SliverGrid.builder(gridDelegate: gridDelegate, itemCount: count, itemBuilder: _buildItem);
    }
    final separatorBuilder = widget.separatorBuilder;
    final separator = widget.separator;
    if (separatorBuilder != null || separator != null) {
      return SliverList.separated(
        itemCount: count,
        itemBuilder: _buildItem,
        separatorBuilder: separatorBuilder ?? (context, index) => separator ?? const SizedBox.shrink(),
      );
    }
    return SliverList.builder(itemCount: count, itemBuilder: _buildItem);
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= _paginator.itemCount) return const SizedBox.shrink();
    if (widget.prefetchItemCount > 0 && index >= _paginator.itemCount - widget.prefetchItemCount) {
      _scheduleLoadMore();
    }
    return widget.itemBuilder(context, _paginator.items[index], index);
  }

  Widget? _buildPaginationFooter(BuildContext context) {
    if (_paginator.isLoadingMore) {
      return widget.loadMoreBuilder?.call(context) ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5))),
          );
    }
    if (_paginator.status == PaginationStatus.loadMoreError) {
      return widget.loadMoreErrorBuilder?.call(context, _paginator.error, _retry) ?? _defaultLoadMoreErrorFooter(context);
    }
    if (!_paginator.hasMore) return widget.endBuilder?.call(context);
    return null;
  }

  Widget _defaultLoadMoreErrorFooter(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.errorIcon, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _errorMessage(_paginator.error),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(onPressed: _retry, child: Text(widget.retryText ?? defaultPaginationRetryTextGlobal)),
        ],
      ),
    );
  }

  Widget _defaultErrorState(BuildContext context) {
    return EmptyStateWidgetx(
      title: widget.errorTitle ?? defaultPaginationErrorTitleGlobal,
      subtitle: _errorMessage(_paginator.error),
      icon: widget.errorIcon,
      actionText: widget.retryText ?? defaultPaginationRetryTextGlobal,
      onAction: _retry,
      actionColor: widget.retryColor,
    );
  }

  Widget _defaultEmptyState(BuildContext context) {
    return EmptyStateWidgetx(title: widget.emptyTitle ?? defaultPaginationEmptyTitleGlobal, subtitle: widget.emptySubtitle, icon: widget.emptyIcon);
  }
}
