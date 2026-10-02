import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/default_configs.dart';
import '../utils/enums.dart';
import '../utils/formx.dart';
import '../utils/grouped_digits_formatterx.dart';
import '../utils/patterns.dart';

/// A styled text field that pairs with [FormX] and validates against
/// [Patterns] out of the box.
///
/// Pass a [form] and a [fieldKey] and the controller, focus node, and
/// next-field focus traversal are all wired for you. Pass a [type] and the
/// keyboard, autofill hints, icon, obscuring, and validation pattern are
/// chosen to match.
///
/// Example:
/// ```dart
/// enum LoginField { email, password }
/// final form = FormX(LoginField.values);
///
/// TextFieldWidgetx(
///   form: form,
///   fieldKey: LoginField.email,
///   label: 'Email',
///   type: FieldTypeX.email,
///   isRequired: true,
///   nextField: LoginField.password,
/// )
///
/// TextFieldWidgetx(
///   form: form,
///   fieldKey: LoginField.password,
///   label: 'Password',
///   type: FieldTypeX.password, // obscured, with a visibility toggle
///   isRequired: true,
///   minLength: 8,
/// )
///
/// // Standalone, without FormX.
/// TextFieldWidgetx(
///   controller: searchController,
///   hint: 'Search products',
///   type: FieldTypeX.search,
///   prefixIcon: Icons.search_rounded,
/// )
/// ```
class TextFieldWidgetx<K> extends StatefulWidget {
  /// The [FormX] that owns this field's controller and focus node.
  ///
  /// When supplied, [fieldKey] is required and [controller] / [focusNode]
  /// must be left null.
  final FormX<K>? form;

  /// The key identifying this field inside [form].
  final K? fieldKey;

  /// The field to move focus to when the user submits this one.
  ///
  /// Only meaningful together with [form]. When null and [textInputAction] is
  /// not given, this field gets [TextInputAction.done].
  final K? nextField;

  /// Controller for standalone use, when no [form] is given.
  final TextEditingController? controller;

  /// Focus node for standalone use, when no [form] is given.
  final FocusNode? focusNode;

  /// Floating label shown above the field.
  final String? label;

  /// Placeholder shown while the field is empty.
  final String? hint;

  /// Helper text shown below the field when there is no error.
  final String? helperText;

  /// Error text supplied from outside — server-side validation, for example.
  ///
  /// Takes precedence over the result of the built-in validators.
  final String? errorText;

  /// Preset that drives keyboard type, autofill, icon, obscuring, and the
  /// default validation pattern. Defaults to [FieldTypeX.text].
  final FieldTypeX type;

  /// When `true` an empty value fails validation with [requiredMessage],
  /// and an asterisk is appended to [label].
  final bool isRequired;

  /// Message used when [isRequired] fails.
  /// Defaults to [defaultFieldRequiredMessageGlobal].
  final String? requiredMessage;

  /// Regex the trimmed value must match. Defaults to the pattern implied by
  /// [type]. An empty value skips this check unless [isRequired] is set.
  final String? validationPattern;

  /// Message used when [validationPattern] fails.
  final String? validationMessage;

  /// Minimum number of characters accepted.
  final int? minLength;

  /// Extra validation run after the built-in checks pass.
  /// Receives the trimmed value.
  final String? Function(String value)? validator;

  /// Icon rendered at the start of the field.
  /// Defaults to the icon implied by [type].
  final IconData? prefixIcon;

  /// Widget rendered at the start of the field. Overrides [prefixIcon].
  final Widget? prefix;

  /// Icon rendered at the end of the field.
  ///
  /// For [FieldTypeX.password] the visibility toggle is used instead.
  final IconData? suffixIcon;

  /// Widget rendered at the end of the field. Overrides [suffixIcon].
  final Widget? suffix;

  /// Called when [suffixIcon] is tapped.
  final VoidCallback? onSuffixTap;

  /// Maximum number of characters. Shows a counter unless [showCounter] is off.
  final int? maxLength;

  /// Maximum number of visible lines. Defaults to `1`, or `4` for
  /// [FieldTypeX.multiline].
  final int? maxLines;

