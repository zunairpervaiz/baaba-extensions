import 'package:flutter/material.dart';

/// A centered empty-state widget with an icon, title, optional subtitle,
/// and optional action button.
///
/// Example:
/// ```dart
/// EmptyStateWidgetx(
///   title: 'No Results',
///   subtitle: 'Try a different search term.',
///   icon: Icons.search_off,
///   actionText: 'Clear Search',
///   onAction: () => controller.clear(),
/// )
/// ```
class EmptyStateWidgetx extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final String? actionText;
  final VoidCallback? onAction;
  final Color? actionColor;
  final EdgeInsets padding;

  const EmptyStateWidgetx({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.iconSize = 64,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
    this.actionText,
    this.onAction,
    this.actionColor,
    this.padding = const EdgeInsets.all(32),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: iconColor ??
                  theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: titleStyle ?? theme.textTheme.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: subtitleStyle ??
                    theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor:
                      actionColor ?? theme.colorScheme.primary,
                ),
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
