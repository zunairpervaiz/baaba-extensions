import 'dart:convert';

import 'package:baaba_extensions/src/utils/default_configs.dart';
import 'package:baaba_extensions/src/utils/enums.dart';
import 'package:baaba_extensions/src/utils/grouped_digits_formatterx.dart';
import 'package:baaba_extensions/src/utils/patterns.dart';
import 'package:flutter/services.dart' as service;

final RegExp alphaRegExp = RegExp(Patterns.alpha);

// String Extensions
extension StringExtension on String? {
  bool hasMatch(String pattern, {bool caseSensitive = true}) {
    return RegExp(pattern, caseSensitive: caseSensitive).hasMatch(validate());
  }

  /// Check email validation
  bool validateEmail() => hasMatch(Patterns.email);

  /// Check email validation
  bool validateEmailEnhanced() => hasMatch(Patterns.emailEnhanced);

  /// Check phone validation
  bool validatePhone() => hasMatch(Patterns.pkMobileLocal);

  /// Check URL validation
  bool validateURL() => hasMatch(Patterns.url);

  /// Returns true if given String is null or isEmpty
  bool get isEmptyOrNull => this == null || (this != null && this!.isEmpty) || (this != null && this! == 'null');

  // Check null string, return given value if null
  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  /// Capitalize given String
  String capitalizeFirstLetter() => (validate().isNotEmpty) ? (this!.substring(0, 1).toUpperCase() + this!.substring(1).toLowerCase()) : validate();

  /// Image regex
  bool get isImage => hasMatch(Patterns.image, caseSensitive: false);

  /// Audio regex
  bool get isAudio => hasMatch(Patterns.audio, caseSensitive: false);

  /// Video regex
  bool get isVideo => hasMatch(Patterns.video, caseSensitive: false);

  /// Txt regex
  bool get isTxt => hasMatch(Patterns.txt, caseSensitive: false);

  /// Document regex
  bool get isDoc => hasMatch(Patterns.doc, caseSensitive: false);

  /// Excel regex
  bool get isExcel => hasMatch(Patterns.excel, caseSensitive: false);

  /// PPT regex
  bool get isPPT => hasMatch(Patterns.ppt, caseSensitive: false);

  /// Document regex
  bool get isApk => hasMatch(Patterns.apk, caseSensitive: false);

  /// PDF regex
  bool get isPdf => hasMatch(Patterns.pdf, caseSensitive: false);

  /// HTML regex
  bool get isHtml => hasMatch(Patterns.html, caseSensitive: false);

  /// Return true if given String is Digit
  bool isDigit() {
    if (validate().isEmpty) {
      return false;
    }
    if (validate().length > 1) {
      for (var r in this!.runes) {
        if (r ^ 0x30 > 9) {
          return false;
        }
      }
      return true;
    } else {
      return this!.runes.first ^ 0x30 <= 9;
    }
  }

  bool get isInt => validate().isDigit();

  /// Check weather String is alpha or not
  bool isAlpha() => alphaRegExp.hasMatch(validate());

  bool isJson() {
    try {
      json.decode(validate());
    } catch (e) {
      return false;
    }
    return true;
  }

  // Copy String to Clipboard
  Future<void> copyToClipboard() async {
    await service.Clipboard.setData(service.ClipboardData(text: validate()));
  }

