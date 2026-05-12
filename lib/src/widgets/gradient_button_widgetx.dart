import 'package:flutter/material.dart';

/// A button with a gradient background.
///
/// Example:
/// ```dart
/// GradientButtonWidgetx(
///   text: 'Get Started',
///   gradientColors: [Colors.purple, Colors.blue],
///   onPressed: () => navigate(),
/// )
/// ```
class GradientButtonWidgetx extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final List<Color> gradientColors;
  final AlignmentGeometry gradientBegin;
  final AlignmentGeometry gradientEnd;
  final double height;
  final double? width;
  final double borderRadius;
  final TextStyle? textStyle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsets padding;

  const GradientButtonWidgetx({
    super.key,
    required this.text,
    this.onPressed,
    this.gradientColors = const [Color(0xFF6C63FF), Color(0xFF3B82F6)],
    this.gradientBegin = Alignment.centerLeft,
    this.gradientEnd = Alignment.centerRight,
    this.height = 52,
    this.width,
    this.borderRadius = 12,
    this.textStyle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: Colors.white24,
          child: Ink(
            height: height,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: gradientBegin,
                end: gradientEnd,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Padding(
              padding: padding,
              child: Row(
                mainAxisSize:
                    width == null ? MainAxisSize.min : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
