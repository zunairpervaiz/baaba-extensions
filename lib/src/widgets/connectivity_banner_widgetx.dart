import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../utils/default_configs.dart';

/// Wraps a screen and slides an offline banner over it whenever the device
/// loses connectivity, then a brief "Back online" confirmation when it returns.
///
/// Wrap it once around your app's builder rather than per screen:
///
/// ```dart
/// MaterialApp(
///   builder: (context, child) => ConnectivityBannerWidgetx(child: child!),
///   home: const HomePage(),
/// )
/// ```
///
/// [connectivity_plus] reports whether a network *interface* is up, not
/// whether the internet is actually reachable — a captive-portal wifi still
/// counts as connected. Pass [verifyConnection] to make the banner depend on a
/// real request:
///
/// ```dart
/// ConnectivityBannerWidgetx(
///   verifyConnection: () async {
///     try {
///       final result = await InternetAddress.lookup('example.com');
///       return result.isNotEmpty;
///     } catch (_) {
///       return false;
///     }
///   },
///   child: const HomePage(),
/// )
/// ```
class ConnectivityBannerWidgetx extends StatefulWidget {
  /// The screen the banner is drawn over.
  final Widget child;

  /// Message shown while the device is offline.
  /// Defaults to [defaultOfflineMessageGlobal].
  final String? offlineMessage;

  /// Message shown briefly once connectivity returns.
  /// Defaults to [defaultOnlineMessageGlobal].
  final String? onlineMessage;

  /// Whether the "Back online" banner is shown at all. Defaults to `true`.
  final bool showOnlineBanner;

  /// How long the "Back online" banner stays before hiding itself.
  final Duration onlineBannerDuration;

  /// Puts the banner along the bottom edge instead of the top.
  final bool showAtBottom;

  /// Background colour of the offline banner.
  final Color? offlineColor;

  /// Background colour of the online banner.
  final Color? onlineColor;

  /// Colour of the banner text and icon.
  final Color textColor;

  /// Height of the banner. Defaults to `36`.
  final double height;

  /// Duration of the slide-in and slide-out. Defaults to `280ms`.
  final Duration animationDuration;

  /// Whether the banner clears the status bar or the home indicator.
  final bool useSafeArea;

  /// Icon shown in the offline banner.
  final IconData offlineIcon;

  /// Icon shown in the online banner.
  final IconData onlineIcon;

  /// Style of the banner text.
  final TextStyle? textStyle;

  /// Replaces the default banner. Receives `true` when online.
  final Widget Function(BuildContext context, bool isOnline)? bannerBuilder;

  /// Called whenever the connection state changes.
  final ValueChanged<bool>? onStatusChanged;

  /// Confirms that the internet is really reachable after the platform
  /// reports a connection. Returning `false` keeps the offline banner up.
  final Future<bool> Function()? verifyConnection;

  /// Overrides the connectivity source, mainly for tests and for apps that
  /// already track connection state themselves. Emits `true` when online.
  ///
  /// When set, [connectivity_plus] is not consulted at all.
  final Stream<bool>? statusStream;

  const ConnectivityBannerWidgetx({
    super.key,
    required this.child,
    this.offlineMessage,
    this.onlineMessage,
    this.showOnlineBanner = true,
    this.onlineBannerDuration = const Duration(seconds: 2),
    this.showAtBottom = false,
    this.offlineColor,
    this.onlineColor,
    this.textColor = Colors.white,
    this.height = 36,
    this.animationDuration = const Duration(milliseconds: 280),
    this.useSafeArea = true,
    this.offlineIcon = Icons.wifi_off_rounded,
    this.onlineIcon = Icons.wifi_rounded,
    this.textStyle,
    this.bannerBuilder,
    this.onStatusChanged,
    this.verifyConnection,
    this.statusStream,
  });

  @override
  State<ConnectivityBannerWidgetx> createState() => _ConnectivityBannerWidgetxState();
}

class _ConnectivityBannerWidgetxState extends State<ConnectivityBannerWidgetx> {
  StreamSubscription<Object?>? _subscription;
  Timer? _hideOnlineTimer;

  /// Null until the first reading arrives, so no banner flashes on startup
  /// before the platform has answered.
  bool? _isOnline;
  bool _showOnlineBanner = false;

