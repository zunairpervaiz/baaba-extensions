import 'package:flutter/material.dart';

import 'utils/default_configs.dart';

extension DialogX on BuildContext {
  /// Shows a customizable confirmation dialog and returns `true` if confirmed,
  /// `false` if cancelled, or `null` if dismissed by tapping outside.
  ///
  /// Example:
  /// ```dart
  /// final confirmed = await context.showConfirmDialog(
  ///   title: 'Delete Item',
  ///   message: 'This action cannot be undone.',
  ///   confirmText: 'Delete',
  ///   confirmColor: Colors.red,
  ///   icon: Icons.delete_outline_rounded,
  /// );
  /// if (confirmed == true) deleteItem();
  /// ```
  Future<bool?> showConfirmDialog({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
    IconData icon = Icons.help_outline_rounded,
    bool barrierDismissible = true,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    BorderRadius? borderRadius,
  }) {
    return showDialog<bool>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => _ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor ?? defaultDialogConfirmColorGlobal,
        cancelColor: cancelColor ?? defaultDialogCancelColorGlobal,
        icon: icon,
        backgroundColor: backgroundColor,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        borderRadius: borderRadius ?? defaultDialogBorderRadiusGlobal,
      ),
    );
  }

  /// Shows a customizable information dialog with a single close action.
  ///
  /// Example:
  /// ```dart
  /// await context.showInfoDialog(
  ///   title: 'Profile Updated',
  ///   message: 'Your changes have been saved successfully.',
  ///   icon: Icons.check_circle_outline_rounded,
  ///   accentColor: Colors.green,
  /// );
  /// ```
  Future<void> showInfoDialog({
    required String title,
    required String message,
    String closeText = 'Got it',
    VoidCallback? onClose,
    Color? accentColor,
    IconData icon = Icons.info_outline_rounded,
    bool barrierDismissible = true,
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    BorderRadius? borderRadius,
  }) {
    return showDialog<void>(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => _InfoDialog(
        title: title,
        message: message,
        closeText: closeText,
        onClose: onClose,
        accentColor: accentColor ?? defaultDialogInfoColorGlobal,
        icon: icon,
        backgroundColor: backgroundColor,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
        borderRadius: borderRadius ?? defaultDialogBorderRadiusGlobal,
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  const _ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    required this.confirmColor,
    required this.cancelColor,
    required this.icon,
    required this.borderRadius,
    this.onConfirm,
    this.onCancel,
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
  });

  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final Color cancelColor;
  final IconData icon;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final surfaceColor = backgroundColor ??
        DialogTheme.of(context).backgroundColor ??
        theme.colorScheme.surface;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogIcon(icon: icon, color: confirmColor),
            const SizedBox(height: 20),
            Text(
              title,
              style: titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: messageStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
                    height: 1.55,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cancelColor,
                      side: BorderSide(
                          color: cancelColor.withValues(alpha: 0.35)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      onConfirm?.call();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: confirmColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({
    required this.title,
    required this.message,
    required this.closeText,
    required this.accentColor,
    required this.icon,
    required this.borderRadius,
    this.onClose,
    this.backgroundColor,
    this.titleStyle,
    this.messageStyle,
  });

  final String title;
  final String message;
  final String closeText;
  final VoidCallback? onClose;
  final Color accentColor;
  final IconData icon;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = backgroundColor ??
        DialogTheme.of(context).backgroundColor ??
        theme.colorScheme.surface;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogIcon(icon: icon, color: accentColor),
            const SizedBox(height: 20),
            Text(
              title,
              style: titleStyle ??
                  theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: messageStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.60),
                    height: 1.55,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onClose?.call();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  closeText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogIcon extends StatelessWidget {
  const _DialogIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 34, color: color),
    );
  }
}
