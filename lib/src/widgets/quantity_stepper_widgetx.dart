import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A compact `− n +` quantity selector, as used in carts and order screens.
///
/// The value is controlled by the parent: [onChanged] fires with the new
/// quantity and the widget renders whatever [value] it is given next. Holding
/// a button repeats it, and [onRemove] turns the minus button into a delete
/// action once [min] is reached.
///
/// Example:
/// ```dart
/// QuantityStepperWidgetx(
///   value: item.quantity,
///   min: 1,
///   max: item.stock,
///   onChanged: (qty) => cart.setQuantity(item, qty),
///   onRemove: () => cart.remove(item),
/// )
///
/// // Let the user type a quantity directly.
/// QuantityStepperWidgetx(
///   value: qty,
///   max: 999,
///   allowManualInput: true,
///   onChanged: (v) => setState(() => qty = v),
/// )
/// ```
class QuantityStepperWidgetx extends StatefulWidget {
  /// The quantity currently displayed.
  final int value;

  /// Called with the new quantity whenever the user changes it.
  ///
  /// Always within [min] and [max]; the widget clamps before calling.
  final ValueChanged<int> onChanged;

  /// Lowest quantity the user can reach with the minus button. Defaults to `1`.
  final int min;

  /// Highest quantity the user can reach with the plus button. Defaults to `99`.
  final int max;

  /// How much each tap adds or removes. Defaults to `1`.
  final int step;

  /// Called when the minus button is pressed while [value] is already at [min].
  ///
  /// When set, the minus button becomes a delete icon at [min] — the usual
  /// "decrement to remove" behaviour in a cart. When null, the minus button is
  /// simply disabled at [min].
  final VoidCallback? onRemove;

  /// When `false` the whole control is dimmed and non-interactive.
  final bool enabled;

  /// Replaces the quantity with a small spinner — for an in-flight cart update.
  final bool isLoading;

  /// Lets the user tap the number and type a quantity directly.
  final bool allowManualInput;

  /// Repeats the increment or decrement while a button is held down.
  final bool enableLongPressRepeat;

  /// Height of the control. Defaults to `36`.
  final double height;

  /// Width of the number between the two buttons. Defaults to `40`.
  final double valueWidth;

  /// Width of each button. Defaults to [height], making them square.
  final double? buttonWidth;

  /// Corner radius of the outer container. Defaults to `10`.
  final double borderRadius;

  /// Background colour of the control. Defaults to transparent.
  final Color? backgroundColor;

  /// Colour of the icons. Defaults to the primary colour.
  final Color? foregroundColor;

  /// Colour of the icons when a button is at its limit. Defaults to a dimmed
  /// [foregroundColor].
  final Color? disabledColor;

  /// Colour of the outer border. Defaults to the theme outline.
  final Color? borderColor;

  /// Width of the outer border. Set to `0` to remove it.
  final double borderWidth;

  /// Size of the plus and minus icons. Defaults to `18`.
  final double iconSize;

  /// Style of the quantity text.
  final TextStyle? textStyle;

  /// Icon used for the decrement button.
  final IconData decrementIcon;

  /// Icon used for the increment button.
  final IconData incrementIcon;

  /// Icon used in place of [decrementIcon] when [onRemove] is set and the
  /// value is at [min].
  final IconData removeIcon;

  const QuantityStepperWidgetx({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
    this.step = 1,
    this.onRemove,
    this.enabled = true,
    this.isLoading = false,
    this.allowManualInput = false,
    this.enableLongPressRepeat = true,
    this.height = 36,
    this.valueWidth = 40,
    this.buttonWidth,
    this.borderRadius = 10,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledColor,
    this.borderColor,
    this.borderWidth = 1,
    this.iconSize = 18,
    this.textStyle,
    this.decrementIcon = Icons.remove_rounded,
    this.incrementIcon = Icons.add_rounded,
    this.removeIcon = Icons.delete_outline_rounded,
  }) : assert(min <= max, 'QuantityStepperWidgetx: min must not exceed max.'),
       assert(step > 0, 'QuantityStepperWidgetx: step must be greater than zero.');

  @override
  State<QuantityStepperWidgetx> createState() => _QuantityStepperWidgetxState();
}

class _QuantityStepperWidgetxState extends State<QuantityStepperWidgetx> {
  /// Mirrors [widget.value] so a held button can keep counting without waiting
  /// for the parent to rebuild between ticks.
  late int _value;
  TextEditingController? _inputController;
  FocusNode? _inputFocus;
  Timer? _repeatTimer;

  @override
  void initState() {
    super.initState();
    _value = widget.value.clamp(widget.min, widget.max);
    if (widget.allowManualInput) {
      _inputController = TextEditingController(text: '$_value');
      _inputFocus = FocusNode()..addListener(_onFocusChanged);
    }
  }

