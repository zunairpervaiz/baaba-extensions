import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A PIN / OTP input widget rendered as a row of individual boxes.
///
/// Automatically advances focus to the next box on entry and moves back
/// on backspace when the current box is empty. A pasted or SMS-autofilled
/// code is spread across the boxes from the one it lands in, and typing into
/// a filled box replaces its digit.
///
/// Example:
/// ```dart
/// PinInputWidgetx(
///   length: 6,
///   onCompleted: (pin) => verifyOtp(pin),
/// )
/// ```
class PinInputWidgetx extends StatefulWidget {
  final int length;
  final void Function(String pin)? onCompleted;
  final void Function(String pin)? onChanged;
  final bool obscureText;
  final String obscuringCharacter;
  final TextInputType keyboardType;
  final double boxSize;
  final double boxSpacing;
  final TextStyle? textStyle;
  final Color? borderColor;
  final Color? activeBorderColor;
  final double borderRadius;
  final bool autofocus;

  const PinInputWidgetx({
    super.key,
    this.length = 4,
    this.onCompleted,
    this.onChanged,
    this.obscureText = false,
    this.obscuringCharacter = '●',
    this.keyboardType = TextInputType.number,
    this.boxSize = 48,
    this.boxSpacing = 8,
    this.textStyle,
    this.borderColor,
    this.activeBorderColor,
    this.borderRadius = 8,
    this.autofocus = true,
  });

  @override
  State<PinInputWidgetx> createState() => _PinInputWidgetxState();
}

class _PinInputWidgetxState extends State<PinInputWidgetx> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _nodes;

  /// The text each box held after the last change, so that a second character
  /// typed into a filled box can be told apart from a multi-digit paste.
  late List<String> _texts;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
    _texts = List.filled(widget.length, '');
  }

  @override
  void didUpdateWidget(covariant PinInputWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.length == oldWidget.length) return;
    // Rebuild the boxes for the new length, keeping the digits that still fit.
    final oldControllers = _controllers;
    final oldNodes = _nodes;
    _controllers = List.generate(widget.length, (i) => TextEditingController(text: i < oldControllers.length ? oldControllers[i].text : ''));
    _nodes = List.generate(widget.length, (_) => FocusNode());
    _texts = [for (final c in _controllers) c.text];
    // Disposed after the frame, once the old fields have detached from them.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final c in oldControllers) {
        c.dispose();
      }
      for (final f in oldNodes) {
        f.dispose();
      }
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _nodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _pin => _controllers.map((c) => c.text).join();

  void _setBox(int index, String text) {
    _controllers[index].value = TextEditingValue(text: text, selection: TextSelection.collapsed(offset: text.length));
    _texts[index] = text;
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) return _onMultiChar(index, value);
    _texts[index] = value;
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _nodes[index + 1].requestFocus();
      } else {
        _nodes[index].unfocus();
      }
    }
    _emit();
  }

  /// Handles more than one character arriving in a box: a keystroke into an
  /// already filled box replaces its digit, and a paste or SMS autofill is
  /// spread across this box and the ones after it.
  void _onMultiChar(int index, String value) {
    final previous = _texts[index];
    var incoming = value.replaceAll(RegExp(r'\s'), '');
    if (previous.isNotEmpty && incoming.length > previous.length) {
      if (incoming.startsWith(previous)) {
        incoming = incoming.substring(previous.length);
      } else if (incoming.endsWith(previous)) {
        incoming = incoming.substring(0, incoming.length - previous.length);
      }
    }
    if (incoming.isEmpty) {
      _setBox(index, previous);
      return;
    }

    var last = index;
    for (var k = 0; k < incoming.length && index + k < widget.length; k++) {
      last = index + k;
      _setBox(last, incoming[k]);
    }
    if (last < widget.length - 1) {
      _nodes[last + 1].requestFocus();
    } else {
      _nodes[index].unfocus();
      _nodes[last].unfocus();
    }
    _emit();
  }

  void _emit() {
    final pin = _pin;
    widget.onChanged?.call(pin);
    if (pin.length == widget.length) widget.onCompleted?.call(pin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = widget.borderColor ?? theme.colorScheme.outline;
    final activeBorder = widget.activeBorderColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < widget.length - 1 ? widget.boxSpacing : 0),
          child: SizedBox(
            width: widget.boxSize,
            height: widget.boxSize,
            child: Focus(
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.backspace && _controllers[i].text.isEmpty && i > 0) {
                  _setBox(i - 1, '');
                  _nodes[i - 1].requestFocus();
                  _emit();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextFormField(
                controller: _controllers[i],
                focusNode: _nodes[i],
                autofocus: widget.autofocus && i == 0,
                keyboardType: widget.keyboardType,
                textAlign: TextAlign.center,
                obscureText: widget.obscureText,
                obscuringCharacter: widget.obscuringCharacter,
                style: widget.textStyle ?? theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: border),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: activeBorder, width: 2),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                ),
                onChanged: (v) => _onChanged(i, v),
              ),
            ),
          ),
        );
      }),
    );
  }
}
