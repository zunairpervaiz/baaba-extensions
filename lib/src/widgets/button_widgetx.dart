import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/default_configs.dart';
import '../utils/enums.dart';

/// A button that understands asynchronous work.
///
/// When [onPressed] returns a [Future], the button disables itself, swaps its
/// label for a spinner, and restores itself once the future settles — so the
/// usual `bool _isLoading` + `setState` boilerplate is no longer needed, and a
/// second tap cannot fire while the first is still running.
///
/// Example:
/// ```dart
/// ButtonWidgetx(
///   text: 'Save',
///   icon: Icons.check_rounded,
///   onPressed: () async => await api.saveProfile(form.values),
/// )
///
/// // Destructive action, full width.
/// ButtonWidgetx.danger(
///   text: 'Delete account',
///   expand: true,
///   onPressed: () => api.deleteAccount(),
/// )
///
/// // Driven by external state (Bloc, Provider, Riverpod).
/// ButtonWidgetx(
///   text: 'Submit',
///   isLoading: state.isSubmitting,
///   onPressed: () => bloc.add(Submitted()),
/// )
/// ```
class ButtonWidgetx extends StatefulWidget {
  /// The label rendered inside the button.
  ///
  /// Ignored when [child] is supplied.
  final String text;

  /// Called when the button is tapped.
  ///
  /// May be synchronous or return a [Future]. While a returned future is
  /// pending the button shows [loadingIndicator] and ignores further taps.
  /// Passing `null` disables the button.
  final FutureOr<void> Function()? onPressed;

  /// Called when the button is long-pressed. Ignored while loading.
  final VoidCallback? onLongPress;

  /// The visual style of the button. Defaults to [ButtonVariantX.filled].
  final ButtonVariantX variant;

  /// The height and typography scale. Defaults to [ButtonSizeX.medium].
  final ButtonSizeX size;

  /// Forces the loading state on, regardless of [onPressed].
  ///
  /// Use this when the loading flag lives in your own state management. The
  /// button is busy when this is `true` *or* an internal future is pending.
  final bool isLoading;

  /// When `false` the button is greyed out and does not respond to taps,
  /// even if [onPressed] is non-null.
  final bool isEnabled;

  /// When `true` the button stretches to the full width of its parent.
  final bool expand;

  /// An icon rendered before the label.
  final IconData? icon;

  /// An icon rendered after the label.
  final IconData? trailingIcon;

  /// Replaces the label entirely. When set, [text], [icon], and
  /// [trailingIcon] are ignored.
  final Widget? child;

  /// Corner radius. Defaults to [defaultButtonBorderRadiusGlobal].
  final double? borderRadius;

  /// Fixed height. Defaults to the height implied by [size].
  final double? height;

  /// Fixed width. Ignored when [expand] is `true`.
  final double? width;

  /// Background colour. Defaults to the colour implied by [variant].
  final Color? backgroundColor;

  /// Label and icon colour. Defaults to the colour implied by [variant].
  final Color? foregroundColor;

  /// Border colour for [ButtonVariantX.outlined]. Defaults to [foregroundColor].
  final Color? borderColor;

  /// Border width for [ButtonVariantX.outlined].
  final double borderWidth;

  /// Style applied to [text]. Merged over the size-derived default.
  final TextStyle? textStyle;

  /// Inner horizontal padding. Defaults to the padding implied by [size].
  final EdgeInsetsGeometry? padding;

  /// Outer margin around the button.
  final EdgeInsetsGeometry? margin;

  /// Material elevation. Defaults to `0`.
  final double elevation;

  /// Widget shown in place of the label while the button is busy.
  ///
  /// Defaults to a [CircularProgressIndicator] tinted with [foregroundColor].
  final Widget? loadingIndicator;

  /// Called when a future returned by [onPressed] completes with an error.
  ///
  /// When this is `null` the error is rethrown after the loading state has
  /// been cleared, so it still reaches your zone or error handler.
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// Semantic label announced by screen readers. Defaults to [text].
  final String? semanticLabel;

  const ButtonWidgetx({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.variant = ButtonVariantX.filled,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  });

  /// A solid button in the primary colour — the main call to action.
  const ButtonWidgetx.filled({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  }) : variant = ButtonVariantX.filled;

  /// A muted button in the secondary-container colour.
  const ButtonWidgetx.tonal({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  }) : variant = ButtonVariantX.tonal;

  /// A bordered, transparent button — a secondary action.
  const ButtonWidgetx.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  }) : variant = ButtonVariantX.outlined;

  /// A label-only button with no background or border — a tertiary action.
  const ButtonWidgetx.text({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  }) : variant = ButtonVariantX.text;

  /// A solid button in the error colour — for destructive actions.
  const ButtonWidgetx.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.onLongPress,
    this.size = ButtonSizeX.medium,
    this.isLoading = false,
    this.isEnabled = true,
    this.expand = false,
    this.icon,
    this.trailingIcon,
    this.child,
    this.borderRadius,
    this.height,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.textStyle,
    this.padding,
    this.margin,
    this.elevation = 0,
    this.loadingIndicator,
    this.onError,
    this.semanticLabel,
  }) : variant = ButtonVariantX.danger;

  @override
  State<ButtonWidgetx> createState() => _ButtonWidgetxState();
}

