import 'package:flutter/material.dart';

extension NumX on num {
  /// Converts the number to a double and returns it as a [SizedBox] with the specified height.
  Widget get heightBox => SizedBox(height: toDouble());

  /// Converts the number to a double and returns it as a [SizedBox] with the specified width.
  Widget get widthBox => SizedBox(width: toDouble());

  /// Delays the execution of the provided [action] by the number of milliseconds represented by this [num].
  Future<void> delay(VoidCallback action) => Future.delayed(Duration(milliseconds: toInt()), action);
}

extension NumCoerceInExtension<T extends num> on T {
  /// Coerces this number within the specified [minimumValue] and optional [maximumValue].
  /// If this number is less than [minimumValue], it returns [minimumValue].
  /// If this number is greater than [maximumValue] (if provided), it returns [maximumValue].
  /// Otherwise, it returns this number.
  T coerceIn(T minimumValue, [T? maximumValue]) {
    if (maximumValue != null && minimumValue > maximumValue) {
      throw ArgumentError('Minimum value cannot be greater than maximum value');
    }
    if (this < minimumValue) return minimumValue;
    if (maximumValue != null && this > maximumValue) return maximumValue;
    return this;
  }
}

extension NumDurationX on int {
  /// Converts this integer to a [Duration] in milliseconds.
  /// Example: `500.milliseconds` returns a Duration of 500 milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Converts this integer to a [Duration] in seconds.
  /// Example: `5.seconds` returns a Duration of 5 seconds.
  Duration get seconds => Duration(seconds: this);

  /// Converts this integer to a [Duration] in minutes.
  /// Example: `2.minutes` returns a Duration of 2 minutes.
  Duration get minutes => Duration(minutes: this);

  /// Converts this integer to a [Duration] in hours.
  /// Example: `1.hours` returns a Duration of 1 hour.
  Duration get hours => Duration(hours: this);

  /// Converts this integer to a [Duration] in days.
  /// Example: `3.days` returns a Duration of 3 days.
  Duration get days => Duration(days: this);
}

extension NumTimeX on int {
  /// Returns a [DateTime] representing the date and time that is this number of days ago from now.
  /// Example: `7.daysAgo` returns a DateTime representing the date and time 7 days ago from now.
  DateTime get daysAgo => DateTime.now().subtract(Duration(days: this));

  /// Returns a [DateTime] representing the date and time that is this number of hours ago from now.
  /// Example: `2.hoursAgo` returns a DateTime representing the date and time 2 hours ago from now.
  DateTime get hoursAgo => DateTime.now().subtract(Duration(hours: this));
}

extension NumPaddingX on num {
  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified padding on all sides.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified vertical padding.
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified horizontal padding.
  EdgeInsets get horizontalPadding => EdgeInsets.symmetric(horizontal: toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified left padding.
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified top padding.
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified right padding.
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());

  /// Converts this number to a double and returns it as an [EdgeInsets] with the specified bottom padding.
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());

  /// Returns a string representing the ordinal suffix for the number.
  String get ordinal =>
      toInt().toString() +
      (toInt() == 1
          ? 'st'
          : toInt() == 2
          ? 'nd'
          : toInt() == 3
          ? 'rd'
          : 'th');

  /// percentage
  double get percentage => this / 100;
}
