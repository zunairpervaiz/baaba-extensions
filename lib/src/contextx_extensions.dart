import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  /// Returns the [MediaQueryData] for the current context.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Returns the [ThemeData] for the current context.
  ThemeData get theme => Theme.of(this);

  /// Returns the [TextTheme] for the current context.
  TextTheme get textTheme => theme.textTheme;

  /// Returns the [ColorScheme] for the current context.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Returns the [Size] of the screen for the current context.
  Size get screenSize => mediaQuery.size;

  /// Returns the width of the screen for the current context.
  double get screenWidth => screenSize.width;

  /// Returns the height of the screen for the current context.
  double get screenHeight => screenSize.height;

  /// Returns true if the screen width is less than 600 pixels, indicating a mobile device.
  bool get isMobile => screenWidth < 600;

  /// Returns true if the screen width is between 600 and 1024 pixels, indicating a tablet device.
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Returns true if the screen width is 1024 pixels or greater, indicating a desktop device.
  bool get isDesktop => screenWidth >= 1024;

  /// Hides the keyboard for the current context.
  void hideKeyboard() => FocusScope.of(this).unfocus();

  /// Returns true if the keyboard is currently visible for the current context.
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
}
