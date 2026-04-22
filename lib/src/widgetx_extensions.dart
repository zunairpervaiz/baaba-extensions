import 'package:flutter/material.dart';

extension WidgetX on Widget {
  /// Wraps the widget in a [Center] widget, centering it within its parent.
  Widget center() => Center(child: this);

  /// Wraps the widget in an [Expanded] widget, allowing it to expand to fill available space.
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps the widget in a [onTap] widget, making it respond to tap gestures with the specified function and visual feedback.
  Widget onTap(
    Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? focusColor,
    WidgetStateProperty<Color?>? overlayColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius ?? BorderRadius.zero,
      splashColor: splashColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Colors.transparent,
      highlightColor: highlightColor ?? Colors.transparent,
      focusColor: focusColor ?? Colors.transparent,
      overlayColor: overlayColor ?? WidgetStateProperty.all(Colors.transparent),
      child: this,
    );
  }

  /// Wraps the widget in a [Padding] widget with the specified padding.
  SizedBox withWidth(double width) => SizedBox(width: width, child: this);

  /// Wraps the widget in a [Padding] widget with the specified padding.
  SizedBox withHeight(double height) => SizedBox(height: height, child: this);

  /// Wraps the widget in a [SizedBox] widget with the specified width and height.
  SizedBox withSize({double? width, double? height}) => SizedBox(width: width, height: height, child: this);

  Widget visible(bool isVisible, {Widget? defaultWidget}) {
    return isVisible ? this : (defaultWidget ?? const SizedBox.shrink());
  }

  /// Add custom corner radius to the widget using [ClipRRect].
  ClipRRect cornerRadiusWithClipRRectOnly({int bottomLeft = 0, int bottomRight = 0, int topLeft = 0, int topRight = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft.toDouble()),
        bottomRight: Radius.circular(bottomRight.toDouble()),
        topLeft: Radius.circular(topLeft.toDouble()),
        topRight: Radius.circular(topRight.toDouble()),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: this,
    );
  }

  /// Add uniform corner radius to the widget using [ClipRRect].
  ClipRRect cornerRadiusWithClipRRect(double radius) {
    return ClipRRect(borderRadius: BorderRadius.all(Radius.circular(radius)), clipBehavior: Clip.antiAliasWithSaveLayer, child: this);
  }
}
