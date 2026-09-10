import 'package:flutter/material.dart';

import 'skeleton_loader_widgetx.dart';

/// A shimmering list placeholder — [rows] repeated skeleton rows, each an
/// optional circular avatar beside two lines of text.
///
/// This is the default first-page loading state of [PaginatedListWidgetx], and
/// is usable on its own anywhere a list is still loading.
///
/// Example:
/// ```dart
/// // Default rows:
/// const SkeletonListWidgetx(rows: 8)
///
/// // No avatar, tighter rows:
/// const SkeletonListWidgetx(rows: 6, showAvatar: false, rowHeight: 44)
///
/// // Fully custom row shape:
/// SkeletonListWidgetx(
///   rows: 5,
///   rowBuilder: (context, index) => const SkeletonLoaderWidgetx(
///     width: double.infinity,
///     height: 120,
///   ),
/// )
/// ```
class SkeletonListWidgetx extends StatelessWidget {
  /// Number of placeholder rows to render.
  final int rows;

  /// Height of the leading avatar and of the whole row when [rowBuilder] and
  /// [showAvatar] are left at their defaults.
  final double rowHeight;

  /// Vertical gap between rows.
  final double spacing;

  /// Padding around the list.
  final EdgeInsets padding;

  /// Whether each default row starts with a circular avatar placeholder.
  final bool showAvatar;

  /// Diameter of the avatar placeholder.
  final double avatarSize;

  /// Corner radius of the line placeholders.
  final BorderRadius borderRadius;

  /// Base shimmer colour. Falls back to a theme-appropriate grey.
  final Color? baseColor;

  /// Highlight shimmer colour. Falls back to a theme-appropriate grey.
  final Color? highlightColor;

  /// Scroll physics for the underlying list.
  final ScrollPhysics? physics;

  /// Whether the list should size itself to its contents.
  final bool shrinkWrap;

  /// Builds a custom placeholder row, replacing the default avatar-and-lines
  /// layout.
  final IndexedWidgetBuilder? rowBuilder;

  const SkeletonListWidgetx({
    super.key,
    this.rows = 6,
    this.rowHeight = 56,
    this.spacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.showAvatar = true,
    this.avatarSize = 44,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
    this.physics,
    this.shrinkWrap = false,
    this.rowBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: rows,
      separatorBuilder: (_, _) => SizedBox(height: spacing),
      itemBuilder: rowBuilder ?? _defaultRow,
    );
  }

  Widget _defaultRow(BuildContext context, int index) {
    return Row(
      children: [
        if (showAvatar) ...[
          SkeletonLoaderWidgetx(
            width: avatarSize,
            height: avatarSize,
            borderRadius: BorderRadius.circular(avatarSize / 2),
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonLoaderWidgetx(
                width: double.infinity,
                height: rowHeight * 0.25,
                borderRadius: borderRadius,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(height: 8),
              FractionallySizedBox(
                widthFactor: 0.6,
                alignment: Alignment.centerLeft,
                child: SkeletonLoaderWidgetx(
                  width: double.infinity,
                  height: rowHeight * 0.2,
                  borderRadius: borderRadius,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
