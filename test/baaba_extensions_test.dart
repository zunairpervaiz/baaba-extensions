import 'dart:async';
import 'dart:math';

import 'package:baaba_extensions/baaba_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

enum _F { name, email, password }

void main() {
  // ──────────────────────────────────────────────
  // StringExtension
  // ──────────────────────────────────────────────
  group('StringExtension', () {
    group('validate', () {
      test('returns empty string for null', () {
        String? s;
        expect(s.validate(), '');
      });
      test('returns custom default for null', () {
        String? s;
        expect(s.validate(value: 'N/A'), 'N/A');
      });
      test('returns empty string for literal "null"', () {
        expect('null'.validate(), '');
      });
      test('returns empty string for empty input', () {
        expect(''.validate(), '');
      });
      test('returns the string when valid', () {
        expect('hello'.validate(), 'hello');
      });
    });

    group('isEmptyOrNull', () {
      test('true for null', () {
        String? s;
        expect(s.isEmptyOrNull, true);
      });
      test('true for empty string', () {
        expect(''.isEmptyOrNull, true);
      });
      test('true for literal "null"', () {
        expect('null'.isEmptyOrNull, true);
      });
      test('false for non-empty string', () {
        expect('hello'.isEmptyOrNull, false);
      });
    });

    group('isNullOrBlank / isNotBlank', () {
      test('isNullOrBlank is true for null', () {
        String? s;
        expect(s.isNullOrBlank, true);
      });
      test('isNullOrBlank is true for whitespace-only', () {
        expect('   '.isNullOrBlank, true);
      });
      test('isNullOrBlank is false for non-blank', () {
        expect('hello'.isNullOrBlank, false);
      });
      test('isNotBlank is true for non-blank', () {
        expect('hello'.isNotBlank, true);
      });
      test('isNotBlank is false for null', () {
        String? s;
        expect(s.isNotBlank, false);
      });
      test('isNotBlank is false for whitespace-only', () {
        expect('   '.isNotBlank, false);
      });
    });

    group('validation helpers', () {
      test('validateEmail accepts a valid email', () {
        expect('user@example.com'.validateEmail(), true);
      });
      test('validateEmail rejects a non-email', () {
        expect('not-an-email'.validateEmail(), false);
      });
      test('validatePhone accepts 03xxxxxxxxx', () {
        expect('03001234567'.validatePhone(), true);
      });
      test('validatePhone rejects short number', () {
        expect('0300123'.validatePhone(), false);
      });
      test('validateURL accepts https URL', () {
        expect('https://flutter.dev'.validateURL(), true);
      });
      test('validateURL rejects plain word', () {
        expect('notaurl'.validateURL(), false);
      });
    });

    group('capitalisation', () {
      test('capitalizeFirstLetter capitalises first char', () {
        expect('hello world'.capitalizeFirstLetter(), 'Hello world');
      });
      test('capitalizeFirstLetter returns empty for empty input', () {
        expect(''.capitalizeFirstLetter(), '');
      });
      test('capitalizeEachWord capitalises every word', () {
        expect('hello world'.capitalizeEachWord(), 'Hello World');
      });
      test('capitalizeEachWord returns empty for empty input', () {
        expect(''.capitalizeEachWord(), '');
      });
    });

    group('case conversion', () {
      test('toSnakeCase converts camelCase', () {
        expect('helloWorld'.toSnakeCase(), 'hello_world');
      });
      test('toSnakeCase converts spaces', () {
        expect('hello world'.toSnakeCase(), 'hello_world');
      });
      test('toCamelCase converts snake_case', () {
        expect('hello_world'.toCamelCase(), 'helloWorld');
      });
      test('toCamelCase converts space-separated', () {
        expect('hello world'.toCamelCase(), 'helloWorld');
      });
      test('toPascalCase converts space-separated', () {
        expect('hello world'.toPascalCase(), 'HelloWorld');
      });
      test('toPascalCase converts snake_case', () {
        expect('hello_world'.toPascalCase(), 'HelloWorld');
      });
      test('toKebabCase converts camelCase', () {
        expect('helloWorld'.toKebabCase(), 'hello-world');
      });
      test('toKebabCase converts spaces', () {
        expect('hello world'.toKebabCase(), 'hello-world');
      });
    });

    group('initials', () {
      test('returns initials for full name', () {
        expect('John Doe'.initials(), 'JD');
      });
      test('returns single initial for one word', () {
        expect('John'.initials(), 'J');
      });
      test('returns empty for empty string', () {
        expect(''.initials(), '');
      });
    });

    group('ellipsize', () {
      test('truncates long string with default ellipsis', () {
        expect('This is a long string'.ellipsize(10), 'This is...');
      });
      test('returns string unchanged when within limit', () {
        expect('Short'.ellipsize(10), 'Short');
      });
      test('uses custom ellipsis character', () {
        expect('Hello World'.ellipsize(8, ellipsis: '…'), 'Hello W…');
      });
      test('returns empty for empty input', () {
        expect(''.ellipsize(5), '');
      });
    });

    group('masking', () {
      setUp(() => isMaskingEnabledGlobal = true);
      tearDown(() => isMaskingEnabledGlobal = true);

      test('mask auto-detects email', () {
        expect('user@example.com'.mask(), 'u***@example.com');
      });
      test('mask auto-detects phone', () {
        final result = '03001234567'.mask();
        expect(result, '03*******67');
      });
      test('mask returns original when isMaskingEnabled is false', () {
        expect('user@example.com'.mask(isMaskingEnabled: false), 'user@example.com');
      });
      test('mask with explicit email type', () {
        expect('user@example.com'.mask(maskType: MaskType.email), 'u***@example.com');
      });
      test('mask with explicit phone type', () {
        expect('03001234567'.mask(maskType: MaskType.phone), '03*******67');
      });
      test('maskEmail masks the name part', () {
        expect('user@example.com'.maskEmail(), 'u***@example.com');
      });
      test('maskPhone masks the middle digits', () {
        expect('03001234567'.maskPhone(), '03*******67');
      });
      test('maskPhone returns original for short string', () {
        expect('123'.maskPhone(), '123');
      });
      test('mask returns original data for non-email non-phone in auto mode', () {
        expect('plaintext'.mask(), 'plaintext');
      });
    });

    group('type conversion', () {
      test('toIntX parses integer string', () {
        expect('42'.toIntX(), 42);
      });
      test('toIntX returns 0 for non-integer', () {
        expect('abc'.toIntX(), 0);
      });
      test('toIntX returns custom default for non-integer', () {
        expect('abc'.toIntX(defaultValue: -1), -1);
      });
      test('toIntX returns default for null', () {
        String? s;
        expect(s.toIntX(), 0);
      });
      test('toDoubleX parses double string', () {
        expect('3.14'.toDoubleX(), 3.14);
      });
      test('toDoubleX returns 0.0 for non-double', () {
        expect('abc'.toDoubleX(), 0.0);
      });
      test('toDoubleX returns custom default', () {
        expect('abc'.toDoubleX(defaultValue: -1.0), -1.0);
      });
      test('toBool returns true for "true"', () {
        expect('true'.toBool(), true);
      });
      test('toBool returns false for "false"', () {
        expect('false'.toBool(), false);
      });
      test('asBool returns true for "true"', () {
        expect('true'.asBool, true);
      });
      test('asBool returns false for other strings', () {
        expect('yes'.asBool, false);
      });
      test('getBoolIntX returns true for "1"', () {
        expect('1'.getBoolIntX(), true);
      });
      test('getBoolIntX returns false for "0"', () {
        expect('0'.getBoolIntX(), false);
      });
      test('getBoolIntX returns false for other values', () {
        expect('2'.getBoolIntX(), false);
      });
    });

    group('string manipulation', () {
      test('reverse reverses a string', () {
        expect('hello'.reverse, 'olleh');
      });
      test('reverse returns empty for empty input', () {
        expect(''.reverse, '');
      });
      test('toListX splits into characters', () {
        expect('abc'.toListX(), ['a', 'b', 'c']);
      });
      test('removeAllWhiteSpace strips all spaces', () {
        expect('hello world flutter'.removeAllWhiteSpace(), 'helloworldflutter');
      });
      test('repeat concatenates n times', () {
        expect('ab'.repeat(3), 'ababab');
      });
      test('repeat with separator', () {
        expect('ab'.repeat(3, separator: '-'), 'ab-ab-ab');
      });
      test('formatNumberWithComma adds commas', () {
        expect('1234567'.formatNumberWithComma(), '1,234,567');
      });
      test('formatNumberWithComma with custom separator', () {
        expect('1234567'.formatNumberWithComma(seperator: '.'), '1.234.567');
      });
      test('countWords counts space-separated words', () {
        expect('hello world flutter'.countWords(), 3);
      });
      test('toSlug uses underscore by default', () {
        expect('hello world'.toSlug(), 'hello_world');
      });
      test('toSlug with custom delimiter', () {
        expect('hello world'.toSlug(delimiter: '-'), 'hello-world');
      });
      test('prefixText prepends value', () {
        expect('Ahmed'.prefixText(value: 'Dr. '), 'Dr. Ahmed');
      });
      test('suffixText appends value', () {
        expect('100'.suffixText(value: ' /-'), '100 /-');
      });
      test('equalsIgnoreCase true for same-case-different strings', () {
        expect('Hello'.equalsIgnoreCase('HELLO'), true);
      });
      test('equalsIgnoreCase false for different strings', () {
        expect('Hello'.equalsIgnoreCase('world'), false);
      });
      test('equalsIgnoreCase true for both null', () {
        String? a;
        String? b;
        expect(a.equalsIgnoreCase(b), true);
      });
    });

    group('split helpers', () {
      test('splitAfter returns substring after first match', () {
        expect('hello world'.splitAfter(' '), 'world');
      });
      test('splitAfter returns empty when no match', () {
        expect('helloworld'.splitAfter(' '), '');
      });
      test('splitBefore returns substring before last match', () {
        expect('hello world'.splitBefore(' '), 'hello');
      });
      test('splitBefore returns empty when no match', () {
        expect('helloworld'.splitBefore(' '), '');
      });
      test('splitBetween returns string between two patterns', () {
        expect('[hello]'.splitBetween('[', ']'), 'hello');
      });
    });

    group('type checks', () {
      test('isAlpha true for letters-only', () {
        expect('hello'.isAlpha(), true);
      });
      test('isAlpha false when digits present', () {
        expect('hello123'.isAlpha(), false);
      });
      test('isDigit true for digits-only', () {
        expect('123'.isDigit(), true);
      });
      test('isDigit false when letters present', () {
        expect('12a'.isDigit(), false);
      });
      test('isJson true for valid JSON', () {
        expect('{"key":"value"}'.isJson(), true);
      });
      test('isJson false for invalid JSON', () {
        expect('not json'.isJson(), false);
      });
      test('isImage true for .png', () {
        expect('photo.png'.isImage, true);
      });
      test('isImage true for .jpg', () {
        expect('photo.jpg'.isImage, true);
      });
      test('isImage false for .pdf', () {
        expect('doc.pdf'.isImage, false);
      });
      test('isPdf true for .pdf', () {
        expect('file.pdf'.isPdf, true);
      });
      test('isAudio true for .mp3', () {
        expect('song.mp3'.isAudio, true);
      });
      test('isVideo true for .mp4', () {
        expect('clip.mp4'.isVideo, true);
      });
      test('isDoc true for .docx', () {
        expect('file.docx'.isDoc, true);
      });
      test('isExcel true for .xlsx', () {
        expect('sheet.xlsx'.isExcel, true);
      });
      test('isPPT true for .pptx', () {
        expect('slides.pptx'.isPPT, true);
      });
      test('isHtml true for .html', () {
        expect('page.html'.isHtml, true);
      });
      test('isApk true for .apk', () {
        expect('app.apk'.isApk, true);
      });
      test('isTxt true for .txt', () {
        expect('notes.txt'.isTxt, true);
      });
    });

    group('misc helpers', () {
      test('getNumericOnly extracts digits', () {
        expect('abc123def456'.getNumericOnly(), '123456');
      });
      test('getNumericOnly with firstWordOnly stops at the space after digits', () {
        expect('123 def456'.getNumericOnly(aFirstWordOnly: true), '123');
      });
      test('calculateReadTime returns positive duration', () {
        expect('Hello world this is a sentence'.calculateReadTime(), greaterThan(0));
      });
      test('setSearchParam returns incremental prefix array', () {
        final result = 'flutter'.setSearchParam();
        expect(result.first, 'f');
        expect(result.last, 'flutter');
        expect(result.length, 7);
      });
      test('formatPkMobile formats 11-digit PK number', () {
        expect('03001234567'.formatPkMobile, '0300-1234567');
      });
      test('formatPkMobile returns original for non-11-digit', () {
        expect('123'.formatPkMobile, '123');
      });
      test('formatPkMobile returns empty for null', () {
        String? s;
        expect(s.formatPkMobile, '');
      });
      test('toDisplayFormattedPhone returns N/A for null', () {
        String? s;
        expect(s.toDisplayFormattedPhone, 'N/A');
      });
      test('toDisplayFormattedPhone formats valid PK number', () {
        expect('03001234567'.toDisplayFormattedPhone, '0300-1234567');
      });
    });
  });

  // ──────────────────────────────────────────────
  // NumX
  // ──────────────────────────────────────────────
  group('NumX', () {
    test('heightBox returns SizedBox with correct height', () {
      final box = 16.heightBox as SizedBox;
      expect(box.height, 16.0);
    });
    test('widthBox returns SizedBox with correct width', () {
      final box = 16.widthBox as SizedBox;
      expect(box.width, 16.0);
    });
    test('delay executes callback after given milliseconds', () async {
      bool called = false;
      await 10.delay(() => called = true);
      expect(called, true);
    });
  });

  group('NumPaddingX', () {
    test('allPadding produces EdgeInsets.all', () {
      expect(16.allPadding, EdgeInsets.all(16));
    });
    test('verticalPadding produces symmetric vertical', () {
      expect(16.verticalPadding, EdgeInsets.symmetric(vertical: 16));
    });
    test('horizontalPadding produces symmetric horizontal', () {
      expect(16.horizontalPadding, EdgeInsets.symmetric(horizontal: 16));
    });
    test('leftPadding produces only left', () {
      expect(8.leftPadding, EdgeInsets.only(left: 8));
    });
    test('topPadding produces only top', () {
      expect(8.topPadding, EdgeInsets.only(top: 8));
    });
    test('rightPadding produces only right', () {
      expect(8.rightPadding, EdgeInsets.only(right: 8));
    });
    test('bottomPadding produces only bottom', () {
      expect(8.bottomPadding, EdgeInsets.only(bottom: 8));
    });
    test('ordinal adds st for 1', () {
      expect(1.ordinal, '1st');
    });
    test('ordinal adds nd for 2', () {
      expect(2.ordinal, '2nd');
    });
    test('ordinal adds rd for 3', () {
      expect(3.ordinal, '3rd');
    });
    test('ordinal adds th for 4', () {
      expect(4.ordinal, '4th');
    });
    test('ordinal adds th for 11', () {
      expect(11.ordinal, '11th');
    });
    test('percentage divides by 100', () {
      expect(50.percentage, 0.5);
      expect(100.percentage, 1.0);
    });
  });

  group('NumDurationX', () {
    test('milliseconds returns correct Duration', () {
      expect(500.milliseconds, const Duration(milliseconds: 500));
    });
    test('seconds returns correct Duration', () {
      expect(5.seconds, const Duration(seconds: 5));
    });
    test('minutes returns correct Duration', () {
      expect(2.minutes, const Duration(minutes: 2));
    });
    test('hours returns correct Duration', () {
      expect(1.hours, const Duration(hours: 1));
    });
    test('days returns correct Duration', () {
      expect(3.days, const Duration(days: 3));
    });
  });

  group('NumTimeX', () {
    test('daysAgo returns DateTime n days in the past', () {
      final result = 7.daysAgo;
      final expected = DateTime.now().subtract(const Duration(days: 7));
      expect(result.year, expected.year);
      expect(result.month, expected.month);
      expect(result.day, expected.day);
    });
    test('hoursAgo returns DateTime n hours in the past', () {
      final result = 2.hoursAgo;
      final expected = DateTime.now().subtract(const Duration(hours: 2));
      expect(result.hour, expected.hour);
    });
  });

  group('NumCoerceInExtension', () {
    test('returns value when within range', () {
      expect(5.coerceIn(1, 10), 5);
    });
    test('clamps to minimum when below range', () {
      expect(0.coerceIn(1, 10), 1);
    });
    test('clamps to maximum when above range', () {
      expect(15.coerceIn(1, 10), 10);
    });
    test('returns value when equal to minimum', () {
      expect(1.coerceIn(1, 10), 1);
    });
    test('returns value when equal to maximum', () {
      expect(10.coerceIn(1, 10), 10);
    });
    test('works without maximum — clamps to minimum only', () {
      expect(0.coerceIn(5), 5);
      expect(10.coerceIn(5), 10);
    });
    test('throws ArgumentError when min > max', () {
      expect(() => 5.coerceIn(10, 1), throwsArgumentError);
    });
  });

  // ──────────────────────────────────────────────
  // ListX
  // ──────────────────────────────────────────────
  group('ListX', () {
    test('validate returns empty list for null iterable', () {
      Iterable<int>? list;
      expect(list.validate(), <int>[]);
    });
    test('validate returns list for non-null iterable', () {
      expect([1, 2, 3].validate(), [1, 2, 3]);
    });
    test('forEachIndexed provides correct index and element', () {
      final result = <String>[];
      ['a', 'b', 'c'].forEachIndexed((i, e) => result.add('$i:$e'));
      expect(result, ['0:a', '1:b', '2:c']);
    });
    test('forEachIndexed does nothing for null iterable', () {
      Iterable<int>? list;
      int count = 0;
      list.forEachIndexed((i, e) => count++);
      expect(count, 0);
    });
    test('sumBy sums selected integer values', () {
      expect([1, 3, 7].sumBy((n) => n), 11);
    });
    test('sumByDouble sums selected double values', () {
      expect([1.5, 2.5].sumByDouble((d) => d), 4.0);
    });
    test('averageBy returns correct average', () {
      expect([1, 2, 3].averageBy((n) => n), 2.0);
    });
    test('averageBy returns null for empty list', () {
      expect(<int>[].averageBy((n) => n), null);
    });
    test('groupBy groups elements by key selector', () {
      final result = [1, 2, 3, 4].groupBy((n) => n.isEven ? 'even' : 'odd');
      expect(result['even'], [2, 4]);
      expect(result['odd'], [1, 3]);
    });
    test('firstWhereOrNull returns matching element', () {
      expect([1, 2, 3].firstWhereOrNull((n) => n > 2), 3);
    });
    test('firstWhereOrNull returns null when no match', () {
      expect([1, 2, 3].firstWhereOrNull((n) => n > 5), null);
    });
    test('firstWhereOrNull returns null for null iterable', () {
      Iterable<int>? list;
      expect(list.firstWhereOrNull((n) => true), null);
    });
  });

  group('ListSplit', () {
    test('splitAt splits at the given index', () {
      final r = [1, 2, 3, 4, 5].splitAt(2);
      expect(r.before, [1, 2]);
      expect(r.after, [3, 4, 5]);
    });
    test('splitAt clamps negative index to 0', () {
      final r = [1, 2, 3].splitAt(-1);
      expect(r.before, <int>[]);
      expect(r.after, [1, 2, 3]);
    });
    test('splitAt clamps out-of-bounds index to length', () {
      final r = [1, 2, 3].splitAt(10);
      expect(r.before, [1, 2, 3]);
      expect(r.after, <int>[]);
    });
    test('chunked splits into sub-lists of given size', () {
      expect([1, 2, 3, 4, 5].chunked(2), [
        [1, 2],
        [3, 4],
        [5],
      ]);
    });
    test('chunked returns whole list for size <= 0', () {
      expect([1, 2, 3].chunked(0), [
        [1, 2, 3],
      ]);
    });
    test('partition separates matching and remaining elements', () {
      final r = [1, 2, 3, 4].partition((n) => n.isEven);
      expect(r.matching, [2, 4]);
      expect(r.remaining, [1, 3]);
    });
  });

  group('ListSwapExtension', () {
    test('swap exchanges two elements by index', () {
      final list = [1, 2, 3];
      list.swap(0, 2);
      expect(list, [3, 2, 1]);
    });
    test('swap adjacent elements', () {
      final list = ['a', 'b', 'c'];
      list.swap(1, 2);
      expect(list, ['a', 'c', 'b']);
    });
    test('swap throws RangeError for out-of-bounds index', () {
      expect(() => [1, 2, 3].swap(0, 5), throwsRangeError);
    });
    test('swap throws RangeError for negative index', () {
      expect(() => [1, 2, 3].swap(-1, 0), throwsRangeError);
    });
  });

  // ──────────────────────────────────────────────
  // DateTimeExt
  // ──────────────────────────────────────────────
  group('DateTimeExt', () {
    test('isToday returns true for DateTime.now()', () {
      expect(DateTime.now().isToday, true);
    });
    test('isToday returns false for yesterday', () {
      expect(DateTime.now().subtract(const Duration(days: 1)).isToday, false);
    });
    test('isYesterday returns true for one day ago', () {
      expect(DateTime.now().subtract(const Duration(days: 1)).isYesterday, true);
    });
    test('isYesterday returns false for today', () {
      expect(DateTime.now().isYesterday, false);
    });
    test('isTomorrow returns true for one day ahead', () {
      expect(DateTime.now().add(const Duration(days: 1)).isTomorrow, true);
    });
    test('isTomorrow returns false for today', () {
      expect(DateTime.now().isTomorrow, false);
    });
    test('isFuture returns true for a future date', () {
      expect(DateTime.now().add(const Duration(hours: 1)).isFuture, true);
    });
    test('isFuture returns false for a past date', () {
      expect(DateTime.now().subtract(const Duration(hours: 1)).isFuture, false);
    });
    test('isPast returns true for a past date', () {
      expect(DateTime.now().subtract(const Duration(hours: 1)).isPast, true);
    });
    test('isPast returns false for a future date', () {
      expect(DateTime.now().add(const Duration(hours: 1)).isPast, false);
    });
    test('startOfDay returns midnight of the same day', () {
      final start = DateTime(2024, 6, 15, 14, 30).startOfDay;
      expect(start, DateTime(2024, 6, 15, 0, 0, 0));
    });
    test('endOfDay returns 23:59:59.999 of the same day', () {
      final end = DateTime(2024, 6, 15, 8, 0).endOfDay;
      expect(end, DateTime(2024, 6, 15, 23, 59, 59, 999));
    });
    test('isSameDay returns true for different times on same date', () {
      final d1 = DateTime(2024, 1, 15, 8, 0);
      final d2 = DateTime(2024, 1, 15, 22, 0);
      expect(d1.isSameDay(d2), true);
    });
    test('isSameDay returns false for different dates', () {
      final d1 = DateTime(2024, 1, 15);
      final d2 = DateTime(2024, 1, 16);
      expect(d1.isSameDay(d2), false);
    });
    test('timeAgo returns "Just now" for a very recent time', () {
      final recent = DateTime.now().subtract(const Duration(seconds: 1));
      expect(recent.timeAgo, 'Just now');
    });
    test('timeAgo contains "minute" for a few minutes ago', () {
      final past = DateTime.now().subtract(const Duration(minutes: 5));
      expect(past.timeAgo, contains('minute'));
      expect(past.timeAgo, contains('ago'));
    });
    test('timeAgo contains "hour" for a few hours ago', () {
      final past = DateTime.now().subtract(const Duration(hours: 3));
      expect(past.timeAgo, contains('hour'));
      expect(past.timeAgo, contains('ago'));
    });
  });

  // ──────────────────────────────────────────────
  // DateTime top-level helpers
  // ──────────────────────────────────────────────
  group('DateTimeHelpers', () {
    test('currentMillisecondsTimeStamp is close to epoch ms now', () {
      final ts = currentMillisecondsTimeStamp();
      expect(ts, closeTo(DateTime.now().millisecondsSinceEpoch, 100));
    });
    test('currentTimeStamp is close to epoch seconds now', () {
      final ts = currentTimeStamp();
      final expected = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      expect(ts, closeTo(expected, 1));
    });
    test('leapYear is true for 2024', () {
      expect(leapYear(2024), true);
    });
    test('leapYear is true for 2000 (divisible by 400)', () {
      expect(leapYear(2000), true);
    });
    test('leapYear is false for 1900 (divisible by 100 but not 400)', () {
      expect(leapYear(1900), false);
    });
    test('leapYear is false for 2023', () {
      expect(leapYear(2023), false);
    });
    test('daysInMonth returns 31 for January', () {
      expect(daysInMonth(1, 2024), 31);
    });
    test('daysInMonth returns 29 for February in leap year', () {
      expect(daysInMonth(2, 2024), 29);
    });
    test('daysInMonth returns 28 for February in non-leap year', () {
      expect(daysInMonth(2, 2023), 28);
    });
    test('daysInMonth returns 30 for April', () {
      expect(daysInMonth(4, 2024), 30);
    });
    test('daysInMonth returns 31 for December', () {
      expect(daysInMonth(12, 2024), 31);
    });
  });

  // ──────────────────────────────────────────────
  // time_formatter
  // ──────────────────────────────────────────────
  group('time_formatter', () {
    test('formatTime returns "Just now" for the current moment', () {
      final now = DateTime.now().millisecondsSinceEpoch;
      expect(formatTime(now), 'Just now');
    });
    test('formatTime returns seconds ago', () {
      final ts = DateTime.now().subtract(const Duration(seconds: 30)).millisecondsSinceEpoch;
      expect(formatTime(ts), '30 seconds ago');
    });
    test('formatTime returns 1 minute ago', () {
      final ts = DateTime.now().subtract(const Duration(minutes: 1)).millisecondsSinceEpoch;
      expect(formatTime(ts), '1 minute ago');
    });
    test('formatTime returns minutes ago', () {
      final ts = DateTime.now().subtract(const Duration(minutes: 5)).millisecondsSinceEpoch;
      expect(formatTime(ts), '5 minutes ago');
    });
    test('formatTime returns hours ago', () {
      final ts = DateTime.now().subtract(const Duration(hours: 3)).millisecondsSinceEpoch;
      expect(formatTime(ts), '3 hours ago');
    });
    test('formatTime returns days ago', () {
      final ts = DateTime.now().subtract(const Duration(days: 3)).millisecondsSinceEpoch;
      expect(formatTime(ts), '3 days ago');
    });
    test('formatTime returns weeks ago', () {
      final ts = DateTime.now().subtract(const Duration(days: 14)).millisecondsSinceEpoch;
      expect(formatTime(ts), '2 weeks ago');
    });
    test('formatTime returns months ago', () {
      final ts = DateTime.now().subtract(const Duration(days: 60)).millisecondsSinceEpoch;
      expect(formatTime(ts), contains('month'));
    });
    test('formatTime returns years ago', () {
      final ts = DateTime.now().subtract(const Duration(days: 400)).millisecondsSinceEpoch;
      expect(formatTime(ts), contains('year'));
    });
  });

  // ──────────────────────────────────────────────
  // BoolxExtensions
  // ──────────────────────────────────────────────
  group('BoolxExtensions', () {
    test('isTrue mirrors the value', () {
      expect(true.isTrue, true);
      expect(false.isTrue, false);
    });
    test('isFalse is the negation', () {
      expect(true.isFalse, false);
      expect(false.isFalse, true);
    });
    test('toggle flips the value', () {
      expect(true.toggle, false);
      expect(false.toggle, true);
    });
  });

  // ──────────────────────────────────────────────
  // Patterns
  // ──────────────────────────────────────────────
  group('Patterns', () {
    test('pkMobileLocal matches 03xxxxxxxxx', () {
      expect(RegExp(Patterns.pkMobileLocal).hasMatch('03001234567'), true);
    });
    test('pkMobileLocal rejects non-matching number', () {
      expect(RegExp(Patterns.pkMobileLocal).hasMatch('1234567890'), false);
    });
    test('pkMobileGlobal matches +92 prefix', () {
      expect(RegExp(Patterns.pkMobileGlobal).hasMatch('+923001234567'), true);
    });
    test('pkMobileGlobal matches 0 prefix', () {
      expect(RegExp(Patterns.pkMobileGlobal).hasMatch('03001234567'), true);
    });
    test('email pattern matches a valid address', () {
      expect(RegExp(Patterns.email).hasMatch('user@example.com'), true);
    });
    test('email pattern rejects plain text', () {
      expect(RegExp(Patterns.email).hasMatch('notanemail'), false);
    });
    test('url pattern matches https URL', () {
      expect(RegExp(Patterns.url).hasMatch('https://flutter.dev'), true);
    });
    test('url pattern rejects plain word', () {
      expect(RegExp(Patterns.url).hasMatch('notaurl'), false);
    });
    test('image pattern matches .jpg and .png', () {
      expect(RegExp(Patterns.image).hasMatch('photo.jpg'), true);
      expect(RegExp(Patterns.image).hasMatch('photo.png'), true);
    });
    test('image pattern rejects .pdf', () {
      expect(RegExp(Patterns.image).hasMatch('doc.pdf'), false);
    });
    test('pdf pattern matches .pdf', () {
      expect(RegExp(Patterns.pdf).hasMatch('file.pdf'), true);
    });
    test('audio pattern matches .mp3 and .wav', () {
      expect(RegExp(Patterns.audio).hasMatch('song.mp3'), true);
      expect(RegExp(Patterns.audio).hasMatch('track.wav'), true);
    });
    test('video pattern matches .mp4 and .avi', () {
      expect(RegExp(Patterns.video).hasMatch('clip.mp4'), true);
      expect(RegExp(Patterns.video).hasMatch('clip.avi'), true);
    });
    test('doc pattern matches .doc and .docx', () {
      expect(RegExp(Patterns.doc).hasMatch('file.docx'), true);
    });
    test('excel pattern matches .xls and .xlsx', () {
      expect(RegExp(Patterns.excel).hasMatch('sheet.xlsx'), true);
    });
    test('ppt pattern matches .ppt and .pptx', () {
      expect(RegExp(Patterns.ppt).hasMatch('slides.pptx'), true);
    });
    test('html pattern matches .html', () {
      expect(RegExp(Patterns.html).hasMatch('page.html'), true);
    });
    test('apk pattern matches .apk', () {
      expect(RegExp(Patterns.apk).hasMatch('app.apk'), true);
    });
    test('txt pattern matches .txt', () {
      expect(RegExp(Patterns.txt).hasMatch('notes.txt'), true);
    });
  });

  // ──────────────────────────────────────────────
  // MaskType
  // ──────────────────────────────────────────────
  group('MaskType', () {
    test('enum exposes auto, email, and phone values', () {
      expect(MaskType.values, containsAll([MaskType.auto, MaskType.email, MaskType.phone]));
      expect(MaskType.values.length, 3);
    });
  });

  // ──────────────────────────────────────────────
  // WidgetX
  // ──────────────────────────────────────────────
  group('WidgetX', () {
    testWidgets('center wraps widget in Center', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hi').center()));
      expect(find.byType(Center), findsWidgets);
    });

    testWidgets('expanded wraps widget in Expanded', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Row(children: [const Text('hi').expanded()])),
        ),
      );
      expect(find.byType(Expanded), findsOneWidget);
    });

    test('withWidth returns SizedBox with given width', () {
      expect(const Text('hi').withWidth(100).width, 100);
    });

    test('withHeight returns SizedBox with given height', () {
      expect(const Text('hi').withHeight(50).height, 50);
    });

    test('withSize returns SizedBox with given dimensions', () {
      final box = const Text('hi').withSize(width: 80, height: 40);
      expect(box.width, 80);
      expect(box.height, 40);
    });

    testWidgets('visible shows widget when true', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hello').visible(true)));
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('visible hides widget when false', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hello').visible(false)));
      expect(find.text('hello'), findsNothing);
    });

    testWidgets('visible shows defaultWidget when false and provided', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hello').visible(false, defaultWidget: const Text('fallback'))));
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('cornerRadiusWithClipRRect wraps in ClipRRect', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hi').cornerRadiusWithClipRRect(8.0)));
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('cornerRadiusWithClipRRectOnly wraps in ClipRRect', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hi').cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8)));
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('onTap wraps in InkWell and fires callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(home: Material(child: const Text('tap me').onTap(() => tapped = true))));
      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });

  // ──────────────────────────────────────────────
  // ContextX
  // ──────────────────────────────────────────────
  group('ContextX', () {
    testWidgets('theme returns ThemeData', (tester) async {
      late ThemeData captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = ctx.theme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, isA<ThemeData>());
    });

    testWidgets('textTheme returns TextTheme', (tester) async {
      late TextTheme captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = ctx.textTheme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, isA<TextTheme>());
    });

    testWidgets('colorScheme returns ColorScheme', (tester) async {
      late ColorScheme captured;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              captured = ctx.colorScheme;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(captured, isA<ColorScheme>());
    });

    testWidgets('screenWidth and screenHeight are positive', (tester) async {
      late double w, h;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              w = ctx.screenWidth;
              h = ctx.screenHeight;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(w, greaterThan(0));
      expect(h, greaterThan(0));
    });

    testWidgets('screenSize equals screenWidth x screenHeight', (tester) async {
      late Size size;
      late double w, h;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              size = ctx.screenSize;
              w = ctx.screenWidth;
              h = ctx.screenHeight;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(size.width, w);
      expect(size.height, h);
    });

    testWidgets('isMobile true for screen width < 600', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool mobile;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              mobile = ctx.isMobile;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(mobile, true);
    });

    testWidgets('isTablet true for screen width between 600 and 1024', (tester) async {
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool tablet;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              tablet = ctx.isTablet;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(tablet, true);
    });

    testWidgets('isDesktop true for screen width >= 1024', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool desktop;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              desktop = ctx.isDesktop;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(desktop, true);
    });

    testWidgets('isKeyboardVisible is false when keyboard is not shown', (tester) async {
      late bool visible;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              visible = ctx.isKeyboardVisible;
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(visible, false);
    });

    testWidgets('hideKeyboard does not throw', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              ctx.hideKeyboard();
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    testWidgets('pickDate — returns selected date', (tester) async {
      DateTime? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () async {
                  picked = await ctx.pickDate(initialDate: DateTime(2024, 6, 15), firstDate: DateTime(2020), lastDate: DateTime(2030));
                },
                child: const Text('pick'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      // Confirm the dialog
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(picked, isNotNull);
    });

    testWidgets('pickDate — returns null on cancel', (tester) async {
      DateTime? picked = DateTime(2000);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () async {
                  picked = await ctx.pickDate(initialDate: DateTime(2024, 6, 15), firstDate: DateTime(2020), lastDate: DateTime(2030));
                },
                child: const Text('pick'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(picked, isNull);
    });

    testWidgets('pickTime — returns selected time', (tester) async {
      TimeOfDay? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () async {
                  picked = await ctx.pickTime(initialTime: const TimeOfDay(hour: 9, minute: 30), initialEntryMode: TimePickerEntryMode.input);
                },
                child: const Text('pick'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(picked, isNotNull);
    });

    testWidgets('pickTime — returns null on cancel', (tester) async {
      TimeOfDay? picked = const TimeOfDay(hour: 0, minute: 0);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              return ElevatedButton(
                onPressed: () async {
                  picked = await ctx.pickTime(initialTime: const TimeOfDay(hour: 9, minute: 30), initialEntryMode: TimePickerEntryMode.input);
                },
                child: const Text('pick'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(picked, isNull);
    });
  });

  // ──────────────────────────────────────────────
  // FormX
  // ──────────────────────────────────────────────
  group('FormX', () {
    test('isEmpty — true when all fields are blank', () {
      final form = FormX(_F.values);
      expect(form.isEmpty, true);
      form.dispose();
    });

    test('isEmpty — false when any field has text', () {
      final form = FormX(_F.values);
      form[_F.name].text = 'Ali';
      expect(form.isEmpty, false);
      form.dispose();
    });

    test('isEmpty — true when fields contain only whitespace', () {
      final form = FormX(_F.values);
      form[_F.name].text = '   ';
      expect(form.isEmpty, true);
      form.dispose();
    });

    test('isDirty — false on fresh form', () {
      final form = FormX(_F.values);
      expect(form.isDirty, false);
      form.dispose();
    });

    test('isDirty — true after a field is changed', () {
      final form = FormX(_F.values);
      form[_F.email].text = 'a@b.com';
      expect(form.isDirty, true);
      form.dispose();
    });

    test('isDirty — false immediately after fill()', () {
      final form = FormX(_F.values);
      form.fill({_F.name: 'Ali', _F.email: 'a@b.com'});
      expect(form.isDirty, false);
      form.dispose();
    });

    test('isDirty — true after fill() then user edits', () {
      final form = FormX(_F.values);
      form.fill({_F.name: 'Ali'});
      form[_F.name].text = 'Bob';
      expect(form.isDirty, true);
      form.dispose();
    });

    test('isDirty — false after reset()', () {
      final form = FormX(_F.values);
      form[_F.name].text = 'Ali';
      form.reset();
      expect(form.isDirty, false);
      form.dispose();
    });

    testWidgets('focus() moves focus to the target field', (tester) async {
      final form = FormX(_F.values);
      late BuildContext ctx;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (c) {
                ctx = c;
                return Column(
                  children: [
                    TextField(controller: form[_F.name], focusNode: form.focusNode(_F.name)),
                    TextField(controller: form[_F.email], focusNode: form.focusNode(_F.email)),
                  ],
                );
              },
            ),
          ),
        ),
      );
      form.focus(_F.email, ctx);
      await tester.pump();
      expect(form.focusNode(_F.email).hasFocus, true);
      form.dispose();
    });

    test('validate — returns null for passing fields', () {
      final form = FormX(_F.values);
      form.fill({_F.name: 'Ali', _F.email: 'a@b.com'});
      final errors = form.validate({_F.name: (v) => v.isEmpty ? 'Required' : null, _F.email: (v) => v.isEmpty ? 'Required' : null});
      expect(errors[_F.name], isNull);
      expect(errors[_F.email], isNull);
      form.dispose();
    });

    test('validate — returns error message for failing fields', () {
      final form = FormX(_F.values);
      final errors = form.validate({_F.name: (v) => v.isEmpty ? 'Required' : null, _F.password: (v) => v.length < 8 ? 'Too short' : null});
      expect(errors[_F.name], 'Required');
      expect(errors[_F.password], 'Too short');
      form.dispose();
    });

    test('validate — only checks keys present in validators map', () {
      final form = FormX(_F.values);
      final errors = form.validate({_F.name: (v) => v.isEmpty ? 'Required' : null});
      expect(errors.containsKey(_F.email), false);
      expect(errors.containsKey(_F.password), false);
      form.dispose();
    });
  });

  // ──────────────────────────────────────────────
  // LoadingOverlayWidgetx
  // ──────────────────────────────────────────────
  group('LoadingOverlayWidgetx', () {
    testWidgets('renders child when not loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingOverlayWidgetx(isLoading: false, child: Text('content'))));
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('renders child and overlay when loading', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoadingOverlayWidgetx(isLoading: true, child: Text('content'))),
        ),
      );
      expect(find.text('content'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('blocks child taps when loading', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: LoadingOverlayWidgetx(
            isLoading: true,
            child: GestureDetector(onTap: () => taps++, child: const SizedBox.expand()),
          ),
        ),
      );
      await tester.tap(find.byType(SizedBox), warnIfMissed: false);
      expect(taps, 0);
    });

    testWidgets('allows child taps when not loading', (tester) async {
      int taps = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: LoadingOverlayWidgetx(
            isLoading: false,
            child: GestureDetector(
              onTap: () => taps++,
              child: const ColoredBox(color: Colors.red, child: SizedBox(width: 100, height: 100)),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(GestureDetector));
      expect(taps, 1);
    });

    testWidgets('fullScreen mode shows ColoredBox barrier', (tester) async {
      const barrierColor = Colors.red;
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlayWidgetx(isLoading: true, mode: LoadingOverlayMode.fullScreen, barrierColor: barrierColor, child: SizedBox.expand()),
        ),
      );
      expect(find.byWidgetPredicate((w) => w is ColoredBox && w.color == barrierColor), findsOneWidget);
    });

    testWidgets('centered mode shows no ColoredBox barrier', (tester) async {
      const barrierColor = Color(0x89000000);
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlayWidgetx(isLoading: true, mode: LoadingOverlayMode.centered, child: SizedBox.expand()),
        ),
      );
      expect(find.byWidgetPredicate((w) => w is ColoredBox && w.color == barrierColor), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('accepts a custom indicator', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingOverlayWidgetx(isLoading: true, indicator: Icon(Icons.hourglass_empty), child: SizedBox.expand()),
        ),
      );
      expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('overlay opacity is 0 when not loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingOverlayWidgetx(isLoading: false, child: SizedBox.expand())));
      final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacity.opacity, 0.0);
    });

    testWidgets('overlay opacity is 1 when loading', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoadingOverlayWidgetx(isLoading: true, child: SizedBox.expand())));
      final opacity = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(opacity.opacity, 1.0);
    });
  });

  // ──────────────────────────────────────────────
  // PaginatorX
  // ──────────────────────────────────────────────
  group('PaginatorX', () {
    List<int> pageOf(int page, int size) => List.generate(size, (i) => (page - 1) * size + i);

    PaginatorX<int> paginatorOf({int pages = 3, int size = 20, Object Function(int)? itemId}) {
      return PaginatorX<int>(
        pageSize: size,
        itemId: itemId,
        fetchPage: (page, _) async => PageX(items: page <= pages ? pageOf(page, size) : <int>[], hasMore: page < pages),
      );
    }

    test('starts in the initial state with nothing loaded', () {
      final p = paginatorOf();
      expect(p.status, PaginationStatus.initial);
      expect(p.itemCount, 0);
      expect(p.hasMore, true);
      expect(p.nextPage, 1);
      expect(p.canLoadMore, true);
      p.dispose();
    });

    test('loadFirstPage fills the first page and advances the page index', () async {
      final p = paginatorOf();
      await p.loadFirstPage();
      expect(p.itemCount, 20);
      expect(p.items.first, 0);
      expect(p.status, PaginationStatus.loaded);
      expect(p.nextPage, 2);
      p.dispose();
    });

    test('loadFirstPage is a no-op once loading has started', () async {
      var calls = 0;
      final p = PaginatorX<int>.simple(
        pageSize: 5,
        fetch: (page) async {
          calls++;
          return pageOf(page, 5);
        },
      );
      await Future.wait([p.loadFirstPage(), p.loadFirstPage()]);
      await p.loadFirstPage();
      expect(calls, 1);
      p.dispose();
    });

    test('loadNextPage appends without dropping earlier pages', () async {
      final p = paginatorOf();
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.itemCount, 40);
      expect(p.items.last, 39);
      p.dispose();
    });

    test('stops at the end of the list', () async {
      final p = paginatorOf(pages: 2);
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.hasMore, false);
      expect(p.canLoadMore, false);
      await p.loadNextPage();
      expect(p.itemCount, 40);
      p.dispose();
    });

    test('infers hasMore from a short page when the API omits it', () async {
      final p = PaginatorX<int>.simple(pageSize: 20, fetch: (page) async => pageOf(page, page == 1 ? 20 : 7));
      await p.loadFirstPage();
      expect(p.hasMore, true);
      await p.loadNextPage();
      expect(p.hasMore, false);
      expect(p.itemCount, 27);
      p.dispose();
    });

    test('stops when a server claims hasMore but returns an empty page', () async {
      var calls = 0;
      final p = PaginatorX<int>(
        pageSize: 10,
        fetchPage: (page, _) async {
          calls++;
          return PageX(items: page == 1 ? pageOf(1, 10) : <int>[], hasMore: true);
        },
      );
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.hasMore, false, reason: 'must not loop on empty pages');
      await p.loadNextPage();
      expect(calls, 2);
      p.dispose();
    });

    test('drops duplicate items across pages when itemId is set', () async {
      final p = PaginatorX<int>(
        pageSize: 3,
        itemId: (i) => i,
        fetchPage: (page, _) async => PageX(items: page == 1 ? [1, 2, 3] : [3, 4, 5], hasMore: page < 2),
      );
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.items, [1, 2, 3, 4, 5]);
      p.dispose();
    });

    test('keeps duplicates when itemId is not set', () async {
      final p = PaginatorX<int>(
        pageSize: 3,
        fetchPage: (page, _) async => PageX(items: page == 1 ? [1, 2, 3] : [3, 4, 5], hasMore: page < 2),
      );
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.items, [1, 2, 3, 3, 4, 5]);
      p.dispose();
    });

    test('passes the cursor of the previous page to the next request', () async {
      final cursors = <String?>[];
      final p = PaginatorX<int>(
        pageSize: 2,
        fetchPage: (page, cursor) async {
          cursors.add(cursor);
          return PageX(items: pageOf(page, 2), nextCursor: page < 3 ? 'cursor-$page' : null, hasMore: page < 3);
        },
      );
      await p.loadFirstPage();
      await p.loadNextPage();
      await p.loadNextPage();
      expect(cursors, [null, 'cursor-1', 'cursor-2']);
      p.dispose();
    });

    test('a concurrent loadNextPage does not fire a second request', () async {
      var calls = 0;
      final gate = Completer<void>();
      final p = PaginatorX<int>(
        pageSize: 2,
        fetchPage: (page, _) async {
          calls++;
          await gate.future;
          return PageX(items: pageOf(page, 2), hasMore: true);
        },
      );
      final a = p.loadFirstPage();
      final b = p.loadNextPage();
      expect(calls, 1, reason: 'the in-flight request must not be duplicated');
      gate.complete();
      await Future.wait([a, b]);
      expect(p.itemCount, 2);
      p.dispose();
    });

    test('refresh replaces the items and resets the page index', () async {
      final p = paginatorOf();
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.itemCount, 40);
      await p.refresh();
      expect(p.itemCount, 20);
      expect(p.nextPage, 2);
      expect(p.status, PaginationStatus.loaded);
      p.dispose();
    });

    test('a refresh discards an in-flight page response', () async {
      final gate = Completer<List<int>>();
      final p = PaginatorX<int>(
        pageSize: 2,
        fetchPage: (page, _) async {
          if (page == 2) return PageX(items: await gate.future, hasMore: true);
          return PageX(items: [1, 2], hasMore: true);
        },
      );
      await p.loadFirstPage();
      final stale = p.loadNextPage();
      final fresh = p.refresh();
      gate.complete([98, 99]);
      await Future.wait([stale, fresh]);
      expect(p.items, [1, 2], reason: 'the superseded page must not be appended');
      p.dispose();
    });

    test('an empty first page reports the empty state', () async {
      final p = PaginatorX<int>.simple(fetch: (_) async => <int>[]);
      await p.loadFirstPage();
      expect(p.status, PaginationStatus.empty);
      expect(p.isEmpty, true);
      expect(p.hasMore, false);
      p.dispose();
    });

    test('a first-page failure reports firstPageError and blocks loading', () async {
      final p = PaginatorX<int>.simple(fetch: (_) async => throw Exception('offline'));
      await p.loadFirstPage();
      expect(p.status, PaginationStatus.firstPageError);
      expect(p.hasError, true);
      expect(p.error, isA<Exception>());
      expect(p.canLoadMore, false, reason: 'must not auto-retry on scroll');
      p.dispose();
    });

    test('a later failure keeps the loaded items and reports loadMoreError', () async {
      final p = PaginatorX<int>(
        pageSize: 2,
        fetchPage: (page, _) async {
          if (page == 2) throw Exception('offline');
          return PageX(items: [1, 2], hasMore: true);
        },
      );
      await p.loadFirstPage();
      await p.loadNextPage();
      expect(p.status, PaginationStatus.loadMoreError);
      expect(p.items, [1, 2], reason: 'loaded items must survive a failure');
      p.dispose();
    });

    test('retry re-requests the failed page and recovers', () async {
      var attempt = 0;
      final p = PaginatorX<int>.simple(
        pageSize: 2,
        fetch: (page) async {
          attempt++;
          if (attempt == 1) throw Exception('offline');
          return [1, 2];
        },
      );
      await p.loadFirstPage();
      expect(p.hasError, true);
      await p.retry();
      expect(p.hasError, false);
      expect(p.items, [1, 2]);
      expect(p.status, PaginationStatus.loaded);
      p.dispose();
    });

    test('retry repeats a refresh when the refresh was what failed', () async {
      final pagesRequested = <int>[];
      var failRefresh = true;
      final p = PaginatorX<int>(
        pageSize: 2,
        fetchPage: (page, _) async {
          pagesRequested.add(page);
          if (page == 1 && pagesRequested.length > 1 && failRefresh) {
            failRefresh = false;
            throw Exception('offline');
          }
          return PageX(items: [1, 2], hasMore: true);
        },
      );
      await p.loadFirstPage();
      await p.refresh();
      expect(p.hasError, true);
      await p.retry();
      expect(pagesRequested, [1, 1, 1], reason: 'retry must repeat page 1');
      expect(p.hasError, false);
      p.dispose();
    });

    test('pause blocks auto-loading until retry clears it', () async {
      final p = paginatorOf();
      await p.loadFirstPage();
      p.pause();
      expect(p.canLoadMore, false);
      await p.loadNextPage();
      expect(p.itemCount, 20);
      await p.resume();
      expect(p.isPaused, false);
      expect(p.itemCount, 40);
      p.dispose();
    });

    test('a timeout fails the page like any other error', () async {
      final p = PaginatorX<int>(
        timeout: const Duration(milliseconds: 20),
        fetchPage: (page, _) => Future.delayed(const Duration(seconds: 5), () => PageX.empty()),
      );
      await p.loadFirstPage();
      expect(p.error, isA<TimeoutException>());
      expect(p.status, PaginationStatus.firstPageError);
      p.dispose();
    });

    test('reset clears the items and the bookkeeping', () async {
      final p = paginatorOf();
      await p.loadFirstPage();
      p.reset();
      expect(p.itemCount, 0);
      expect(p.nextPage, 1);
      expect(p.status, PaginationStatus.initial);
      expect(p.hasMore, true);
      p.dispose();
    });

    test('updateFetcher reloads from the first page with the new query', () async {
      final p = PaginatorX<int>.simple(pageSize: 2, fetch: (_) async => [1, 2]);
      await p.loadFirstPage();
      await p.loadNextPage();
      await p.updateFetcher((page, _) async => PageX(items: [7, 8]));
      expect(p.items, [7, 8]);
      expect(p.nextPage, 2);
      p.dispose();
    });

    test('a response arriving after dispose does not throw', () async {
      final gate = Completer<void>();
      final p = PaginatorX<int>(
        fetchPage: (page, _) async {
          await gate.future;
          return PageX(items: [1], hasMore: false);
        },
      );
      final pending = p.loadFirstPage();
      p.dispose();
      gate.complete();
      await expectLater(pending, completes);
    });

    test('local mutations keep the list in sync without refetching', () async {
      final p = PaginatorX<int>(
        pageSize: 3,
        itemId: (i) => i,
        fetchPage: (page, _) async => PageX(items: [1, 2, 3], hasMore: false),
      );
      await p.loadFirstPage();

      p.addItem(4);
      expect(p.items, [1, 2, 3, 4]);

      p.addItem(4);
      expect(p.items, [1, 2, 3, 4], reason: 'itemId must block a duplicate');

      p.insertItem(0, 0);
      expect(p.items.first, 0);

      p.removeWhere((i) => i == 2);
      expect(p.items, [0, 1, 3, 4]);

      p.updateWhere((i) => i == 3, (i) => 33);
      expect(p.items, [0, 1, 33, 4]);

      p.removeAt(99);
      expect(p.items.length, 4, reason: 'an out-of-range index is a no-op');

      p.setItems([5, 6]);
      expect(p.items, [5, 6]);

      p.clearItems();
      expect(p.status, PaginationStatus.empty);
      p.dispose();
    });

    test('notifies listeners on load and on mutation', () async {
      final p = PaginatorX<int>.simple(fetch: (_) async => [1]);
      var notifications = 0;
      p.addListener(() => notifications++);
      await p.loadFirstPage();
      expect(notifications, 2, reason: 'one for loading, one for the result');
      p.addItem(2);
      expect(notifications, 3);
      p.dispose();
    });
  });

  // ──────────────────────────────────────────────
  // PaginatedListWidgetx
  // ──────────────────────────────────────────────
  group('PaginatedListWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('shows a skeleton placeholder, then the first page', (tester) async {
      final gate = Completer<List<String>>();
      await tester.pumpWidget(host(PaginatedListWidgetx<String>(fetchItems: (_) => gate.future, itemBuilder: (context, item, index) => Text(item))));
      await tester.pump();
      expect(find.byType(SkeletonListWidgetx), findsOneWidget);

      gate.complete(['Ali', 'Sana']);
      await tester.pumpAndSettle();
      expect(find.byType(SkeletonListWidgetx), findsNothing);
      expect(find.text('Ali'), findsOneWidget);
      expect(find.text('Sana'), findsOneWidget);
    });

    testWidgets('shows the empty state when the first page has no items', (tester) async {
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            fetchItems: (_) async => <String>[],
            emptyTitle: 'No users',
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No users'), findsOneWidget);
      expect(find.byType(EmptyStateWidgetx), findsOneWidget);
    });

    testWidgets('autoLoad false leaves the list untouched until asked', (tester) async {
      var calls = 0;
      final paginator = PaginatorX<String>.simple(
        fetch: (page) async {
          calls++;
          return ['row'];
        },
      );
      addTearDown(paginator.dispose);

      await tester.pumpWidget(
        host(PaginatedListWidgetx<String>(controller: paginator, autoLoad: false, itemBuilder: (context, item, index) => Text(item))),
      );
      await tester.pumpAndSettle();
      expect(calls, 0);

      await paginator.loadFirstPage();
      await tester.pumpAndSettle();
      expect(find.text('row'), findsOneWidget);
    });

    testWidgets('a first-page failure offers an inline retry that recovers', (tester) async {
      var attempt = 0;
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            fetchItems: (page) async {
              attempt++;
              if (attempt == 1) throw Exception('offline');
              return ['recovered'];
            },
            errorTitle: 'Load failed',
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Load failed'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('recovered'), findsOneWidget);
      expect(find.text('Load failed'), findsNothing);
    });

    testWidgets('reports the failure through onError once', (tester) async {
      final errors = <Object>[];
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            fetchItems: (_) async => throw Exception('offline'),
            onError: (error, _) => errors.add(error),
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(errors.length, 1);
    });

    testWidgets('auto-fills the viewport when the first page is short', (tester) async {
      final requested = <int>[];
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            pageSize: 2,
            fetchItems: (page) async {
              requested.add(page);
              return page <= 3 ? ['p$page-a', 'p$page-b'] : <String>[];
            },
            itemBuilder: (context, item, index) => SizedBox(height: 40, child: Text(item)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(requested.length, greaterThan(1), reason: 'a page too short to scroll must pull the next one');
      expect(find.text('p2-a'), findsOneWidget);
    });

    testWidgets('a later failure keeps the rows and shows a footer retry', (tester) async {
      var attempt = 0;
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            pageSize: 2,
            fetchItems: (page) async {
              if (page == 2) {
                attempt++;
                if (attempt == 1) throw Exception('offline');
                return ['p2-a', 'p2-b'];
              }
              return ['p1-a', 'p1-b'];
            },
            itemBuilder: (context, item, index) => SizedBox(height: 40, child: Text(item)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('p1-a'), findsOneWidget, reason: 'rows must survive');
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text('p2-a'), findsOneWidget);
    });

    testWidgets('errorMode.dialog offers Retry and recovers on tap', (tester) async {
      var attempt = 0;
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            errorMode: PaginationErrorMode.dialog,
            errorTitle: 'Network error',
            fetchItems: (page) async {
              attempt++;
              if (attempt == 1) throw Exception('offline');
              return ['recovered'];
            },
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Network error'), findsWidgets);

      // Scoped to the dialog: the error state behind it also offers Retry.
      await tester.tap(find.descendant(of: find.byType(Dialog), matching: find.widgetWithText(FilledButton, 'Retry')));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('recovered'), findsOneWidget);
    });

    testWidgets('cancelling the dialog pauses loading and does not reopen it', (tester) async {
      var cancelled = false;
      final paginator = PaginatorX<String>.simple(fetch: (_) async => throw Exception('offline'));
      addTearDown(paginator.dispose);

      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            controller: paginator,
            errorMode: PaginationErrorMode.dialog,
            onErrorCancelled: () => cancelled = true,
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsOneWidget);

      await tester.tap(find.widgetWithText(OutlinedButton, 'Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(cancelled, true);
      expect(paginator.isPaused, true);
      expect(paginator.canLoadMore, false);
    });

    testWidgets('errorMode.dialogOnFirstPage stays inline for later pages', (tester) async {
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            pageSize: 2,
            errorMode: PaginationErrorMode.dialogOnFirstPage,
            fetchItems: (page) async {
              if (page == 2) throw Exception('offline');
              return ['p1-a', 'p1-b'];
            },
            itemBuilder: (context, item, index) => SizedBox(height: 40, child: Text(item)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing, reason: 'a later page must not interrupt with a dialog');
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('pull-to-refresh reloads from the first page', (tester) async {
      var loads = 0;
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            pageSize: 20,
            fetchItems: (page) async {
              loads++;
              return List.generate(20, (i) => 'load$loads-row$i');
            },
            itemBuilder: (context, item, index) => SizedBox(height: 60, child: Text(item)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('load1-row0'), findsOneWidget);

      await tester.fling(find.byType(CustomScrollView), const Offset(0, 320), 1000);
      await tester.pumpAndSettle();
      expect(find.text('load2-row0'), findsOneWidget);
    });

    testWidgets('renders a grid when a gridDelegate is supplied', (tester) async {
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            fetchItems: (_) async => ['a', 'b', 'c', 'd'],
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SliverGrid), findsOneWidget);
      expect(find.text('d'), findsOneWidget);
    });

    testWidgets('renders the header, separators, and end footer', (tester) async {
      await tester.pumpWidget(
        host(
          PaginatedListWidgetx<String>(
            pageSize: 10,
            fetchItems: (_) async => ['a', 'b'],
            header: const Text('HEADER'),
            separator: const Divider(),
            endBuilder: (_) => const Text('THE END'),
            itemBuilder: (context, item, index) => Text(item),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('HEADER'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      expect(find.text('THE END'), findsOneWidget);
    });

    testWidgets('an in-flight page landing after unmount does not throw', (tester) async {
      final gate = Completer<List<String>>();
      await tester.pumpWidget(host(PaginatedListWidgetx<String>(fetchItems: (_) => gate.future, itemBuilder: (context, item, index) => Text(item))));
      await tester.pump();

      await tester.pumpWidget(host(const SizedBox()));
      gate.complete(['late']);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('a controller supplied by the caller survives the widget', (tester) async {
      final paginator = PaginatorX<String>.simple(fetch: (_) async => ['kept']);
      addTearDown(paginator.dispose);

      await tester.pumpWidget(host(PaginatedListWidgetx<String>(controller: paginator, itemBuilder: (context, item, index) => Text(item))));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(const SizedBox()));

      expect(paginator.items, ['kept'], reason: 'the caller owns dispose');
      paginator.addItem('still usable');
      expect(paginator.itemCount, 2);
    });
  });

  // ──────────────────────────────────────────────
  // ButtonWidgetx
  // ──────────────────────────────────────────────
  group('ButtonWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('renders the label and fires a synchronous onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(ButtonWidgetx(text: 'Save', onPressed: () => taps++)));

      expect(find.text('Save'), findsOneWidget);
      await tester.tap(find.byType(ButtonWidgetx));
      await tester.pump();
      expect(taps, 1);
    });

    testWidgets('shows a spinner while an async onPressed is in flight', (tester) async {
      final gate = Completer<void>();
      await tester.pumpWidget(host(ButtonWidgetx(text: 'Save', onPressed: () => gate.future)));

      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(ButtonWidgetx));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);

      gate.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('ignores a second tap while the first is still running', (tester) async {
      final gate = Completer<void>();
      var calls = 0;
      await tester.pumpWidget(
        host(
          ButtonWidgetx(
            text: 'Submit',
            onPressed: () {
              calls++;
              return gate.future;
            },
          ),
        ),
      );

      await tester.tap(find.byType(ButtonWidgetx));
      await tester.pump();
      await tester.tap(find.byType(ButtonWidgetx), warnIfMissed: false);
      await tester.pump();

      expect(calls, 1, reason: 'the button must not re-enter while loading');
      gate.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('a null onPressed disables the button', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(const ButtonWidgetx(text: 'Disabled')));
      await tester.tap(find.byType(ButtonWidgetx), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('isEnabled false blocks taps even with an onPressed', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(ButtonWidgetx(text: 'Off', isEnabled: false, onPressed: () => taps++)));
      await tester.tap(find.byType(ButtonWidgetx), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
    });

    testWidgets('external isLoading shows the spinner without a tap', (tester) async {
      await tester.pumpWidget(host(ButtonWidgetx(text: 'Save', isLoading: true, onPressed: () {})));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('onError receives the failure and the button recovers', (tester) async {
      Object? captured;
      await tester.pumpWidget(
        host(ButtonWidgetx(text: 'Save', onPressed: () async => throw StateError('boom'), onError: (error, _) => captured = error)),
      );

      await tester.tap(find.byType(ButtonWidgetx));
      await tester.pumpAndSettle();

      expect(captured, isStateError);
      expect(find.text('Save'), findsOneWidget, reason: 'loading must clear after a failure');
    });

    testWidgets('a future landing after unmount does not throw', (tester) async {
      final gate = Completer<void>();
      await tester.pumpWidget(host(ButtonWidgetx(text: 'Save', onPressed: () => gate.future)));
      await tester.tap(find.byType(ButtonWidgetx));
      await tester.pump();

      await tester.pumpWidget(host(const SizedBox()));
      gate.complete();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('named constructors select their variant', (tester) async {
      await tester.pumpWidget(host(const ButtonWidgetx.danger(text: 'Delete')));
      final widget = tester.widget<ButtonWidgetx>(find.byType(ButtonWidgetx));
      expect(widget.variant, ButtonVariantX.danger);
    });
  });

  // ──────────────────────────────────────────────
  // TextFieldWidgetx
  // ──────────────────────────────────────────────
  group('TextFieldWidgetx', () {
    Widget host(Widget child, {GlobalKey<FormState>? formKey}) => MaterialApp(
      home: Scaffold(
        body: Form(key: formKey, child: child),
      ),
    );

    testWidgets('appends an asterisk to the label when required', (tester) async {
      await tester.pumpWidget(host(const TextFieldWidgetx(label: 'Email', isRequired: true)));
      expect(find.text('Email *'), findsOneWidget);
    });

    testWidgets('required validation fails on an empty value', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(host(const TextFieldWidgetx(label: 'Name', isRequired: true), formKey: formKey));

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text(defaultFieldRequiredMessageGlobal), findsOneWidget);
    });

    testWidgets('email type rejects a malformed address and accepts a valid one', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        host(
          const TextFieldWidgetx(label: 'Email', type: FieldTypeX.email),
          formKey: formKey,
        ),
      );

      await tester.enterText(find.byType(TextField), 'not-an-email');
      expect(formKey.currentState!.validate(), isFalse);

      await tester.enterText(find.byType(TextField), 'ali@example.com');
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('an optional empty field skips the pattern check', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(
        host(
          const TextFieldWidgetx(label: 'Email', type: FieldTypeX.email),
          formKey: formKey,
        ),
      );
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('minLength is enforced once the user has typed', (tester) async {
      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(host(const TextFieldWidgetx(label: 'Password', minLength: 8), formKey: formKey));

      await tester.enterText(find.byType(TextField), 'short');
      expect(formKey.currentState!.validate(), isFalse);

      await tester.enterText(find.byType(TextField), 'longenough');
      expect(formKey.currentState!.validate(), isTrue);
    });

    testWidgets('password type obscures the value and the toggle reveals it', (tester) async {
      await tester.pumpWidget(host(const TextFieldWidgetx(label: 'Password', type: FieldTypeX.password)));

      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);
    });

    testWidgets('reads and writes through a FormX controller', (tester) async {
      final form = FormX(_F.values);
      addTearDown(form.dispose);

      await tester.pumpWidget(host(TextFieldWidgetx<_F>(form: form, fieldKey: _F.email, label: 'Email')));
      await tester.enterText(find.byType(TextField), 'ali@example.com');

      expect(form.value(_F.email), 'ali@example.com');
    });

    testWidgets('nextField moves focus on submit', (tester) async {
      final form = FormX(_F.values);
      addTearDown(form.dispose);

      await tester.pumpWidget(
        host(
          Column(
            children: [
              TextFieldWidgetx<_F>(form: form, fieldKey: _F.email, label: 'Email', nextField: _F.password),
              TextFieldWidgetx<_F>(form: form, fieldKey: _F.password, label: 'Password'),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      expect(form.focusNode(_F.password).hasFocus, isTrue);
    });

    testWidgets('a caller-supplied controller survives the field being disposed', (tester) async {
      final controller = TextEditingController(text: 'kept');
      addTearDown(controller.dispose);

      await tester.pumpWidget(host(TextFieldWidgetx(controller: controller, label: 'Note')));
      await tester.pumpWidget(host(const SizedBox()));

      expect(controller.text, 'kept', reason: 'the caller owns dispose');
    });

    testWidgets('number type strips non-digits', (tester) async {
      await tester.pumpWidget(host(const TextFieldWidgetx(label: 'Age', type: FieldTypeX.number)));
      await tester.enterText(find.byType(TextField), '12a3b');
      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, '123');
    });
  });

  // ──────────────────────────────────────────────
  // AsyncBuilderWidgetx
  // ──────────────────────────────────────────────
  group('AsyncBuilderWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('shows the loading state, then the data', (tester) async {
      final gate = Completer<String>();
      await tester.pumpWidget(host(AsyncBuilderWidgetx<String>(future: () => gate.future, builder: (_, data) => Text(data))));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      gate.complete('loaded');
      await tester.pumpAndSettle();
      expect(find.text('loaded'), findsOneWidget);
    });

    testWidgets('renders the empty state for an empty list', (tester) async {
      await tester.pumpWidget(host(AsyncBuilderWidgetx<List<String>>(future: () async => const [], builder: (_, data) => Text('${data.length}'))));
      await tester.pumpAndSettle();
      expect(find.text(defaultAsyncEmptyTitleGlobal), findsOneWidget);
    });

    testWidgets('a failure offers a retry that recovers', (tester) async {
      var attempt = 0;
      await tester.pumpWidget(
        host(
          AsyncBuilderWidgetx<String>(
            future: () async {
              attempt++;
              if (attempt == 1) throw StateError('nope');
              return 'second time';
            },
            builder: (_, data) => Text(data),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(defaultAsyncErrorTitleGlobal), findsOneWidget);
      await tester.tap(find.text(defaultAsyncRetryTextGlobal));
      await tester.pumpAndSettle();

      expect(find.text('second time'), findsOneWidget);
    });

    testWidgets('a rebuild does not refire the future', (tester) async {
      var calls = 0;
      Future<String> fetch() async {
        calls++;
        return 'value';
      }

      await tester.pumpWidget(host(AsyncBuilderWidgetx<String>(future: fetch, builder: (_, data) => Text(data))));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(AsyncBuilderWidgetx<String>(future: fetch, builder: (_, data) => Text(data))));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('a changed reloadOn refires the future', (tester) async {
      var calls = 0;
      Future<String> fetch() async {
        calls++;
        return 'value $calls';
      }

      await tester.pumpWidget(host(AsyncBuilderWidgetx<String>(future: fetch, reloadOn: 1, builder: (_, d) => Text(d))));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(AsyncBuilderWidgetx<String>(future: fetch, reloadOn: 2, builder: (_, d) => Text(d))));
      await tester.pumpAndSettle();

      expect(calls, 2);
      expect(find.text('value 2'), findsOneWidget);
    });

    testWidgets('reports the failure through onError once', (tester) async {
      var reports = 0;
      await tester.pumpWidget(
        host(
          AsyncBuilderWidgetx<String>(future: () async => throw StateError('bad'), onError: (_, _) => reports++, builder: (_, data) => Text(data)),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump();

      expect(reports, 1);
    });

    testWidgets('the stream constructor renders each value', (tester) async {
      final controller = StreamController<int>();
      addTearDown(controller.close);

      await tester.pumpWidget(host(AsyncBuilderWidgetx<int>.stream(stream: controller.stream, builder: (_, v) => Text('$v'))));

      controller.add(1);
      await tester.pumpAndSettle();
      expect(find.text('1'), findsOneWidget);

      controller.add(2);
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('a custom isEmpty overrides the default', (tester) async {
      await tester.pumpWidget(
        host(
          AsyncBuilderWidgetx<String>(
            future: () async => 'placeholder',
            isEmpty: (value) => value == 'placeholder',
            builder: (_, data) => Text(data),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(defaultAsyncEmptyTitleGlobal), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────
  // SheetX
  // ──────────────────────────────────────────────
  group('SheetX', () {
    testWidgets('showSheet returns the value it was popped with', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await context.showSheet<String>(
                    title: 'Pick',
                    child: Builder(
                      builder: (inner) => TextButton(onPressed: () => Navigator.of(inner).pop('picked'), child: const Text('Choose')),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Pick'), findsOneWidget);

      await tester.tap(find.text('Choose'));
      await tester.pumpAndSettle();
      expect(result, 'picked');
    });

    testWidgets('showActionSheet returns the tapped action value', (tester) async {
      String? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await context.showActionSheet<String>(
                    title: 'Manage',
                    actions: const [
                      SheetActionX(label: 'Edit', icon: Icons.edit, value: 'edit'),
                      SheetActionX(label: 'Delete', icon: Icons.delete, value: 'delete', isDestructive: true),
                    ],
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(result, 'delete');
    });

    testWidgets('the cancel row dismisses with a null result', (tester) async {
      String? result = 'untouched';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await context.showActionSheet<String>(
                    actions: const [SheetActionX(label: 'Edit', value: 'edit')],
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(defaultSheetCancelTextGlobal));
      await tester.pumpAndSettle();

      expect(result, isNull);
    });

    testWidgets('a disabled action cannot be tapped', (tester) async {
      String? result = 'untouched';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await context.showActionSheet<String>(
                    actions: const [SheetActionX(label: 'Locked', value: 'locked', isEnabled: false)],
                  );
                },
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Locked'), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(result, 'untouched', reason: 'the sheet must still be open');
    });
  });

  // ──────────────────────────────────────────────
  // QuantityStepperWidgetx
  // ──────────────────────────────────────────────
  group('QuantityStepperWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('increments and decrements through onChanged', (tester) async {
      var value = 2;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => QuantityStepperWidgetx(value: value, max: 5, onChanged: (v) => setState(() => value = v)),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(value, 3);

      await tester.tap(find.byIcon(Icons.remove_rounded));
      await tester.pump();
      expect(value, 2);
    });

    testWidgets('clamps at max', (tester) async {
      var value = 3;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => QuantityStepperWidgetx(value: value, max: 3, onChanged: (v) => setState(() => value = v)),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_rounded), warnIfMissed: false);
      await tester.pump();
      expect(value, 3);
    });

    testWidgets('onRemove fires instead of decrementing at min', (tester) async {
      var removed = false;
      await tester.pumpWidget(host(QuantityStepperWidgetx(value: 1, min: 1, onChanged: (_) {}, onRemove: () => removed = true)));

      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pump();
      expect(removed, isTrue);
    });

    testWidgets('without onRemove the minus button is inert at min', (tester) async {
      var changes = 0;
      await tester.pumpWidget(host(QuantityStepperWidgetx(value: 1, min: 1, onChanged: (_) => changes++)));

      await tester.tap(find.byIcon(Icons.remove_rounded), warnIfMissed: false);
      await tester.pump();
      expect(changes, 0);
    });

    testWidgets('respects a step greater than one', (tester) async {
      var value = 0;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) =>
                QuantityStepperWidgetx(value: value, min: 0, max: 10, step: 5, onChanged: (v) => setState(() => value = v)),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pump();
      expect(value, 5);
    });
  });

  // ──────────────────────────────────────────────
  // BadgeWidgetx
  // ──────────────────────────────────────────────
  group('BadgeWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('hides at zero and shows a positive count', (tester) async {
      await tester.pumpWidget(host(const BadgeWidgetx(count: 0, child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsNothing);

      await tester.pumpWidget(host(const BadgeWidgetx(count: 4, child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('showZero renders the zero badge', (tester) async {
      await tester.pumpWidget(host(const BadgeWidgetx(count: 0, showZero: true, child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('caps the count at maxCount', (tester) async {
      await tester.pumpWidget(host(const BadgeWidgetx(count: 250, maxCount: 99, child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('99+'), findsOneWidget);
    });

    testWidgets('renders a custom label', (tester) async {
      await tester.pumpWidget(host(const BadgeWidgetx(label: 'NEW', child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('NEW'), findsOneWidget);
    });

    testWidgets('isVisible false hides the badge entirely', (tester) async {
      await tester.pumpWidget(host(const BadgeWidgetx(count: 9, isVisible: false, child: Icon(Icons.mail))));
      await tester.pumpAndSettle();
      expect(find.text('9'), findsNothing);
    });
  });

  // ──────────────────────────────────────────────
  // AlertBannerWidgetx
  // ──────────────────────────────────────────────
  group('AlertBannerWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('renders the title and message', (tester) async {
      await tester.pumpWidget(host(const AlertBannerWidgetx.error(title: 'Payment failed', message: 'Card declined.')));
      expect(find.text('Payment failed'), findsOneWidget);
      expect(find.text('Card declined.'), findsOneWidget);
    });

    testWidgets('the close button fires onClose', (tester) async {
      var closed = false;
      await tester.pumpWidget(host(AlertBannerWidgetx.info(message: 'Heads up.', onClose: () => closed = true)));

      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pump();
      expect(closed, isTrue);
    });

    testWidgets('the action button fires onAction', (tester) async {
      var extended = false;
      await tester.pumpWidget(host(AlertBannerWidgetx.warning(message: 'Expiring soon.', actionText: 'Extend', onAction: () => extended = true)));

      await tester.tap(find.text('Extend'));
      await tester.pump();
      expect(extended, isTrue);
    });

    testWidgets('each named constructor picks its own type', (tester) async {
      await tester.pumpWidget(host(const AlertBannerWidgetx.success(message: 'Done.')));
      expect(tester.widget<AlertBannerWidgetx>(find.byType(AlertBannerWidgetx)).type, AlertTypeX.success);
      expect(find.byIcon(Icons.check_circle_outline_rounded), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────
  // TimelineWidgetx
  // ──────────────────────────────────────────────
  group('TimelineWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('renders every entry with its subtitle and timestamp', (tester) async {
      await tester.pumpWidget(
        host(
          const TimelineWidgetx(
            items: [
              TimelineItemX(title: 'Order placed', timestamp: '09:02', state: TimelineItemStateX.completed),
              TimelineItemX(title: 'Packed', subtitle: 'Warehouse 3', state: TimelineItemStateX.active),
              TimelineItemX(title: 'Delivered'),
            ],
          ),
        ),
      );

      expect(find.text('Order placed'), findsOneWidget);
      expect(find.text('09:02'), findsOneWidget);
      expect(find.text('Warehouse 3'), findsOneWidget);
      expect(find.text('Delivered'), findsOneWidget);
    });

    testWidgets('a completed entry shows a check in its node', (tester) async {
      await tester.pumpWidget(
        host(
          const TimelineWidgetx(
            items: [TimelineItemX(title: 'Done', state: TimelineItemStateX.completed)],
          ),
        ),
      );
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('taps reach the entry callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        host(
          TimelineWidgetx(
            items: [TimelineItemX(title: 'Tap me', onTap: () => tapped = true)],
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('renders extra content attached to an entry', (tester) async {
      await tester.pumpWidget(
        host(
          const TimelineWidgetx(
            items: [TimelineItemX(title: 'With content', content: Text('EXTRA'))],
          ),
        ),
      );
      expect(find.text('EXTRA'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────
  // ChipsFilterWidgetx
  // ──────────────────────────────────────────────
  group('ChipsFilterWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('multiple mode adds and removes from the selection', (tester) async {
      var selected = <String>['a'];
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) =>
                ChipsFilterWidgetx<String>(items: const ['a', 'b'], selected: selected, onChanged: (v) => setState(() => selected = v)),
          ),
        ),
      );

      await tester.tap(find.text('b'));
      await tester.pump();
      expect(selected, ['a', 'b']);

      await tester.tap(find.text('a'));
      await tester.pump();
      expect(selected, ['b']);
    });

    testWidgets('single mode replaces the selection', (tester) async {
      var selected = <String>['a'];
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => ChipsFilterWidgetx<String>(
              items: const ['a', 'b'],
              selected: selected,
              mode: ChipsSelectionModeX.single,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('b'));
      await tester.pump();
      expect(selected, ['b']);
    });

    testWidgets('single mode clears on re-tap when allowEmpty', (tester) async {
      var selected = <String>['a'];
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => ChipsFilterWidgetx<String>(
              items: const ['a', 'b'],
              selected: selected,
              mode: ChipsSelectionModeX.single,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('a'));
      await tester.pump();
      expect(selected, isEmpty);
    });

    testWidgets('allowEmpty false keeps the selection on re-tap', (tester) async {
      var selected = <String>['a'];
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) => ChipsFilterWidgetx<String>(
              items: const ['a', 'b'],
              selected: selected,
              mode: ChipsSelectionModeX.single,
              allowEmpty: false,
              onChanged: (v) => setState(() => selected = v),
            ),
          ),
        ),
      );

      await tester.tap(find.text('a'));
      await tester.pump();
      expect(selected, ['a']);
    });

    testWidgets('does not mutate the incoming selection list', (tester) async {
      final original = <String>['a'];
      await tester.pumpWidget(host(ChipsFilterWidgetx<String>(items: const ['a', 'b'], selected: original, onChanged: (_) {})));

      await tester.tap(find.text('b'));
      await tester.pump();
      expect(original, ['a'], reason: 'the caller list must be left alone');
    });

    testWidgets('uses labelBuilder and countBuilder', (tester) async {
      await tester.pumpWidget(
        host(
          ChipsFilterWidgetx<int>(
            items: const [1, 2],
            selected: const [],
            labelBuilder: (i) => 'Item $i',
            countBuilder: (i) => i * 10,
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('enabled false blocks taps', (tester) async {
      var changes = 0;
      await tester.pumpWidget(host(ChipsFilterWidgetx<String>(items: const ['a'], selected: const [], enabled: false, onChanged: (_) => changes++)));

      await tester.tap(find.text('a'), warnIfMissed: false);
      await tester.pump();
      expect(changes, 0);
    });
  });

  // ──────────────────────────────────────────────
  // SegmentedControlWidgetx
  // ──────────────────────────────────────────────
  group('SegmentedControlWidgetx', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

    testWidgets('renders every segment and reports the tapped one', (tester) async {
      String? picked;
      await tester.pumpWidget(
        host(SegmentedControlWidgetx<String>(items: const ['All', 'Active', 'Archived'], value: 'All', onChanged: (v) => picked = v)),
      );

      expect(find.text('Active'), findsOneWidget);
      await tester.tap(find.text('Archived'));
      await tester.pump();
      expect(picked, 'Archived');
    });

    testWidgets('tapping the selected segment does not fire onChanged', (tester) async {
      var calls = 0;
      await tester.pumpWidget(host(SegmentedControlWidgetx<String>(items: const ['A', 'B'], value: 'A', onChanged: (_) => calls++)));

      await tester.tap(find.text('A'));
      await tester.pump();
      expect(calls, 0);
    });

    testWidgets('an unknown value simply highlights nothing', (tester) async {
      await tester.pumpWidget(host(SegmentedControlWidgetx<String>(items: const ['A', 'B'], value: 'Z', onChanged: (_) {})));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('enabled false blocks taps', (tester) async {
      var calls = 0;
      await tester.pumpWidget(host(SegmentedControlWidgetx<String>(items: const ['A', 'B'], value: 'A', enabled: false, onChanged: (_) => calls++)));

      await tester.tap(find.text('B'), warnIfMissed: false);
      await tester.pump();
      expect(calls, 0);
    });
  });

  // ──────────────────────────────────────────────
  // NetworkImageWidgetx
  // ──────────────────────────────────────────────
  group('NetworkImageWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('a null url renders the error state, not an Image', (tester) async {
      await tester.pumpWidget(host(const NetworkImageWidgetx(url: null, width: 60, height: 60)));
      expect(find.byType(Image), findsNothing);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('a blank url renders the error state', (tester) async {
      await tester.pumpWidget(host(const NetworkImageWidgetx(url: '   ', width: 60, height: 60)));
      expect(find.byIcon(Icons.image_not_supported_outlined), findsOneWidget);
    });

    testWidgets('a custom errorWidget replaces the default icon', (tester) async {
      await tester.pumpWidget(host(const NetworkImageWidgetx(url: null, width: 60, height: 60, errorWidget: Text('AB'))));
      expect(find.text('AB'), findsOneWidget);
      expect(find.byIcon(Icons.image_not_supported_outlined), findsNothing);
    });

    testWidgets('the circle constructor clips to an oval', (tester) async {
      await tester.pumpWidget(host(const NetworkImageWidgetx.circle(url: null, size: 48)));
      expect(find.byType(ClipOval), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────
  // ScrollToTopWidgetx
  // ──────────────────────────────────────────────
  group('ScrollToTopWidgetx', () {
    testWidgets('stays hidden until the threshold is passed, then scrolls back', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollToTopWidgetx(
              controller: controller,
              threshold: 200,
              child: ListView.builder(
                controller: controller,
                itemCount: 100,
                itemBuilder: (_, i) => SizedBox(height: 50, child: Text('row $i')),
              ),
            ),
          ),
        ),
      );

      expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity, 0);

      controller.jumpTo(600);
      await tester.pumpAndSettle();
      expect(tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).opacity, 1);

      await tester.tap(find.byIcon(Icons.arrow_upward_rounded));
      await tester.pumpAndSettle();
      expect(controller.offset, 0);
    });

    testWidgets('does not throw when disposed while the controller lives on', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ScrollToTopWidgetx(
              controller: controller,
              child: ListView(controller: controller, children: const [SizedBox(height: 2000)]),
            ),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      expect(tester.takeException(), isNull);
    });
  });

  // ──────────────────────────────────────────────
  // AnimatedCounterWidgetx
  // ──────────────────────────────────────────────
  group('AnimatedCounterWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('animates up to the final value', (tester) async {
      await tester.pumpWidget(host(const AnimatedCounterWidgetx(value: 120)));
      await tester.pumpAndSettle();
      expect(find.text('120'), findsOneWidget);
    });

    test('formats with a thousands separator', () {
      const counter = AnimatedCounterWidgetx(value: 0, useThousandsSeparator: true);
      expect(counter.format(1234567), '1,234,567');
      expect(counter.format(999), '999');
      expect(counter.format(1000), '1,000');
    });

    test('keeps the sign and the fraction when grouping', () {
      const counter = AnimatedCounterWidgetx(value: 0, useThousandsSeparator: true, decimals: 2);
      expect(counter.format(-12345.5), '-12,345.50');
    });

    test('applies prefix, suffix, and decimals', () {
      const counter = AnimatedCounterWidgetx(value: 0, prefix: 'Rs. ', suffix: '/-', decimals: 2);
      expect(counter.format(45.5), 'Rs. 45.50/-');
    });

    test('a custom formatter wins over every other option', () {
      final counter = AnimatedCounterWidgetx(value: 0, prefix: 'ignored', formatter: (v) => 'V=${v.round()}');
      expect(counter.format(7.2), 'V=7');
    });
  });

  // ──────────────────────────────────────────────
  // CircularProgressWidgetx
  // ──────────────────────────────────────────────
  group('CircularProgressWidgetx', () {
    Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

    testWidgets('renders the percentage label', (tester) async {
      await tester.pumpWidget(host(const CircularProgressWidgetx(value: 0.42)));
      await tester.pumpAndSettle();
      expect(find.text('42%'), findsOneWidget);
    });

    testWidgets('clamps a value above one', (tester) async {
      await tester.pumpWidget(host(const CircularProgressWidgetx(value: 5)));
      await tester.pumpAndSettle();
      expect(find.text('100%'), findsOneWidget);
    });

    testWidgets('a null value falls back to an indeterminate spinner', (tester) async {
      await tester.pumpWidget(host(const CircularProgressWidgetx(value: null)));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('a custom center replaces the percentage', (tester) async {
      await tester.pumpWidget(host(const CircularProgressWidgetx(value: 0.5, center: Text('7 MB'))));
      await tester.pumpAndSettle();
      expect(find.text('7 MB'), findsOneWidget);
      expect(find.text('50%'), findsNothing);
    });

    testWidgets('renders the caption under the percentage', (tester) async {
      await tester.pumpWidget(host(const CircularProgressWidgetx(value: 0.3, caption: 'of goal')));
      await tester.pumpAndSettle();
      expect(find.text('of goal'), findsOneWidget);
    });
  });

  // ──────────────────────────────────────────────
  // ConnectivityBannerWidgetx
  // ──────────────────────────────────────────────
  group('ConnectivityBannerWidgetx', () {
    testWidgets('shows the offline banner and then the back-online confirmation', (tester) async {
      final status = StreamController<bool>.broadcast();
      addTearDown(status.close);

      await tester.pumpWidget(
        MaterialApp(
          home: ConnectivityBannerWidgetx(
            statusStream: status.stream,
            child: const Scaffold(body: Text('content')),
          ),
        ),
      );

      expect(find.text(defaultOfflineMessageGlobal), findsNothing, reason: 'nothing shows before the first reading');

      status.add(false);
      await tester.pumpAndSettle();
      expect(find.text(defaultOfflineMessageGlobal), findsOneWidget);

      status.add(true);
      await tester.pumpAndSettle();
      expect(find.text(defaultOnlineMessageGlobal), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();
      expect(find.text(defaultOnlineMessageGlobal), findsNothing);
    });

    testWidgets('reports every change through onStatusChanged', (tester) async {
      final status = StreamController<bool>.broadcast();
      addTearDown(status.close);
      final seen = <bool>[];

      await tester.pumpWidget(
        MaterialApp(
          home: ConnectivityBannerWidgetx(
            statusStream: status.stream,
            onStatusChanged: seen.add,
            child: const Scaffold(body: SizedBox()),
          ),
        ),
      );

      status.add(false);
      await tester.pumpAndSettle();
      status.add(true);
      await tester.pumpAndSettle();
      status.add(true);
      await tester.pumpAndSettle();

      expect(seen, [false, true], reason: 'a repeated status is not a change');
    });

    testWidgets('showOnlineBanner false suppresses the confirmation', (tester) async {
      final status = StreamController<bool>.broadcast();
      addTearDown(status.close);

      await tester.pumpWidget(
        MaterialApp(
          home: ConnectivityBannerWidgetx(
            statusStream: status.stream,
            showOnlineBanner: false,
            child: const Scaffold(body: SizedBox()),
          ),
        ),
      );

      status.add(false);
      await tester.pumpAndSettle();
      status.add(true);
      await tester.pumpAndSettle();

      expect(find.text(defaultOnlineMessageGlobal), findsNothing);
    });

    testWidgets('a status arriving after unmount does not throw', (tester) async {
      final status = StreamController<bool>.broadcast();
      addTearDown(status.close);

      await tester.pumpWidget(
        MaterialApp(
          home: ConnectivityBannerWidgetx(
            statusStream: status.stream,
            child: const Scaffold(body: SizedBox()),
          ),
        ),
      );
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      status.add(false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  // ──────────────────────────────────────────────
  // ImagePickerSheetWidgetx
  // ──────────────────────────────────────────────
  group('ImagePickerSheetWidgetx', () {
    testWidgets('pickSource returns the chosen source', (tester) async {
      ImagePickerSourceX? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  ElevatedButton(onPressed: () async => picked = await ImagePickerSheetWidgetx.pickSource(context), child: const Text('open')),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text(defaultImagePickerCameraTextGlobal), findsOneWidget);
      expect(find.text(defaultImagePickerGalleryTextGlobal), findsOneWidget);
      expect(find.text(defaultImagePickerRemoveTextGlobal), findsNothing);

      await tester.tap(find.text(defaultImagePickerGalleryTextGlobal));
      await tester.pumpAndSettle();
      expect(picked, ImagePickerSourceX.gallery);
    });

    testWidgets('showRemove adds the destructive remove row', (tester) async {
      ImagePickerSourceX? picked;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async => picked = await ImagePickerSheetWidgetx.pickSource(context, showRemove: true),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(defaultImagePickerRemoveTextGlobal));
      await tester.pumpAndSettle();

      expect(picked, ImagePickerSourceX.remove);
    });

    testWidgets('buildActions honours the visibility flags', (tester) async {
      const sheet = ImagePickerSheetWidgetx(showCamera: false, showGallery: true, showRemove: true);
      final actions = sheet.buildActions();

      expect(actions.length, 2);
      expect(actions.first.value, ImagePickerSourceX.gallery);
      expect(actions.last.isDestructive, isTrue);
    });

    testWidgets('a dismissed sheet yields null', (tester) async {
      ImagePickerSourceX? picked = ImagePickerSourceX.camera;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) =>
                  ElevatedButton(onPressed: () async => picked = await ImagePickerSheetWidgetx.pickSource(context), child: const Text('open')),
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(defaultSheetCancelTextGlobal));
      await tester.pumpAndSettle();

      expect(picked, isNull);
    });
  });

  // ──────────────────────────────────────────────
  // ListX — new members
  // ──────────────────────────────────────────────
  group('ListX additions', () {
    const users = [(id: 1, name: 'Ali'), (id: 2, name: 'Sara'), (id: 1, name: 'Ali again')];

    group('emptiness', () {
      test('isEmptyOrNull is true for null and for empty', () {
        List<int>? nothing;
        expect(nothing.isEmptyOrNull, isTrue);
        expect(<int>[].isEmptyOrNull, isTrue);
        expect([1].isEmptyOrNull, isFalse);
      });
      test('isNotEmptyOrNull is the inverse', () {
        List<int>? nothing;
        expect(nothing.isNotEmptyOrNull, isFalse);
        expect(<int>[].isNotEmptyOrNull, isFalse);
        expect([1].isNotEmptyOrNull, isTrue);
      });
      test('lengthOrZero returns 0 for null', () {
        List<int>? nothing;
        expect(nothing.lengthOrZero, 0);
        expect([1, 2].lengthOrZero, 2);
      });
    });

    group('firstOrNull / lastOrNull', () {
      test('returns null for a null receiver', () {
        List<int>? nothing;
        expect(nothing.firstOrNull, isNull);
        expect(nothing.lastOrNull, isNull);
      });
      test('returns null for an empty iterable', () {
        List<int>? empty = [];
        expect(empty.firstOrNull, isNull);
        expect(empty.lastOrNull, isNull);
      });
      test('returns the ends of a populated iterable', () {
        List<int>? items = [1, 2, 3];
        expect(items.firstOrNull, 1);
        expect(items.lastOrNull, 3);
      });
    });

    group('grouping and indexing', () {
      test('groupCountBy counts each group', () {
        expect([1, 2, 3, 4, 5].groupCountBy((n) => n.isEven), {false: 3, true: 2});
      });
      test('associateBy keys by the selector, last duplicate winning', () {
        final byId = users.associateBy((u) => u.id);
        expect(byId.keys, [1, 2]);
        expect(byId[1]!.name, 'Ali again');
      });
      test('associateWith derives both key and value', () {
        expect(users.take(2).associateWith((u) => u.id, (u) => u.name), {1: 'Ali', 2: 'Sara'});
      });
    });

    group('lookups', () {
      test('lastWhereOrNull finds the last match', () {
        expect([1, 2, 3, 4].lastWhereOrNull((n) => n.isEven), 4);
        expect([1, 3].lastWhereOrNull((n) => n.isEven), isNull);
      });
      test('singleWhereOrNull returns the only match', () {
        expect([1, 2, 3].singleWhereOrNull((n) => n == 2), 2);
      });
      test('singleWhereOrNull returns null for none or many, never throwing', () {
        expect([1, 3].singleWhereOrNull((n) => n.isEven), isNull);
        expect([2, 4].singleWhereOrNull((n) => n.isEven), isNull);
      });
      test('indexWhereOrNull returns null instead of -1', () {
        expect([1, 2, 3].indexWhereOrNull((n) => n == 3), 2);
        expect([1, 2, 3].indexWhereOrNull((n) => n == 9), isNull);
      });
    });

    group('distinctBy', () {
      test('keeps the first element per key', () {
        final result = users.distinctBy((u) => u.id);
        expect(result.length, 2);
        expect(result.first.name, 'Ali');
      });
      test('returns empty for null', () {
        List<int>? nothing;
        expect(nothing.distinctBy((n) => n), isEmpty);
      });
    });

    group('sorting', () {
      test('sortedByDescending reverses the order', () {
        expect([2, 1, 3].sortedByDescending((n) => n), [3, 2, 1]);
      });
      test('sortedWith uses an explicit comparator', () {
        expect(['bbb', 'a', 'cc'].sortedWith((a, b) => a.length.compareTo(b.length)), ['a', 'cc', 'bbb']);
      });
      test('sortedByMany falls through to the next selector on a tie', () {
        const people = [(last: 'Khan', first: 'Zara'), (last: 'Ali', first: 'Bilal'), (last: 'Khan', first: 'Ahmed')];
        final sorted = people.sortedByMany([(p) => p.last, (p) => p.first]);
        expect(sorted.map((p) => p.first).toList(), ['Bilal', 'Ahmed', 'Zara']);
      });
      test('sorting does not mutate the source list', () {
        final source = [3, 1, 2];
        source.sortedBy((n) => n);
        source.sortedByDescending((n) => n);
        expect(source, [3, 1, 2]);
      });
      test('isSortedBy detects ascending order', () {
        expect([1, 2, 3].isSortedBy((n) => n), isTrue);
        expect([1, 3, 2].isSortedBy((n) => n), isFalse);
        expect(<int>[].isSortedBy((n) => n), isTrue);
      });
    });

    group('mapping', () {
      test('mapNotNull drops null results', () {
        expect(['1', 'x', '3'].mapNotNull(int.tryParse), [1, 3]);
      });
      test('whereNotNullBy keeps elements with a non-null field', () {
        const rows = [(id: 1, email: 'a@b.com'), (id: 2, email: null), (id: 3, email: 'c@d.com')];
        expect(rows.whereNotNullBy((r) => r.email).map((r) => r.id).toList(), [1, 3]);
      });
    });

    group('set operations', () {
      test('containsAny and containsAll', () {
        expect([1, 2, 3].containsAny([9, 2]), isTrue);
        expect([1, 2, 3].containsAny([9]), isFalse);
        expect([1, 2, 3].containsAll([1, 3]), isTrue);
        expect([1, 2, 3].containsAll([1, 9]), isFalse);
      });
      test('except removes the elements of other, preserving order', () {
        expect([1, 2, 3, 4].except([2, 4]), [1, 3]);
      });
      test('intersect keeps shared elements without duplicates', () {
        expect([1, 2, 2, 3].intersect([2, 3, 9]), [2, 3]);
      });
    });

    group('pageAt', () {
      final items = List.generate(25, (i) => i);
      test('pages are 1-based to match PaginatorX.firstPage', () {
        expect(items.pageAt(1, size: 10).first, 0);
        expect(items.pageAt(2, size: 10).first, 10);
      });
      test('the last page returns the remainder', () {
        expect(items.pageAt(3, size: 10), [20, 21, 22, 23, 24]);
      });
      test('an out-of-range page is empty, not an error', () {
        expect(items.pageAt(99, size: 10), isEmpty);
        expect(items.pageAt(0, size: 10), isEmpty);
      });
      test('a non-positive size yields nothing', () {
        expect(items.pageAt(1, size: 0), isEmpty);
      });
    });

    group('randomness', () {
      test('shuffled leaves the source untouched and keeps every element', () {
        final source = [1, 2, 3, 4, 5];
        final result = source.shuffled(Random(7));
        expect(source, [1, 2, 3, 4, 5]);
        expect(result..sort(), [1, 2, 3, 4, 5]);
      });
      test('a seeded shuffle is reproducible', () {
        expect([1, 2, 3, 4, 5].shuffled(Random(3)), [1, 2, 3, 4, 5].shuffled(Random(3)));
      });
      test('randomOrNull returns null when empty, an element otherwise', () {
        expect(<int>[].randomOrNull(), isNull);
        expect([1, 2, 3].randomOrNull(Random(1)), isIn([1, 2, 3]));
      });
    });

    test('joinToString formats with separator, prefix and suffix', () {
      expect(users.take(2).joinToString((u) => u.name, separator: ' & ', prefix: '[', suffix: ']'), '[Ali & Sara]');
    });
  });

  // ──────────────────────────────────────────────
  // IterableNullableX
  // ──────────────────────────────────────────────
  group('IterableNullableX', () {
    test('whereNotNull strips nulls', () {
      expect([1, null, 3].whereNotNull(), [1, 3]);
    });
    test('whereNotNull on a null receiver is empty', () {
      List<int?>? nothing;
      expect(nothing.whereNotNull(), isEmpty);
    });
    test('firstNotNull finds the first present value', () {
      expect([null, null, 7].firstNotNull, 7);
      expect(<int?>[null].firstNotNull, isNull);
    });
  });

  // ──────────────────────────────────────────────
  // IterableAsyncX
  // ──────────────────────────────────────────────
  group('IterableAsyncX', () {
    test('mapAsync preserves order and runs one at a time', () async {
      final running = <int>[];
      var maxConcurrent = 0;
      final result = await [1, 2, 3].mapAsync((e) async {
        running.add(e);
        if (running.length > maxConcurrent) maxConcurrent = running.length;
        await Future<void>.delayed(Duration.zero);
        running.remove(e);
        return e * 2;
      });
      expect(result, [2, 4, 6]);
      expect(maxConcurrent, 1);
    });

    test('mapParallel preserves the original order', () async {
      final result = await [1, 2, 3, 4].mapParallel((e) async {
        await Future<void>.delayed(Duration(milliseconds: 5 - e));
        return e * 10;
      });
      expect(result, [10, 20, 30, 40]);
    });

    test('mapParallel honours the concurrency cap', () async {
      var active = 0;
      var maxActive = 0;
      final result = await List.generate(8, (i) => i).mapParallel((e) async {
        active++;
        if (active > maxActive) maxActive = active;
        await Future<void>.delayed(Duration.zero);
        active--;
        return e;
      }, concurrency: 3);

      expect(result, [0, 1, 2, 3, 4, 5, 6, 7]);
      expect(maxActive, lessThanOrEqualTo(3));
    });

    test('mapParallel on an empty or null iterable does no work', () async {
      List<int>? nothing;
      expect(await nothing.mapParallel((e) async => e), isEmpty);
      expect(await <int>[].mapParallel((e) async => e), isEmpty);
    });

    test('forEachAsync visits every element in order', () async {
      final seen = <int>[];
      await [1, 2, 3].forEachAsync((e) async => seen.add(e));
      expect(seen, [1, 2, 3]);
    });

    test('firstWhereAsync short-circuits at the first match', () async {
      var tested = 0;
      final found = await [1, 2, 3, 4].firstWhereAsync((e) async {
        tested++;
        return e.isEven;
      });
      expect(found, 2);
      expect(tested, 2, reason: 'elements after the match must not be tested');
    });

    test('firstWhereAsync returns null when nothing matches', () async {
      expect(await [1, 3].firstWhereAsync((e) async => e.isEven), isNull);
    });
  });

  // ──────────────────────────────────────────────
  // ListAccessX
  // ──────────────────────────────────────────────
  group('ListAccessX', () {
    test('getOrNull returns null out of range', () {
      expect(['a', 'b'].getOrNull(0), 'a');
      expect(['a', 'b'].getOrNull(5), isNull);
      expect(['a', 'b'].getOrNull(-1), isNull);
    });
    test('getOrElse falls back', () {
      expect(['a'].getOrElse(9, 'z'), 'z');
      expect(['a'].getOrElse(0, 'z'), 'a');
    });
    test('safeSublist clamps both bounds instead of throwing', () {
      expect([1, 2, 3].safeSublist(1, 99), [2, 3]);
      expect([1, 2, 3].safeSublist(-5), [1, 2, 3]);
      expect([1, 2, 3].safeSublist(9), isEmpty);
      expect(<int>[].safeSublist(0, 3), isEmpty);
    });
  });

  // ──────────────────────────────────────────────
  // ListMutationX
  // ──────────────────────────────────────────────
  group('ListMutationX', () {
    test('toggle adds when absent and removes when present', () {
      final selected = <String>['a'];
      selected.toggle('b');
      expect(selected, ['a', 'b']);
      selected.toggle('a');
      expect(selected, ['b']);
    });

    test('moveItem reorders and reports success', () {
      final items = [1, 2, 3, 4];
      expect(items.moveItem(0, 2), isTrue);
      expect(items, [2, 3, 1, 4]);
    });

    test('moveItem rejects out-of-range and no-op indices', () {
      final items = [1, 2, 3];
      expect(items.moveItem(0, 9), isFalse);
      expect(items.moveItem(-1, 1), isFalse);
      expect(items.moveItem(1, 1), isFalse);
      expect(items, [1, 2, 3]);
    });

    test('addIf and addAllIf respect the condition', () {
      final items = <int>[];
      items.addIf(false, 1);
      items.addIf(true, 2);
      items.addAllIf(false, [3, 4]);
      items.addAllIf(true, [5, 6]);
      expect(items, [2, 5, 6]);
    });

    test('removeWhereCounted reports how many went', () {
      final items = [1, 2, 3, 4];
      expect(items.removeWhereCounted((n) => n.isEven), 2);
      expect(items, [1, 3]);
    });
  });

  // ──────────────────────────────────────────────
  // ListTransformX
  // ──────────────────────────────────────────────
  group('ListTransformX', () {
    test('replaceWhere swaps matches without touching the source', () {
      final source = [1, 2, 3];
      expect(source.replaceWhere((n) => n == 2, 9), [1, 9, 3]);
      expect(source, [1, 2, 3]);
    });

    test('upsert replaces an existing entry by key', () {
      const orders = [(id: 1, total: 100), (id: 2, total: 200)];
      final result = orders.upsert((id: 2, total: 999), by: (o) => o.id);
      expect(result.length, 2);
      expect(result[1].total, 999);
    });

    test('upsert appends when nothing matches', () {
      const orders = [(id: 1, total: 100)];
      final result = orders.upsert((id: 5, total: 500), by: (o) => o.id);
      expect(result.length, 2);
      expect(result.last.id, 5);
      expect(orders.length, 1, reason: 'the source must be untouched');
    });

    test('rotate wraps in both directions', () {
      expect([1, 2, 3, 4].rotate(1), [2, 3, 4, 1]);
      expect([1, 2, 3, 4].rotate(-1), [4, 1, 2, 3]);
      expect([1, 2, 3, 4].rotate(0), [1, 2, 3, 4]);
      expect([1, 2, 3, 4].rotate(4), [1, 2, 3, 4]);
      expect([1, 2, 3, 4].rotate(5), [2, 3, 4, 1]);
      expect(<int>[].rotate(2), isEmpty);
    });

    test('diff reports what to add and what to remove', () {
      final result = [1, 2, 3].diff([2, 3, 4]);
      expect(result.added, [4]);
      expect(result.removed, [1]);
    });

    test('intersperse inserts between, never at the ends', () {
      expect(['a', 'b', 'c'].intersperse('-'), ['a', '-', 'b', '-', 'c']);
      expect(['a'].intersperse('-'), ['a']);
      expect(<String>[].intersperse('-'), isEmpty);
    });
  });

  // ──────────────────────────────────────────────
  // ListxWidgetExtensions — new members
  // ──────────────────────────────────────────────
  group('ListxWidgetExtensions additions', () {
    Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));
    List<Widget> children() => const [Text('a'), Text('b'), Text('c')];

    test('the layout builders return their concrete widget type', () {
      expect(children().toRow(), isA<Row>());
      expect(children().toColumn(), isA<Column>());
      expect(children().toStack(), isA<Stack>());
      expect(children().toListView(), isA<ListView>());
      expect(children().toWrap(), isA<Wrap>());
      expect(children().toGrid(), isA<GridView>());
      expect(children().toPageView(), isA<PageView>());
      expect(children().toIndexedStack(), isA<IndexedStack>());
      expect(children().toSliverList(), isA<SliverList>());
      expect(children().toSliverGrid(), isA<SliverGrid>());
    });

    test('separatedBy inserts between children only', () {
      final result = children().separatedBy(const Divider());
      expect(result.length, 5);
      expect(result[1], isA<Divider>());
      expect(result[3], isA<Divider>());
      expect(result.first, isA<Text>());
      expect(result.last, isA<Text>());
    });

    test('separatedBy leaves a short list alone', () {
      expect(<Widget>[].separatedBy(const Divider()), isEmpty);
      expect([const Text('only')].separatedBy(const Divider()).length, 1);
    });

    testWidgets('withSpacing inserts sized gaps of the right axis', (tester) async {
      await tester.pumpWidget(host(children().withSpacing(12).toColumn()));
      final boxes = tester.widgetList<SizedBox>(find.byType(SizedBox)).where((b) => b.height == 12);
      expect(boxes.length, 2);

      await tester.pumpWidget(host(children().withSpacing(10, axis: Axis.horizontal).toRow()));
      final wide = tester.widgetList<SizedBox>(find.byType(SizedBox)).where((b) => b.width == 10);
      expect(wide.length, 2);
    });

    testWidgets('withDividers puts a Divider between rows', (tester) async {
      await tester.pumpWidget(host(children().withDividers(indent: 16).toColumn()));
      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('expanded wraps every child', (tester) async {
      await tester.pumpWidget(host(children().expanded().toRow()));
      expect(find.byType(Expanded), findsNWidgets(3));
    });

    testWidgets('flexible wraps every child', (tester) async {
      await tester.pumpWidget(host(children().flexible().toColumn()));
      expect(find.byType(Flexible), findsNWidgets(3));
    });

    testWidgets('paddedAll and paddedSymmetric apply to each child', (tester) async {
      await tester.pumpWidget(host(children().paddedAll(8).toColumn()));
      final padded = tester.widgetList<Padding>(find.byType(Padding)).where((p) => p.padding == const EdgeInsets.all(8));
      expect(padded.length, 3);

      await tester.pumpWidget(host(children().paddedSymmetric(horizontal: 6).toColumn()));
      final symmetric = tester
          .widgetList<Padding>(find.byType(Padding))
          .where((p) => p.padding == const EdgeInsets.symmetric(horizontal: 6));
      expect(symmetric.length, 3);
    });

    testWidgets('toWrap renders every child', (tester) async {
      await tester.pumpWidget(host(children().toWrap(spacing: 4)));
      expect(find.byType(Wrap), findsOneWidget);
      expect(find.text('b'), findsOneWidget);
    });

    testWidgets('toGrid lays children into columns', (tester) async {
      await tester.pumpWidget(host(children().toGrid(crossAxisCount: 3)));
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('toIndexedStack shows only the selected child', (tester) async {
      await tester.pumpWidget(host(children().toIndexedStack(index: 1)));
      expect(find.text('b'), findsOneWidget);
      expect(find.text('a'), findsNothing);
    });

    testWidgets('toSliverList works inside a CustomScrollView', (tester) async {
      await tester.pumpWidget(host(CustomScrollView(slivers: [children().toSliverList()])));
      expect(find.text('a'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
    });

    testWidgets('toScrollableRow scrolls instead of overflowing', (tester) async {
      await tester.pumpWidget(
        host(List.generate(30, (i) => SizedBox(width: 100, child: Text('item $i'))).toScrollableRow()),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('toPageView pages through the children', (tester) async {
      final controller = PageController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(host(children().toPageView(controller: controller)));
      expect(find.text('a'), findsOneWidget);

      controller.jumpToPage(2);
      await tester.pumpAndSettle();
      expect(find.text('c'), findsOneWidget);
    });
  });
}
