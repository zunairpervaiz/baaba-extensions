import 'package:flutter/material.dart';

extension ScrollxExtensions on ScrollController {
  /// Animates the scroll position to the given value.
  Future<void> animateToPosition(
    double offset, {
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.fastOutSlowIn,
  }) async {
    await animateTo(offset, duration: duration, curve: curve);
  }

  /// Animates the scroll position to the bottom of the scrollable.
  Future<void> animateToBottom({Duration duration = const Duration(milliseconds: 500), Curve curve = Curves.fastOutSlowIn}) async {
    await animateToPosition(position.maxScrollExtent, duration: duration, curve: curve);
  }

  /// Animates the scroll position to the top of the scrollable.
  Future<void> animateToTop({Duration duration = const Duration(milliseconds: 500), Curve curve = Curves.fastOutSlowIn}) async {
    await animateToPosition(position.minScrollExtent, duration: duration, curve: curve);
  }

  /// Checks if the scroll position is near the bottom of the scrollable.
  bool isNearBottom({double threshold = 50.0}) => position.pixels >= position.maxScrollExtent - threshold;

  bool get canScroll => hasClients && position.maxScrollExtent > position.minScrollExtent;
}
