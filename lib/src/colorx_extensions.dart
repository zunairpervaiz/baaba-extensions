import 'package:flutter/material.dart';

extension ColorX on Color {
  /// Returns a lighter version of this color by increasing HSL lightness by [amount].
  ///
  /// Example: `Colors.blue.lighten(0.2)`
  Color lighten([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Returns a darker version of this color by decreasing HSL lightness by [amount].
  ///
  /// Example: `Colors.blue.darken(0.2)`
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Returns the hex string representation of this color.
  ///
  /// Example: `Colors.blue.toHex()` → `'#2196F3'`
  String toHex({bool leadingHash = true, bool includeAlpha = false}) {
    final ri = (r * 255).round().toRadixString(16).padLeft(2, '0');
    final gi = (g * 255).round().toRadixString(16).padLeft(2, '0');
    final bi = (b * 255).round().toRadixString(16).padLeft(2, '0');
    final hex = includeAlpha
        ? '${(a * 255).round().toRadixString(16).padLeft(2, '0')}$ri$gi$bi'
        : '$ri$gi$bi';
    return leadingHash ? '#$hex' : hex;
  }

  /// Returns true when the color's luminance is above 0.5 (perceived as light).
  bool get isLight => computeLuminance() > 0.5;

  /// Returns true when the color's luminance is 0.5 or below (perceived as dark).
  bool get isDark => !isLight;

  /// Returns the complementary color (hue shifted by 180°).
  Color get complementary {
    final hsl = HSLColor.fromColor(this);
    return hsl.withHue((hsl.hue + 180) % 360).toColor();
  }

  /// Returns a color blended toward [other] by [weight] (0.0 = this, 1.0 = other).
  ///
  /// Example: `Colors.red.mix(Colors.blue, weight: 0.5)` → purple-ish
  Color mix(Color other, {double weight = 0.5}) {
    final w = weight.clamp(0.0, 1.0);
    return Color.fromARGB(
      ((a + (other.a - a) * w) * 255).round(),
      ((r + (other.r - r) * w) * 255).round(),
      ((g + (other.g - g) * w) * 255).round(),
      ((b + (other.b - b) * w) * 255).round(),
    );
  }

  /// Returns a copy of this color with the HSL saturation set to [saturation].
  Color withSaturationLevel(double saturation) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation(saturation.clamp(0.0, 1.0)).toColor();
  }

  /// Returns a copy of this color with the HSL lightness set to [lightness].
  Color withLightnessLevel(double lightness) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
  }
}
