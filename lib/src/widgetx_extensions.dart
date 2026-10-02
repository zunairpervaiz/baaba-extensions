import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension WidgetX on Widget {
  /// Wraps the widget in a [Center].
  Widget center() => Center(child: this);

  /// Wraps the widget in an [Expanded] with the given [flex].
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Wraps the widget in a [Flexible] with the given [flex] and [fit].
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => Flexible(flex: flex, fit: fit, child: this);

  /// Wraps the widget in an [InkWell] that calls [function] on tap.
  Widget onTap(
    Function? function, {
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? focusColor,
    WidgetStateProperty<Color?>? overlayColor,
  }) {
    return InkWell(
      onTap: function as void Function()?,
      borderRadius: borderRadius ?? BorderRadius.zero,
      splashColor: splashColor ?? Colors.transparent,
      hoverColor: hoverColor ?? Colors.transparent,
      highlightColor: highlightColor ?? Colors.transparent,
      focusColor: focusColor ?? Colors.transparent,
      overlayColor: overlayColor ?? WidgetStateProperty.all(Colors.transparent),
      child: this,
    );
  }

  /// Returns a [SizedBox] with the given [width].
  SizedBox withWidth(double width) => SizedBox(width: width, child: this);

  /// Returns a [SizedBox] with the given [height].
  SizedBox withHeight(double height) => SizedBox(height: height, child: this);

  /// Returns a [SizedBox] constrained to [width] and [height].
  SizedBox withSize({double? width, double? height}) => SizedBox(width: width, height: height, child: this);

  /// Shows or hides the widget based on [isVisible].
  Widget visible(bool isVisible, {Widget? defaultWidget}) => isVisible ? this : (defaultWidget ?? const SizedBox.shrink());

  /// Clips the widget with a per-corner radius.
  ClipRRect cornerRadiusWithClipRRectOnly({int bottomLeft = 0, int bottomRight = 0, int topLeft = 0, int topRight = 0}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft.toDouble()),
        bottomRight: Radius.circular(bottomRight.toDouble()),
        topLeft: Radius.circular(topLeft.toDouble()),
        topRight: Radius.circular(topRight.toDouble()),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: this,
    );
  }

  /// Clips the widget with a uniform corner radius.
  ClipRRect cornerRadiusWithClipRRect(double radius) {
    return ClipRRect(borderRadius: BorderRadius.all(Radius.circular(radius)), clipBehavior: Clip.antiAliasWithSaveLayer, child: this);
  }

  // ── Padding ──────────────────────────────────────────────────────────────

  /// Wraps the widget with the given [EdgeInsets] padding.
  Padding padding(EdgeInsets padding) => Padding(padding: padding, child: this);

  /// Wraps the widget with uniform padding of [value] on all sides.
  Padding paddingAll(double value) => Padding(padding: EdgeInsets.all(value), child: this);

  /// Wraps the widget with symmetric padding.
  Padding paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
    child: this,
  );

  /// Wraps the widget with padding on individual sides.
  Padding paddingOnly({double left = 0, double top = 0, double right = 0, double bottom = 0}) => Padding(
    padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
    child: this,
  );

  // ── Opacity & Transforms ─────────────────────────────────────────────────

  /// Wraps the widget in an [Opacity]. [value] is clamped to 0.0–1.0.
  Opacity opacity(double value) => Opacity(opacity: value.clamp(0.0, 1.0), child: this);

  /// Rotates the widget by [angle] radians.
  Transform rotate(double angle) => Transform.rotate(angle: angle, child: this);

  /// Scales the widget uniformly by [factor].
  Transform scale(double factor) => Transform.scale(scale: factor, child: this);

  /// Translates the widget by ([dx], [dy]) logical pixels.
  Transform translate({double dx = 0, double dy = 0}) => Transform.translate(offset: Offset(dx, dy), child: this);

  // ── Decoration ───────────────────────────────────────────────────────────

  /// Wraps the widget in a [Card].
  Card card({double? elevation, Color? color, Color? shadowColor, double? borderRadius, EdgeInsetsGeometry? margin}) => Card(
    elevation: elevation,
    color: color,
    shadowColor: shadowColor,
    margin: margin,
    shape: borderRadius != null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)) : null,
    child: this,
  );

  /// Wraps the widget in a [Tooltip] with [message].
  Tooltip tooltip(String message) => Tooltip(message: message, child: this);

  /// Wraps the widget in a [Hero] with the given [tag].
  Hero hero(Object tag) => Hero(tag: tag, child: this);

  /// Wraps the widget in a [SafeArea].
  SafeArea safeArea({bool top = true, bool bottom = true, bool left = true, bool right = true}) =>
      SafeArea(top: top, bottom: bottom, left: left, right: right, child: this);

  /// Wraps the widget in a [SliverToBoxAdapter].
  SliverToBoxAdapter get sliverBox => SliverToBoxAdapter(child: this);

  /// Renders this widget off-screen and returns it as PNG bytes, sized to the
  /// widget itself — for custom map markers, share images, or thumbnails.
  ///
  /// The widget is laid out with loose constraints up to [logicalSize]
  /// (defaults to the screen) and captured at [pixelRatio] (defaults to the
  /// device pixel ratio). It is built outside the app's tree, so it inherits
  /// no [Theme], [MediaQuery] text scale, or localizations — wrap it in those
  /// if it needs them. [waitToRender] gives images inside it time to decode
  /// before the capture.
  ///
  /// Example (a Google Maps marker):
  /// ```dart
  /// final dpr = View.of(context).devicePixelRatio;
  /// final icon = BitmapDescriptor.bytes(await markerWidget.toPngBytes(), imagePixelRatio: dpr);
  /// ```
  Future<Uint8List> toPngBytes({
    Size? logicalSize,
    double? pixelRatio,
    Duration waitToRender = const Duration(milliseconds: 300),
    TextDirection textDirection = TextDirection.ltr,
    ui.FlutterView? view,
  }) async {
    final targetView = view ?? ui.PlatformDispatcher.instance.implicitView ?? ui.PlatformDispatcher.instance.views.first;
    final size = logicalSize ?? targetView.physicalSize / targetView.devicePixelRatio;
    final capturePixelRatio = pixelRatio ?? targetView.devicePixelRatio;

    final repaintBoundary = RenderRepaintBoundary();
    final renderView = RenderView(
      view: targetView,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        logicalConstraints: BoxConstraints.tight(size),
        physicalConstraints: BoxConstraints.tight(size) * targetView.devicePixelRatio,
        devicePixelRatio: targetView.devicePixelRatio,
      ),
    );
    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    final focusManager = FocusManager();
    final buildOwner = BuildOwner(focusManager: focusManager);
    renderView.prepareInitialFrame();

    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: MediaQuery(
        // The capture ratio, so Image.asset picks the matching 2x/3x variant
        // instead of the 1x one, which would come out blurry.
        data: MediaQueryData(devicePixelRatio: capturePixelRatio),
        child: Directionality(textDirection: textDirection, child: this),
      ),
    ).attachToRenderTree(buildOwner);

    ui.Image? image;
    try {
      buildOwner.buildScope(rootElement);
      await Future<void>.delayed(waitToRender);
      buildOwner.buildScope(rootElement);
      buildOwner.finalizeTree();

      pipelineOwner
        ..flushLayout()
        ..flushCompositingBits()
        ..flushPaint();

      image = await repaintBoundary.toImage(pixelRatio: capturePixelRatio);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    } finally {
      // Tear the off-screen tree down so its State objects are disposed and
      // nothing outlives the capture — this runs once per marker.
      image?.dispose();
      RenderObjectToWidgetAdapter<RenderBox>(container: repaintBoundary).attachToRenderTree(buildOwner, rootElement);
      buildOwner
        ..buildScope(rootElement)
        ..finalizeTree();
      pipelineOwner.rootNode = null;
      pipelineOwner.dispose();
      renderView.dispose();
      focusManager.dispose();
    }
  }
}
