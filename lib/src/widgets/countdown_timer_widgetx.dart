import 'dart:async';
import 'package:flutter/material.dart';

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
  final Duration duration;
  final VoidCallback? onFinished;
  final void Function(Duration remaining)? onTick;
  final Widget Function(
    BuildContext context,
    Duration remaining,
    bool isFinished,
  )? builder;
  final TextStyle? textStyle;
  final bool autoStart;

  const CountdownTimerWidgetx({
    super.key,
    required this.duration,
    this.onFinished,
    this.onTick,
    this.builder,
    this.textStyle,
    this.autoStart = true,
  });

  @override
  State<CountdownTimerWidgetx> createState() =>
      CountdownTimerWidgetxState();
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
    if (_remaining.inSeconds <= 0) {
      _timer?.cancel();
      setState(() => _isFinished = true);
      widget.onFinished?.call();
    } else {
      setState(() => _remaining -= const Duration(seconds: 1));
      widget.onTick?.call(_remaining);
    }
  }

  String _format(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '$h:$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder!(context, _remaining, _isFinished);
    }
    return Text(
      _isFinished ? '00:00' : _format(_remaining),
      style: widget.textStyle ?? Theme.of(context).textTheme.titleMedium,
    );
  }
}
