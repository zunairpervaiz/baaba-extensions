import 'dart:async';

import 'package:flutter/material.dart';

class SwiperWidgetx extends StatefulWidget {
  /// The widgets to be shown in the carousel of default constructor
  final List<Widget>? items;

  /// The widget item builder that will be used to build item on demand
  final IndexedWidgetBuilder? itemBuilder;

  /// The widgets count that should be shown at carousel
  final int itemCount;

  /// Set carousel height and overrides any existing [aspectRatio].
  final double? height;

  /// Aspect ratio is used if no height have been declared.
  ///
  /// Defaults to 16:9 aspect ratio.
  final double aspectRatio;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 0.8, which means each page fills 80% of the carousel.
  final num viewportFraction;

  /// The initial page to show when first creating the [SwiperWidgetX].
  ///
  /// Defaults to 0.
  final num initialPage;

  /// The actual index of the [PageView].
  ///
  /// This value can be ignored unless you know the carousel will be scrolled
  /// backwards more then 10000 pages.
  /// Defaults to 10000 to simulate infinite backwards scrolling.
  final num realPage;

  ///Determines if carousel should loop infinitely or be limited to item length.
  ///
  ///Defaults to true, i.e. infinite loop.
  final bool enableInfiniteScroll;

  /// Reverse the order of items if set to true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// Enables auto play, sliding one page at a time.
  ///
  /// Use [autoPlayInterval] to determent the frequency of slides.
  /// Defaults to false.
  final bool autoPlay;

  /// Sets Duration to determent the frequency of slides when
  ///
  /// [autoPlay] is set to true.
  /// Defaults to 4 seconds.
  final Duration autoPlayInterval;

  /// The animation duration between two transitioning pages while in auto playback.
  ///
  /// Defaults to 800 ms.
  final Duration autoPlayAnimationDuration;

  /// Determines the animation curve physics.
  ///
  /// Defaults to [Curves.fastOutSlowIn].
  final Curve autoPlayCurve;

  /// Sets a timer on touch detected that pause the auto play with
  /// the given [Duration].
  ///
  /// Touch Detection is only active if [autoPlay] is true.
  final Duration? pauseAutoPlayOnTouch;

  /// Determines if current page should be larger then the side images,
  /// creating a feeling of depth in the carousel.
  ///
  /// Defaults to false.
  final bool? enlargeCenterPage;

  /// The axis along which the page view scrolls.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis scrollDirection;

  /// Called whenever the page in the center of the viewport changes.
  final Function(int index)? onPageChanged;

  /// How the carousel should respond to user input.
  ///
  /// For example, determines how the items continues to animate after the
  /// user stops dragging the page view.
  ///
  /// The physics are modified to snap to page boundaries using
  /// [PageScrollPhysics] prior to being used.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? scrollPhysics;

  /// The [PageController] driving the carousel's [PageView].
  ///
  /// It is created, owned and disposed by the carousel's state, built from
  /// [viewportFraction], [initialPage], [realPage] and [enableInfiniteScroll],
  /// and recreated only when one of those changes. It is available only while
  /// this widget is the one mounted; reading it otherwise throws a
  /// [StateError].
  PageController get pageController =>
      _controllerHolder.controller ?? (throw StateError('SwiperWidgetx: pageController is only available while the carousel is mounted.'));

  // Lets the state hand its controller to the widget methods below without the
  // widget creating (and leaking) a controller of its own on every rebuild.
  final _SwiperControllerHolder _controllerHolder;

  /// [isFastScrollingEnabled] can be used to scrolling fast the [PageView].
  /// But it will not work if [autoPlay] is enabled. It also sets the [scrollPhysics] to [ClampingScrollPhysics].
  final bool isFastScrollingEnabled;

  Future<void> nextPage({required Duration duration, required Curve curve}) {
    return pageController.nextPage(duration: duration, curve: curve);
  }

