import 'package:flutter/material.dart';

import '../scrollx_extensions.dart';

/// Wraps a scrollable and floats a "back to top" button over it once the user
/// has scrolled past [threshold].
///
/// The same [controller] must be attached to the scrollable passed as [child],
/// otherwise there is no scroll position to watch.
///
/// Example:
/// ```dart
/// final controller = ScrollController();
///
/// ScrollToTopWidgetx(
///   controller: controller,
///   child: ListView.builder(
///     controller: controller,
///     itemCount: posts.length,
///     itemBuilder: (_, i) => PostCard(posts[i]),
///   ),
/// )
/// ```
class ScrollToTopWidgetx extends StatefulWidget {
  /// The scrollable this button controls.
  final Widget child;

  /// The controller attached to [child].
  final ScrollController controller;

  /// How far the user must scroll before the button appears. Defaults to `300`.
  final double threshold;

  /// Where the button sits over [child]. Defaults to the bottom-right.
  final AlignmentGeometry alignment;

  /// Gap between the button and the edges of [child].
  final EdgeInsetsGeometry margin;

  /// Icon inside the button.
  final IconData icon;

  /// Label rendered beside [icon], turning the button into an extended FAB.
  final String? label;

  /// Diameter of the button. Ignored when [label] is set.
  final double size;

  /// Background colour. Defaults to the primary colour.
  final Color? backgroundColor;

  /// Icon and label colour. Defaults to the onPrimary colour.
  final Color? foregroundColor;

  /// Material elevation of the button.
  final double elevation;

  /// How long the scroll-to-top animation takes.
  final Duration scrollDuration;

  /// Curve of the scroll-to-top animation.
  final Curve scrollCurve;

  /// How long the button takes to fade and scale in or out.
  final Duration animationDuration;

  /// Replaces the default button entirely. It is still shown and hidden for
  /// you; wire its own `onTap` to [ScrollController.animateTo] if you need
  /// different scroll behaviour.
  final Widget? button;

  /// Called after the scroll-to-top animation has been started.
  final VoidCallback? onPressed;

  const ScrollToTopWidgetx({
    super.key,
    required this.child,
    required this.controller,
    this.threshold = 300,
    this.alignment = Alignment.bottomRight,
    this.margin = const EdgeInsets.all(16),
    this.icon = Icons.arrow_upward_rounded,
    this.label,
    this.size = 44,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 4,
    this.scrollDuration = const Duration(milliseconds: 400),
    this.scrollCurve = Curves.easeOutCubic,
    this.animationDuration = const Duration(milliseconds: 200),
    this.button,
    this.onPressed,
  });

  @override
  State<ScrollToTopWidgetx> createState() => _ScrollToTopWidgetxState();
}

class _ScrollToTopWidgetxState extends State<ScrollToTopWidgetx> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    _scheduleCheck();
  }

  @override
  void didUpdateWidget(covariant ScrollToTopWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
      _scheduleCheck();
    } else if (widget.threshold != oldWidget.threshold) {
      _scheduleCheck();
    }
  }

  // The listener only fires on scroll, so a controller that starts (or already
  // sits) past the threshold would otherwise keep the button hidden. The
  // scrollable attaches during layout, hence the wait for the first frame.
  void _scheduleCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) => _onScroll());
  }

  @override
  void dispose() {
    // The controller belongs to the caller, so only the listener is removed.
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || !widget.controller.hasClients) return;
    final shouldShow = widget.controller.offset > widget.threshold;
    // Rebuild only when the button actually crosses the threshold, not on
    // every scroll notification.
    if (shouldShow != _isVisible && mounted) setState(() => _isVisible = shouldShow);
  }

  void _scrollToTop() {
    widget.controller.animateToTop(duration: widget.scrollDuration, curve: widget.scrollCurve);
    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final background = widget.backgroundColor ?? scheme.primary;
    final foreground = widget.foregroundColor ?? scheme.onPrimary;

    final Widget fab =
        widget.button ??
        Material(
          color: background,
          elevation: widget.elevation,
          shape: widget.label == null ? const CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.size / 2)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _scrollToTop,
            child: widget.label == null
                ? SizedBox(
                    width: widget.size,
                    height: widget.size,
                    child: Icon(widget.icon, size: widget.size * 0.5, color: foreground),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(widget.icon, size: 18, color: foreground),
                        const SizedBox(width: 8),
                        Text(
                          widget.label!,
                          style: TextStyle(color: foreground, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
          ),
        );

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Align(
            alignment: widget.alignment,
            child: Padding(
              padding: widget.margin,
              child: IgnorePointer(
                ignoring: !_isVisible,
                child: AnimatedScale(
                  scale: _isVisible ? 1 : 0.6,
                  duration: widget.animationDuration,
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(opacity: _isVisible ? 1 : 0, duration: widget.animationDuration, child: fab),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
