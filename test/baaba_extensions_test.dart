import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:baaba_extensions/baaba_extensions.dart';

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
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: Row(children: [const Text('hi').expanded()])),
      ));
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
      await tester.pumpWidget(MaterialApp(
        home: const Text('hello').visible(false, defaultWidget: const Text('fallback')),
      ));
      expect(find.text('fallback'), findsOneWidget);
    });

    testWidgets('cornerRadiusWithClipRRect wraps in ClipRRect', (tester) async {
      await tester.pumpWidget(MaterialApp(home: const Text('hi').cornerRadiusWithClipRRect(8.0)));
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('cornerRadiusWithClipRRectOnly wraps in ClipRRect', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: const Text('hi').cornerRadiusWithClipRRectOnly(topLeft: 8, topRight: 8),
      ));
      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('onTap wraps in InkWell and fires callback', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Material(child: const Text('tap me').onTap(() => tapped = true)),
      ));
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
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          captured = ctx.theme;
          return const SizedBox.shrink();
        }),
      ));
      expect(captured, isA<ThemeData>());
    });

    testWidgets('textTheme returns TextTheme', (tester) async {
      late TextTheme captured;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          captured = ctx.textTheme;
          return const SizedBox.shrink();
        }),
      ));
      expect(captured, isA<TextTheme>());
    });

    testWidgets('colorScheme returns ColorScheme', (tester) async {
      late ColorScheme captured;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          captured = ctx.colorScheme;
          return const SizedBox.shrink();
        }),
      ));
      expect(captured, isA<ColorScheme>());
    });

    testWidgets('screenWidth and screenHeight are positive', (tester) async {
      late double w, h;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          w = ctx.screenWidth;
          h = ctx.screenHeight;
          return const SizedBox.shrink();
        }),
      ));
      expect(w, greaterThan(0));
      expect(h, greaterThan(0));
    });

    testWidgets('screenSize equals screenWidth x screenHeight', (tester) async {
      late Size size;
      late double w, h;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          size = ctx.screenSize;
          w = ctx.screenWidth;
          h = ctx.screenHeight;
          return const SizedBox.shrink();
        }),
      ));
      expect(size.width, w);
      expect(size.height, h);
    });

    testWidgets('isMobile true for screen width < 600', (tester) async {
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool mobile;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          mobile = ctx.isMobile;
          return const SizedBox.shrink();
        }),
      ));
      expect(mobile, true);
    });

    testWidgets('isTablet true for screen width between 600 and 1024', (tester) async {
      tester.view.physicalSize = const Size(800, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool tablet;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          tablet = ctx.isTablet;
          return const SizedBox.shrink();
        }),
      ));
      expect(tablet, true);
    });

    testWidgets('isDesktop true for screen width >= 1024', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      late bool desktop;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          desktop = ctx.isDesktop;
          return const SizedBox.shrink();
        }),
      ));
      expect(desktop, true);
    });

    testWidgets('isKeyboardVisible is false when keyboard is not shown', (tester) async {
      late bool visible;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          visible = ctx.isKeyboardVisible;
          return const SizedBox.shrink();
        }),
      ));
      expect(visible, false);
    });

    testWidgets('hideKeyboard does not throw', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (ctx) {
          ctx.hideKeyboard();
          return const SizedBox.shrink();
        }),
      ));
    });
  });
}
