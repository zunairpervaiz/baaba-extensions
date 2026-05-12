import 'dart:async';
import 'package:flutter/material.dart';

/// A styled search input with a clear button and built-in debounce.
///
/// [onSearch] fires after [debounceDuration] of inactivity.
/// [onChanged] fires on every keystroke.
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
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    widget.onChanged?.call(_controller.text);
    _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onSearch?.call(_controller.text);
    });
  }

  void _clear() {
    _controller.clear();
    widget.onClear?.call();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconClr = widget.iconColor ??
        theme.colorScheme.onSurface.withValues(alpha: 0.5);

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
        contentPadding: widget.contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: widget.backgroundColor ??
            theme.colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}
