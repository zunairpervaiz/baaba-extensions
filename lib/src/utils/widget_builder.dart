import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// Being used interally by VxWidgetBuilders for eg [TextBuilder]
///
abstract class VxWidgetBuilders<T extends Widget> {
  T make({Key? key});
}

abstract class VxWidgetContextBuilder<T extends Widget> {
  T make(BuildContext context, {Key? key});
}

abstract class VxTextSpanBuilder<T> {
  T make({Key? key});
}
