import 'package:baaba_extensions/src/utils/time_formatter.dart';

extension DateTimeExt on DateTime {
  /// Returns a human-readable relative time string, e.g. 'Just now', '5 minutes ago'.
  String get timeAgo => formatTime(millisecondsSinceEpoch);

  /// Returns true when this date falls on today's calendar day.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Returns true when this date falls on yesterday's calendar day.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Returns true when this date falls on tomorrow's calendar day.
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  /// Returns true when this [DateTime] is after [DateTime.now].
  bool get isFuture => isAfter(DateTime.now());

  /// Returns true when this [DateTime] is before [DateTime.now].
  bool get isPast => isBefore(DateTime.now());

  /// Returns a [DateTime] at midnight (00:00:00.000) of this date.
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns a [DateTime] at 23:59:59.999 of this date.
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  /// Returns true when this date falls on the same calendar day as [other].
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  // ── Week ──────────────────────────────────────────────────────────────────

  /// Returns true when the weekday is Saturday or Sunday.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true when the weekday is Monday through Friday.
  bool get isWeekday => !isWeekend;

  /// Returns the [DateTime] at midnight of the Monday that starts this week.
  DateTime get startOfWeek =>
      subtract(Duration(days: weekday - 1)).startOfDay;

  /// Returns the [DateTime] at end-of-day of the Sunday that ends this week.
  DateTime get endOfWeek =>
      startOfWeek.add(const Duration(days: 6)).endOfDay;

  // ── Month ─────────────────────────────────────────────────────────────────

  /// Returns the first moment of the current month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns the last moment of the current month (23:59:59.999 on the last day).
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Returns true when this date is in the same calendar month as [other].
  bool isSameMonth(DateTime other) =>
      year == other.year && month == other.month;

  // ── Year ──────────────────────────────────────────────────────────────────

  /// Returns the first moment of the current year.
  DateTime get startOfYear => DateTime(year);

  /// Returns the last moment of the current year.
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  /// Returns true when this date is in the same calendar year as [other].
  bool isSameYear(DateTime other) => year == other.year;

  // ── Quarter & Age ─────────────────────────────────────────────────────────

  /// Returns the quarter (1–4) this date falls in.
  int get quarterOf => ((month - 1) ~/ 3) + 1;

  /// Returns the number of full years between this date and today.
  ///
  /// Example: for a birth date, returns the person's age in years.
  int get age {
    final now = DateTime.now();
    int years = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      years--;
    }
    return years;
  }

  // ── Convenience arithmetic ────────────────────────────────────────────────

  /// Returns a new [DateTime] shifted [days] days into the future.
  DateTime addDays(int days) => add(Duration(days: days));

  /// Returns a new [DateTime] shifted [days] days into the past.
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Returns a new [DateTime] shifted [hours] hours into the future.
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Returns a new [DateTime] shifted [hours] hours into the past.
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Returns a new [DateTime] shifted [minutes] minutes into the future.
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Returns a new [DateTime] shifted [minutes] minutes into the past.
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));
}

/// Returns the current time in milliseconds since epoch.
int currentMillisecondsTimeStamp() => DateTime.now().millisecondsSinceEpoch;

/// Returns the current time as Unix seconds.
int currentTimeStamp() =>
    (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

/// Returns true when [year] is a leap year.
bool leapYear(int year) {
  if (year % 400 == 0) return true;
  if (year % 100 == 0) return false;
  return year % 4 == 0;
}

/// Returns the number of days in [monthNum] of [year].
int daysInMonth(int monthNum, int year) {
  const monthLengths = [31, 0, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
  if (monthNum == 2) return leapYear(year) ? 29 : 28;
  return monthLengths[monthNum - 1];
}