  /// Minimum number of visible lines.
  final int? minLines;

  /// Whether the character counter is displayed when [maxLength] is set.
  final bool showCounter;

  /// Overrides the keyboard type implied by [type].
  final TextInputType? keyboardType;

  /// Overrides the keyboard action key implied by [nextField].
  final TextInputAction? textInputAction;

  /// Input formatters applied on top of those implied by [type].
  final List<TextInputFormatter>? inputFormatters;

  /// How the value is capitalised as the user types.
  final TextCapitalization textCapitalization;

  /// Called on every keystroke with the raw value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the field from the keyboard.
  ///
  /// Runs after focus has moved to [nextField], when one is set.
  final ValueChanged<String>? onSubmitted;

  /// Called when the field is tapped. Combine with [readOnly] to open a
  /// picker instead of the keyboard.
  final VoidCallback? onTap;

  /// When `true` the value cannot be edited but can still be selected.
  final bool readOnly;

  /// When `false` the field is greyed out and non-interactive.
  final bool enabled;

  /// Requests focus as soon as the field is mounted.
  final bool autofocus;

  /// When to run validation. Defaults to
  /// [AutovalidateMode.onUserInteraction], so an untouched field is not
  /// marked invalid before the user has had a chance to type.
  final AutovalidateMode autovalidateMode;

  /// Corner radius. Defaults to [defaultFieldBorderRadiusGlobal].
  final double? borderRadius;

  /// Background colour of the field.
  final Color? fillColor;

  /// Border colour when the field is not focused.
  final Color? borderColor;

  /// Border colour when the field has focus.
  final Color? focusedBorderColor;

  /// Style applied to the entered text.
  final TextStyle? textStyle;

  /// Style applied to [hint].
  final TextStyle? hintStyle;

  /// Style applied to [label].
  final TextStyle? labelStyle;

  /// Inner padding of the field.
  final EdgeInsetsGeometry? contentPadding;

  /// Outer margin around the field.
  final EdgeInsetsGeometry? margin;

  /// Autofill hints passed to the platform. Defaults to those implied by [type].
  final List<String>? autofillHints;

  const TextFieldWidgetx({
    super.key,
    this.form,
    this.fieldKey,
    this.nextField,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.type = FieldTypeX.text,
    this.isRequired = false,
    this.requiredMessage,
    this.validationPattern,
    this.validationMessage,
    this.minLength,
    this.validator,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.showCounter = true,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.enabled = true,
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.contentPadding,
    this.margin,
    this.autofillHints,
  }) : assert(form == null || fieldKey != null, 'TextFieldWidgetx: fieldKey is required when a form is given.'),
       assert(form == null || controller == null, 'TextFieldWidgetx: pass either a form or a controller, not both.'),
       assert(form == null || focusNode == null, 'TextFieldWidgetx: pass either a form or a focusNode, not both.');

  @override
  State<TextFieldWidgetx<K>> createState() => _TextFieldWidgetxState<K>();
}

