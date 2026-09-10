import 'package:flutter/material.dart';

/// A number that animates from its previous value to its new one.
///
/// Use it for stat tiles, cart totals, live scores, and price changes, where
/// a number snapping to a new value reads as a glitch.
///
/// Example:
/// ```dart
/// AnimatedCounterWidgetx(value: order.total, prefix: 'Rs. ', decimals: 2)
///
/// AnimatedCounterWidgetx(
///   value: followers,
///   useThousandsSeparator: true,
///   textStyle: context.textTheme.headlineMedium,
/// )
///
/// // Full control over formatting — plug in intl, for instance.
/// AnimatedCounterWidgetx(
///   value: revenue,
///   formatter: (v) => NumberFormat.compactCurrency(symbol: 'Rs. ').format(v),
/// )
/// ```
class AnimatedCounterWidgetx extends StatelessWidget {
  /// The number to display. Changing it animates from the previous value.
  final num value;

  /// How long the animation to a new [value] takes. Defaults to `600ms`.
  final Duration duration;

  /// Curve of the animation.
  final Curve curve;

  /// Number of decimal places shown. Defaults to `0`.
  final int decimals;

  /// Groups the integer part into thousands using [separator].
  final bool useThousandsSeparator;

  /// The thousands separator. Defaults to `,`.
  final String separator;

  /// Text placed before the number — a currency symbol, usually.
  final String prefix;

  /// Text placed after the number — a unit or a percent sign.
  final String suffix;

  /// Replaces the built-in formatting entirely. When set, [decimals],
  /// [useThousandsSeparator], [separator], [prefix], and [suffix] are ignored.
  final String Function(num value)? formatter;

  /// Style of the rendered number.
  final TextStyle? textStyle;

  /// Alignment of the text within its box.
  final TextAlign? textAlign;

  /// Maximum lines before the text is ellipsised.
  final int? maxLines;

  /// Animates from this value the first time the widget is built.
  ///
  /// Defaults to `0`, so a counter counts up on entry. Set it to [value] to
  /// have the first frame render the final number with no animation.
  final num? initialValue;

  const AnimatedCounterWidgetx({
    super.key,
    required this.value,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.decimals = 0,
    this.useThousandsSeparator = false,
    this.separator = ',',
    this.prefix = '',
    this.suffix = '',
    this.formatter,
    this.textStyle,
    this.textAlign,
    this.maxLines,
    this.initialValue,
  }) : assert(decimals >= 0, 'AnimatedCounterWidgetx: decimals must not be negative.');

  /// Formats [current] according to this widget's configuration.
  String format(num current) {
    if (formatter != null) return formatter!(current);

    final fixed = current.toStringAsFixed(decimals);
    if (!useThousandsSeparator) return '$prefix$fixed$suffix';

    // Only the integer part is grouped; a leading minus is preserved.
    final isNegative = fixed.startsWith('-');
    final unsigned = isNegative ? fixed.substring(1) : fixed;
    final dotIndex = unsigned.indexOf('.');
    final whole = dotIndex == -1 ? unsigned : unsigned.substring(0, dotIndex);
    final fraction = dotIndex == -1 ? '' : unsigned.substring(dotIndex);

    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(separator);
      buffer.write(whole[i]);
    }

    return '$prefix${isNegative ? '-' : ''}$buffer$fraction$suffix';
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      // The tween's begin is only honoured on the first build; afterwards
      // TweenAnimationBuilder animates from wherever the value currently is.
      tween: Tween<double>(begin: (initialValue ?? 0).toDouble(), end: value.toDouble()),
      duration: duration,
      curve: curve,
      builder: (context, current, _) => Text(
        format(current),
        style: textStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: maxLines == null ? null : TextOverflow.ellipsis,
      ),
    );
  }
}
