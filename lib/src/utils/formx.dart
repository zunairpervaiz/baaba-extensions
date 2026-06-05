import 'package:flutter/material.dart';

/// A generic form controller that manages [TextEditingController] instances
/// for a set of keys — enums, strings, or any type.
///
/// Example:
/// ```dart
/// enum LoginField { email, password }
///
/// final form = FormX(LoginField.values);
///
/// TextFormField(controller: form[LoginField.email])
///
/// final data = form.values; // {LoginField.email: 'ali@gmail.com', ...}
///
/// form.dispose();
/// ```
class FormX<K> {
  final Map<K, TextEditingController> _controllers;

  /// Creates a [FormX] from a list of keys.
  /// A [TextEditingController] is created for each key.
  FormX(List<K> keys)
      : _controllers = {for (final k in keys) k: TextEditingController()};

  /// Returns the [TextEditingController] for the given [key].
  TextEditingController operator [](K key) {
    assert(_controllers.containsKey(key), 'FormX: key "$key" not found.');
    return _controllers[key]!;
  }

  /// Returns trimmed text values for all fields as a map.
  Map<K, String> get values =>
      _controllers.map((k, c) => MapEntry(k, c.text.trim()));

  /// Returns the trimmed value for a single [key].
  String value(K key) => this[key].text.trim();

  /// Pre-fills fields from an existing map — useful for edit screens.
  ///
  /// Example:
  /// ```dart
  /// form.fill({LoginField.email: 'ali@gmail.com'});
  /// ```
  void fill(Map<K, String> data) {
    data.forEach((key, val) {
      if (_controllers.containsKey(key)) {
        _controllers[key]!.text = val;
      }
    });
  }

  /// Clears all fields.
  void reset() {
    for (final c in _controllers.values) {
      c.clear();
    }
  }

  /// Disposes all controllers. Call this in [State.dispose].
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
  }
}
