import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A horizontal step progress indicator.
///
/// With [labels], each label gets the room between its neighbours, which is
/// measured with a [LayoutBuilder] — so do not place a labelled stepper inside
/// [IntrinsicHeight] or [IntrinsicWidth].
///
/// Example:
/// ```dart
/// StepperIndicatorWidgetx(
///   totalSteps: 4,
///   currentStep: 2,
///   labels: ['Info', 'Address', 'Payment', 'Done'],
/// )
/// ```
class StepperIndicatorWidgetx extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color? activeColor;
  final Color? completedColor;
  final Color? inactiveColor;
  final double stepSize;
  final double connectorHeight;
  final List<String>? labels;
  final TextStyle? labelStyle;
  final TextStyle? activeLabelStyle;

  const StepperIndicatorWidgetx({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.activeColor,
    this.completedColor,
    this.inactiveColor,
    this.stepSize = 32,
    this.connectorHeight = 3,
    this.labels,
    this.labelStyle,
    this.activeLabelStyle,
  });

  @override
  Widget build(BuildContext context) {
    // No steps, nothing to draw (and `totalSteps * 2 - 1` would go negative).
    if (totalSteps <= 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final active = activeColor ?? theme.colorScheme.primary;
    final completed = completedColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.outlineVariant;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(totalSteps * 2 - 1, (i) {
            if (i.isOdd) {
              final connectorStepIndex = i ~/ 2;
              final isCompleted = connectorStepIndex < currentStep - 1;
              return Expanded(
                child: Container(height: connectorHeight, color: isCompleted ? completed : inactive),
              );
            }
            final stepIndex = i ~/ 2 + 1;
            final isCompleted = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;
            final circleColor = isCompleted || isActive ? active : inactive;

            return Container(
              width: stepSize,
              height: stepSize,
              decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: isCompleted
                  ? Icon(Icons.check_rounded, size: stepSize * 0.5, color: Colors.white)
                  : Text(
                      '$stepIndex',
                      style: TextStyle(color: Colors.white, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: stepSize * 0.38),
                    ),
            );
          }),
        ),
        if (labels != null && labels!.isNotEmpty) ...[
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) => _buildLabels(constraints, active, inactive)),
        ],
      ],
    );
  }

  // Each label is centred under its step and may use the room up to halfway to
  // each neighbour, rather than only the width of the step circle. The first
  // and last labels cannot extend past the edges, so they start at the circle
  // and grow inwards; a label narrower than the circle stays centred on it.
  Widget _buildLabels(BoxConstraints constraints, Color active, Color inactive) {
    Widget label(int stepIndex) {
      final isActive = stepIndex + 1 == currentStep;
      return Text(
        stepIndex < labels!.length ? labels![stepIndex] : '',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: isActive
            ? (activeLabelStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: active))
            : (labelStyle ?? TextStyle(fontSize: 10, color: inactive)),
      );
    }

    Widget edgeLabel(int stepIndex, AlignmentGeometry alignment) => Align(
      alignment: alignment,
      child: ConstrainedBox(constraints: BoxConstraints(minWidth: stepSize), child: label(stepIndex)),
    );

    if (totalSteps == 1) return Row(children: [Expanded(child: edgeLabel(0, Alignment.centerLeft))]);

    // Distance between the centres of neighbouring step circles.
    final width = constraints.hasBoundedWidth ? constraints.maxWidth : totalSteps * stepSize;
    final pitch = math.max(0.0, (width - stepSize) / (totalSteps - 1));

    return Row(
      children: [
        SizedBox(width: (stepSize + pitch) / 2, child: edgeLabel(0, Alignment.centerLeft)),
        for (var i = 1; i < totalSteps - 1; i++) SizedBox(width: pitch, child: label(i)),
        Expanded(child: edgeLabel(totalSteps - 1, Alignment.centerRight)),
      ],
    );
  }
}