  /// Animates the controlled [SwiperWidgetX] to the previous page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> previousPage({required Duration duration, required Curve curve}) {
    return pageController.previousPage(duration: duration, curve: curve);
  }

  /// Changes which page is displayed in the controlled [SwiperWidgetX].
  ///
  /// Jumps the page position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToPage(int page) {
    final index = _getRealIndex(pageController.page!.toInt(), (realPage - initialPage).toInt(), itemCount);
    return pageController.jumpToPage(pageController.page!.toInt() + page - index);
  }

  /// Animates the controlled [SwiperWidgetX] from the current page to the given page.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  Future<void> animateToPage(int page, {required Duration duration, required Curve curve}) {
    final index = _getRealIndex(pageController.page!.toInt(), (realPage - initialPage).toInt(), itemCount);
    return pageController.animateToPage(pageController.page!.toInt() + page - index, duration: duration, curve: curve);
  }

  SwiperWidgetx({
    super.key,
    required List<Widget> this.items,
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    int realPage = 10000,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnTouch,
    this.enlargeCenterPage = false,
    this.onPageChanged,
    this.scrollPhysics,
    this.isFastScrollingEnabled = false,
    this.scrollDirection = Axis.horizontal,
  }) : realPage = enableInfiniteScroll ? realPage + initialPage : initialPage,
       itemCount = items.length,
       itemBuilder = null,
       _controllerHolder = _SwiperControllerHolder();

  SwiperWidgetx.builder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height,
    this.aspectRatio = 16 / 9,
    this.viewportFraction = 0.8,
    this.initialPage = 0,
    int realPage = 10000,
    this.enableInfiniteScroll = true,
    this.reverse = false,
    this.autoPlay = false,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.pauseAutoPlayOnTouch,
    this.enlargeCenterPage = false,
    this.onPageChanged,
    this.scrollPhysics,
    this.isFastScrollingEnabled = false,
    this.scrollDirection = Axis.horizontal,
  }) : realPage = enableInfiniteScroll ? realPage + initialPage : initialPage,
       items = null,
       _controllerHolder = _SwiperControllerHolder();

  @override
  SwiperWidgetxState createState() => SwiperWidgetxState();
}

class _SwiperControllerHolder {
  PageController? controller;
}