class _TextFieldWidgetxState<K> extends State<TextFieldWidgetx<K>> {
  /// Created only when the widget owns its controller — i.e. neither a form
  /// nor a controller was supplied — so that it can be disposed safely.
  TextEditingController? _ownedController;
  FocusNode? _ownedFocusNode;
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.type == FieldTypeX.password;
    if (widget.form == null) {
      if (widget.controller == null) _ownedController = TextEditingController();
      if (widget.focusNode == null) _ownedFocusNode = FocusNode();
    }
  }

  @override
  void didUpdateWidget(covariant TextFieldWidgetx<K> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The caller may start or stop supplying a form, controller, or focus node
    // between builds. Create an owned one when the supplied one disappears,
    // and release the owned one when the caller supplies their own. Caller-
    // owned objects are never disposed here.
    final needsController = widget.form == null && widget.controller == null;
    if (needsController && _ownedController == null) {
      // Carry the text over so the field does not blank out.
      _ownedController = TextEditingController(text: _controllerOf(oldWidget)?.text);
    } else if (!needsController && _ownedController != null) {
      _disposeAfterFrame(_ownedController!);
      _ownedController = null;
    }

    final needsFocusNode = widget.form == null && widget.focusNode == null;
    if (needsFocusNode && _ownedFocusNode == null) {
      _ownedFocusNode = FocusNode();
    } else if (!needsFocusNode && _ownedFocusNode != null) {
      _disposeAfterFrame(_ownedFocusNode!);
      _ownedFocusNode = null;
    }
  }

  /// The controller [w] was displaying, owned or not, for carrying text over.
  TextEditingController? _controllerOf(TextFieldWidgetx<K> w) {
    final form = w.form;
    if (form != null) return form[w.fieldKey as K];
    return w.controller ?? _ownedController;
  }

  /// Disposes [notifier] once the frame is done, after the [TextFormField]
  /// has detached from it in this rebuild.
  void _disposeAfterFrame(ChangeNotifier notifier) {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifier.dispose());
  }

  @override
  void dispose() {
    // Only what this widget created is disposed; a FormX or a caller-supplied
    // controller outlives the field and owns its own cleanup.
    _ownedController?.dispose();
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  TextEditingController get _controller {
    final form = widget.form;
    if (form != null) return form[widget.fieldKey as K];
    return widget.controller ?? _ownedController!;
  }

  FocusNode? get _focusNode {
    final form = widget.form;
    if (form != null) return form.focusNode(widget.fieldKey as K);
    return widget.focusNode ?? _ownedFocusNode;
  }

  bool get _isPassword => widget.type == FieldTypeX.password;

  TextInputType get _keyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;
    return switch (widget.type) {
      FieldTypeX.email => TextInputType.emailAddress,
      FieldTypeX.password => TextInputType.visiblePassword,
      FieldTypeX.phone => TextInputType.phone,
      FieldTypeX.number || FieldTypeX.cnic => TextInputType.number,
      FieldTypeX.multiline => TextInputType.multiline,
      FieldTypeX.url => TextInputType.url,
      FieldTypeX.text || FieldTypeX.search => TextInputType.text,
    };
  }

  TextInputAction get _textInputAction {
    if (widget.textInputAction != null) return widget.textInputAction!;
    if (widget.nextField != null) return TextInputAction.next;
    return switch (widget.type) {
      FieldTypeX.search => TextInputAction.search,
      FieldTypeX.multiline => TextInputAction.newline,
      _ => TextInputAction.done,
    };
  }

  IconData? get _prefixIcon {
    if (widget.prefixIcon != null) return widget.prefixIcon;
    return switch (widget.type) {
      FieldTypeX.email => Icons.mail_outline_rounded,
      FieldTypeX.password => Icons.lock_outline_rounded,
      FieldTypeX.phone => Icons.phone_outlined,
      FieldTypeX.search => Icons.search_rounded,
      FieldTypeX.url => Icons.link_rounded,
      FieldTypeX.cnic => Icons.badge_outlined,
      FieldTypeX.text || FieldTypeX.number || FieldTypeX.multiline => null,
    };
  }

  List<String>? get _autofillHints {
    if (widget.autofillHints != null) return widget.autofillHints;
    return switch (widget.type) {
      FieldTypeX.email => const [AutofillHints.email],
      FieldTypeX.password => const [AutofillHints.password],
      FieldTypeX.phone => const [AutofillHints.telephoneNumber],
      FieldTypeX.url => const [AutofillHints.url],
      _ => null,
    };
  }

  String? get _pattern {
    if (widget.validationPattern != null) return widget.validationPattern;
    return switch (widget.type) {
      FieldTypeX.email => Patterns.email,
      FieldTypeX.phone => Patterns.phone,
      FieldTypeX.url => Patterns.url,
      FieldTypeX.cnic => Patterns.cnic,
      _ => null,
    };
  }

  String get _patternMessage {
    if (widget.validationMessage != null) return widget.validationMessage!;
    return switch (widget.type) {
      FieldTypeX.email => defaultFieldInvalidEmailMessageGlobal,
      FieldTypeX.phone => defaultFieldInvalidPhoneMessageGlobal,
      FieldTypeX.cnic => defaultFieldInvalidCnicMessageGlobal,
      _ => 'Enter a valid ${(widget.label ?? 'value').toLowerCase()}',
    };
  }

  List<TextInputFormatter> get _formatters => [
    if (widget.type == FieldTypeX.number) FilteringTextInputFormatter.digitsOnly,
    if (widget.type == FieldTypeX.cnic) const GroupedDigitsInputFormatterX.cnic(),
    ...?widget.inputFormatters,
  ];

  String? _validate(String? raw) {
    final value = (raw ?? '').trim();

    if (widget.isRequired && value.isEmpty) return widget.requiredMessage ?? defaultFieldRequiredMessageGlobal;
    // An optional field left blank is valid — length and pattern checks only
    // apply once the user has actually entered something.
    if (value.isEmpty) return null;

    if (widget.minLength != null && value.length < widget.minLength!) {
      return 'Must be at least ${widget.minLength} characters';
    }

    final pattern = _pattern;
    if (pattern != null && !RegExp(pattern).hasMatch(value)) return _patternMessage;

    return widget.validator?.call(value);
  }

  void _handleSubmitted(String value) {
    final form = widget.form;
    final next = widget.nextField;
    if (form != null && next != null) {
      form.focus(next, context);
    } else if (widget.type != FieldTypeX.multiline) {
      _focusNode?.unfocus();
    }
    widget.onSubmitted?.call(value);
  }

  Widget? _buildSuffix(Color hintColor) {
    if (widget.suffix != null) return widget.suffix;
    if (_isPassword) {
      return IconButton(
        icon: Icon(_obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: hintColor),
        onPressed: () => setState(() => _obscured = !_obscured),
        tooltip: _obscured ? 'Show password' : 'Hide password',
      );
    }
    if (widget.suffixIcon == null) return null;
    return IconButton(
      icon: Icon(widget.suffixIcon, size: 20, color: hintColor),
      onPressed: widget.onSuffixTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final radius = BorderRadius.circular(widget.borderRadius ?? defaultFieldBorderRadiusGlobal);
    final hintColor = scheme.onSurface.withValues(alpha: 0.5);
    final idleBorder = widget.borderColor ?? scheme.outline.withValues(alpha: 0.5);
    final activeBorder = widget.focusedBorderColor ?? scheme.primary;
    final prefixIcon = _prefixIcon;

    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: width),
    );

    final field = TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      obscureText: _obscured,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      autofocus: widget.autofocus,
      keyboardType: _keyboardType,
      textInputAction: _textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: _formatters,
      maxLength: widget.maxLength,
      maxLines: _isPassword ? 1 : (widget.maxLines ?? (widget.type == FieldTypeX.multiline ? 4 : 1)),
      minLines: widget.minLines,
      style: widget.textStyle ?? theme.textTheme.bodyLarge,
      autofillHints: _autofillHints,
      autovalidateMode: widget.autovalidateMode,
      validator: _validate,
      onChanged: widget.onChanged,
      onFieldSubmitted: _handleSubmitted,
      onTap: widget.onTap,
      decoration: InputDecoration(
        labelText: widget.label == null ? null : (widget.isRequired ? '${widget.label} *' : widget.label),
        hintText: widget.hint,
        helperText: widget.helperText,
        errorText: widget.errorText,
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        counterText: widget.showCounter ? null : '',
        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle ?? TextStyle(color: hintColor),
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        prefixIcon: widget.prefix ?? (prefixIcon == null ? null : Icon(prefixIcon, size: 20, color: hintColor)),
        suffixIcon: _buildSuffix(hintColor),
        border: border(idleBorder, 1),
        enabledBorder: border(idleBorder, 1),
        focusedBorder: border(activeBorder, 1.6),
        errorBorder: border(scheme.error, 1),
        focusedErrorBorder: border(scheme.error, 1.6),
        disabledBorder: border(idleBorder.withValues(alpha: 0.3), 1),
      ),
    );

    if (widget.margin == null) return field;
    return Padding(padding: widget.margin!, child: field);
  }
}
