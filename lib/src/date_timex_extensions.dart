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
    final now = DateTime.now();
    // Calendar arithmetic, not 24-hour Durations, so a DST change cannot shift the day.
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  /// Returns true when this date falls on tomorrow's calendar day.
  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
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
  bool isSameDay(DateTime other) => year == other.year && month == other.month && day == other.day;

  // ── Week ──────────────────────────────────────────────────────────────────

  /// Returns true when the weekday is Saturday or Sunday.
  bool get isWeekend => weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true when the weekday is Monday through Friday.
  bool get isWeekday => !isWeekend;

  /// Returns the [DateTime] at midnight of the Monday that starts this week.
  DateTime get startOfWeek => DateTime(year, month, day - (weekday - 1));

  /// Returns the [DateTime] at end-of-day of the Sunday that ends this week.
  DateTime get endOfWeek => DateTime(year, month, day + (7 - weekday), 23, 59, 59, 999);

  // ── Month ─────────────────────────────────────────────────────────────────

  /// Returns the first moment of the current month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns the last moment of the current month (23:59:59.999 on the last day).
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  /// Returns true when this date is in the same calendar month as [other].
  bool isSameMonth(DateTime other) => year == other.year && month == other.month;

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
  DateTime addDays(int days) => shiftDaysX(days);

  /// Returns a new [DateTime] shifted [days] days into the past.
  DateTime subtractDays(int days) => shiftDaysX(-days);

  /// Returns this moment moved by [days] calendar days, keeping the wall-clock
  /// time even across a daylight-saving change, where `add(Duration(days: 1))`
  /// would land an hour off.
  ///
  /// Example: `DateTime(2026, 3, 7, 12).shiftDaysX(1)` → `2026-03-08 12:00`
  DateTime shiftDaysX(int days) => isUtc
      ? DateTime.utc(year, month, day + days, hour, minute, second, millisecond, microsecond)
      : DateTime(year, month, day + days, hour, minute, second, millisecond, microsecond);

  /// Returns a new [DateTime] shifted [hours] hours into the future.
  DateTime addHours(int hours) => add(Duration(hours: hours));

  /// Returns a new [DateTime] shifted [hours] hours into the past.
  DateTime subtractHours(int hours) => subtract(Duration(hours: hours));

  /// Returns a new [DateTime] shifted [minutes] minutes into the future.
  DateTime addMinutes(int minutes) => add(Duration(minutes: minutes));

  /// Returns a new [DateTime] shifted [minutes] minutes into the past.
  DateTime subtractMinutes(int minutes) => subtract(Duration(minutes: minutes));

  // ── Formatting ────────────────────────────────────────────────────────────

  /// Returns this date formatted with an `intl`-style [pattern], in English,
  /// without depending on `intl`.
  ///
  /// | Token | Output | | Token | Output |
  /// |---|---|---|---|---|
  /// | `yyyy` / `yy` / `y` | `2026` / `26` / `2026` | | `HH` / `H` | `09` / `9` (24-hour) |
  /// | `MMMM` / `MMM` | `March` / `Mar` | | `hh` / `h` | `09` / `9` (12-hour) |
  /// | `MM` / `M` | `03` / `3` | | `mm` / `m` | `05` / `5` |
  /// | `dd` / `d` | `05` / `5` | | `ss` / `s` | `07` / `7` |
  /// | `EEEE` / `EEE` | `Thursday` / `Thu` | | `SSS` | `042` (fraction of a second, one digit per `S`) |
  /// | `a` | `AM` / `PM` | | `'text'` | literal text; `''` is a quote |
  ///
  /// Any other character is copied as is. For localised output (Urdu month
  /// names, other calendars) use `intl`'s `DateFormat` instead.
  ///
  /// Example: `DateTime(2026, 3, 5, 14, 5).format('d MMM, h:mm a')` → `'5 Mar, 2:05 PM'`
  String format(String pattern) {
    final out = StringBuffer();
    var i = 0;
    while (i < pattern.length) {
      final char = pattern[i];

      if (char == "'") {
        // '' on its own is a quote; inside quoted text, '' is a quote too and
        // does not end the text. An unclosed quote runs to the end.
        if (i + 1 < pattern.length && pattern[i + 1] == "'") {
          out.write("'");
          i += 2;
          continue;
        }
        i++;
        while (i < pattern.length) {
          if (pattern[i] != "'") {
            out.write(pattern[i++]);
          } else if (i + 1 < pattern.length && pattern[i + 1] == "'") {
            out.write("'");
            i += 2;
          } else {
            i++;
            break;
          }
        }
        continue;
      }

      var count = 1;
      while (i + count < pattern.length && pattern[i + count] == char) {
        count++;
      }
      out.write(_formatField(char, count) ?? char * count);
      i += count;
    }
    return out.toString();
  }

  String? _formatField(String char, int count) {
    String pad(int value) => value.toString().padLeft(count, '0');
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;

    return switch (char) {
      'y' => count == 2 ? (year % 100).toString().padLeft(2, '0') : pad(year),
      'M' => count >= 4 ? _monthNames[month - 1] : (count == 3 ? _monthNames[month - 1].substring(0, 3) : pad(month)),
      'd' => pad(day),
      'E' => count >= 4 ? _weekdayNames[weekday - 1] : _weekdayNames[weekday - 1].substring(0, 3),
      'H' => pad(hour),
      'h' => pad(hour12),
      'm' => pad(minute),
      's' => pad(second),
      'S' => (millisecond * 1000 + microsecond).toString().padLeft(6, '0').padRight(count, '0').substring(0, count),
      'a' => hour < 12 ? 'AM' : 'PM',
      _ => null,
    };
  }
}

const _monthNames = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const _weekdayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

/// Returns the current time in milliseconds since epoch.
int currentMillisecondsTimeStamp() => DateTime.now().millisecondsSinceEpoch;

/// Returns the current time as Unix seconds.
int currentTimeStamp() => (DateTime.now().millisecondsSinceEpoch ~/ 1000).toInt();

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
