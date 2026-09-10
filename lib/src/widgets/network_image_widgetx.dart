import 'package:flutter/material.dart';

import 'skeleton_loader_widgetx.dart';

/// A network image with a shimmering placeholder, an error fallback, rounded
/// corners, and a fade-in — the four things [Image.network] leaves to you.
///
/// A null or blank [url] goes straight to the error state, so a missing avatar
/// or product photo does not need a null check at every call site.
///
/// Example:
/// ```dart
/// NetworkImageWidgetx(
///   url: product.imageUrl,
///   width: double.infinity,
///   height: 180,
///   borderRadius: 12,
/// )
///
/// // A circular avatar with initials as the fallback.
/// NetworkImageWidgetx.circle(
///   url: user.avatarUrl,
///   size: 48,
///   errorWidget: Text(user.initials),
/// )
/// ```
class NetworkImageWidgetx extends StatelessWidget {
  /// The image URL. A null or blank value renders [errorWidget].
  final String? url;

  /// Width of the image box.
  final double? width;

  /// Height of the image box.
  final double? height;

  /// How the image is inscribed into its box. Defaults to [BoxFit.cover].
  final BoxFit fit;

  /// Corner radius. Ignored when [isCircle] is `true`.
  final double borderRadius;

  /// Clips the image to a circle. Set by [NetworkImageWidgetx.circle].
  final bool isCircle;

  /// Shown while the image is downloading.
  /// Defaults to a [SkeletonLoaderWidgetx] the size of the image box.
  final Widget? placeholder;

  /// Shown when the URL is missing or the download fails.
  /// Defaults to a muted broken-image icon on a neutral background.
  final Widget? errorWidget;

  /// Renders a determinate spinner instead of [placeholder] once the server
  /// reports a content length.
  final bool showProgress;

  /// Duration of the fade-in once the image has decoded.
  final Duration fadeDuration;

  /// Background colour behind the image, visible while it loads and in the
  /// error state.
  final Color? backgroundColor;

  /// Tag for a [Hero] transition. When null no hero is created.
  final Object? heroTag;

  /// Called when the image is tapped.
  final VoidCallback? onTap;

  /// Border drawn around the image box.
  final BoxBorder? border;

  /// HTTP headers sent with the request — an auth token, for example.
  final Map<String, String>? headers;

  /// Description announced by screen readers.
  final String? semanticLabel;

  /// Number of device pixels per logical pixel to decode at. Leave null to
  /// decode at full resolution.
  final int? cacheWidth;

  const NetworkImageWidgetx({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
    this.showProgress = false,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.heroTag,
    this.onTap,
    this.border,
    this.headers,
    this.semanticLabel,
    this.cacheWidth,
  }) : isCircle = false;

  /// A circular image of the given [size] — an avatar, in practice.
  const NetworkImageWidgetx.circle({
    super.key,
    required this.url,
    required double size,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.showProgress = false,
    this.fadeDuration = const Duration(milliseconds: 300),
    this.backgroundColor,
    this.heroTag,
    this.onTap,
    this.border,
    this.headers,
    this.semanticLabel,
    this.cacheWidth,
  }) : isCircle = true,
       width = size,
       height = size,
       borderRadius = 0;

  bool get _hasUrl => url != null && url!.trim().isNotEmpty;

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) return placeholder!;
    return SkeletonLoaderWidgetx(
      // A skeleton needs concrete bounds; an unconstrained image falls back to
      // a small block rather than trying to fill infinity.
      width: width ?? 80,
      height: height ?? 80,
      borderRadius: isCircle ? BorderRadius.circular((width ?? 80) / 2) : BorderRadius.circular(borderRadius),
    );
  }

  Widget _buildError(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (errorWidget != null) {
      return Container(
        width: width,
        height: height,
        color: backgroundColor ?? scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: errorWidget,
      );
    }
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined, size: _iconSizeFor(width, height), color: scheme.onSurface.withValues(alpha: 0.35)),
    );
  }

  static double _iconSizeFor(double? width, double? height) {
    final box = [width, height].whereType<double>().where((v) => v.isFinite).fold<double?>(null, (a, b) => a == null || b < a ? b : a);
    if (box == null) return 28;
    return (box * 0.35).clamp(16, 40);
  }

  @override
  Widget build(BuildContext context) {
    Widget image = _hasUrl
        ? Image.network(
            url!,
            width: width,
            height: height,
            fit: fit,
            headers: headers,
            cacheWidth: cacheWidth,
            semanticLabel: semanticLabel,
            errorBuilder: (context, _, _) => _buildError(context),
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              if (!showProgress) return _buildPlaceholder(context);
              final total = progress.expectedTotalBytes;
              return Container(
                width: width,
                height: height,
                color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    // A server that omits Content-Length leaves the spinner
                    // indeterminate instead of stuck at zero.
                    value: total == null ? null : progress.cumulativeBytesLoaded / total,
                  ),
                ),
              );
            },
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(opacity: frame == null ? 0 : 1, duration: fadeDuration, curve: Curves.easeOut, child: child);
            },
          )
        : _buildError(context);

    image = isCircle
        ? ClipOval(child: image)
        : (borderRadius > 0 ? ClipRRect(borderRadius: BorderRadius.circular(borderRadius), child: image) : image);

    if (border != null) {
      image = Container(
        decoration: BoxDecoration(
          border: border,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(borderRadius),
        ),
        child: image,
      );
    }

    if (heroTag != null) image = Hero(tag: heroTag!, child: image);
    if (onTap != null) {
      image = GestureDetector(onTap: onTap, behavior: HitTestBehavior.opaque, child: image);
    }

    return image;
  }
}
