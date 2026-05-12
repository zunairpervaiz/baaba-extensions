import 'package:flutter/material.dart';

/// A star rating widget for both input and read-only display.
///
/// Supports full stars or half-stars when [allowHalfRating] is true.
///
/// Example:
/// ```dart
/// RatingWidgetx(
///   initialRating: 3.5,
///   allowHalfRating: true,
///   onRatingChanged: (r) => print(r),
/// )
/// ```
class RatingWidgetx extends StatefulWidget {
  final double initialRating;
  final int starCount;
  final double size;
  final Color filledColor;
  final Color unfilledColor;
  final bool readOnly;
  final void Function(double rating)? onRatingChanged;
  final bool allowHalfRating;
  final IconData filledIcon;
  final IconData unfilledIcon;
  final IconData halfFilledIcon;
  final double spacing;

  const RatingWidgetx({
    super.key,
    this.initialRating = 0,
    this.starCount = 5,
    this.size = 28,
    this.filledColor = const Color(0xFFFFC107),
    this.unfilledColor = const Color(0xFFBDBDBD),
    this.readOnly = false,
    this.onRatingChanged,
    this.allowHalfRating = false,
    this.filledIcon = Icons.star_rounded,
    this.unfilledIcon = Icons.star_outline_rounded,
    this.halfFilledIcon = Icons.star_half_rounded,
    this.spacing = 2,
  });

  @override
  State<RatingWidgetx> createState() => _RatingWidgetxState();
}

class _RatingWidgetxState extends State<RatingWidgetx> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating
        .clamp(0.0, widget.starCount.toDouble());
  }

  void _onTap(int starNumber, TapDownDetails details) {
    if (widget.readOnly) return;
    double newRating;
    if (widget.allowHalfRating &&
        details.localPosition.dx < widget.size / 2) {
      newRating = starNumber - 0.5;
    } else {
      newRating = starNumber.toDouble();
    }
    setState(() => _rating = newRating);
    widget.onRatingChanged?.call(_rating);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.starCount, (i) {
        final starNumber = i + 1;
        final IconData icon;
        final Color color;

        if (_rating >= starNumber) {
          icon = widget.filledIcon;
          color = widget.filledColor;
        } else if (widget.allowHalfRating && _rating >= starNumber - 0.5) {
          icon = widget.halfFilledIcon;
          color = widget.filledColor;
        } else {
          icon = widget.unfilledIcon;
          color = widget.unfilledColor;
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
          child: GestureDetector(
            onTapDown: widget.readOnly
                ? null
                : (details) => _onTap(starNumber, details),
            child: Icon(icon, size: widget.size, color: color),
          ),
        );
      }),
    );
  }
}
