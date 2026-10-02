import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A circular progress ring with a label in the middle.
///
/// Unlike [CircularProgressIndicator] this animates between values, supports a
/// gradient sweep, and renders its own percentage label — the shape used for
/// dashboards, upload progress, goal rings, and quiz scores.
///
/// Example:
/// ```dart
/// CircularProgressWidgetx(value: 0.72, size: 120)
///
/// // Gradient ring with a custom centre.
/// CircularProgressWidgetx(
///   value: uploaded / total,
///   size: 90,
///   strokeWidth: 8,
///   gradientColors: const [Colors.orange, Colors.pink],
///   center: Text('${uploaded}MB'),
/// )
///
/// // Indeterminate, while the total is still unknown.
/// CircularProgressWidgetx(value: null, size: 60)
/// ```
class CircularProgressWidgetx extends StatelessWidget {
  /// Progress from `0.0` to `1.0`. Values outside that range are clamped, and a
  /// non-finite value (`NaN` from `0 / 0`, or infinity from dividing by zero)
  /// is treated as `0.0`.
  ///
  /// Pass `null` for an indeterminate spinner.
  final double? value;

  /// Diameter of the ring. Defaults to `80`.
  final double size;

  /// Thickness of the ring. Defaults to `8`.
  final double strokeWidth;

  /// Colour of the progress arc. Defaults to the primary colour.
  /// Ignored when [gradientColors] is set.
  final Color? progressColor;

  /// Colour of the unfilled track behind the arc.
  final Color? backgroundColor;

  /// Sweeps the arc through these colours instead of using [progressColor].
  /// Needs at least two entries.
  final List<Color>? gradientColors;

  /// Rounds the ends of the arc. Defaults to `true`.
  final bool isRounded;

  /// Where the arc starts, in degrees clockwise from twelve o'clock.
  final double startAngle;

  /// Widget rendered in the middle of the ring. Overrides [showPercentage].
  final Widget? center;

  /// Renders the progress as a percentage in the middle of the ring.
  /// Defaults to `true`. Ignored when [center] is set or [value] is null.
  final bool showPercentage;

  /// Decimal places on the percentage label. Defaults to `0`.
  final int percentageDecimals;

  /// Style of the percentage label. Defaults to a size derived from [size].
  final TextStyle? labelStyle;

  /// Caption rendered under the percentage — `of goal`, `uploaded`, and so on.
  final String? caption;

  /// Style of [caption].
  final TextStyle? captionStyle;

  /// How long the ring takes to animate to a new [value]. Defaults to `600ms`.
  final Duration animationDuration;

  /// Curve of the value animation.
  final Curve animationCurve;

  const CircularProgressWidgetx({
    super.key,
    required this.value,
    this.size = 80,
    this.strokeWidth = 8,
    this.progressColor,
    this.backgroundColor,
    this.gradientColors,
    this.isRounded = true,
    this.startAngle = 0,
    this.center,
    this.showPercentage = true,
    this.percentageDecimals = 0,
    this.labelStyle,
    this.caption,
    this.captionStyle,
    this.animationDuration = const Duration(milliseconds: 600),
    this.animationCurve = Curves.easeOutCubic,
  }) : assert(gradientColors == null || gradientColors.length >= 2, 'CircularProgressWidgetx: gradientColors needs at least two colours.');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final track = backgroundColor ?? scheme.outline.withValues(alpha: 0.18);
    final arcColor = progressColor ?? scheme.primary;

    // An indeterminate ring has nothing to tween towards, so it falls back to
    // the framework spinner rather than animating a fabricated value.
    if (value == null) {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                backgroundColor: track,
                valueColor: AlwaysStoppedAnimation<Color>(arcColor),
                strokeCap: isRounded ? StrokeCap.round : StrokeCap.butt,
              ),
            ),
            ?center,
          ],
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: value!.isFinite ? value!.clamp(0.0, 1.0) : 0.0),
      duration: animationDuration,
      curve: animationCurve,
      builder: (context, animated, _) => SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _RingPainter(
            value: animated,
            strokeWidth: strokeWidth,
            trackColor: track,
            arcColor: arcColor,
            gradientColors: gradientColors,
            isRounded: isRounded,
            startAngle: startAngle,
          ),
          child: Center(child: center ?? _buildLabel(context, animated, theme)),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, double animated, ThemeData theme) {
    if (!showPercentage) return const SizedBox.shrink();

    final percent = (animated * 100).toStringAsFixed(percentageDecimals);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$percent%',
          style: labelStyle ?? theme.textTheme.titleMedium?.copyWith(fontSize: size * 0.2, fontWeight: FontWeight.w700, height: 1.1),
        ),
        if (caption != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              caption!,
              textAlign: TextAlign.center,
              style:
                  captionStyle ??
                  theme.textTheme.bodySmall?.copyWith(fontSize: size * 0.1, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), height: 1.1),
            ),
          ),
      ],
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.value,
    required this.strokeWidth,
    required this.trackColor,
    required this.arcColor,
    required this.gradientColors,
    required this.isRounded,
    required this.startAngle,
  });

  final double value;
  final double strokeWidth;
  final Color trackColor;
  final Color arcColor;
  final List<Color>? gradientColors;
  final bool isRounded;
  final double startAngle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - strokeWidth) / 2;
    if (radius <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    // Canvas angles start at three o'clock, so shift by a quarter turn to make
    // twelve o'clock the zero point users expect.
    final start = -math.pi / 2 + startAngle * math.pi / 180;
    final sweep = 2 * math.pi * value;

    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    if (value <= 0) return;

    final arcPaint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = isRounded ? StrokeCap.round : StrokeCap.butt;

    final colors = gradientColors;
    if (colors != null) {
      arcPaint.shader = SweepGradient(
        colors: [...colors, colors.first],
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(start),
      ).createShader(rect);
    } else {
      arcPaint.color = arcColor;
    }

    canvas.drawArc(rect, start, sweep, false, arcPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.value != value ||
      old.strokeWidth != strokeWidth ||
      old.trackColor != trackColor ||
      old.arcColor != arcColor ||
      old.isRounded != isRounded ||
      old.startAngle != startAngle ||
      !listEquals(old.gradientColors, gradientColors);

  static bool listEquals(List<Color>? a, List<Color>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
