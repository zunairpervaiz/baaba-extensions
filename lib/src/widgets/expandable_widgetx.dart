import 'package:flutter/material.dart';

/// An animated expand / collapse container.
///
/// Example:
/// ```dart
/// ExpandableWidgetx(
///   header: Text('Section title'),
///   body: Text('Hidden content revealed on tap.'),
///   initiallyExpanded: true,
/// )
/// ```
class ExpandableWidgetx extends StatefulWidget {
  final Widget header;
  final Widget body;
  final bool initiallyExpanded;
  final Duration animationDuration;
  final Curve curve;
  final void Function(bool isExpanded)? onToggle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsets? headerPadding;
  final EdgeInsets? bodyPadding;

  const ExpandableWidgetx({
    super.key,
    required this.header,
    required this.body,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.onToggle,
    this.backgroundColor,
    this.borderRadius,
    this.headerPadding,
    this.bodyPadding,
  });

  @override
  State<ExpandableWidgetx> createState() => _ExpandableWidgetxState();
}

class _ExpandableWidgetxState extends State<ExpandableWidgetx>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _heightFactor;
  late final Animation<double> _iconTurn;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _heightFactor =
        CurvedAnimation(parent: _controller, curve: widget.curve);
    _iconTurn =
        Tween<double>(begin: 0.0, end: 0.5).animate(_heightFactor);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isExpanded = !_isExpanded);
    _isExpanded ? _controller.forward() : _controller.reverse();
    widget.onToggle?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: widget.borderRadius,
            child: Padding(
              padding: widget.headerPadding ?? EdgeInsets.zero,
              child: Row(
                children: [
                  Expanded(child: widget.header),
                  RotationTransition(
                    turns: _iconTurn,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: AnimatedBuilder(
              animation: _heightFactor,
              builder: (_, child) => Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              ),
              child: Padding(
                padding: widget.bodyPadding ?? EdgeInsets.zero,
                child: widget.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
