import 'package:flutter/material.dart';

/// A count or dot badge anchored to the corner of another widget.
///
/// Hides itself when [count] is zero (unless [showZero] is set) and caps the
/// displayed number at [maxCount], rendering `99+` beyond it — so the badge
/// never grows unbounded over a tab icon.
///
/// Example:
/// ```dart
/// BadgeWidgetx(
///   count: unreadCount,
///   child: const Icon(Icons.notifications_outlined),
/// )
///
/// // A plain status dot, no number.
/// BadgeWidgetx.dot(
///   isVisible: hasUpdates,
///   color: Colors.green,
///   child: const Icon(Icons.person_outline),
/// )
///
/// // Custom text.
/// BadgeWidgetx(label: 'NEW', child: ProductCard(product))
/// ```
class BadgeWidgetx extends StatelessWidget {
  /// The widget the badge is anchored to — usually an icon or an avatar.
  final Widget child;

  /// The number shown in the badge.
  ///
  /// Ignored when [label] is supplied. A value of zero hides the badge unless
  /// [showZero] is `true`.
  final int? count;

  /// Text shown instead of [count] — `NEW`, `BETA`, and the like.
  final String? label;

  /// Largest number rendered as-is. Anything above shows as `$maxCount+`.
  final int maxCount;

  /// Renders a small dot with no text.
  final bool isDot;

  /// When `false` the badge is not rendered at all, whatever [count] says.
  final bool isVisible;

  /// Shows the badge even when [count] is zero.
  final bool showZero;

  /// Background colour. Defaults to the theme error colour.
  final Color? color;

  /// Text colour. Defaults to the theme onError colour.
  final Color? textColor;

  /// Colour of the ring drawn around the badge, which separates it from the
  /// content behind. Defaults to the surface colour.
  final Color? borderColor;

  /// Width of the ring around the badge. Set to `0` to remove it.
  final double borderWidth;

  /// Diameter of the badge when [isDot] is `true`. Defaults to `9`.
  final double dotSize;

  /// Font size of the badge text. Defaults to `10`.
  final double fontSize;

  /// Where the badge sits relative to [child]. Defaults to the top-right.
  final AlignmentGeometry alignment;

  /// Nudges the badge from its [alignment] position.
  final Offset offset;

  /// Animates the badge in and out as it appears, disappears, or changes.
  final bool animate;

  /// Duration of the appearance animation when [animate] is `true`.
  final Duration animationDuration;

  const BadgeWidgetx({
    super.key,
    required this.child,
    this.count,
    this.label,
    this.maxCount = 99,
    this.isVisible = true,
    this.showZero = false,
    this.color,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.5,
    this.dotSize = 9,
    this.fontSize = 10,
    this.alignment = Alignment.topRight,
    this.offset = const Offset(6, -6),
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 220),
  }) : isDot = false;

  /// A badge with no text — just a coloured status dot.
  const BadgeWidgetx.dot({
    super.key,
    required this.child,
    this.isVisible = true,
    this.color,
    this.borderColor,
    this.borderWidth = 1.5,
    this.dotSize = 9,
    this.alignment = Alignment.topRight,
    this.offset = const Offset(2, -2),
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 220),
  }) : isDot = true,
       count = null,
       label = null,
       maxCount = 99,
       showZero = false,
       textColor = null,
       fontSize = 10;

  /// Returns the text to render, or `null` when the badge should be hidden.
  String? get _resolvedLabel {
    if (!isVisible) return null;
    if (isDot) return '';
    if (label != null) return label;
    final value = count;
    if (value == null) return null;
    if (value <= 0 && !showZero) return null;
    return value > maxCount ? '$maxCount+' : '$value';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = _resolvedLabel;

    final Widget badge = text == null
        ? const SizedBox.shrink()
        : Container(
            // A dot has no text, so it is sized directly; a counted badge is
            // sized by its label but never narrower than it is tall.
            constraints: isDot ? null : BoxConstraints(minWidth: fontSize + 8, minHeight: fontSize + 8),
            height: isDot ? dotSize : null,
            width: isDot ? dotSize : null,
            padding: isDot || text.isEmpty ? null : EdgeInsets.symmetric(horizontal: text.length > 2 ? 5 : 4),
            decoration: BoxDecoration(
              color: color ?? scheme.error,
              shape: BoxShape.circle,
              border: borderWidth <= 0 ? null : Border.all(color: borderColor ?? scheme.surface, width: borderWidth),
            ),
            child: isDot
                ? null
                : Center(
                    widthFactor: 1,
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textColor ?? scheme.onError, fontSize: fontSize, fontWeight: FontWeight.w700, height: 1.1),
                    ),
                  ),
          );

    return Stack(
      clipBehavior: Clip.none,
      alignment: alignment,
      children: [
        child,
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: Transform.translate(
              offset: offset,
              child: animate
                  ? AnimatedSwitcher(
                      duration: animationDuration,
                      transitionBuilder: (widget, animation) => ScaleTransition(scale: animation, child: widget),
                      // The key makes each distinct value its own child, so the
                      // switcher animates on a count change and not only on
                      // appearance.
                      child: KeyedSubtree(key: ValueKey<String?>(text), child: badge),
                    )
                  : badge,
            ),
          ),
        ),
      ],
    );
  }
}
