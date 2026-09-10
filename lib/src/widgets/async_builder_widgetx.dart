import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/default_configs.dart';
import 'empty_state_widgetx.dart';

/// Signature for building the data state of an [AsyncBuilderWidgetx].
typedef AsyncDataBuilderX<T> = Widget Function(BuildContext context, T data);

/// Signature for building the error state, given the error and a retry action.
typedef AsyncErrorBuilderX = Widget Function(BuildContext context, Object error, VoidCallback retry);

/// A [FutureBuilder] with the loading, empty, and error states already wired.
///
/// [PaginatedListWidgetx] solves this for paginated lists; this solves it for
/// every single-shot fetch — a profile screen, a detail page, a dashboard
/// card. The future is created once and held, so a rebuild does not refire the
/// request, and [retry] re-runs it on demand.
///
/// Example:
/// ```dart
/// AsyncBuilderWidgetx<Profile>(
///   future: () => api.getProfile(userId),
///   builder: (context, profile) => ProfileView(profile),
/// )
///
/// // A list, with the empty state handled automatically.
/// AsyncBuilderWidgetx<List<Order>>(
///   future: () => api.getOrders(),
///   emptyTitle: 'No orders yet',
///   enableRefresh: true,
///   builder: (context, orders) => Column(
///     children: orders.map(OrderTile.new).toList(),
///   ),
/// )
///
/// // Refetch whenever the id changes.
/// AsyncBuilderWidgetx<Product>(
///   future: () => api.getProduct(id),
///   reloadOn: id,
///   builder: (context, product) => ProductView(product),
/// )
///
/// // Live data.
/// AsyncBuilderWidgetx<int>.stream(
///   stream: counter.stream,
///   builder: (context, value) => Text('$value'),
/// )
/// ```
class AsyncBuilderWidgetx<T> extends StatefulWidget {
  /// Creates the future to watch.
  ///
  /// This is a factory, not a future, so that [retry] and [reloadOn] can run
  /// it again. It is called once on mount and never during a plain rebuild.
  final Future<T> Function()? future;

  /// The stream to watch, as an alternative to [future].
  final Stream<T>? stream;

  /// Builds the UI once data has arrived.
  final AsyncDataBuilderX<T> builder;

  /// Shown while the first result is pending.
  /// Defaults to a centered [CircularProgressIndicator].
  final WidgetBuilder? loadingBuilder;

  /// Shown when the future or stream fails.
  /// Defaults to an [EmptyStateWidgetx] with a retry action.
  final AsyncErrorBuilderX? errorBuilder;

  /// Shown when the result is considered empty by [isEmpty].
  /// Defaults to an [EmptyStateWidgetx].
  final WidgetBuilder? emptyBuilder;

  /// Decides whether a result should render the empty state.
  ///
  /// Defaults to treating `null`, an empty [Iterable], an empty [Map], and a
  /// blank [String] as empty; anything else is data.
  final bool Function(T data)? isEmpty;

  /// Re-runs [future] whenever this value changes between builds.
  ///
  /// Use it for a screen whose request depends on an id, a filter, or a query.
  final Object? reloadOn;

  /// Rendered immediately instead of the loading state, when available.
  final T? initialData;

  /// When `true` the previous data stays on screen during a [retry] or a
  /// [reloadOn] change, instead of falling back to the loading state.
  final bool keepPreviousData;

  /// When `true` the data state is wrapped in a pull-to-refresh scroll view.
  ///
  /// The content becomes scrollable, so do not enable it around a child that
  /// already scrolls.
  final bool enableRefresh;

  /// Called after a successful pull-to-refresh or [retry].
  final VoidCallback? onRefresh;

  /// Called whenever the future or stream fails. Use it for crash reporting.
  final void Function(Object error, StackTrace? stackTrace)? onError;

  /// Called once each time data arrives successfully.
  final void Function(T data)? onData;

  /// Maps an error to the message shown in the default error state.
  /// Defaults to [defaultAsyncErrorMessageGlobal], with a distinct message
  /// for [TimeoutException].
  final String Function(Object error)? errorMessageBuilder;

  /// Title of the default error state. Defaults to [defaultAsyncErrorTitleGlobal].
  final String? errorTitle;

  /// Label of the retry button. Defaults to [defaultAsyncRetryTextGlobal].
  final String? retryText;

  /// Title of the default empty state. Defaults to [defaultAsyncEmptyTitleGlobal].
  final String? emptyTitle;

  /// Subtitle of the default empty state.
  final String? emptySubtitle;

  /// Icon of the default empty state.
  final IconData emptyIcon;

  /// Icon of the default error state.
  final IconData errorIcon;

  const AsyncBuilderWidgetx({
    super.key,
    required this.future,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.isEmpty,
    this.reloadOn,
    this.initialData,
    this.keepPreviousData = false,
    this.enableRefresh = false,
    this.onRefresh,
    this.onError,
    this.onData,
    this.errorMessageBuilder,
    this.errorTitle,
    this.retryText,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.errorIcon = Icons.cloud_off_rounded,
  }) : stream = null;

