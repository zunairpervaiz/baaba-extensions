import 'package:flutter/material.dart';
import 'package:baaba_extensions/baaba_extensions.dart' show LoadingOverlayMode;

/// A blocking loading overlay that sits on top of [child].
///
/// When [isLoading] is `true`:
/// - [child] absorbs no pointer events — it is completely non-interactive.
/// - An animated overlay fades in according to [mode].
///
/// When [isLoading] is `false` the overlay fades out and [child] becomes
/// interactive again.
///
/// [mode] controls the visual appearance:
/// - [LoadingOverlayMode.fullScreen] — a translucent [barrierColor] layer
///   fills the entire widget area with a centred [indicator] on top.
/// - [LoadingOverlayMode.centered] — only the [indicator] is shown at the
///   centre with no background tint.
///
/// Both modes use `AnimatedOpacity` so the transition is smooth without
/// removing the overlay widget from the tree, avoiding layout thrashing.
///
/// Example:
/// ```dart
/// // Full-screen dark barrier (default):
/// LoadingOverlayWidgetx(
///   isLoading: _isBusy,
///   child: MyScreen(),
/// )
///
/// // Centred spinner, no tint:
/// LoadingOverlayWidgetx(
///   isLoading: _isBusy,
///   mode: LoadingOverlayMode.centered,
///   child: MyScreen(),
/// )
///
/// // Custom indicator and barrier colour:
/// LoadingOverlayWidgetx(
///   isLoading: _isBusy,
///   barrierColor: Colors.white70,
///   indicator: const MyBrandedSpinner(),
///   child: MyScreen(),
/// )
/// ```
class LoadingOverlayWidgetx extends StatelessWidget {
  /// The widget rendered beneath the overlay.
  final Widget child;

  /// Whether the overlay is visible and [child] is blocked.
  final bool isLoading;

  /// Visual style of the overlay. Defaults to [LoadingOverlayMode.fullScreen].
  final LoadingOverlayMode mode;

  /// Background colour used in [LoadingOverlayMode.fullScreen].
  /// Defaults to `Colors.black54`.
  final Color barrierColor;

  /// The loading indicator displayed at the centre of the overlay.
  /// Defaults to [CircularProgressIndicator].
  final Widget? indicator;

  /// Duration of the fade in / out animation. Defaults to 200 ms.
  final Duration animationDuration;

  // Cached default indicator — avoids recreating the widget on every build
  // when no custom indicator is supplied.
  static const Widget _defaultIndicator = CircularProgressIndicator();

  const LoadingOverlayWidgetx({
    super.key,
    required this.child,
    required this.isLoading,
    this.mode = LoadingOverlayMode.fullScreen,
    this.barrierColor = const Color(0x89000000), // ~Colors.black54
    this.indicator,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final Widget spinner = indicator ?? _defaultIndicator;

    // Positioned.fill ensures the overlay always covers the full Stack area
    // in both modes. In [fullScreen] mode the ColoredBox provides the tint;
    // in [centered] mode it is transparent (no extra widget needed).
    //
    // IgnorePointer prevents the fading-out overlay from consuming touches
    // after isLoading flips to false but before the animation completes.
    // AbsorbPointer on child is what actually blocks interaction while loading.
    return Stack(
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: child,
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            opacity: isLoading ? 1.0 : 0.0,
            duration: animationDuration,
            child: IgnorePointer(
              ignoring: !isLoading,
              child: mode == LoadingOverlayMode.fullScreen
                  ? ColoredBox(
                      color: barrierColor,
                      child: Center(child: spinner),
                    )
                  : Center(child: spinner),
            ),
          ),
        ),
      ],
    );
  }
}