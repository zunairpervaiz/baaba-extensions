import 'dart:async';

import 'package:flutter/material.dart';

import '../durationx_extensions.dart';

/// A countdown timer that auto-ticks every second and fires [onFinished]
/// when it reaches zero.
///
/// Expose the state key to call [start], [pause], and [reset] programmatically.
///
/// Example:
/// ```dart
/// final key = GlobalKey<CountdownTimerWidgetxState>();
///
/// CountdownTimerWidgetx(
///   key: key,
///   duration: const Duration(minutes: 5),
///   onFinished: () => showDialog(...),
/// )
///
/// // Programmatic control:
/// key.currentState?.pause();
/// key.currentState?.reset();
/// ```
class CountdownTimerWidgetx extends StatefulWidget {
  /// The time to count down from.
  ///
  /// Changing it starts the countdown over from the new value; it keeps
  /// ticking if it was running or [autoStart] is set.
  final Duration duration;
  final VoidCallback? onFinished;
  final void Function(Duration remaining)? onTick;
  final Widget Function(BuildContext context, Duration remaining, bool isFinished)? builder;
  final TextStyle? textStyle;
  final bool autoStart;

  const CountdownTimerWidgetx({super.key, required this.duration, this.onFinished, this.onTick, this.builder, this.textStyle, this.autoStart = true});

  @override
  State<CountdownTimerWidgetx> createState() => CountdownTimerWidgetxState();
}

class CountdownTimerWidgetxState extends State<CountdownTimerWidgetx> {
  late Duration _remaining;
  Timer? _timer;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    if (widget.autoStart) start();
  }

  @override
  void didUpdateWidget(covariant CountdownTimerWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration == oldWidget.duration) return;
    // A new duration starts the countdown over. It keeps ticking if it was
    // already running or [CountdownTimerWidgetx.autoStart] is set, and
    // otherwise waits for [start], as on first mount.
    final wasRunning = _timer?.isActive ?? false;
    _timer?.cancel();
    _remaining = widget.duration;
    _isFinished = false;
    if (widget.autoStart || wasRunning) start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Starts or resumes the countdown.
  void start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
  }

  /// Pauses the countdown.
  void pause() => _timer?.cancel();

  /// Resets the countdown to the original [duration] and stops ticking.
  void reset() {
    _timer?.cancel();
    setState(() {
      _remaining = widget.duration;
      _isFinished = false;
    });
  }

  void _tick(Timer _) {
    final next = _remaining - const Duration(seconds: 1);
    if (next <= Duration.zero) {
      // Finish on the tick that reaches zero, not one tick later.
      _timer?.cancel();
      setState(() {
        _remaining = Duration.zero;
        _isFinished = true;
      });
      widget.onTick?.call(_remaining);
      widget.onFinished?.call();
    } else {
      setState(() => _remaining = next);
      widget.onTick?.call(_remaining);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _remaining, _isFinished);
    }
    return Text((_isFinished ? Duration.zero : _remaining).toClock(), style: widget.textStyle ?? Theme.of(context).textTheme.titleMedium);
  }
}