  /// Watches a [Stream] instead of a future.
  ///
  /// [retry] and [reloadOn] do not apply — the stream itself controls when new
  /// values arrive — so no retry action is offered in the error state.
  const AsyncBuilderWidgetx.stream({
    super.key,
    required this.stream,
    required this.builder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.isEmpty,
    this.initialData,
    this.onError,
    this.onData,
    this.errorMessageBuilder,
    this.errorTitle,
    this.retryText,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon = Icons.inbox_outlined,
    this.errorIcon = Icons.cloud_off_rounded,
  }) : future = null,
       reloadOn = null,
       keepPreviousData = true,
       enableRefresh = false,
       onRefresh = null;

  @override
  State<AsyncBuilderWidgetx<T>> createState() => AsyncBuilderWidgetxState<T>();
}

/// State for [AsyncBuilderWidgetx], exposed so a [GlobalKey] can call [retry].
class AsyncBuilderWidgetxState<T> extends State<AsyncBuilderWidgetx<T>> {
  Future<T>? _future;
  T? _lastData;
  Object? _reportedError;

  @override
  void initState() {
    super.initState();
    _lastData = widget.initialData;
    _start();
  }

  @override
  void didUpdateWidget(covariant AsyncBuilderWidgetx<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // A plain rebuild must not refire the request — only an explicit change of
    // the reload key or of the fetcher itself does.
    if (widget.reloadOn != oldWidget.reloadOn || widget.future != oldWidget.future) _start();
  }

  void _start() {
    final fetcher = widget.future;
    if (fetcher == null) return;
    _reportedError = null;
    if (!widget.keepPreviousData) _lastData = null;
    _future = fetcher();
  }

  /// Re-runs the future and rebuilds. Has no effect in stream mode.
  void retry() {
    if (widget.future == null) return;
    setState(_start);
    widget.onRefresh?.call();
  }

  Future<void> _handleRefresh() async {
    final fetcher = widget.future;
    if (fetcher == null) return;
    final next = fetcher();
    setState(() {
      _reportedError = null;
      _future = next;
    });
    // Swallow the error here — the builder below already renders it.
    await next.catchError((_) => _lastData as T);
    widget.onRefresh?.call();
  }

  bool _isEmpty(T data) {
    final custom = widget.isEmpty;
    if (custom != null) return custom(data);
    final Object? value = data;
    if (value == null) return true;
    if (value is Iterable) return value.isEmpty;
    if (value is Map) return value.isEmpty;
    if (value is String) return value.trim().isEmpty;
    return false;
  }

  String _messageFor(Object error) {
    if (widget.errorMessageBuilder != null) return widget.errorMessageBuilder!(error);
    if (error is TimeoutException) return defaultPaginationTimeoutMessageGlobal;
    return defaultAsyncErrorMessageGlobal;
  }

  Widget _buildLoading(BuildContext context) =>
      widget.loadingBuilder?.call(context) ??
      const Center(
        child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()),
      );

  Widget _buildError(BuildContext context, Object error) {
    if (widget.errorBuilder != null) return widget.errorBuilder!(context, error, retry);
    return EmptyStateWidgetx(
      title: widget.errorTitle ?? defaultAsyncErrorTitleGlobal,
      subtitle: _messageFor(error),
      icon: widget.errorIcon,
      // A stream cannot be re-run from here, so no retry action is offered.
      actionText: widget.future == null ? null : (widget.retryText ?? defaultAsyncRetryTextGlobal),
      onAction: widget.future == null ? null : retry,
    );
  }

  Widget _buildEmpty(BuildContext context) {
    if (widget.emptyBuilder != null) return widget.emptyBuilder!(context);
    return EmptyStateWidgetx(title: widget.emptyTitle ?? defaultAsyncEmptyTitleGlobal, subtitle: widget.emptySubtitle, icon: widget.emptyIcon);
  }

  Widget _wrapRefresh(Widget child) {
    if (!widget.enableRefresh || widget.future == null) return child;
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: LayoutBuilder(
        builder: (_, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildFor(BuildContext context, AsyncSnapshot<T> snapshot) {
    if (snapshot.hasError) {
      final error = snapshot.error!;
      // Report each distinct failure once, after the frame, so that a
      // reporting callback never calls setState during a build.
      if (!identical(_reportedError, error)) {
        _reportedError = error;
        final onError = widget.onError;
        if (onError != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => onError(error, snapshot.stackTrace));
        }
      }
      // Previous data outranks the error when the caller asked to keep it.
      if (widget.keepPreviousData && _lastData != null) return _wrapRefresh(widget.builder(context, _lastData as T));
      return _wrapRefresh(_buildError(context, error));
    }

    if (snapshot.hasData) {
      final data = snapshot.data as T;
      if (!identical(_lastData, data)) {
        _lastData = data;
        final onData = widget.onData;
        if (onData != null) WidgetsBinding.instance.addPostFrameCallback((_) => onData(data));
      }
      if (_isEmpty(data)) return _wrapRefresh(_buildEmpty(context));
      return _wrapRefresh(widget.builder(context, data));
    }

    if (widget.keepPreviousData && _lastData != null) return _wrapRefresh(widget.builder(context, _lastData as T));
    return _buildLoading(context);
  }

  @override
  Widget build(BuildContext context) {
    final stream = widget.stream;
    if (stream != null) {
      return StreamBuilder<T>(stream: stream, initialData: widget.initialData, builder: _buildFor);
    }
    return FutureBuilder<T>(future: _future, initialData: widget.initialData, builder: _buildFor);
  }
}
