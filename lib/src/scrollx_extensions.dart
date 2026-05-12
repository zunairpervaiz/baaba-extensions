import 'package:flutter/material.dart';

extension ScrollxExtensions on ScrollController {
  /// Animates to [offset] with the given [duration] and [curve].
  Future<void> animateToPosition(
    double offset, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.fastOutSlowIn,
  }) async {
    if (!hasClients) return;
    await animateTo(offset, duration: duration, curve: curve);
  }

  /// Animates to the bottom of the scrollable.
  Future<void> animateToBottom({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.fastOutSlowIn,
  }) =>
      animateToPosition(
        position.maxScrollExtent,
        duration: duration,
        curve: curve,
      );

  /// Animates to the top of the scrollable.
  Future<void> animateToTop({
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.fastOutSlowIn,
  }) =>
      animateToPosition(
        position.minScrollExtent,
        duration: duration,
        curve: curve,
      );

  /// Jumps instantly to the bottom of the scrollable.
  void jumpToBottom() {
    if (hasClients) jumpTo(position.maxScrollExtent);
  }

  /// Jumps instantly to the top of the scrollable.
  void jumpToTop() {
    if (hasClients) jumpTo(position.minScrollExtent);
  }

  /// Returns true when the scroll position is within [threshold] px of the bottom.
  bool isNearBottom({double threshold = 50.0}) =>
      hasClients && position.pixels >= position.maxScrollExtent - threshold;

  /// Returns true when the scroll position is within [threshold] px of the top.
  bool isNearTop({double threshold = 50.0}) =>
      hasClients && position.pixels <= position.minScrollExtent + threshold;

  /// Returns true when the scroll position is exactly at the top.
  bool get isAtTop =>
      hasClients && position.pixels <= position.minScrollExtent;

  /// Returns true when the scroll position is exactly at the bottom.
  bool get isAtBottom =>
      hasClients && position.pixels >= position.maxScrollExtent;

  /// Returns true when the controller has clients and the content is scrollable.
  bool get canScroll =>
      hasClients &&
      position.maxScrollExtent > position.minScrollExtent;

  /// Returns the current scroll progress as a value from 0.0 (top) to 1.0 (bottom).
  double get scrollPercentage {
    if (!hasClients) return 0.0;
    final extent =
        position.maxScrollExtent - position.minScrollExtent;
    if (extent == 0) return 0.0;
    return ((position.pixels - position.minScrollExtent) / extent)
        .clamp(0.0, 1.0);
  }
}
