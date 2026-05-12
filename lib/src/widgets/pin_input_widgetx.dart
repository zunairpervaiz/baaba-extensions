import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A PIN / OTP input widget rendered as a row of individual boxes.
///
/// Automatically advances focus to the next box on entry and moves back
/// on backspace when the current box is empty.
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
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
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

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _nodes[index + 1].requestFocus();
      } else {
        _nodes[index].unfocus();
      }
    }
    final pin = _pin;
    widget.onChanged?.call(pin);
    if (pin.length == widget.length) widget.onCompleted?.call(pin);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = widget.borderColor ?? theme.colorScheme.outline;
    final activeBorder =
        widget.activeBorderColor ?? theme.colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (i) {
        return Padding(
          padding: EdgeInsets.only(
            right: i < widget.length - 1 ? widget.boxSpacing : 0,
          ),
          child: SizedBox(
            width: widget.boxSize,
            height: widget.boxSize,
            child: Focus(
              onKeyEvent: (_, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[i].text.isEmpty &&
                    i > 0) {
                  _controllers[i - 1].clear();
                  _nodes[i - 1].requestFocus();
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
                maxLength: 1,
                obscureText: widget.obscureText,
                obscuringCharacter: widget.obscuringCharacter,
                inputFormatters: [LengthLimitingTextInputFormatter(1)],
                style: widget.textStyle ?? theme.textTheme.titleLarge,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: border),
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: activeBorder, width: 2),
                    borderRadius:
                        BorderRadius.circular(widget.borderRadius),
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
