import 'package:flutter/material.dart';

/// A generic form controller that manages [TextEditingController] and
/// [FocusNode] instances for a set of keys — enums, strings, or any type.
///
/// Example:
/// ```dart
/// enum LoginField { email, password }
///
/// final form = FormX(LoginField.values);
///
/// TextFormField(
///   controller: form[LoginField.email],
///   focusNode: form.focusNode(LoginField.email),
/// )
///
/// final data = form.values; // {LoginField.email: 'ali@gmail.com', ...}
///
/// form.dispose();
/// ```
class FormX<K> {
  final Map<K, TextEditingController> _controllers;
  final Map<K, FocusNode> _focusNodes;
  final Map<K, String> _initialValues;

  /// Creates a [FormX] from a list of keys.
  /// A [TextEditingController] and [FocusNode] are created for each key.
  FormX(List<K> keys)
      : _controllers = {for (final k in keys) k: TextEditingController()},
        _focusNodes = {for (final k in keys) k: FocusNode()},
        _initialValues = {for (final k in keys) k: ''};

  /// Returns the [TextEditingController] for the given [key].
  TextEditingController operator [](K key) {
    assert(_controllers.containsKey(key), 'FormX: key "$key" not found.');
    return _controllers[key]!;
  }

  /// Returns the [FocusNode] for the given [key].
  /// Pass this to a [TextFormField] so [focus] can move focus to it.
  FocusNode focusNode(K key) {
    assert(_focusNodes.containsKey(key), 'FormX: key "$key" not found.');
    return _focusNodes[key]!;
  }

  /// Returns trimmed text values for all fields as a map.
  Map<K, String> get values =>
      _controllers.map((k, c) => MapEntry(k, c.text.trim()));

  /// Returns the trimmed value for a single [key].
  String value(K key) => this[key].text.trim();

  /// Returns `true` if every field is empty or contains only whitespace.
  bool get isEmpty =>
      _controllers.values.every((c) => c.text.trim().isEmpty);

  /// Returns `true` if any field's current value differs from its initial value.
  ///
  /// The baseline resets whenever [fill] is called, so an edit-form that has
  /// been pre-populated reports `false` until the user actually changes a field.
  bool get isDirty => _controllers.entries.any(
        (e) => e.value.text.trim() != (_initialValues[e.key] ?? ''),
      );

  /// Pre-fills fields from an existing map — useful for edit screens.
  ///
  /// Also updates the dirty-tracking baseline so the form is considered clean
  /// immediately after filling.
  ///
  /// Example:
  /// ```dart
  /// form.fill({LoginField.email: 'ali@gmail.com'});
  /// ```
  void fill(Map<K, String> data) {
    data.forEach((key, val) {
      if (_controllers.containsKey(key)) {
        _controllers[key]!.text = val;
        _initialValues[key] = val;
      }
    });
  }

  /// Requests keyboard focus for the field identified by [key].
  ///
  /// The [TextFormField] must have been given `focusNode: form.focusNode(key)`
  /// for this to work.
  ///
  /// Example:
  /// ```dart
  /// form.focus(LoginField.password, context);
  /// ```
  void focus(K key, BuildContext context) {
    assert(_focusNodes.containsKey(key), 'FormX: key "$key" not found.');
    FocusScope.of(context).requestFocus(_focusNodes[key]);
  }

  /// Runs each validator against the corresponding field's trimmed value and
  /// returns a map of errors. A `null` value means the field passed validation.
  ///
  /// Only keys present in [validators] are checked; unspecified fields are
  /// omitted from the result.
  ///
  /// Example:
  /// ```dart
  /// final errors = form.validate({
  ///   LoginField.email: (v) => v.isEmpty ? 'Required' : null,
  ///   LoginField.password: (v) => v.length < 8 ? 'Too short' : null,
  /// });
  /// if (errors.values.any((e) => e != null)) { /* show errors */ }
  /// ```
  Map<K, String?> validate(Map<K, String? Function(String)> validators) {
    return {
      for (final entry in validators.entries)
        entry.key: entry.value(value(entry.key)),
    };
  }

  /// Clears all fields and resets the dirty-tracking baseline.
  void reset() {
    for (final entry in _controllers.entries) {
      entry.value.clear();
      _initialValues[entry.key] = '';
    }
  }

  /// Disposes all controllers and focus nodes. Call this in [State.dispose].
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    for (final f in _focusNodes.values) {
      f.dispose();
    }
  }
}