class _ButtonWidgetxState extends State<ButtonWidgetx> {
  bool _busy = false;

  bool get _isLoading => widget.isLoading || _busy;

  bool get _isInteractive => widget.isEnabled && widget.onPressed != null && !_isLoading;

  Future<void> _handleTap() async {
    // Guards against a second tap landing before the first future settles.
    if (!_isInteractive) return;

    final result = widget.onPressed!();
    if (result is! Future<void>) return;

    setState(() => _busy = true);
    try {
      await result;
    } catch (error, stackTrace) {
      if (widget.onError == null) rethrow;
      widget.onError!(error, stackTrace);
    } finally {
      // The button may have been disposed while the future was in flight.
      if (mounted) setState(() => _busy = false);
    }
  }

  double get _height {
    if (widget.height != null) return widget.height!;
    return switch (widget.size) {
      ButtonSizeX.small => defaultButtonHeightSmallGlobal,
      ButtonSizeX.medium => defaultButtonHeightMediumGlobal,
      ButtonSizeX.large => defaultButtonHeightLargeGlobal,
    };
  }

  double get _fontSize => switch (widget.size) {
    ButtonSizeX.small => 13,
    ButtonSizeX.medium => 15,
    ButtonSizeX.large => 17,
  };

  double get _iconSize => switch (widget.size) {
    ButtonSizeX.small => 16,
    ButtonSizeX.medium => 18,
    ButtonSizeX.large => 20,
  };

  EdgeInsetsGeometry get _padding {
    if (widget.padding != null) return widget.padding!;
    return switch (widget.size) {
      ButtonSizeX.small => const EdgeInsets.symmetric(horizontal: 14),
      ButtonSizeX.medium => const EdgeInsets.symmetric(horizontal: 20),
      ButtonSizeX.large => const EdgeInsets.symmetric(horizontal: 26),
    };
  }

  Color _resolveBackground(ColorScheme scheme) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    return switch (widget.variant) {
      ButtonVariantX.filled => scheme.primary,
      ButtonVariantX.tonal => scheme.secondaryContainer,
      ButtonVariantX.danger => scheme.error,
      ButtonVariantX.outlined || ButtonVariantX.text => Colors.transparent,
    };
  }

  Color _resolveForeground(ColorScheme scheme) {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    return switch (widget.variant) {
      ButtonVariantX.filled => scheme.onPrimary,
      ButtonVariantX.tonal => scheme.onSecondaryContainer,
      ButtonVariantX.danger => scheme.onError,
      ButtonVariantX.outlined || ButtonVariantX.text => scheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = BorderRadius.circular(widget.borderRadius ?? defaultButtonBorderRadiusGlobal);
    final background = _resolveBackground(scheme);
    final foreground = _resolveForeground(scheme);
    // Disabled is a dimmed version of the real style, so the button keeps its
    // shape and the layout does not shift when it becomes interactive again.
    final isDimmed = !widget.isEnabled || (widget.onPressed == null && !_isLoading);

    final Widget label = _isLoading
        ? (widget.loadingIndicator ??
              SizedBox(
                height: _iconSize + 2,
                width: _iconSize + 2,
                child: CircularProgressIndicator(strokeWidth: 2.2, valueColor: AlwaysStoppedAnimation<Color>(foreground)),
              ))
        : widget.child ??
              Row(
                mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[Icon(widget.icon, size: _iconSize, color: foreground), const SizedBox(width: 8)],
                  Flexible(
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: foreground, fontSize: _fontSize, fontWeight: FontWeight.w600).merge(widget.textStyle),
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[const SizedBox(width: 8), Icon(widget.trailingIcon, size: _iconSize, color: foreground)],
                ],
              );

    Widget button = Opacity(
      opacity: isDimmed ? 0.45 : 1.0,
      child: Material(
        color: background,
        elevation: widget.elevation,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _isInteractive ? _handleTap : null,
          onLongPress: _isInteractive ? widget.onLongPress : null,
          borderRadius: radius,
          child: Container(
            height: _height,
            width: widget.expand ? double.infinity : widget.width,
            padding: _padding,
            decoration: widget.variant == ButtonVariantX.outlined
                ? BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(color: widget.borderColor ?? foreground, width: widget.borderWidth),
                  )
                : null,
            child: Center(child: label),
          ),
        ),
      ),
    );

    if (widget.margin != null) button = Padding(padding: widget.margin!, child: button);

    return Semantics(button: true, enabled: _isInteractive, label: widget.semanticLabel ?? widget.text, child: button);
  }
}
