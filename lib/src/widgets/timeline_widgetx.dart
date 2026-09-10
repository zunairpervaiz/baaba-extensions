import 'package:flutter/material.dart';

import '../utils/enums.dart';

/// One entry in a [TimelineWidgetx].
///
/// Example:
/// ```dart
/// TimelineItemX(
///   title: 'Out for delivery',
///   subtitle: 'Courier: Ali Raza',
///   timestamp: '10:24 AM',
///   state: TimelineItemStateX.active,
/// )
/// ```
class TimelineItemX {
  /// The heading of the entry.
  final String title;

  /// Optional detail line below [title].
  final String? subtitle;

  /// Optional time or date shown alongside the entry.
  final String? timestamp;

  /// Whether this step is done, in progress, or still ahead.
  /// Defaults to [TimelineItemStateX.pending].
  final TimelineItemStateX state;

  /// Icon rendered inside the node instead of the default filled circle.
  final IconData? icon;

  /// Overrides the node and connector colour implied by [state].
  final Color? color;

  /// Arbitrary content rendered below [subtitle] — a photo, a map, a button.
  final Widget? content;

  /// Called when the entry is tapped.
  final VoidCallback? onTap;

  const TimelineItemX({
    required this.title,
    this.subtitle,
    this.timestamp,
    this.state = TimelineItemStateX.pending,
    this.icon,
    this.color,
    this.content,
    this.onTap,
  });
}

/// A vertical timeline for order tracking, activity feeds, and audit trails.
///
/// Each entry draws a node and a connector to the next one, coloured by its
/// [TimelineItemStateX] — completed steps are solid, the active step is
/// ringed and highlighted, pending steps are muted.
///
/// Example:
/// ```dart
/// TimelineWidgetx(
///   items: [
///     TimelineItemX(title: 'Order placed', timestamp: '09:02 AM', state: TimelineItemStateX.completed),
///     TimelineItemX(title: 'Packed', timestamp: '09:40 AM', state: TimelineItemStateX.completed),
///     TimelineItemX(title: 'Out for delivery', timestamp: '10:24 AM', state: TimelineItemStateX.active),
///     TimelineItemX(title: 'Delivered'),
///   ],
/// )
/// ```
class TimelineWidgetx extends StatelessWidget {
  /// The entries, rendered top to bottom in the order given.
  final List<TimelineItemX> items;

  /// Colour of completed nodes and connectors. Defaults to the primary colour.
  final Color? completedColor;

  /// Colour of the active node. Defaults to [completedColor].
  final Color? activeColor;

  /// Colour of pending nodes and connectors. Defaults to a muted outline.
  final Color? pendingColor;

  /// Diameter of each node. Defaults to `14`.
  final double nodeSize;

  /// Thickness of the connector line. Defaults to `2`.
  final double lineWidth;

  /// Vertical gap between one entry and the next. Defaults to `8`.
  final double itemSpacing;

  /// Horizontal gap between the node column and the entry content.
  final double contentSpacing;

  /// Width reserved for [TimelineItemX.timestamp] in a leading column.
  ///
  /// When null the timestamp is rendered on the right of the title instead of
  /// in its own column.
  final double? timestampWidth;

  /// Draws the connector of pending entries as a dashed line.
  final bool dashPendingConnector;

  /// Renders the whole entry, replacing the default layout. The node column is
  /// still drawn for you.
  final Widget Function(BuildContext context, TimelineItemX item, int index)? itemBuilder;

  /// Style applied to [TimelineItemX.title].
  final TextStyle? titleStyle;

  /// Style applied to [TimelineItemX.subtitle].
  final TextStyle? subtitleStyle;

  /// Style applied to [TimelineItemX.timestamp].
  final TextStyle? timestampStyle;

  /// Padding around the whole timeline.
  final EdgeInsetsGeometry padding;

  /// When `true` the timeline sizes itself to its content instead of filling
  /// the available height. Defaults to `true`.
  final bool shrinkWrap;

  /// Scroll physics. Defaults to [NeverScrollableScrollPhysics] so the
  /// timeline nests inside an outer scroll view without conflict.
  final ScrollPhysics? physics;

