/*
 * Copyright 2026 Zunair Pervaiz. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:baaba_extensions/baaba_extensions.dart';
import 'package:baaba_extensions/src/mixins/color_mixin.dart';
import 'package:baaba_extensions/src/mixins/render_mixin.dart';
import 'package:baaba_extensions/src/utils/none_widget.dart';
import 'package:baaba_extensions/src/utils/widget_builder.dart';
import 'package:flutter/material.dart';

/// Fluent builder for a [Text] widget — chain modifiers, then call [make].
///
/// [make] builds a plain [Text] at exactly the size you set: nothing is shrunk
/// to fit, and the system text scale is respected. For text that should shrink
/// to fit its box, wrap the result in `FittedBox(fit: BoxFit.scaleDown, child: ...)`.
@protected
class VxTextBuilder extends VxWidgetBuilders<Widget> with VxColorMixin<VxTextBuilder>, VxRenderMixin<VxTextBuilder> {
  VxTextBuilder(String this._text) {
    setChildToColor(this);
    setChildForRender(this);
  }

  VxTextBuilder.existing(String this._text, this._textStyle) {
    setChildToColor(this);
    setChildForRender(this);
  }

  /// Creates a builder that rebuilds [source], keeping its text or text span,
  /// style, key, and layout settings.
  VxTextBuilder.fromText(Text source)
      : _text = source.data,
        _textSpan = source.textSpan,
        _textStyle = source.style,
        _source = source,
        _maxLines = source.maxLines,
        _textAlign = source.textAlign,
        _overflow = source.overflow,
        _softWrap = source.softWrap,
        _strutStyle = source.strutStyle {
    setChildToColor(this);
    setChildForRender(this);
  }

  String? _text, _fontFamily;
  InlineSpan? _textSpan;
  // The Text this builder was made from, if any; supplies the settings the
  // builder has no setter for (key, textDirection, semanticsLabel, ...).
  Text? _source;

  double? _scaleFactor, _fontSize, _letterSpacing, _lineHeight, _wordSpacing;
  int? _maxLines;
  FontWeight? _fontWeight;
  TextAlign? _textAlign;
  FontStyle? _fontStyle;
  TextDecoration? _decoration;
  TextStyle? _textStyle, _themedStyle;
  StrutStyle? _strutStyle;
  TextOverflow? _overflow;
  TextBaseline? _textBaseline;
  bool? _softWrap;
  bool _hasShadow = false;
  double _shadowBlur = 0.0;
  Color _shadowColor = const Color(0xFF000000);
  Offset _shadowOffset = Offset.zero;

  /// The text to display.
  ///
  /// This will be null if a [textSpan] is provided instead.
  VxTextBuilder text(String text) {
    _text = text;
    return this;
  }

  /// Set [color] of the text
  VxTextBuilder color(Color? color) {
    velocityColor = color;
    return this;
  }

  /// Returns this builder unchanged; [make] always builds a plain [Text] now.
  @Deprecated('Has no effect since 0.8.0 — make() always builds a plain Text. Remove the call.')
  VxTextBuilder get isIntrinsic => this;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it is truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  VxTextBuilder maxLines(int lines) {
    _maxLines = lines;
    return this;
  }

  /// Set [fontFamily] for the text
  VxTextBuilder fontFamily(String family) {
    _fontFamily = family;
    return this;
  }

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  VxTextBuilder softWrap(bool softWrap) {
    _softWrap = softWrap;
    return this;
  }

  /// Returns this builder unchanged; text is no longer auto-sized.
  @Deprecated('Has no effect since 0.8.0 — text is no longer auto-sized. Remove the call.')
  VxTextBuilder wrapWords(bool wrapWords) => this;

  /// The common baseline that should be aligned between this text span and its
  /// parent text span, or, for the root text spans, with the line box.
  VxTextBuilder textBaseLine(TextBaseline baseline) {
    _textBaseline = baseline;
    return this;
  }

  /// The amount of space (in logical pixels) to add at each sequence of
  /// white-space (i.e. between each word). A negative value can be used to
  /// bring the words closer.
  VxTextBuilder wordSpacing(double spacing) {
    _wordSpacing = spacing;
    return this;
  }

  /// Can be used to set overflow of a text.
  /// How visual overflow should be handled.
  VxTextBuilder overflow(TextOverflow overflow) {
    _overflow = overflow;
    return this;
  }

  /// Returns this builder unchanged; text is no longer auto-sized.
  @Deprecated('Has no effect since 0.8.0 — text is no longer auto-sized. Use size() for the font size, or FittedBox(fit: BoxFit.scaleDown) to shrink to fit.')
  VxTextBuilder minFontSize(double minFontSize) => this;

  /// Returns this builder unchanged; text is no longer auto-sized.
  @Deprecated('Has no effect since 0.8.0 — text is no longer auto-sized. Use size() for the font size, or FittedBox(fit: BoxFit.scaleDown) to shrink to fit.')
  VxTextBuilder maxFontSize(double maxFontSize) => this;

  /// Returns this builder unchanged; text is no longer auto-sized.
  @Deprecated('Has no effect since 0.8.0 — text is no longer auto-sized. Remove the call.')
  VxTextBuilder stepGranularity(double stepGranularity) => this;

  /// Returns this builder unchanged; text is no longer auto-sized, so it never
  /// swaps in a replacement.
  @Deprecated('Has no effect since 0.8.0 — text is no longer auto-sized. Use overflow() or maxLines() instead.')
  VxTextBuilder overflowReplacement(Widget overflowReplacement) => this;

  /// Set [FontWeight] for the text
  VxTextBuilder fontWeight(FontWeight weight) {
    _fontWeight = weight;
    return this;
  }

  /// Use textStyle to provide custom or any theme style.
  ///
  /// If the style's 'inherit' property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  VxTextBuilder textStyle(TextStyle? style) {
    _themedStyle = style;
    return this;
  }

  /// The strut style to use. Strut style defines the strut, which sets minimum
  /// vertical layout metrics.
  ///
  /// Omitting or providing null will disable strut.
  ///
  /// Omitting or providing null for any properties of [StrutStyle] will result in
  /// default values being used. It is highly recommended to at least specify a
  /// font size.
  ///
  /// See [StrutStyle] for details.
  VxTextBuilder strutStyle(StrutStyle? style) {
    _strutStyle = style;
    return this;
  }

  // Give custom text alignment
  VxTextBuilder align(TextAlign align) => this.._textAlign = align;

  /// How the text should be aligned horizontally.
  ///
  /// To align text in [center]
  VxTextBuilder get center => this.._textAlign = TextAlign.center;

  /// To align text in [start]
  VxTextBuilder get start => this.._textAlign = TextAlign.start;

  /// To align text in [end]
  VxTextBuilder get end => this.._textAlign = TextAlign.end;

  /// To align text as [justify]
  VxTextBuilder get justify => this.._textAlign = TextAlign.justify;

  /// To overlow text as [fade]
  VxTextBuilder get fade => this.._overflow = TextOverflow.fade;

  /// To overlow text as [ellipsis]
  VxTextBuilder get ellipsis => this.._overflow = TextOverflow.ellipsis;

  /// To overlow text as [visible]
  VxTextBuilder get visible => this.._overflow = TextOverflow.visible;

  /// To set fontSize of the text using [size]
  VxTextBuilder size(double? size) => this.._fontSize = size;

  /// Sets [TextTheme] display large
  VxTextBuilder displayLarge(BuildContext context) {
    _themedStyle = context.textTheme.displayLarge;
    return this;
  }

  /// Sets [TextTheme] display medium
  VxTextBuilder displayMedium(BuildContext context) {
    _themedStyle = context.textTheme.displayMedium;
    return this;
  }

  /// Sets [TextTheme] display small
  VxTextBuilder displaySmall(BuildContext context) {
    _themedStyle = context.textTheme.displaySmall;
    return this;
  }

  /// Sets [TextTheme] headline large
  VxTextBuilder headlineLarge(BuildContext context) {
    _themedStyle = context.textTheme.headlineLarge;
    return this;
  }

  /// Sets [TextTheme] headline medium
  VxTextBuilder headlineMedium(BuildContext context) {
    _themedStyle = context.textTheme.headlineMedium;
    return this;
  }

  /// Sets [TextTheme] headline small
  VxTextBuilder headlineSmall(BuildContext context) {
    _themedStyle = context.textTheme.headlineSmall;
    return this;
  }

  /// Sets [TextTheme] title large
  VxTextBuilder titleLarge(BuildContext context) {
    _themedStyle = context.textTheme.titleLarge;
    return this;
  }

  /// Sets [TextTheme] title medium
  VxTextBuilder titleMedium(BuildContext context) {
    _themedStyle = context.textTheme.titleMedium;
    return this;
  }

  /// Sets [TextTheme] title small
  VxTextBuilder titleSmall(BuildContext context) {
    _themedStyle = context.textTheme.titleSmall;
    return this;
  }

  /// Sets [TextTheme] body large
  VxTextBuilder bodyLarge(BuildContext context) {
    _themedStyle = context.textTheme.bodyLarge;
    return this;
  }

  /// Sets [TextTheme] body medium
  VxTextBuilder bodyMedium(BuildContext context) {
    _themedStyle = context.textTheme.bodyMedium;
    return this;
  }

  /// Sets [TextTheme] body small
  VxTextBuilder bodySmall(BuildContext context) {
    _themedStyle = context.textTheme.bodySmall;
    return this;
  }

  /// Sets [TextTheme] label large
  VxTextBuilder labelLarge(BuildContext context) {
    _themedStyle = context.textTheme.labelLarge;
    return this;
  }

  /// Sets [TextTheme] label medium
  VxTextBuilder labelMedium(BuildContext context) {
    _themedStyle = context.textTheme.labelMedium;
    return this;
  }

  /// Sets [TextTheme] label small
  VxTextBuilder labelSmall(BuildContext context) {
    _themedStyle = context.textTheme.labelSmall;
    return this;
  }

  /// Sets [textScaleFactor] to extra small i.e. 0.75
  VxTextBuilder get xs => _fontSizedText(child: this, scaleFactor: 0.75);

  /// Sets [textScaleFactor] to small i.e. 0.875
  VxTextBuilder get sm => _fontSizedText(child: this, scaleFactor: 0.875);

  /// Sets [textScaleFactor] to base i.e. 1 or default
  VxTextBuilder get base => _fontSizedText(child: this, scaleFactor: 1);

  /// Sets [textScaleFactor] to large i.e. 1.125
  VxTextBuilder get lg => _fontSizedText(child: this, scaleFactor: 1.125);

  /// Sets [textScaleFactor] to extra large i.e. 1.25
  VxTextBuilder get xl => _fontSizedText(child: this, scaleFactor: 1.25);

  /// Sets [textScaleFactor] to twice extra large i.e. 1.5
  VxTextBuilder get xl2 => _fontSizedText(child: this, scaleFactor: 1.5);

  /// Sets [textScaleFactor] to thrice extra large i.e. 1.875
  VxTextBuilder get xl3 => _fontSizedText(child: this, scaleFactor: 1.875);

  /// Sets [textScaleFactor] to four times extra large i.e. 2.25
  VxTextBuilder get xl4 => _fontSizedText(child: this, scaleFactor: 2.25);

  /// Sets [textScaleFactor] to five times extra large i.e. 3
  VxTextBuilder get xl5 => _fontSizedText(child: this, scaleFactor: 3);

  /// Sets [textScaleFactor] to six times extra large i.e. 4
  VxTextBuilder get xl6 => _fontSizedText(child: this, scaleFactor: 4);

  /// Sets [textScaleFactor] to custom value
  VxTextBuilder scale(double value) => _fontSizedText(child: this, scaleFactor: value);

  // The factor is applied in make(), to the explicit size(), else the theme or
  // text style's font size, else 14 — so `titleLarge(ctx).xl` scales the
  // titleLarge size, not a hardcoded 14.
  VxTextBuilder _fontSizedText({required double scaleFactor, required VxTextBuilder child}) {
    _scaleFactor = scaleFactor;
    return this;
  }

  /// Sets [FontWeight] to [FontWeight.w100]
  VxTextBuilder get hairLine => _fontWeightedText(weight: FontWeight.w100);

  /// Sets [FontWeight] to [FontWeight.w200]
  VxTextBuilder get thin => _fontWeightedText(weight: FontWeight.w200);

  /// Sets [FontWeight] to [FontWeight.w300]
  VxTextBuilder get light => _fontWeightedText(weight: FontWeight.w300);

  /// Sets [FontWeight] to [FontWeight.w400]
  VxTextBuilder get normal => _fontWeightedText(weight: FontWeight.w400);

  /// Sets [FontWeight] to [FontWeight.w500]
  VxTextBuilder get medium => _fontWeightedText(weight: FontWeight.w500);

  /// Sets [FontWeight] to [FontWeight.w600]
  VxTextBuilder get semiBold => _fontWeightedText(weight: FontWeight.w600);

  /// Sets [FontWeight] to [FontWeight.w700]
  VxTextBuilder get bold => _fontWeightedText(weight: FontWeight.w700);

  /// Sets [FontWeight] to [FontWeight.w800]
  VxTextBuilder get extraBold => _fontWeightedText(weight: FontWeight.w800);

  /// Sets [FontWeight] to [FontWeight.w900]
  VxTextBuilder get extraBlack => _fontWeightedText(weight: FontWeight.w900);

  VxTextBuilder _fontWeightedText({required FontWeight weight}) {
    _fontWeight = weight;
    return this;
  }

  /// Sets [FontStyle] to [FontStyle.italic]
  VxTextBuilder get italic => this.._fontStyle = FontStyle.italic;

  /// Sets [letterSpacing] to -3.0
  VxTextBuilder get tightest => this.._letterSpacing = -3.0;

  /// Sets [letterSpacing] to -2.0
  VxTextBuilder get tighter => this.._letterSpacing = -2.0;

  /// Sets [letterSpacing] to -1.0
  VxTextBuilder get tight => this.._letterSpacing = -1.0;

  /// Sets [letterSpacing] to 1.0
  VxTextBuilder get wide => this.._letterSpacing = 1.0;

  /// Sets [letterSpacing] to 2.0
  VxTextBuilder get wider => this.._letterSpacing = 2.0;

  /// Sets [letterSpacing] to 3.0
  VxTextBuilder get widest => this.._letterSpacing = 3.0;

  /// Sets custom [letterSpacing] with [val]
  VxTextBuilder letterSpacing(double val) => this.._letterSpacing = val;

  /// Sets [TextDecoration] as [TextDecoration.underline]
  VxTextBuilder get underline => this.._decoration = TextDecoration.underline;

  /// Sets [TextDecoration] as [TextDecoration.lineThrough]
  VxTextBuilder get lineThrough => this.._decoration = TextDecoration.lineThrough;

  /// Sets [TextDecoration] as [TextDecoration.overline]
  VxTextBuilder get overline => this.._decoration = TextDecoration.overline;

  /// Converts the text to fully uppercase. Has no effect on a text span.
  VxTextBuilder get uppercase => this.._text = _text?.toUpperCase();

  /// Converts the text to fully lowercase. Has no effect on a text span.
  VxTextBuilder get lowercase => this.._text = _text?.toLowerCase();

  /// Converts the text to first letter of very word as uppercase. Has no effect on a text span.
  VxTextBuilder get capitalize => this.._text = _text?.trim().capitalizeAllWords();

  /// Sets [lineHeight] to 0.75
  VxTextBuilder get heightTight => this.._lineHeight = 0.75;

  /// Sets [lineHeight] to 0.875
  VxTextBuilder get heightSnug => this.._lineHeight = 0.875;

  /// Sets [lineHeight] to 1.25
  VxTextBuilder get heightRelaxed => this.._lineHeight = 1.25;

  /// Sets [lineHeight] to 1.5
  VxTextBuilder get heightLoose => this.._lineHeight = 1.5;

  /// Sets custom [lineHeight] with [val]
  VxTextBuilder lineHeight(double val) => this.._lineHeight = val;

  /// Sets [Shadow] as specified in request *#127*
  VxTextBuilder shadow(double offsetX, double offsetY, double blurRadius, Color color) => this
    .._hasShadow = true
    .._shadowBlur = blurRadius
    .._shadowColor = color
    .._shadowOffset = Offset(offsetX, offsetY);

  /// Sets [Shadow] blur
  VxTextBuilder shadowBlur(double blur) => this
    .._hasShadow = true
    .._shadowBlur = blur;

  /// Sets [Shadow] color
  VxTextBuilder shadowColor(Color color) => this
    .._hasShadow = true
    .._shadowColor = color;

  /// Sets [Shadow] offset
  VxTextBuilder shadowOffset(double dx, double dy) => this
    .._hasShadow = true
    .._shadowOffset = Offset(dx, dy);

  @override
  Widget make({Key? key}) {
    if (!willRender) {
      return const NoneWidget();
    }
    final sdw = [Shadow(blurRadius: _shadowBlur, color: _shadowColor, offset: _shadowOffset)];
    final baseSize = _fontSize ?? _themedStyle?.fontSize ?? _textStyle?.fontSize ?? 14.0;

    final ts = TextStyle(
      color: velocityColor,
      // The xs…xl5 presets multiply the size here rather than through a
      // TextScaler, which would replace the system text scale instead of
      // compounding with it.
      fontSize: _scaleFactor == null ? _fontSize : baseSize * _scaleFactor!,
      fontStyle: _fontStyle,
      fontFamily: _fontFamily,
      fontWeight: _fontWeight,
      letterSpacing: _letterSpacing,
      decoration: _decoration,
      height: _lineHeight,
      textBaseline: _textBaseline ?? TextBaseline.alphabetic,
      wordSpacing: _wordSpacing,
      shadows: _hasShadow ? sdw : null,
    );
    final style = _themedStyle?.merge(ts) ?? _textStyle?.merge(ts) ?? ts;
    final src = _source;

    // softWrap and overflow stay null unless set, so an ambient
    // DefaultTextStyle (e.g. an AppBar title's ellipsis) still applies.
    if (_textSpan != null) {
      return Text.rich(
        _textSpan!,
        key: key ?? src?.key,
        textAlign: _textAlign,
        maxLines: _maxLines,
        style: style,
        softWrap: _softWrap,
        overflow: _overflow,
        strutStyle: _strutStyle,
        textDirection: src?.textDirection,
        locale: src?.locale,
        textScaler: src?.textScaler,
        semanticsLabel: src?.semanticsLabel,
        semanticsIdentifier: src?.semanticsIdentifier,
        textWidthBasis: src?.textWidthBasis,
        textHeightBehavior: src?.textHeightBehavior,
        selectionColor: src?.selectionColor,
      );
    }
    return Text(
      _text ?? '',
      key: key ?? src?.key,
      textAlign: _textAlign,
      maxLines: _maxLines,
      style: style,
      softWrap: _softWrap,
      overflow: _overflow,
      strutStyle: _strutStyle,
      textDirection: src?.textDirection,
      locale: src?.locale,
      textScaler: src?.textScaler,
      semanticsLabel: src?.semanticsLabel,
      semanticsIdentifier: src?.semanticsIdentifier,
      textWidthBasis: src?.textWidthBasis,
      textHeightBehavior: src?.textHeightBehavior,
      selectionColor: src?.selectionColor,
    );
  }
}

extension VxTextExtensions on Text {
  /// Converts this [Text] into a [VxTextBuilder] for further fluent styling.
  ///
  /// Works for [Text.rich] too, and carries over the source's key, style,
  /// and layout settings (maxLines, textAlign, overflow, softWrap, strutStyle,
  /// textDirection, semanticsLabel, ...).
  VxTextBuilder get text => VxTextBuilder.fromText(this);
}

extension VxStringTextExtensions on String {
  /// Creates a [VxTextBuilder] from this string for fluent text styling.
  ///
  /// Example: `'Hello World'.text.bold.blue500.xl2.make()`
  VxTextBuilder get text => VxTextBuilder(this);
}
