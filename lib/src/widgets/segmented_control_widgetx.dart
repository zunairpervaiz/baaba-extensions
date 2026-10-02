import 'package:flutter/material.dart';

/// A two- or three-way toggle with a sliding indicator.
///
/// Cleaner than a [TabBar] for a small, fixed set of mutually exclusive
/// choices — All / Active / Archived, Monthly / Yearly, List / Grid.
///
/// Example:
/// ```dart
/// SegmentedControlWidgetx<OrderFilter>(
///   items: OrderFilter.values,
///   value: filter,
///   labelBuilder: (f) => f.name.capitalizeFirstLetter(),
///   onChanged: (f) => setState(() => filter = f),
/// )
///
/// // Icon-only, for a layout switcher.
/// SegmentedControlWidgetx<bool>(
///   items: const [false, true],
///   value: isGrid,
///   labelBuilder: (v) => v ? 'Grid' : 'List',
///   iconBuilder: (v) => v ? Icons.grid_view_rounded : Icons.view_list_rounded,
///   showLabels: false,
///   onChanged: (v) => setState(() => isGrid = v),
/// )
/// ```
class SegmentedControlWidgetx<T> extends StatelessWidget {
  /// The available segments, rendered left to right.
  final List<T> items;

  /// The currently selected segment.
  final T value;

  /// Called with the segment the user tapped.
  ///
  /// Not called when the already-selected segment is tapped.
  final ValueChanged<T> onChanged;

  /// Produces the label for a segment. Defaults to `item.toString()`.
  final String Function(T item)? labelBuilder;

  /// Produces an icon for a segment.
  final IconData? Function(T item)? iconBuilder;

  /// Whether labels are rendered. Set to `false` for an icon-only control.
  final bool showLabels;

  /// Height of the control. Defaults to `40`.
  final double height;

  /// When `true` the control fills the available width and every segment gets
  /// an equal share. When `false` it sizes to its content.
  final bool expand;

  /// Corner radius of the outer track. Defaults to `10`.
  final double borderRadius;

  /// Gap between the track and the sliding indicator.
  final double indicatorPadding;

  /// Background colour of the track.
  final Color? backgroundColor;

  /// Colour of the sliding indicator. Defaults to the surface colour.
  final Color? indicatorColor;

  /// Label colour of the selected segment.
  final Color? selectedLabelColor;

  /// Label colour of an unselected segment.
  final Color? labelColor;

  /// Colour of the track border. Set [borderWidth] to `0` to remove it.
  final Color? borderColor;

  /// Width of the track border. Defaults to `0`.
  final double borderWidth;

  /// Style applied to segment labels.
  final TextStyle? labelStyle;

  /// Size of segment icons. Defaults to `18`.
  final double iconSize;

  /// Duration of the indicator slide. Defaults to `220ms`.
  final Duration animationDuration;

  /// Curve of the indicator slide.
  final Curve animationCurve;

  /// Outer margin around the control.
  final EdgeInsetsGeometry? margin;

  /// When `false` the control is dimmed and non-interactive.
  final bool enabled;

  const SegmentedControlWidgetx({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.labelBuilder,
    this.iconBuilder,
    this.showLabels = true,
    this.height = 40,
    this.expand = true,
    this.borderRadius = 10,
    this.indicatorPadding = 3,
    this.backgroundColor,
    this.indicatorColor,
    this.selectedLabelColor,
    this.labelColor,
    this.borderColor,
    this.borderWidth = 0,
    this.labelStyle,
    this.iconSize = 18,
    this.animationDuration = const Duration(milliseconds: 220),
    this.animationCurve = Curves.easeOutCubic,
    this.margin,
    this.enabled = true,
  }) : assert(items.length > 0, 'SegmentedControlWidgetx: items must not be empty.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final track = backgroundColor ?? scheme.surfaceContainerHighest.withValues(alpha: 0.6);
    final indicator = indicatorColor ?? scheme.surface;
    final selectedText = selectedLabelColor ?? scheme.onSurface;
    final unselectedText = labelColor ?? scheme.onSurface.withValues(alpha: 0.6);
    // An unknown value simply leaves no segment highlighted rather than
    // throwing, so a nullable or out-of-range selection is safe to pass.
    final selectedIndex = items.indexOf(value);

    // No LayoutBuilder here: with expand false the control is wrapped in
    // IntrinsicWidth, and LayoutBuilder cannot report intrinsic sizes. The
    // indicator is placed by alignment instead, as a 1/n-wide slice of the
    // track, which needs no measured width.
    final count = items.length;
    final indicatorX = count == 1 ? 0.0 : -1.0 + 2.0 * selectedIndex / (count - 1);

    Widget control = Container(
      height: height,
      decoration: BoxDecoration(
        color: track,
        borderRadius: BorderRadius.circular(borderRadius),
        border: borderWidth <= 0 ? null : Border.all(color: borderColor ?? scheme.outline.withValues(alpha: 0.4), width: borderWidth),
      ),
      padding: EdgeInsets.all(indicatorPadding),
      child: Stack(
        children: [
          if (selectedIndex >= 0)
            Positioned.fill(
              child: AnimatedAlign(
                duration: animationDuration,
                curve: animationCurve,
                alignment: Alignment(indicatorX, 0),
                child: FractionallySizedBox(
                  widthFactor: 1 / count,
                  heightFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: indicator,
                      borderRadius: BorderRadius.circular(borderRadius - indicatorPadding),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 4, offset: const Offset(0, 1))],
                    ),
                  ),
                ),
              ),
            ),
          Row(
            children: [
              for (var i = 0; i < count; i++)
                Expanded(
                  child: _Segment(
                    label: labelBuilder?.call(items[i]) ?? items[i].toString(),
                    icon: iconBuilder?.call(items[i]),
                    showLabel: showLabels,
                    iconSize: iconSize,
                    color: i == selectedIndex ? selectedText : unselectedText,
                    isSelected: i == selectedIndex,
                    labelStyle: labelStyle,
                    animationDuration: animationDuration,
                    onTap: !enabled || i == selectedIndex ? null : () => onChanged(items[i]),
                  ),
                ),
            ],
          ),
        ],
      ),
    );

    if (!expand) control = IntrinsicWidth(child: control);
    if (!enabled) control = Opacity(opacity: 0.5, child: control);
    if (margin != null) control = Padding(padding: margin!, child: control);
    return control;
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.showLabel,
    required this.iconSize,
    required this.color,
    required this.isSelected,
    required this.animationDuration,
    this.icon,
    this.labelStyle,
    this.onTap,
  });

  final String label;
  final bool showLabel;
  final double iconSize;
  final Color color;
  final bool isSelected;
  final Duration animationDuration;
  final IconData? icon;
  final TextStyle? labelStyle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        // Opaque so the whole segment responds, not just the glyphs in it.
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: animationDuration,
            style: (labelStyle ?? theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[Icon(icon, size: iconSize, color: color), if (showLabel) const SizedBox(width: 6)],
                if (showLabel)
                  Flexible(
                    child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