  /// Keeps the banner in the tree for the length of its slide-out and drops it
  /// afterwards, so a hidden banner is not left rendering text off-screen
  /// where screen readers would still reach it.
  bool _isBannerInTree = false;

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void didUpdateWidget(covariant ConnectivityBannerWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.statusStream != oldWidget.statusStream) {
      _subscription?.cancel();
      _listen();
    }
  }

  @override
  void dispose() {
    _hideOnlineTimer?.cancel();
    _subscription?.cancel();
    super.dispose();
  }

  void _listen() {
    final injected = widget.statusStream;
    if (injected != null) {
      _subscription = injected.listen(_applyStatus);
      return;
    }

    final connectivity = Connectivity();
    _subscription = connectivity.onConnectivityChanged.listen((results) => _handleResults(results));
    // The stream only fires on change, so the current state is read once up
    // front — otherwise an app launched offline shows no banner at all.
    connectivity.checkConnectivity().then(_handleResults).catchError((_) {});
  }

  Future<void> _handleResults(List<ConnectivityResult> results) async {
    final hasInterface = results.any((r) => r != ConnectivityResult.none);

    if (!hasInterface) {
      _applyStatus(false);
      return;
    }

    final verify = widget.verifyConnection;
    if (verify == null) {
      _applyStatus(true);
      return;
    }

    bool reachable;
    try {
      reachable = await verify();
    } catch (_) {
      reachable = false;
    }
    if (mounted) _applyStatus(reachable);
  }

  void _applyStatus(bool isOnline) {
    if (!mounted || _isOnline == isOnline) return;

    final wasOffline = _isOnline == false;
    setState(() {
      _isOnline = isOnline;
      // The confirmation only makes sense as a transition out of an offline
      // state, never on the first reading.
      _showOnlineBanner = isOnline && wasOffline && widget.showOnlineBanner;
      if (!isOnline || _showOnlineBanner) _isBannerInTree = true;
    });
    widget.onStatusChanged?.call(isOnline);

    _hideOnlineTimer?.cancel();
    if (_showOnlineBanner) {
      _hideOnlineTimer = Timer(widget.onlineBannerDuration, () {
        if (mounted) setState(() => _showOnlineBanner = false);
      });
    }
  }

  bool get _isBannerVisible => _isOnline == false || _showOnlineBanner;

  @override
  Widget build(BuildContext context) {
    final isOnline = _isOnline ?? true;
    final padding = MediaQuery.paddingOf(context);
    final safeInset = !widget.useSafeArea ? 0.0 : (widget.showAtBottom ? padding.bottom : padding.top);

    final Widget banner =
        widget.bannerBuilder?.call(context, isOnline) ??
        Container(
          height: widget.height + safeInset,
          padding: EdgeInsets.only(top: widget.showAtBottom ? 0 : safeInset, bottom: widget.showAtBottom ? safeInset : 0),
          color: isOnline ? (widget.onlineColor ?? defaultAlertSuccessColorGlobal) : (widget.offlineColor ?? defaultAlertErrorColorGlobal),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(isOnline ? widget.onlineIcon : widget.offlineIcon, size: 16, color: widget.textColor),
              const SizedBox(width: 8),
              Text(
                isOnline ? (widget.onlineMessage ?? defaultOnlineMessageGlobal) : (widget.offlineMessage ?? defaultOfflineMessageGlobal),
                style: widget.textStyle ?? TextStyle(color: widget.textColor, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );

    return Stack(
      children: [
        widget.child,
        AnimatedPositioned(
          duration: widget.animationDuration,
          curve: Curves.easeOutCubic,
          left: 0,
          right: 0,
          top: widget.showAtBottom ? null : (_isBannerVisible ? 0 : -(widget.height + safeInset)),
          bottom: widget.showAtBottom ? (_isBannerVisible ? 0 : -(widget.height + safeInset)) : null,
          onEnd: () {
            if (mounted && !_isBannerVisible) setState(() => _isBannerInTree = false);
          },
          child: Material(color: Colors.transparent, child: _isBannerInTree ? banner : const SizedBox.shrink()),
        ),
      ],
    );
  }
}
