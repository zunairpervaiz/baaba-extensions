import 'package:baaba_extensions/src/utils/enums.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReadMoreWidgetx extends StatefulWidget {
  final String data;
  final String trimExpandedText;
  final String trimCollapsedText;
  final Color? colorClickableText;
  final int trimLength;
  final int trimLines;
  final TrimMode trimMode;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final double? textScaleFactor;
  final String? semanticsLabel;

  const ReadMoreWidgetx(
    this.data, {
    this.trimExpandedText = 'Show less',
    this.trimCollapsedText = 'Show more',
    this.colorClickableText,
    this.trimLength = 200,
    this.trimLines = 2,
    this.trimMode = TrimMode.length,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaleFactor,
    this.semanticsLabel,
    super.key,
  });

  @override
  ReadMoreWidgetxState createState() => ReadMoreWidgetxState();
}

const String _kEllipsis = '\u2026';
const String _kLineSeparator = '\u2028';

// Returns the longest prefix of [text] that is at most [maxLength] UTF-16 code
// units long and ends on a whole character, so an emoji or other surrogate
// pair is never cut in half (which leaves an ill-formed string that throws).
String _safePrefix(String text, int maxLength) {
  var length = 0;
  for (final char in text.characters) {
    if (length + char.length > maxLength) break;
    length += char.length;
  }
  return text.substring(0, length);
}

class ReadMoreWidgetxState extends State<ReadMoreWidgetx> {
  bool _readMore = true;

  // Owned by the state rather than built in build(): a recognizer created per
  // frame is never disposed.
  late final TapGestureRecognizer _linkRecognizer;

  @override
  void initState() {
    super.initState();
    _linkRecognizer = TapGestureRecognizer()..onTap = _onTapLink;
  }

  @override
  void dispose() {
    _linkRecognizer.dispose();
    super.dispose();
  }

  void _onTapLink() {
    setState(() {
      _readMore = !_readMore;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle? effectiveTextStyle = widget.style;

    if (widget.style == null || widget.style!.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }

    final textAlign = widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;

    final textDirection = widget.textDirection ?? Directionality.of(context);

    final locale = widget.locale ?? Localizations.maybeLocaleOf(context);

    final overflow = defaultTextStyle.overflow;

    final colorClickableText = widget.colorClickableText ?? Theme.of(context).colorScheme.primary;

    TextSpan link = TextSpan(
      text: _readMore ? widget.trimCollapsedText : widget.trimExpandedText,
      style: effectiveTextStyle!.copyWith(color: colorClickableText),
      recognizer: _linkRecognizer,
    );

    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;

        final text = TextSpan(style: effectiveTextStyle, text: widget.data);

        TextPainter textPainter = TextPainter(
          text: link,
          textAlign: textAlign,
          textDirection: textDirection,
          maxLines: widget.trimLines,
          locale: locale,
          ellipsis: overflow == TextOverflow.ellipsis ? _kEllipsis : null,
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;

        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;

        bool linkLongerThanLine = false;
        int endIndex;

        if (linkSize.width < maxWidth) {
          final pos = textPainter.getPositionForOffset(Offset(textSize.width - linkSize.width, textSize.height));
          endIndex = textPainter.getOffsetBefore(pos.offset) ?? 0;
        } else {
          var pos = textPainter.getPositionForOffset(textSize.bottomLeft(Offset.zero));
          endIndex = pos.offset;
          linkLongerThanLine = true;
        }
        final didExceedMaxLines = textPainter.didExceedMaxLines;
        textPainter.dispose();

        var textSpan = TextSpan();
        switch (widget.trimMode) {
          case TrimMode.length:
            if (widget.trimLength < widget.data.length) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: _readMore ? _safePrefix(widget.data, widget.trimLength) : widget.data,
                children: <TextSpan>[link],
              );
            } else {
              textSpan = TextSpan(style: effectiveTextStyle, text: widget.data);
            }

            break;

          case TrimMode.line:
            if (didExceedMaxLines) {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: _readMore ? _safePrefix(widget.data, endIndex) + (linkLongerThanLine ? _kLineSeparator : '') : widget.data,
                children: <TextSpan>[link],
              );
            } else {
              textSpan = TextSpan(style: effectiveTextStyle, text: widget.data);
            }
            break;
        }
        return SelectableText.rich(textSpan, textAlign: textAlign, textDirection: textDirection);
      },
    );

    if (widget.semanticsLabel != null) {
      result = Semantics(
        textDirection: widget.textDirection,
        label: widget.semanticsLabel,
        child: ExcludeSemantics(child: result),
      );
    }
    return result;
  }
}
