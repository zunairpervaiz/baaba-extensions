import 'dart:async';

import 'package:flutter/material.dart';

/// A styled search input with a clear button and built-in debounce.
///
/// [onSearch] fires after [debounceDuration] of inactivity.
/// [onChanged] fires on every change to the text — not on a cursor or
/// selection move. The clear button fires [onSearch] with `''` at once.
///
/// Example:
/// ```dart
/// SearchBarWidgetx(
///   hintText: 'Search users…',
///   onSearch: (q) => bloc.search(q),
/// )
/// ```
class SearchBarWidgetx extends StatefulWidget {
  final void Function(String query)? onSearch;
  final void Function(String query)? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final Duration debounceDuration;
  final TextEditingController? controller;
  final Color? backgroundColor;
  final Color? iconColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsets? contentPadding;
  final bool autofocus;

  const SearchBarWidgetx({
    super.key,
    this.onSearch,
    this.onChanged,
    this.onClear,
    this.hintText = 'Search...',
    this.debounceDuration = const Duration(milliseconds: 500),
    this.controller,
    this.backgroundColor,
    this.iconColor,
    this.hintStyle,
    this.textStyle,
    this.borderRadius = 12,
    this.contentPadding,
    this.autofocus = false,
  });

  @override
  State<SearchBarWidgetx> createState() => _SearchBarWidgetxState();
}

class _SearchBarWidgetxState extends State<SearchBarWidgetx> {
  /// Created only when no [SearchBarWidgetx.controller] is supplied, so that
  /// a caller-owned controller is never disposed here.
  TextEditingController? _ownedController;
  Timer? _debounce;
  late bool _hasText;

  /// The text last reported, so that a selection or composing change — which
  /// also notifies the controller's listeners — does not re-fire the callbacks.
  late String _lastText;

  TextEditingController get _controller => widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) _ownedController = TextEditingController();
    _attach();
  }

  @override
  void didUpdateWidget(covariant SearchBarWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == oldWidget.controller) return;
    final previous = oldWidget.controller ?? _ownedController!;
    previous.removeListener(_onTextChanged);
    if (widget.controller == null) {
      // The caller stopped supplying one: take over with its current text.
      _ownedController = TextEditingController(text: previous.text);
    } else if (_ownedController != null) {
      // Disposed after the frame, once the TextField has let go of it.
      final stale = _ownedController!;
      _ownedController = null;
      WidgetsBinding.instance.addPostFrameCallback((_) => stale.dispose());
    }
    _attach();
  }

  void _attach() {
    _lastText = _controller.text;
    _hasText = _lastText.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onTextChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    if (text == _lastText) return;
    _lastText = text;
    final hasText = text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    widget.onChanged?.call(text);
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onSearch?.call(text);
    });
  }

  void _clear() {
    _controller.clear();
    // Clearing schedules a debounced search like any edit; cancel it so the
    // immediate onSearch('') below is the only one.
    _debounce?.cancel();
    widget.onClear?.call();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconClr = widget.iconColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.5);

    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      style: widget.textStyle,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: widget.hintStyle,
        prefixIcon: Icon(Icons.search_rounded, color: iconClr),
        suffixIcon: _hasText
            ? IconButton(
                icon: Icon(Icons.close_rounded, color: iconClr),
                onPressed: _clear,
              )
            : null,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: widget.backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(widget.borderRadius)),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(widget.borderRadius)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(widget.borderRadius)),
      ),
    );
  }
}
