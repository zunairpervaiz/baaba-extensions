extension BoolxExtensions on bool {
  /// Returns the current value.
  bool get isTrue => this;

  /// Returns the opposite of the current value.
  bool get isFalse => !this;

  /// Returns the opposite of the current value.
  bool get toggle => !this;
}
