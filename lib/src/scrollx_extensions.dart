import 'package:flutter/material.dart';

/// Every member is safe to call on an unattached controller (it does nothing,
/// or reports `false` / `0.0`) and on a controller attached to more than one
/// scroll view. With several attached views, the jump and animate members move
/// each view to its own top or bottom, and the getters report on the most
/// recently attached view (`positions.last`).
extension ScrollxExtensions on ScrollController {
  // The most recently attached position, or null when nothing is attached.
  // `position` asserts exactly one attachment, so it is never used here.
  ScrollPosition? get _lastPosition => hasClients ? positions.last : null;

  /// Animates to [offset] with the given [duration] and [curve].
  Future<void> animateToPosition(double offset, {Duration duration = const Duration(milliseconds: 500), Curve curve = Curves.fastOutSlowIn}) async {
    if (!hasClients) return;
    await animateTo(offset, duration: duration, curve: curve);
  }

  /// Animates every attached scrollable to its own bottom; does nothing when unattached.
  Future<void> animateToBottom({Duration duration = const Duration(milliseconds: 500), Curve curve = Curves.fastOutSlowIn}) async {
    if (!hasClients) return;
    await Future.wait([for (final p in positions) p.animateTo(p.maxScrollExtent, duration: duration, curve: curve)]);
  }

  /// Animates every attached scrollable to its own top; does nothing when unattached.
  Future<void> animateToTop({Duration duration = const Duration(milliseconds: 500), Curve curve = Curves.fastOutSlowIn}) async {
    if (!hasClients) return;
    await Future.wait([for (final p in positions) p.animateTo(p.minScrollExtent, duration: duration, curve: curve)]);
  }

  /// Jumps every attached scrollable instantly to its own bottom.
  void jumpToBottom() {
    for (final p in positions.toList()) {
      p.jumpTo(p.maxScrollExtent);
    }
  }

  /// Jumps every attached scrollable instantly to its own top.
  void jumpToTop() {
    for (final p in positions.toList()) {
      p.jumpTo(p.minScrollExtent);
    }
  }

  /// Returns true when the scroll position is within [threshold] px of the bottom.
  bool isNearBottom({double threshold = 50.0}) {
    final p = _lastPosition;
    return p != null && p.pixels >= p.maxScrollExtent - threshold;
  }

  /// Returns true when the scroll position is within [threshold] px of the top.
  bool isNearTop({double threshold = 50.0}) {
    final p = _lastPosition;
    return p != null && p.pixels <= p.minScrollExtent + threshold;
  }

  /// Returns true when the scroll position is exactly at the top.
  bool get isAtTop {
    final p = _lastPosition;
    return p != null && p.pixels <= p.minScrollExtent;
  }

  /// Returns true when the scroll position is exactly at the bottom.
  bool get isAtBottom {
    final p = _lastPosition;
    return p != null && p.pixels >= p.maxScrollExtent;
  }

  /// Returns true when the controller has clients and the content is scrollable.
  bool get canScroll {
    final p = _lastPosition;
    return p != null && p.maxScrollExtent > p.minScrollExtent;
  }

  /// Returns the current scroll progress as a value from 0.0 (top) to 1.0 (bottom).
  double get scrollPercentage {
    final p = _lastPosition;
    if (p == null) return 0.0;
    final extent = p.maxScrollExtent - p.minScrollExtent;
    if (extent == 0) return 0.0;
    return ((p.pixels - p.minScrollExtent) / extent).clamp(0.0, 1.0);
  }
}
