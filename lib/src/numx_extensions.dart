import 'package:flutter/material.dart';

extension NumX on num {
  /// Returns a [SizedBox] with this value as height.
  Widget get heightBox => SizedBox(height: toDouble());

  /// Returns a [SizedBox] with this value as width.
  Widget get widthBox => SizedBox(width: toDouble());

  /// Runs [action] after this many milliseconds.
  Future<void> delay(VoidCallback action) =>
      Future.delayed(Duration(milliseconds: toInt()), action);

  /// Returns true when this value is between [min] and [max] (inclusive).
  bool isBetween(num min, num max) => this >= min && this <= max;

  /// Returns this value rounded to [decimals] decimal places as a [double].
  ///
  /// Example: `3.14159.roundTo(2)` → `3.14`
  double roundTo(int decimals) =>
      double.parse(toDouble().toStringAsFixed(decimals));
}

extension NumCoerceInExtension<T extends num> on T {
  /// Clamps this value between [minimumValue] and [maximumValue].
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
  /// Returns a [Duration] of this many milliseconds.
  Duration get milliseconds => Duration(milliseconds: this);

  /// Returns a [Duration] of this many seconds.
  Duration get seconds => Duration(seconds: this);

  /// Returns a [Duration] of this many minutes.
  Duration get minutes => Duration(minutes: this);

  /// Returns a [Duration] of this many hours.
  Duration get hours => Duration(hours: this);

  /// Returns a [Duration] of this many days.
  Duration get days => Duration(days: this);
}

extension NumTimeX on int {
  /// Returns a [DateTime] this many days before now.
  DateTime get daysAgo => DateTime.now().subtract(Duration(days: this));

  /// Returns a [DateTime] this many hours before now.
  DateTime get hoursAgo => DateTime.now().subtract(Duration(hours: this));

  /// Returns a [DateTime] this many minutes before now.
  DateTime get minutesAgo => DateTime.now().subtract(Duration(minutes: this));

  /// Returns a [DateTime] this many seconds before now.
  DateTime get secondsAgo => DateTime.now().subtract(Duration(seconds: this));

  /// Returns a [DateTime] this many days from now.
  DateTime get daysFromNow => DateTime.now().add(Duration(days: this));

  /// Returns a [DateTime] this many hours from now.
  DateTime get hoursFromNow => DateTime.now().add(Duration(hours: this));

  /// Returns a [DateTime] this many minutes from now.
  DateTime get minutesFromNow => DateTime.now().add(Duration(minutes: this));

  /// Returns a [DateTime] this many seconds from now.
  DateTime get secondsFromNow => DateTime.now().add(Duration(seconds: this));
}

extension NumPaddingX on num {
  /// Returns [EdgeInsets.all] with this value.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// Returns [EdgeInsets.symmetric] with this value as vertical inset.
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());

  /// Returns [EdgeInsets.symmetric] with this value as horizontal inset.
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Returns [EdgeInsets.only] with this value on the left.
  EdgeInsets get leftPadding => EdgeInsets.only(left: toDouble());

  /// Returns [EdgeInsets.only] with this value on the top.
  EdgeInsets get topPadding => EdgeInsets.only(top: toDouble());

  /// Returns [EdgeInsets.only] with this value on the right.
  EdgeInsets get rightPadding => EdgeInsets.only(right: toDouble());

  /// Returns [EdgeInsets.only] with this value on the bottom.
  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: toDouble());

  /// Returns the ordinal string for this integer, e.g. `1` → `'1st'`.
  String get ordinal {
    final n = toInt();
    if (n % 100 >= 11 && n % 100 <= 13) return '${n}th';
    switch (n % 10) {
      case 1:
        return '${n}st';
      case 2:
        return '${n}nd';
      case 3:
        return '${n}rd';
      default:
        return '${n}th';
    }
  }

  /// Returns this value divided by 100 (i.e. the fraction representation).
  double get percentage => this / 100;
}