  const TimelineWidgetx({
    super.key,
    required this.items,
    this.completedColor,
    this.activeColor,
    this.pendingColor,
    this.nodeSize = 14,
    this.lineWidth = 2,
    this.itemSpacing = 8,
    this.contentSpacing = 14,
    this.timestampWidth,
    this.dashPendingConnector = false,
    this.itemBuilder,
    this.titleStyle,
    this.subtitleStyle,
    this.timestampStyle,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          _TimelineRow(item: items[index], index: index, isFirst: index == 0, isLast: index == items.length - 1, config: this),
    );
  }

  Color resolveColor(BuildContext context, TimelineItemX item) {
    if (item.color != null) return item.color!;
    final scheme = Theme.of(context).colorScheme;
    return switch (item.state) {
      TimelineItemStateX.completed => completedColor ?? scheme.primary,
      TimelineItemStateX.active => activeColor ?? completedColor ?? scheme.primary,
      TimelineItemStateX.pending => pendingColor ?? scheme.outline.withValues(alpha: 0.45),
    };
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item, required this.index, required this.isFirst, required this.isLast, required this.config});

  final TimelineItemX item;
  final int index;
  final bool isFirst;
  final bool isLast;
  final TimelineWidgetx config;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = config.resolveColor(context, item);
    final isPending = item.state == TimelineItemStateX.pending;
    final isActive = item.state == TimelineItemStateX.active;
    // The connector below a node belongs to the step that follows it, so it
    // stays muted until that step itself is reached.
    final connectorColor = isPending ? (config.pendingColor ?? scheme.outline.withValues(alpha: 0.45)) : color;

    final timestampStyle = config.timestampStyle ?? theme.textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.55), height: 1.2);

    final body =
        config.itemBuilder?.call(context, item, index) ??
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style:
                        config.titleStyle ??
                        theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                          color: isPending ? scheme.onSurface.withValues(alpha: 0.55) : scheme.onSurface,
                        ),
                  ),
                ),
                if (item.timestamp != null && config.timestampWidth == null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(item.timestamp!, style: timestampStyle),
                  ),
              ],
            ),
            if (item.subtitle != null) ...[
              const SizedBox(height: 3),
              Text(
                item.subtitle!,
                style:
                    config.subtitleStyle ??
                    theme.textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withValues(alpha: isPending ? 0.4 : 0.65), height: 1.3),
              ),
            ],
            if (item.content != null) ...[const SizedBox(height: 8), item.content!],
          ],
        );

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (config.timestampWidth != null)
            SizedBox(
              width: config.timestampWidth,
              child: Padding(
                padding: const EdgeInsets.only(top: 1, right: 8),
                child: Text(item.timestamp ?? '', textAlign: TextAlign.right, style: timestampStyle),
              ),
            ),
          SizedBox(
            width: config.nodeSize + 8,
            child: Column(
              children: [
                // The half-height stub above the node keeps the line continuous
                // between rows without drawing past the first or last one.
                SizedBox(
                  height: 4,
                  child: isFirst
                      ? null
                      : Center(
                          child: Container(width: config.lineWidth, color: isPending ? connectorColor : connectorColor),
                        ),
                ),
                _TimelineNode(size: config.nodeSize, color: color, state: item.state, icon: item.icon, surface: scheme.surface),
                Expanded(
                  child: isLast
                      ? const SizedBox.shrink()
                      : Center(
                          child: config.dashPendingConnector && isPending
                              ? _DashedLine(width: config.lineWidth, color: connectorColor)
                              : Container(width: config.lineWidth, color: connectorColor),
                        ),
                ),
              ],
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: item.onTap,
              child: Padding(
                padding: EdgeInsets.only(left: config.contentSpacing, bottom: isLast ? 0 : config.itemSpacing + 8),
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.size, required this.color, required this.state, required this.surface, this.icon});

  final double size;
  final Color color;
  final TimelineItemStateX state;
  final Color surface;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final isActive = state == TimelineItemStateX.active;
    final isCompleted = state == TimelineItemStateX.completed;

    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: isActive ? surface : color,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: isActive ? 3 : 1.5),
        boxShadow: isActive ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 6, spreadRadius: 2)] : null,
      ),
      child: icon != null
          ? Icon(icon, size: size * 0.6, color: isActive ? color : surface)
          : (isCompleted ? Icon(Icons.check_rounded, size: size * 0.65, color: surface) : null),
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dash = 4.0;
        const gap = 3.0;
        final count = (constraints.maxHeight / (dash + gap)).floor().clamp(0, 200);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            count,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: gap),
              child: Container(width: width, height: dash, color: color),
            ),
          ),
        );
      },
    );
  }
}
