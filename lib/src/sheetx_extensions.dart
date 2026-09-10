import 'package:flutter/material.dart';

import 'utils/default_configs.dart';

/// One row in a [SheetX.showActionSheet] — the bottom-sheet equivalent of a
/// menu item.
///
/// Example:
/// ```dart
/// SheetActionX(label: 'Delete', icon: Icons.delete_outline, value: 'delete', isDestructive: true)
/// ```
class SheetActionX<T> {
  /// The text shown for this action.
  final String label;

  /// Optional secondary line beneath [label].
  final String? subtitle;

  /// Leading icon. Ignored when [leading] is supplied.
  final IconData? icon;

  /// Leading widget. Overrides [icon] — use it for an avatar or an image.
  final Widget? leading;

  /// The value returned by the sheet when this row is tapped.
  final T? value;

  /// Called when the row is tapped, after the sheet has been dismissed.
  final VoidCallback? onTap;

  /// When `true` the row is tinted with the error colour.
  final bool isDestructive;

  /// When `false` the row is dimmed and cannot be tapped.
  final bool isEnabled;

  /// Overrides the colour of the label and icon.
  final Color? color;

  const SheetActionX({
    required this.label,
    this.subtitle,
    this.icon,
    this.leading,
    this.value,
    this.onTap,
    this.isDestructive = false,
    this.isEnabled = true,
    this.color,
  });
}