class SwiperWidgetxState extends State<SwiperWidgetx> with TickerProviderStateMixin {
  Timer? timer;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = _createController();
    widget._controllerHolder.controller = _controller;
    timer = getTimer();
  }

  // widget.realPage already folds in initialPage and enableInfiniteScroll.
  PageController _createController() => PageController(viewportFraction: widget.viewportFraction.toDouble(), initialPage: widget.realPage.toInt());

  @override
  void didUpdateWidget(covariant SwiperWidgetx oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewportFraction != widget.viewportFraction ||
        oldWidget.initialPage != widget.initialPage ||
        oldWidget.realPage != widget.realPage ||
        oldWidget.enableInfiniteScroll != widget.enableInfiniteScroll) {
      final previous = _controller;
      _controller = _createController();
      // The PageView detaches from the old controller during this frame's
      // build, so it is only safe to dispose once the frame is done.
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
    if (!identical(oldWidget._controllerHolder, widget._controllerHolder)) oldWidget._controllerHolder.controller = null;
    widget._controllerHolder.controller = _controller;
  }

  Timer? getTimer() {
    return widget.autoPlay
        ? Timer.periodic(widget.autoPlayInterval, (_) {
            if (widget.itemCount <= 0 || !_controller.hasClients) return;
            _controller.nextPage(duration: widget.autoPlayAnimationDuration, curve: widget.autoPlayCurve);
          })
        : null;
  }

  void pauseOnTouch() {
    timer?.cancel();
    timer = Timer(widget.pauseAutoPlayOnTouch!, () {
      timer = getTimer();
    });
  }

  Widget fastScrollWidget(Widget child) {
    int? t;
    late double p;
    return Listener(
      onPointerMove: (pos) {
        if (t == null || DateTime.now().millisecondsSinceEpoch - t! > 100) {
          t = DateTime.now().millisecondsSinceEpoch;
          p = pos.position.dx;
        } else {
          final double v = (p - pos.position.dx) / (DateTime.now().millisecondsSinceEpoch - t!);
          if (v < -2 || v > 2) {
            final vx = (v * 1.2).isFinite ? (v * 1.2).round() : 0;
            _controller.animateToPage(
              _controller.page!.toInt() + vx,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeOutCubic,
            );
          }
        }
      },
      child: child,
    );
  }

  Widget getWrapper(Widget child) {
    if (widget.height != null) {
      final Widget wrapper = SizedBox(height: widget.height, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : (widget.isFastScrollingEnabled ? fastScrollWidget(wrapper) : wrapper);
    } else {
      final Widget wrapper = AspectRatio(aspectRatio: widget.aspectRatio, child: child);
      return widget.autoPlay && widget.pauseAutoPlayOnTouch != null
          ? addGestureDetection(wrapper)
          : (widget.isFastScrollingEnabled ? fastScrollWidget(wrapper) : wrapper);
    }
  }

  Widget addGestureDetection(Widget child) {
    return GestureDetector(onPanDown: (_) => pauseOnTouch(), child: child);
  }

  @override
  void dispose() {
    timer?.cancel();
    widget._controllerHolder.controller = null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nothing to page through; the item lookups below would otherwise index an
    // empty list (or call itemBuilder with a phantom index 0).
    if (widget.itemCount <= 0) return const SizedBox.shrink();

    return getWrapper(
      PageView.builder(
        physics: widget.isFastScrollingEnabled ? ClampingScrollPhysics() : widget.scrollPhysics,
        scrollDirection: widget.scrollDirection,
        controller: _controller,
        reverse: widget.reverse,
        itemCount: widget.enableInfiniteScroll ? null : widget.itemCount,
        onPageChanged: (int index) {
          final int currentPage = _getRealIndex(index + widget.initialPage.toInt(), widget.realPage.toInt(), widget.itemCount);
          if (widget.onPageChanged != null) {
            widget.onPageChanged!(currentPage);
          }
        },
        itemBuilder: (context, i) {
          final int index = _getRealIndex(i + widget.initialPage.toInt(), widget.realPage.toInt(), widget.itemCount);
          return AnimatedBuilder(
            animation: _controller,
            child: (widget.items != null ? widget.items![index] : widget.itemBuilder!(context, index)),
            builder: (BuildContext context, child) {
              double? distortionValue = 1.0;
              if (widget.enlargeCenterPage != null && widget.enlargeCenterPage == true) {
                double itemOffset;
                try {
                  itemOffset = _controller.page! - i;
                } catch (e) {
                  final BuildContext storageContext = _controller.position.context.storageContext;
                  final double? previousSavedPosition = PageStorage.of(storageContext).readState(storageContext) as double?;

                  if (previousSavedPosition != null) {
                    itemOffset = previousSavedPosition - i.toDouble();
                  } else {
                    itemOffset = widget.realPage.toDouble() - i.toDouble();
                  }
                }
                final distortionRatio = (1 - (itemOffset.abs() * 0.3)).clamp(0.0, 1.0);
                distortionValue = Curves.easeOut.transform(distortionRatio);
              }
              final double height = widget.height ?? MediaQuery.sizeOf(context).width * (1 / widget.aspectRatio);

              if (widget.scrollDirection == Axis.horizontal) {
                return Center(
                  child: SizedBox(height: distortionValue * height, child: child),
                );
              } else {
                return Center(
                  child: SizedBox(width: distortionValue * MediaQuery.sizeOf(context).width, child: child),
                );
              }
            },
          );
        },
      ),
    );
  }
}

int _getRealIndex(int position, int base, int length) {
  final int offset = position - base;
  return _remainder(offset, length);
}

int _remainder(int input, int source) {
  if (source == 0) {
    return 0;
  }
  final int result = input % source;
  return result < 0 ? source + result : result;
}
