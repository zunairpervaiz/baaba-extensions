import 'package:flutter/material.dart';

/// A shimmer-style loading placeholder.
///
/// Use it wherever content is still loading to give the user a visual cue
/// about the shape of the incoming content.
///
/// Example:
/// ```dart
/// SkeletonLoaderWidgetx(width: 200, height: 20)
/// SkeletonLoaderWidgetx(width: 48, height: 48, borderRadius: BorderRadius.circular(24))
/// ```
class SkeletonLoaderWidgetx extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonLoaderWidgetx({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<SkeletonLoaderWidgetx> createState() => _SkeletonLoaderWidgetxState();
}

class _SkeletonLoaderWidgetxState extends State<SkeletonLoaderWidgetx>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = widget.baseColor ??
        (isDark ? Colors.grey.shade700 : Colors.grey.shade300);
    final highlight = widget.highlightColor ??
        (isDark ? Colors.grey.shade600 : Colors.grey.shade100);

    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [base, highlight, base],
            stops: [
              (_anim.value - 1).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 1).clamp(0.0, 1.0),
            ],
          ),
        ),
      ),
    );
  }
}