extension SheetX on BuildContext {
  /// Shows a rounded modal bottom sheet with a drag handle, safe-area padding,
  /// and keyboard avoidance already handled, and returns the value the sheet
  /// was popped with.
  ///
  /// The sheet grows with its content up to [maxHeightFactor] of the screen
  /// and stays above the keyboard, so it works for forms as well as menus.
  ///
  /// Example:
  /// ```dart
  /// final result = await context.showSheet<String>(
  ///   title: 'Add a note',
  ///   child: NoteForm(),
  /// );
  /// ```
  Future<T?> showSheet<T>({
    required Widget child,
    String? title,
    Widget? titleWidget,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useSafeArea = true,
    double maxHeightFactor = 0.9,
    double? borderRadius,
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    EdgeInsetsGeometry padding = const EdgeInsets.fromLTRB(20, 0, 20, 20),
    TextStyle? titleStyle,
    RouteSettings? routeSettings,
  }) {
    final radius = Radius.circular(borderRadius ?? defaultSheetBorderRadiusGlobal);
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor ?? Theme.of(this).colorScheme.surface,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(this).height * maxHeightFactor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      builder: (sheetContext) => _SheetShell(
        title: title,
        titleWidget: titleWidget,
        showDragHandle: showDragHandle,
        handleColor: handleColor,
        titleStyle: titleStyle,
        padding: padding,
        child: child,
      ),
    );
  }

  /// Shows a bottom sheet whose content scrolls and which the user can drag
  /// between [minSize] and [maxSize] as a fraction of the screen height.
  ///
  /// The [ScrollController] handed to [builder] must be attached to the
  /// scrollable inside it, otherwise dragging the sheet will not work.
  ///
  /// Example:
  /// ```dart
  /// context.showScrollableSheet(
  ///   title: 'Select a city',
  ///   builder: (context, scrollController) => ListView.builder(
  ///     controller: scrollController,
  ///     itemCount: cities.length,
  ///     itemBuilder: (_, i) => ListTile(title: Text(cities[i])),
  ///   ),
  /// );
  /// ```
  Future<T?> showScrollableSheet<T>({
    required Widget Function(BuildContext context, ScrollController scrollController) builder,
    String? title,
    Widget? titleWidget,
    double initialSize = 0.6,
    double minSize = 0.3,
    double maxSize = 0.95,
    bool showDragHandle = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool expand = false,
    double? borderRadius,
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    TextStyle? titleStyle,
    RouteSettings? routeSettings,
  }) {
    final radius = Radius.circular(borderRadius ?? defaultSheetBorderRadiusGlobal);
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor,
      routeSettings: routeSettings,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        expand: expand,
        snap: true,
        builder: (context, scrollController) => DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
            child: Column(
              children: [
                if (showDragHandle) _DragHandle(color: handleColor),
                if (title != null || titleWidget != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    child:
                        titleWidget ??
                        Text(title!, style: titleStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                Expanded(child: builder(context, scrollController)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a list of actions in a bottom sheet and returns the value of the
  /// one the user picked, or `null` if the sheet was dismissed.
  ///
  /// This is the "Camera / Gallery / Cancel" pattern — the mobile-native
  /// alternative to a dialog full of buttons.
  ///
  /// Example:
  /// ```dart
  /// final choice = await context.showActionSheet<String>(
  ///   title: 'Manage post',
  ///   actions: [
  ///     SheetActionX(label: 'Edit', icon: Icons.edit_outlined, value: 'edit'),
  ///     SheetActionX(label: 'Share', icon: Icons.share_outlined, value: 'share'),
  ///     SheetActionX(label: 'Delete', icon: Icons.delete_outline, value: 'delete', isDestructive: true),
  ///   ],
  /// );
  /// ```
  Future<T?> showActionSheet<T>({
    required List<SheetActionX<T>> actions,
    String? title,
    String? message,
    String? cancelText,
    bool showCancel = true,
    bool showDragHandle = true,
    bool isDismissible = true,
    double? borderRadius,
    Color? backgroundColor,
    Color? barrierColor,
    Color? handleColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    final radius = Radius.circular(borderRadius ?? defaultSheetBorderRadiusGlobal);
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      isDismissible: isDismissible,
      useSafeArea: true,
      backgroundColor: backgroundColor ?? Theme.of(this).colorScheme.surface,
      barrierColor: barrierColor,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(this).height * 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
      ),
      builder: (sheetContext) => _ActionSheet<T>(
        actions: actions,
        title: title,
        message: message,
        cancelText: cancelText ?? defaultSheetCancelTextGlobal,
        showCancel: showCancel,
        showDragHandle: showDragHandle,
        handleColor: handleColor,
        titleStyle: titleStyle,
        messageStyle: messageStyle,
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: color ?? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Wraps arbitrary sheet content with the handle, the title, keyboard
/// avoidance, and a scroll view so tall content never overflows.
class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.child,
    required this.showDragHandle,
    required this.padding,
    this.title,
    this.titleWidget,
    this.handleColor,
    this.titleStyle,
  });

  final Widget child;
  final bool showDragHandle;
  final EdgeInsetsGeometry padding;
  final String? title;
  final Widget? titleWidget;
  final Color? handleColor;
  final TextStyle? titleStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Lifts the sheet above the on-screen keyboard when a field is focused.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDragHandle) _DragHandle(color: handleColor),
            if (title != null || titleWidget != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child:
                    titleWidget ?? Text(title!, style: titleStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
            Padding(padding: padding, child: child),
          ],
        ),
      ),
    );
  }
}

class _ActionSheet<T> extends StatelessWidget {
  const _ActionSheet({
    required this.actions,
    required this.cancelText,
    required this.showCancel,
    required this.showDragHandle,
    this.title,
    this.message,
    this.handleColor,
    this.titleStyle,
    this.messageStyle,
  });

  final List<SheetActionX<T>> actions;
  final String cancelText;
  final bool showCancel;
  final bool showDragHandle;
  final String? title;
  final String? message;
  final Color? handleColor;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDragHandle) _DragHandle(color: handleColor),
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, message == null ? 8 : 4),
                child: Text(title!, style: titleStyle ?? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              ),
            if (message != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Text(message!, style: messageStyle ?? theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: 0.65))),
              ),
            for (final action in actions)
              _ActionRow<T>(
                action: action,
                // Pop first so the callback runs against a settled navigator
                // and is free to push a route or open another sheet.
                onTap: () {
                  Navigator.of(context).pop(action.value);
                  action.onTap?.call();
                },
              ),
            if (showCancel) ...[
              Divider(height: 1, thickness: 1, color: scheme.outlineVariant.withValues(alpha: 0.4)),
              InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(cancelText, style: theme.textTheme.titleSmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.7))),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionRow<T> extends StatelessWidget {
  const _ActionRow({required this.action, required this.onTap});

  final SheetActionX<T> action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = action.color ?? (action.isDestructive ? scheme.error : scheme.onSurface);

    return Opacity(
      opacity: action.isEnabled ? 1 : 0.4,
      child: InkWell(
        onTap: action.isEnabled ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              if (action.leading != null) ...[
                action.leading!,
                const SizedBox(width: 16),
              ] else if (action.icon != null) ...[
                Icon(action.icon, size: 22, color: color),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      action.label,
                      style: theme.textTheme.bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w500),
                    ),
                    if (action.subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(action.subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6))),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
