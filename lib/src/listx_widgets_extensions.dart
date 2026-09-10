import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

extension ListxWidgetExtensions on List<Widget> {
  /// Returns a [Row] laying these widgets out horizontally.
  Row toRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) => Row(
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    children: this,
  );

  /// Returns a [Stack] layering these widgets on top of one another.
  Stack toStack({
    Key? key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clip = Clip.hardEdge,
  }) => Stack(key: key, alignment: alignment, textDirection: textDirection, fit: fit, clipBehavior: clip, children: this);

  /// Returns a [Column] laying these widgets out vertically.
  Column toColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
  }) => Column(
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    children: this,
  );

  /// Returns a [ListView] holding these widgets.
  ///
  /// Pass [itemBuilder] to build the rows lazily instead; the item count then
  /// defaults to this list's length.
  ///
  /// There is deliberately no `toList()` here — `Iterable.toList` is an
  /// instance method, and instance members always win over extensions, so such
  /// a member could never be reached.
  ListView toListView({
    NullableIndexedWidgetBuilder? itemBuilder,
    int? itemCount,
    ChildIndexGetter? findChildIndexCallback,
    Key? key,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    bool addAutomaticKeepAlives = true,
    bool addRepaintBoundaries = true,
    bool addSemanticIndexes = true,
    int? semanticChildCount,
  }) => itemBuilder == null
      ? ListView(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticChildCount: semanticChildCount,
          children: this,
        )
      : ListView.builder(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          padding: padding,
          itemExtent: itemExtent,
          prototypeItem: prototypeItem,
          cacheExtent: cacheExtent,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticChildCount: semanticChildCount,
          findChildIndexCallback: findChildIndexCallback,
          itemCount: itemCount ?? length,
          itemBuilder: itemBuilder,
        );

  /// Returns a [Wrap] that flows these widgets onto as many lines as needed.
  ///
  /// Example: `tags.map(TagChip.new).toList().toWrap(spacing: 8)`
  Wrap toWrap({
    Key? key,
    Axis direction = Axis.horizontal,
    WrapAlignment alignment = WrapAlignment.start,
    double spacing = 8,
    WrapAlignment runAlignment = WrapAlignment.start,
    double runSpacing = 8,
    WrapCrossAlignment crossAxisAlignment = WrapCrossAlignment.start,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    Clip clipBehavior = Clip.none,
  }) => Wrap(
    key: key,
    direction: direction,
    alignment: alignment,
    spacing: spacing,
    runAlignment: runAlignment,
    runSpacing: runSpacing,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    clipBehavior: clipBehavior,
    children: this,
  );

  /// Returns a [GridView] arranging these widgets into [crossAxisCount]
  /// columns.
  ///
  /// Example: `photos.toGrid(crossAxisCount: 3, spacing: 4)`
  GridView toGrid({
    Key? key,
    int crossAxisCount = 2,
    double spacing = 8,
    double? mainAxisSpacing,
    double? crossAxisSpacing,
    double childAspectRatio = 1,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? cacheExtent,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  }) => GridView.count(
    key: key,
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: mainAxisSpacing ?? spacing,
    crossAxisSpacing: crossAxisSpacing ?? spacing,
    childAspectRatio: childAspectRatio,
    scrollDirection: scrollDirection,
    reverse: reverse,
    controller: controller,
    primary: primary,
    physics: physics,
    shrinkWrap: shrinkWrap,
    padding: padding,
    cacheExtent: cacheExtent,
    restorationId: restorationId,
    clipBehavior: clipBehavior,
    children: this,
  );

  /// Returns a [SliverList] for use inside a [CustomScrollView].
  ///
  /// Example: `CustomScrollView(slivers: [header, items.toSliverList()])`
  SliverList toSliverList({bool addAutomaticKeepAlives = true, bool addRepaintBoundaries = true, bool addSemanticIndexes = true}) =>
      SliverList(
        delegate: SliverChildListDelegate(
          this,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        ),
      );

  /// Returns a [SliverGrid] of [crossAxisCount] columns for use inside a
  /// [CustomScrollView].
  SliverGrid toSliverGrid({int crossAxisCount = 2, double spacing = 8, double? mainAxisSpacing, double? crossAxisSpacing, double childAspectRatio = 1}) =>
      SliverGrid(
        delegate: SliverChildListDelegate(this),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing ?? spacing,
          crossAxisSpacing: crossAxisSpacing ?? spacing,
          childAspectRatio: childAspectRatio,
        ),
      );

  /// Returns a [PageView] paging through these widgets.
  ///
  /// Example: `onboardingPages.toPageView(onPageChanged: (i) => setState(...))`
  PageView toPageView({
    Key? key,
    PageController? controller,
    Axis scrollDirection = Axis.horizontal,
    bool reverse = false,
    ScrollPhysics? physics,
    bool pageSnapping = true,
    ValueChanged<int>? onPageChanged,
    bool padEnds = true,
    Clip clipBehavior = Clip.hardEdge,
  }) => PageView(
    key: key,
    controller: controller,
    scrollDirection: scrollDirection,
    reverse: reverse,
    physics: physics,
    pageSnapping: pageSnapping,
    onPageChanged: onPageChanged,
    padEnds: padEnds,
    clipBehavior: clipBehavior,
    children: this,
  );

  /// Returns an [IndexedStack] showing only the child at [index].
  ///
  /// Every child stays alive and keeps its state, which is what tab bodies
  /// usually want.
  IndexedStack toIndexedStack({
    Key? key,
    int index = 0,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit sizing = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
  }) => IndexedStack(
    key: key,
    index: index,
    alignment: alignment,
    textDirection: textDirection,
    sizing: sizing,
    clipBehavior: clipBehavior,
    children: this,
  );

  /// Returns a horizontally scrolling [Row], so overflowing children scroll
  /// instead of throwing a layout error.
  SingleChildScrollView toScrollableRow({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool reverse = false,
  }) => SingleChildScrollView(
    key: key,
    scrollDirection: Axis.horizontal,
    controller: controller,
    physics: physics,
    padding: padding,
    reverse: reverse,
    child: Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: this),
  );

  /// Returns a vertically scrolling [Column].
  SingleChildScrollView toScrollableColumn({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    ScrollController? controller,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool reverse = false,
  }) => SingleChildScrollView(
    key: key,
    controller: controller,
    physics: physics,
    padding: padding,
    reverse: reverse,
    child: Column(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, mainAxisSize: MainAxisSize.min, children: this),
  );

  /// Returns a copy with [separator] inserted between every pair of children,
  /// but not before the first or after the last.
  ///
  /// Example:
  /// ```dart
  /// tiles.separatedBy(const Divider(height: 1)).toColumn()
  /// ```
  List<Widget> separatedBy(Widget separator) {
    if (length < 2) return List<Widget>.from(this);
    final result = <Widget>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) result.add(separator);
      result.add(this[i]);
    }
    return result;
  }

  /// Returns a copy with a [SizedBox] of [gap] logical pixels between every
  /// pair of children.
  ///
  /// [axis] decides whether the gap is vertical (the default, for a [Column])
  /// or horizontal (for a [Row]).
  ///
  /// Example: `fields.withSpacing(12).toColumn()`
  List<Widget> withSpacing(double gap, {Axis axis = Axis.vertical}) =>
      separatedBy(axis == Axis.vertical ? SizedBox(height: gap) : SizedBox(width: gap));

  /// Returns a copy with a [Divider] between every pair of children.
  ///
  /// Example: `rows.withDividers(indent: 16).toColumn()`
  List<Widget> withDividers({double height = 1, double thickness = 1, double indent = 0, double endIndent = 0, Color? color}) =>
      separatedBy(Divider(height: height, thickness: thickness, indent: indent, endIndent: endIndent, color: color));

  /// Wraps every child in an [Expanded], so they share the available space.
  ///
  /// Example: `[left, right].expanded().toRow()`
  List<Widget> expanded({int flex = 1}) => [for (final child in this) Expanded(flex: flex, child: child)];

  /// Wraps every child in a [Flexible].
  List<Widget> flexible({int flex = 1, FlexFit fit = FlexFit.loose}) => [
    for (final child in this) Flexible(flex: flex, fit: fit, child: child),
  ];

  /// Applies the same padding to every child.
  List<Widget> paddedAll(double value) => [for (final child in this) Padding(padding: EdgeInsets.all(value), child: child)];

  /// Applies the same symmetric padding to every child.
  List<Widget> paddedSymmetric({double horizontal = 0, double vertical = 0}) => [
    for (final child in this) Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: child),
  ];
}
