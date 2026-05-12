import 'package:flutter/material.dart';

extension DurationX on Duration {
  /// Returns a compact human-readable string, e.g. `'2h 30m'`, `'45s'`.
  ///
  /// Example: `const Duration(hours: 2, minutes: 30).format()` → `'2h 30m'`
  String format() {
    if (inDays > 0) {
      final h = inHours.remainder(24);
      return h > 0 ? '${inDays}d ${h}h' : '${inDays}d';
    }
    if (inHours > 0) {
      final m = inMinutes.remainder(60);
      return m > 0 ? '${inHours}h ${m}m' : '${inHours}h';
    }
    if (inMinutes > 0) {
      final s = inSeconds.remainder(60);
      return s > 0 ? '${inMinutes}m ${s}s' : '${inMinutes}m';
    }
    return '${inSeconds}s';
  }

  /// Returns a [DateTime] this duration from now.
  ///
  /// Example: `const Duration(hours: 2).fromNow` → two hours in the future
  DateTime get fromNow => DateTime.now().add(this);

  /// Returns a [DateTime] this duration before now.
  ///
  /// Example: `const Duration(days: 7).ago` → seven days in the past
  DateTime get ago => DateTime.now().subtract(this);

  /// Runs [action] after this duration elapses.
  Future<void> delay(VoidCallback action) => Future.delayed(this, action);

  /// Returns true when this duration is exactly zero.
  bool get isZero => inMicroseconds == 0;

  /// Returns a new [Duration] scaled by [factor].
  ///
  /// Example: `const Duration(seconds: 10) * 2.5` → `Duration(seconds: 25)`
  Duration operator *(double factor) =>
      Duration(microseconds: (inMicroseconds * factor).round());
}
