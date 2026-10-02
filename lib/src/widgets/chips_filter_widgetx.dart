import 'package:flutter/material.dart';

import '../listx_extensions.dart';
import '../utils/enums.dart';

/// A row or wrap of selectable filter chips.
///
/// The selection is controlled by the parent: [onChanged] fires with the new
/// list and the widget renders whatever [selected] it is given next. In
/// [ChipsSelectionModeX.single] that list holds at most one item.
///
/// Example:
/// ```dart
/// // Multi-select filters that wrap onto several lines.
/// ChipsFilterWidgetx<String>(
///   items: ['Pizza', 'Burgers', 'Biryani', 'Desserts'],
///   selected: activeFilters,
///   onChanged: (values) => setState(() => activeFilters = values),
/// )
///
/// // Single-select, scrolling horizontally on one line.
/// ChipsFilterWidgetx<Category>(
///   items: categories,
///   labelBuilder: (c) => c.name,
///   selected: selectedCategory == null ? [] : [selectedCategory!],
///   mode: ChipsSelectionModeX.single,
///   isScrollable: true,
///   onChanged: (values) => setState(() => selectedCategory = values.firstOrNull),
/// )
/// ```
class ChipsFilterWidgetx<T> extends StatelessWidget {
  /// The full set of chips to render.
  final List<T> items;

  /// The currently selected items.
  ///
  /// In [ChipsSelectionModeX.single] anything beyond the first entry is
  /// ignored when deciding which chip appears selected.
  final List<T> selected;

  /// Called with the new selection whenever a chip is tapped.
  final ValueChanged<List<T>> onChanged;

  /// Produces the label for an item. Defaults to `item.toString()`.
  final String Function(T item)? labelBuilder;

  /// Produces a leading icon for an item.
  final IconData? Function(T item)? iconBuilder;

  /// Produces a trailing count badge for an item — `Pizza (12)`.
  final int? Function(T item)? countBuilder;

  /// Whether one or many chips can be selected at a time.
  /// Defaults to [ChipsSelectionModeX.multiple].
  final ChipsSelectionModeX mode;

  /// When `true` the chips sit on one horizontally scrolling line instead of
  /// wrapping onto several.
  final bool isScrollable;

  /// In [ChipsSelectionModeX.single], whether tapping the selected chip
  /// clears the selection. Defaults to `true`.
  final bool allowEmpty;

  /// Whether a check mark is shown on selected chips.
  final bool showCheckmark;

  /// Horizontal gap between chips.
  final double spacing;

  /// Vertical gap between lines when wrapping.
  final double runSpacing;

  /// Fill colour of a selected chip. Defaults to the primary colour.
  final Color? selectedColor;

  /// Fill colour of an unselected chip. Defaults to transparent.
  final Color? backgroundColor;

  /// Label colour of a selected chip. Defaults to the onPrimary colour.
  final Color? selectedLabelColor;

  /// Label colour of an unselected chip.
  final Color? labelColor;

  /// Border colour of an unselected chip.
  final Color? borderColor;

  /// Corner radius. Defaults to `20`, giving a pill.
  final double borderRadius;

  /// Inner padding of each chip.
  final EdgeInsetsGeometry padding;

  /// Padding around the whole group. Applies to the scroll view when
  /// [isScrollable] is set.
  final EdgeInsetsGeometry? groupPadding;

  /// Style applied to chip labels.
  final TextStyle? labelStyle;

  /// Alignment of the chips when they wrap. Ignored when [isScrollable].
  final WrapAlignment alignment;

  /// When `false` every chip is dimmed and non-interactive.
  final bool enabled;

  const ChipsFilterWidgetx({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.labelBuilder,
    this.iconBuilder,
    this.countBuilder,
    this.mode = ChipsSelectionModeX.multiple,
    this.isScrollable = false,
    this.allowEmpty = true,
    this.showCheckmark = true,
    this.spacing = 8,
    this.runSpacing = 8,
    this.selectedColor,
    this.backgroundColor,
    this.selectedLabelColor,
    this.labelColor,
    this.borderColor,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    this.groupPadding,
    this.labelStyle,
    this.alignment = WrapAlignment.start,
    this.enabled = true,
  });

  // In single mode only the first selected item counts, so a caller that
  // passes several never sees two chips marked or loses the tapped one.
  Iterable<T> get _effectiveSelected => mode == ChipsSelectionModeX.single ? selected.take(1) : selected;

  void _handleTap(T item) {
    final isSelected = _effectiveSelected.contains(item);

    if (mode == ChipsSelectionModeX.single) {
      if (isSelected) {
        onChanged(allowEmpty ? const [] : [item]);
      } else {
        onChanged([item]);
      }
      return;
    }

    // A new list is emitted rather than mutating the incoming one, which the
    // caller may be holding as immutable state.
    onChanged(List<T>.from(selected)..toggle(item));
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSelected = _effectiveSelected;
    final chips = [
      for (final item in items)
        _FilterChip(
          label: labelBuilder?.call(item) ?? item.toString(),
          icon: iconBuilder?.call(item),
          count: countBuilder?.call(item),
          isSelected: effectiveSelected.contains(item),
          onTap: enabled ? () => _handleTap(item) : null,
          config: this,
        ),
    ];

    if (isScrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: groupPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < chips.length; i++) ...[if (i > 0) SizedBox(width: spacing), chips[i]],
          ],
        ),
      );
    }

    final wrap = Wrap(spacing: spacing, runSpacing: runSpacing, alignment: alignment, children: chips);
    return groupPadding == null ? wrap : Padding(padding: groupPadding!, child: wrap);
  }
}

class _FilterChip<T> extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected, required this.config, this.icon, this.count, this.onTap});

  final String label;
  final bool isSelected;
  final IconData? icon;
  final int? count;
  final VoidCallback? onTap;
  final ChipsFilterWidgetx<T> config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(config.borderRadius);

    final fill = isSelected ? (config.selectedColor ?? scheme.primary) : (config.backgroundColor ?? Colors.transparent);
    final foreground = isSelected ? (config.selectedLabelColor ?? scheme.onPrimary) : (config.labelColor ?? scheme.onSurface.withValues(alpha: 0.8));
    final border = isSelected ? fill : (config.borderColor ?? scheme.outline.withValues(alpha: 0.45));

    return Opacity(
      opacity: config.enabled ? 1 : 0.5,
      child: Material(
        color: fill,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            padding: config.padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: border, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected && config.showCheckmark) ...[
                  Icon(Icons.check_rounded, size: 16, color: foreground),
                  const SizedBox(width: 6),
                ] else if (icon != null) ...[
                  Icon(icon, size: 16, color: foreground),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style:
                      config.labelStyle?.copyWith(color: foreground) ??
                      theme.textTheme.bodyMedium?.copyWith(color: foreground, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                ),
                if (count != null) ...[
                  const SizedBox(width: 6),
                  Text(
                    '$count',
                    style: theme.textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: 0.75), fontWeight: FontWeight.w600),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