  @override
  void didUpdateWidget(covariant QuantityStepperWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _value) {
      _value = widget.value.clamp(widget.min, widget.max);
      _syncInput();
    }
  }

  @override
  void dispose() {
    _repeatTimer?.cancel();
    _inputFocus?.removeListener(_onFocusChanged);
    _inputFocus?.dispose();
    _inputController?.dispose();
    super.dispose();
  }

  void _syncInput() {
    final controller = _inputController;
    if (controller != null && controller.text != '$_value') controller.text = '$_value';
  }

  void _onFocusChanged() {
    // Commit whatever was typed as soon as the field loses focus, so a value
    // left uncommitted cannot drift away from what the parent holds.
    if (_inputFocus?.hasFocus == false) _commitInput(_inputController?.text ?? '');
  }

  void _commitInput(String raw) {
    final parsed = int.tryParse(raw.trim());
    if (parsed == null) {
      _syncInput();
      return;
    }
    _apply(parsed);
    _syncInput();
  }

  bool get _canDecrement => widget.enabled && !widget.isLoading && (_value > widget.min || widget.onRemove != null);

  bool get _canIncrement => widget.enabled && !widget.isLoading && _value < widget.max;

  bool get _isAtRemoveThreshold => widget.onRemove != null && _value <= widget.min;

  void _apply(int next) {
    final clamped = next.clamp(widget.min, widget.max);
    if (clamped == _value) return;
    setState(() => _value = clamped);
    widget.onChanged(clamped);
  }

  void _decrement() {
    if (!_canDecrement) return;
    if (_isAtRemoveThreshold) {
      _stopRepeat();
      widget.onRemove!.call();
      return;
    }
    _apply(_value - widget.step);
    _syncInput();
  }

  void _increment() {
    if (!_canIncrement) return;
    _apply(_value + widget.step);
    _syncInput();
  }

  void _startRepeat(VoidCallback action) {
    if (!widget.enableLongPressRepeat) return;
    _repeatTimer?.cancel();
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 90), (_) {
      // Stop as soon as the action can no longer be applied, so the timer does
      // not spin against a clamped value.
      if (!mounted) return _stopRepeat();
      action();
    });
  }

  void _stopRepeat() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = widget.foregroundColor ?? scheme.primary;
    final disabled = widget.disabledColor ?? foreground.withValues(alpha: 0.3);
    final buttonWidth = widget.buttonWidth ?? widget.height;
    final radius = BorderRadius.circular(widget.borderRadius);

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: radius,
          border: widget.borderWidth <= 0
              ? null
              : Border.all(color: widget.borderColor ?? scheme.outline.withValues(alpha: 0.4), width: widget.borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepperButton(
              icon: _isAtRemoveThreshold ? widget.removeIcon : widget.decrementIcon,
              iconSize: widget.iconSize,
              width: buttonWidth,
              color: _canDecrement ? (_isAtRemoveThreshold ? scheme.error : foreground) : disabled,
              borderRadius: BorderRadius.only(topLeft: radius.topLeft, bottomLeft: radius.bottomLeft),
              onTap: _canDecrement ? _decrement : null,
              // Holding to remove would be destructive, so repeat is only
              // wired up while the button is still a plain decrement.
              onLongPressStart: _canDecrement && !_isAtRemoveThreshold ? () => _startRepeat(_decrement) : null,
              onLongPressEnd: _stopRepeat,
              semanticLabel: _isAtRemoveThreshold ? 'Remove' : 'Decrease quantity',
            ),
            SizedBox(
              width: widget.valueWidth,
              child: Center(child: _buildValue(theme, scheme)),
            ),
            _StepperButton(
              icon: widget.incrementIcon,
              iconSize: widget.iconSize,
              width: buttonWidth,
              color: _canIncrement ? foreground : disabled,
              borderRadius: BorderRadius.only(topRight: radius.topRight, bottomRight: radius.bottomRight),
              onTap: _canIncrement ? _increment : null,
              onLongPressStart: _canIncrement ? () => _startRepeat(_increment) : null,
              onLongPressEnd: _stopRepeat,
              semanticLabel: 'Increase quantity',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValue(ThemeData theme, ColorScheme scheme) {
    if (widget.isLoading) {
      return SizedBox(
        height: widget.iconSize - 2,
        width: widget.iconSize - 2,
        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(widget.foregroundColor ?? scheme.primary)),
      );
    }

    final style = widget.textStyle ?? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600);

    if (!widget.allowManualInput) {
      return Text('$_value', style: style, textAlign: TextAlign.center);
    }

    return TextField(
      controller: _inputController,
      focusNode: _inputFocus,
      enabled: widget.enabled,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: style,
      onSubmitted: _commitInput,
      decoration: const InputDecoration(isDense: true, border: InputBorder.none, contentPadding: EdgeInsets.zero),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.iconSize,
    required this.width,
    required this.color,
    required this.borderRadius,
    required this.semanticLabel,
    this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
  });

  final IconData icon;
  final double iconSize;
  final double width;
  final Color color;
  final BorderRadius borderRadius;
  final String semanticLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPressStart;
  final VoidCallback? onLongPressEnd;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: semanticLabel,
      child: GestureDetector(
        onLongPressStart: onLongPressStart == null ? null : (_) => onLongPressStart!(),
        onLongPressEnd: (_) => onLongPressEnd?.call(),
        onLongPressCancel: onLongPressEnd,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: SizedBox(
            width: width,
            child: Icon(icon, size: iconSize, color: color),
          ),
        ),
      ),
    );
  }
}
