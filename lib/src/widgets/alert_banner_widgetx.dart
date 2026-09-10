import 'package:flutter/material.dart';

import '../utils/default_configs.dart';
import '../utils/enums.dart';

/// An inline success, error, warning, or info banner.
///
/// Use it where a snackbar is wrong — a validation summary above a form, an
/// account-status notice at the top of a screen, a rate-limit warning that
/// must stay on screen until it is resolved.
///
/// Example:
/// ```dart
/// AlertBannerWidgetx.error(
///   title: 'Payment failed',
///   message: 'Your card was declined. Try a different payment method.',
///   onClose: () => setState(() => showError = false),
/// )
///
/// AlertBannerWidgetx.success(message: 'Profile updated.')
///
/// AlertBannerWidgetx.warning(
///   message: 'Your session expires in 2 minutes.',
///   actionText: 'Extend',
///   onAction: extendSession,
/// )
/// ```
class AlertBannerWidgetx extends StatelessWidget {
  /// The severity, which selects the default colour and icon.
  final AlertTypeX type;

  /// The message body. Required — a banner with no message says nothing.
  final String message;

  /// Optional bold heading above [message].
  final String? title;

  /// Overrides the icon implied by [type]. Pass `null` with
  /// [showIcon] set to `false` to remove it entirely.
  final IconData? icon;

  /// Whether the leading icon is rendered.
  final bool showIcon;

  /// When set, a close button is shown and this is called when it is tapped.
  ///
  /// The banner does not remove itself — the caller controls its visibility.
  final VoidCallback? onClose;

  /// Label of the trailing action button. Requires [onAction].
  final String? actionText;

  /// Called when the trailing action button is tapped.
  final VoidCallback? onAction;

  /// Renders the banner with a solid background instead of the default
  /// tinted-with-border style.
  final bool isFilled;

  /// Overrides the accent colour implied by [type].
  final Color? color;

  /// Overrides the background colour.
  final Color? backgroundColor;

  /// Overrides the text colour.
  final Color? textColor;

  /// Corner radius. Defaults to `12`.
  final double borderRadius;

  /// Width of the left accent bar. Set to `0` to remove it.
  final double accentBarWidth;

  /// Inner padding.
  final EdgeInsetsGeometry padding;

  /// Outer margin around the banner.
  final EdgeInsetsGeometry? margin;

  /// Style applied to [title].
  final TextStyle? titleStyle;

  /// Style applied to [message].
  final TextStyle? messageStyle;

  const AlertBannerWidgetx({
    super.key,
    required this.message,
    this.type = AlertTypeX.info,
    this.title,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actionText,
    this.onAction,
    this.isFilled = false,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.accentBarWidth = 4,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.titleStyle,
    this.messageStyle,
  });

  /// A green banner confirming that something worked.
  const AlertBannerWidgetx.success({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actionText,
    this.onAction,
    this.isFilled = false,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.accentBarWidth = 4,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.titleStyle,
    this.messageStyle,
  }) : type = AlertTypeX.success;

  /// A red banner reporting a failure.
  const AlertBannerWidgetx.error({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actionText,
    this.onAction,
    this.isFilled = false,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.accentBarWidth = 4,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.titleStyle,
    this.messageStyle,
  }) : type = AlertTypeX.error;

  /// An amber banner cautioning the user.
  const AlertBannerWidgetx.warning({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actionText,
    this.onAction,
    this.isFilled = false,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.accentBarWidth = 4,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.titleStyle,
    this.messageStyle,
  }) : type = AlertTypeX.warning;

  /// A blue banner carrying neutral information.
  const AlertBannerWidgetx.info({
    super.key,
    required this.message,
    this.title,
    this.icon,
    this.showIcon = true,
    this.onClose,
    this.actionText,
    this.onAction,
    this.isFilled = false,
    this.color,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
    this.accentBarWidth = 4,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.titleStyle,
    this.messageStyle,
  }) : type = AlertTypeX.info;

  Color get _accent {
    if (color != null) return color!;
    return switch (type) {
      AlertTypeX.success => defaultAlertSuccessColorGlobal,
      AlertTypeX.error => defaultAlertErrorColorGlobal,
      AlertTypeX.warning => defaultAlertWarningColorGlobal,
      AlertTypeX.info => defaultAlertInfoColorGlobal,
    };
  }

  IconData get _icon {
    if (icon != null) return icon!;
    return switch (type) {
      AlertTypeX.success => Icons.check_circle_outline_rounded,
      AlertTypeX.error => Icons.error_outline_rounded,
      AlertTypeX.warning => Icons.warning_amber_rounded,
      AlertTypeX.info => Icons.info_outline_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = _accent;
    // The filled variant carries the accent as its background, so its content
    // flips to white; the tinted variant keeps the accent for text and icon.
    final background = backgroundColor ?? (isFilled ? accent : accent.withValues(alpha: 0.10));
    final foreground = textColor ?? (isFilled ? Colors.white : accent);
    final radius = BorderRadius.circular(borderRadius);

    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showIcon) ...[Icon(_icon, size: 20, color: foreground), const SizedBox(width: 12)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null) ...[
                Text(
                  title!,
                  style: titleStyle ?? theme.textTheme.titleSmall?.copyWith(color: foreground, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
              ],
              Text(
                message,
                style:
                    messageStyle ??
                    theme.textTheme.bodyMedium?.copyWith(color: isFilled ? foreground : foreground.withValues(alpha: 0.9), height: 1.35),
              ),
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 8),
                InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      actionText!,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: foreground,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (onClose != null)
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.close_rounded, size: 18, color: foreground.withValues(alpha: 0.8)),
            ),
          ),
      ],
    );

    Widget banner = Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: radius,
        border: isFilled ? null : Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (accentBarWidth > 0 && !isFilled) Container(width: accentBarWidth, color: accent),
            Expanded(
              child: Padding(padding: padding, child: content),
            ),
          ],
        ),
      ),
    );

    if (margin != null) banner = Padding(padding: margin!, child: banner);
    return Semantics(container: true, liveRegion: true, child: banner);
  }
}
