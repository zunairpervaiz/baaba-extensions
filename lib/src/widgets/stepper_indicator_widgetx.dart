import 'package:flutter/material.dart';

/// A horizontal step progress indicator.
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
                child: Container(
                  height: connectorHeight,
                  color: isCompleted ? completed : inactive,
                ),
              );
            }
            final stepIndex = i ~/ 2 + 1;
            final isCompleted = stepIndex < currentStep;
            final isActive = stepIndex == currentStep;
            final circleColor =
                isCompleted || isActive ? active : inactive;

            return Container(
              width: stepSize,
              height: stepSize,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? Icon(
                      Icons.check_rounded,
                      size: stepSize * 0.5,
                      color: Colors.white,
                    )
                  : Text(
                      '$stepIndex',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: stepSize * 0.38,
                      ),
                    ),
            );
          }),
        ),
        if (labels != null && labels!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps * 2 - 1, (i) {
              if (i.isOdd) return const Expanded(child: SizedBox.shrink());
              final stepIndex = i ~/ 2;
              final isActive = stepIndex + 1 == currentStep;
              final label =
                  stepIndex < labels!.length ? labels![stepIndex] : '';
              return SizedBox(
                width: stepSize,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: isActive
                      ? (activeLabelStyle ??
                          TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: active,
                          ))
                      : (labelStyle ??
                          TextStyle(fontSize: 10, color: inactive)),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