  /// for ex. add comma in price
  String formatNumberWithComma({String seperator = ','}) {
    // Group only the integer part, so the digits after a decimal point stay as they are.
    final value = validate();
    final dot = value.indexOf('.');
    final integer = dot == -1 ? value : value.substring(0, dot);
    final rest = dot == -1 ? '' : value.substring(dot);
    return integer.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}$seperator') + rest;
  }

  /// It reverses the String
  String get reverse {
    return String.fromCharCodes(validate().runes.toList().reversed);
  }

  /// It return list of single character from String
  List<String> toListX() {
    return validate().trim().split('');
  }

  /// Splits from a [pattern] and returns remaining String after that
  String splitAfter(Pattern pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
    var matchIterator = pattern.allMatches(validate()).iterator;

    if (matchIterator.moveNext()) {
      var match = matchIterator.current;
      var length = match.end - match.start;
      return validate().substring(match.start + length);
    }
    return '';
  }

  /// Splits from a [pattern] and returns String before that
  String splitBefore(Pattern pattern) {
    ArgumentError.checkNotNull(pattern, 'pattern');
    var matchIterator = pattern.allMatches(validate()).iterator;

    Match? match;
    while (matchIterator.moveNext()) {
      match = matchIterator.current;
    }

    if (match != null) {
      return validate().substring(0, match.start);
    }
    return '';
  }

  /// It matches the String and returns between [startPattern] and [endPattern]
  String splitBetween(Pattern startPattern, Pattern endPattern) {
    final after = splitAfter(startPattern);
    final end = endPattern.allMatches(after).firstOrNull;
    return end == null ? '' : after.substring(0, end.start);
  }

  /// Return int value of given string
  int toIntX({int defaultValue = 0}) {
    return int.tryParse(validate(), radix: 10) ?? defaultValue;
  }

  /// Return double value of given string
  double toDoubleX({double defaultValue = 0.0}) {
    if (this == null) return defaultValue;

    try {
      return double.parse(this!);
    } catch (e) {
      return defaultValue;
    }
  }

  /// Removes white space from given String
  String removeAllWhiteSpace() => validate().replaceAll(RegExp(r'\s+'), '');

  /// Returns only numbers from a string trim Whitespaces
  String getNumericOnly({bool aFirstWordOnly = false}) {
    String numericOnlyString = '';

    for (var i = 0; i < validate().length; i++) {
      if ((this![i].isDigit())) {
        numericOnlyString += this![i];
      }
      if (aFirstWordOnly && numericOnlyString.isNotEmpty && this![i] == " ") {
        break;
      }
    }

    return numericOnlyString;
  }

  /// Returns the given string n times
  String repeat(int n, {String separator = ''}) {
    if (n < 0) throw ArgumentError.value(n, 'n', 'must not be negative');

    var repeatedString = '';

    for (var i = 0; i < n; i++) {
      if (i > 0) {
        repeatedString += separator;
      }
      repeatedString += validate();
    }

    return repeatedString;
  }

  /// Returns the average reading time of this String in minutes.
  double calculateReadTime({int wordsPerMinute = 200}) {
    var words = countWords();
    var number = words / wordsPerMinute;
    return number;
  }

  /// Return number of words ina given String
  int countWords() {
    final text = validate().trim();
    return text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
  }

  /// Generate slug of a given String
  String toSlug({String delimiter = '_'}) {
    String text = validate().trim().toLowerCase();
    return text.replaceAll(' ', delimiter);
  }

  /// returns searchable array for Firebase Database
  List<String> setSearchParam() {
    String word = validate();

    List<String> caseSearchList = [];
    String temp = '';

    for (int i = 0; i < word.length; i++) {
      temp = temp + word[i];
      caseSearchList.add(temp.toLowerCase());
    }

    return caseSearchList;
  }

  /// Returns true if given value is '1', else returns false
  bool getBoolIntX() {
    if (this == "1") {
      return true;
    }
    return false;
  }

  ///  eg. Text("Dr. ${VARIABLE_NAME}"); =>  Text("VARIABLE_NAME.prefixText("Dr.")");
  String prefixText({required String value}) {
    return '$value${validate()}';
  }

  ///  eg. Text("${VARIABLE_NAME} /-"); =>  Text("VARIABLE_NAME.suffixText("/-")");
  String suffixText({required String value}) {
    return '${validate()}$value';
  }

  /// This function returns given string with each word capital
  String capitalizeEachWord() {
    if (validate().isEmpty) {
      return '';
    }

    final capitalizedWords = this!.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      final firstLetter = word[0].toUpperCase();
      final remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    });

    return capitalizedWords.join(' ');
  }

  /// Capitalize all words in a string
  String capitalizeAllWords() {
    if (validate().isEmpty) {
      return '';
    }
    return this!.split(' ').map((word) => word.capitalizeFirstLetter()).join(' ');
  }

  /// Returns true if the validate() method returns 'true', otherwise returns false.
  bool toBool() => validate() == 'true';

  /// helper function to mask email and phone strings.
  String mask({MaskType maskType = MaskType.auto, bool? isMaskingEnabled}) {
    String data = validate();
    final bool effectiveEnabled = isMaskingEnabled ?? isMaskingEnabledGlobal;

    // isMaskingEnabled ??= isMaskingEnabledGlobal;

    if (!effectiveEnabled) {
      return data; // Return original data if masking is disabled
    }

    if (maskType == MaskType.auto) {
      if (validateEmail()) return maskEmail(isMaskingEnabled: true);
      if (validatePhone()) return maskPhone(isMaskingEnabled: true);
    }

    if (maskType == MaskType.email) return maskEmail(isMaskingEnabled: true);
    if (maskType == MaskType.phone) return maskPhone(isMaskingEnabled: true);

    return data; // Return original data if something goes wrong
  }

  /// Mask email (e.g., user@example.com -> u***@example.com)
  String maskEmail({bool? isMaskingEnabled}) {
    String data = validate();

    isMaskingEnabled ??= isMaskingEnabledGlobal;

    if (!isMaskingEnabledGlobal && !isMaskingEnabled) {
      return data; // Return original data if masking is disabled
    }
    if (isMaskingEnabledGlobal && !isMaskingEnabled) {
      return data; // Return original data if masking is disabled
    }

    final parts = data.split('@');
    if (parts.length == 2 && parts[0].isNotEmpty) {
      final namePart = parts[0].substring(0, 1);
      final domainPart = parts[1];
      final maskedName = namePart + '*' * (parts[0].length - 1);
      return '$maskedName@$domainPart';
    }
    return data;
  }

  /// Mask phone (e.g., 1234567890 -> 12******90)
  String maskPhone({bool? isMaskingEnabled}) {
    String data = validate();

    isMaskingEnabled ??= isMaskingEnabledGlobal;

    if (!isMaskingEnabledGlobal && !isMaskingEnabled) {
      return data; // Return original data if masking is disabled
    }
    if (isMaskingEnabledGlobal && !isMaskingEnabled) {
      return data; // Return original data if masking is disabled
    }

    final length = data.length;
    if (length > 4) {
      final prefix = data.substring(0, 2);
      final suffix = data.substring(length - 2);
      final maskedMiddle = '*' * (length - 4);
      return '$prefix$maskedMiddle$suffix';
    }
    return data;
  }

  String? get formatPkMobile {
    if (this == null || this!.isEmpty) return this ?? '';

    final cleanNumber = this!.replaceAll(RegExp(r'\D'), '');

    if (cleanNumber.length == 11) {
      return '${cleanNumber.substring(0, 4)}-${cleanNumber.substring(4)}';
    }

    return this;
  }

  /// Returns this CNIC grouped as `00000-0000000-0`, or the string unchanged
  /// when it does not hold exactly 13 digits.
  ///
  /// Example: `'3520212345671'.formatCnic` → `'35202-1234567-1'`
  String get formatCnic {
    final digits = validate().replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(Patterns.cnicDigits).hasMatch(digits)) return validate();
    return const GroupedDigitsInputFormatterX.cnic().format(digits);
  }

  /// Returns true for a Pakistani CNIC, written either `00000-0000000-0` or as
  /// 13 bare digits.
  bool get isCnic {
    final value = validate();
    return RegExp(Patterns.cnic).hasMatch(value) || RegExp(Patterns.cnicDigits).hasMatch(value);
  }

  String? get toDisplayFormattedPhone {
    if (this == null || this!.isEmpty) return "N/A";

    return formatPkMobile ?? this;
  }

  /// Returns true if the validate() method returns 'true', otherwise returns false.
  bool get asBool => this == 'true';

  /// Returns true if this String is null, empty or consists of only whitespace characters.
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Returns [fallback] when this String is null, empty, or only whitespace,
  /// otherwise returns this String unchanged.
  ///
  /// Example: `user.middleName.ifBlank('—')`
  String ifBlank(String fallback) => isNullOrBlank ? fallback : validate();

  /// Compares this String to another String, ignoring case considerations.
  bool equalsIgnoreCase(String? other) =>
      (this == null && other == null) || (this != null && other != null && this!.toLowerCase() == other.toLowerCase());

  /// Converts this String to camel case.
  /// Example: "hello world" or "hello_world" or "hello-world" becomes "helloWorld".
  String toCamelCase() {
    if (isEmptyOrNull) return '';
    String value = validate();
    final words = _caseWords(value);
    if (words.isEmpty) return '';
    return words.first.toLowerCase() + words.skip(1).map(_capitalizeWord).join();
  }

  /// Truncates this String to a specified [maxLength] and appends an [ellipsis] string.
  /// Example: "This is a long string".ellipsize(10) returns "This is..."
  String ellipsize(int maxLength, {String ellipsis = "..."}) {
    if (isEmptyOrNull) return '';
    String value = validate();
    if (value.length <= maxLength) {
      return value;
    }
    if (maxLength <= ellipsis.length) return ellipsis.substring(0, maxLength.clamp(0, ellipsis.length));
    return value.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  /// Converts this String to PascalCase.
  /// Example: "hello world" or "hello_world" becomes "HelloWorld".
  String toPascalCase() {
    if (isEmptyOrNull) return '';
    String value = validate();
    return _caseWords(value).map(_capitalizeWord).join();
  }

  /// Converts this String to snake_case.
  /// Example: "helloWorld" or "Hello World" becomes "hello_world".
  String toSnakeCase() {
    if (isEmptyOrNull) return '';
    String value = validate();
    return _caseWords(value).map((word) => word.toLowerCase()).join('_');
  }

  /// Converts this String to kebab-case.
  /// Example: "helloWorld" or "Hello World" becomes "hello-world".
  String toKebabCase() {
    if (isEmptyOrNull) return '';
    String value = validate();
    return _caseWords(value).map((word) => word.toLowerCase()).join('-');
  }

  /// Extracts initials from a string.
  /// Example: "John Doe" returns "JD".
  String initials() {
    if (isEmptyOrNull) return '';
    String value = validate();
    return value.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).map((word) => word[0].toUpperCase()).join();
  }

  /// Returns true if this String is not null and contains at least one non-whitespace character.
  bool get isNotBlank => this != null && this!.trim().isNotEmpty;

  /// Removes all HTML tags from this string.
  ///
  /// Example: `'<b>Hello</b> <i>world</i>'.stripHtml()` → `'Hello world'`
  String stripHtml() => validate().replaceAll(RegExp(r'<[^>]*>'), '');

  /// Returns true when this string contains any of the given [needles].
  ///
  /// Example: `'hello'.containsAny(['hi', 'hello'])` → `true`
  bool containsAny(List<String> needles) => needles.any((needle) => validate().contains(needle));

  /// Returns true when this string contains all of the given [needles].
  ///
  /// Example: `'hello world'.containsAll(['hello', 'world'])` → `true`
  bool containsAll(List<String> needles) => needles.every((needle) => validate().contains(needle));

  /// Wraps the string at [lineLength] characters, breaking at word boundaries.
  ///
  /// Example: `'hello world foo'.wrapAt(7)` → `'hello\nworld\nfoo'`
  String wrapAt(int lineLength) {
    if (validate().isEmpty) return '';
    final words = validate().split(' ');
    final buffer = StringBuffer();
    var currentLength = 0;
    for (final word in words) {
      if (currentLength + word.length > lineLength && currentLength > 0) {
        buffer.write('\n');
        currentLength = 0;
      } else if (currentLength > 0) {
        buffer.write(' ');
        currentLength++;
      }
      buffer.write(word);
      currentLength += word.length;
    }
    return buffer.toString();
  }
}

// Splits text into words for the case converters: at spaces, `_` and `-`,
// and at case changes, keeping acronyms together — `'userID'` → `user`, `ID`.
final RegExp _caseWordRegExp = RegExp(r'\p{Lu}+(?!\p{Ll})\p{N}*|\p{Lu}?[\p{Ll}\p{N}]+|\p{Lt}\p{Ll}*|[\p{Lo}\p{N}]+', unicode: true);

List<String> _caseWords(String value) => _caseWordRegExp.allMatches(value).map((m) => m[0]!).toList();

String _capitalizeWord(String word) => word[0].toUpperCase() + word.substring(1).toLowerCase();
