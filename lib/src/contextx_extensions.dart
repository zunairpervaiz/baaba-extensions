import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  // ── Theme ─────────────────────────────────────────────────────────────────

  /// Returns the [MediaQueryData] for this context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [ThemeData] for this context.
  ThemeData get theme => Theme.of(this);

  /// Returns the [TextTheme] for this context.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the [ColorScheme] for this context.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns true when the active theme brightness is dark.
  bool get isDark => theme.brightness == Brightness.dark;

  /// Returns true when the active theme brightness is light.
  bool get isLight => theme.brightness == Brightness.light;

  // ── Screen ────────────────────────────────────────────────────────────────

  /// Returns the screen [Size].
  Size get screenSize => mediaQuery.size;

  /// Returns the screen width in logical pixels.
  double get screenWidth => screenSize.width;

  /// Returns the screen height in logical pixels.
  double get screenHeight => screenSize.height;

  /// Returns true when screen width is less than 600.
  bool get isMobile => screenWidth < 600;

  /// Returns true when screen width is between 600 and 1024.
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Returns true when screen width is 1024 or greater.
  bool get isDesktop => screenWidth >= 1024;

  /// Returns the current device [Orientation].
  Orientation get orientation => mediaQuery.orientation;

  /// Returns true when the device is in portrait orientation.
  bool get isPortrait => orientation == Orientation.portrait;

  /// Returns true when the device is in landscape orientation.
  bool get isLandscape => orientation == Orientation.landscape;

  // ── Safe-Area & Insets ────────────────────────────────────────────────────

  /// Returns the top safe-area inset (status bar height).
  double get topPadding => mediaQuery.padding.top;

  /// Returns the bottom safe-area inset (home indicator / nav bar height).
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Returns the full [MediaQueryData.viewPadding].
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// Returns the current [MediaQueryData.viewInsets] (e.g. keyboard area).
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// Returns the device pixel ratio.
  double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Returns the current locale.
  Locale get locale => Localizations.localeOf(this);

  // ── Keyboard ─────────────────────────────────────────────────────────────

  /// Dismisses the soft keyboard.
  void hideKeyboard() => FocusScope.of(this).unfocus();

  /// Returns true when the soft keyboard is currently visible.
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;

  // ── Navigation ───────────────────────────────────────────────────────────

  /// Returns the nearest [NavigatorState].
  NavigatorState get navigator => Navigator.of(this);

  /// Pushes [page] as a [MaterialPageRoute].
  Future<T?> push<T extends Object?>(Widget page) =>
      navigator.push<T>(MaterialPageRoute(builder: (_) => page));

  /// Pops the top route, optionally returning [result].
  void pop<T extends Object?>([T? result]) => navigator.pop<T>(result);

  /// Pushes a named route.
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);

  /// Replaces the current route with [page].
  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(Widget page) =>
      navigator.pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page));

  /// Removes all existing routes and pushes [page] as the new root.
  Future<T?> pushAndRemoveAll<T extends Object?>(Widget page) =>
      navigator.pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        (_) => false,
      );

  // ── Scaffold ─────────────────────────────────────────────────────────────

  /// Shows [snackBar] via the nearest [ScaffoldMessenger].
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar,
  ) =>
      ScaffoldMessenger.of(this).showSnackBar(snackBar);

  /// Shows a modal bottom sheet.
  Future<T?> showModalSheet<T>({
    required WidgetBuilder builder,
    bool isScrollControlled = true,
    bool isDismissible = true,
    Color? backgroundColor,
    ShapeBorder? shape,
    BorderRadius? borderRadius,
  }) =>
      showModalBottomSheet<T>(
        context: this,
        builder: builder,
        isScrollControlled: isScrollControlled,
        isDismissible: isDismissible,
        backgroundColor: backgroundColor,
        shape: shape ??
            (borderRadius != null
                ? RoundedRectangleBorder(borderRadius: borderRadius)
                : null),
      );
}
