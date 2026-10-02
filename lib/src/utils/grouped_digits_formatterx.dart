import 'package:flutter/services.dart';

/// A [TextInputFormatter] that keeps only digits and groups them with a
/// separator as the user types — a CNIC, a mobile number, a card number.
///
/// ```dart
/// TextField(inputFormatters: const [GroupedDigitsInputFormatterX.cnic()]);       // 35202-1234567-1
/// TextField(inputFormatters: const [GroupedDigitsInputFormatterX.pkMobile()]);   // 0300-1234567
/// TextField(inputFormatters: const [GroupedDigitsInputFormatterX(groupLengths: [4, 4, 4, 4], separator: ' ')]);
/// ```
///
/// Input past the last group is dropped, a digit typed into an already full
/// field is rejected, pasted text is reformatted, and the caret stays next to
/// the digit it was beside — editing the middle of a number does not throw it
/// to the end. Backspacing over a separator deletes the digit before it.
class GroupedDigitsInputFormatterX extends TextInputFormatter {
  /// The number of digits in each group, in order.
  final List<int> groupLengths;

  /// Written between groups. Defaults to `-`.
  final String separator;

  const GroupedDigitsInputFormatterX({required this.groupLengths, this.separator = '-'})
    : assert(separator.length > 0, 'separator must not be empty');

  /// Pakistani CNIC — `00000-0000000-0`.
  const GroupedDigitsInputFormatterX.cnic() : groupLengths = const [5, 7, 1], separator = '-';

  /// Pakistani mobile number — `0300-1234567`.
  const GroupedDigitsInputFormatterX.pkMobile() : groupLengths = const [4, 7], separator = '-';

  /// Returns the total number of digits this formatter accepts.
  int get maxDigits => groupLengths.fold(0, (sum, length) => sum + length);

  /// Returns [input] with everything but digits removed, cut to [maxDigits],
  /// and grouped.
  ///
  /// Example: `GroupedDigitsInputFormatterX.cnic().format('3520212345671')` → `'35202-1234567-1'`
  String format(String input) => _group(_digitsOf(input));

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final caret = newValue.selection.isValid ? newValue.selection.extentOffset.clamp(0, text.length) : text.length;

    var digits = _digitsOf(text, limit: false);
    var digitsBeforeCaret = _digitsOf(text.substring(0, caret), limit: false).length;

    // A full field accepts no more digits. Truncating would keep the new digit
    // and silently push the last one out, so the keystroke is rejected instead.
    // Pasting into an empty or partial field still truncates to maxDigits.
    final oldDigitCount = _digitsOf(oldValue.text, limit: false).length;
    if (oldDigitCount >= maxDigits && digits.length > oldDigitCount) return oldValue;

    // Deleting only a separator leaves the digits untouched, so the separator
    // would simply be put back. Backspace deletes the digit before it instead,
    // and forward-delete the digit after it. A selection that held only a
    // separator deletes nothing.
    final oldSelection = oldValue.selection;
    final deletedOnlySeparator = text.length < oldValue.text.length && digits == _digitsOf(oldValue.text, limit: false);
    if (deletedOnlySeparator && oldSelection.isValid && oldSelection.isCollapsed) {
      final isBackspace = caret < oldSelection.extentOffset;
      if (isBackspace && digitsBeforeCaret > 0) {
        digits = digits.substring(0, digitsBeforeCaret - 1) + digits.substring(digitsBeforeCaret);
        digitsBeforeCaret--;
      } else if (!isBackspace && digitsBeforeCaret < digits.length) {
        digits = digits.substring(0, digitsBeforeCaret) + digits.substring(digitsBeforeCaret + 1);
      }
    }

    if (digits.length > maxDigits) digits = digits.substring(0, maxDigits);
    if (digitsBeforeCaret > digits.length) digitsBeforeCaret = digits.length;

    final formatted = _group(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: _offsetAfterDigits(formatted, digitsBeforeCaret)),
    );
  }

  String _digitsOf(String input, {bool limit = true}) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    return limit && digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
  }

  String _group(String digits) {
    final buffer = StringBuffer();
    var index = 0;
    for (final length in groupLengths) {
      if (index >= digits.length) break;
      final end = (index + length).clamp(0, digits.length);
      if (index > 0) buffer.write(separator);
      buffer.write(digits.substring(index, end));
      index = end;
    }
    return buffer.toString();
  }

  /// The offset just past the [count]th digit of [formatted].
  int _offsetAfterDigits(String formatted, int count) {
    if (count == 0) return 0;
    var seen = 0;
    for (var i = 0; i < formatted.length; i++) {
      final unit = formatted.codeUnitAt(i);
      if (unit >= 0x30 && unit <= 0x39 && ++seen == count) return i + 1;
    }
    return formatted.length;
  }
}
