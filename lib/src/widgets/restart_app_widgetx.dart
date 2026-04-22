import 'package:flutter/material.dart';

class RestartAppWidgetx extends StatefulWidget {
  final Widget child;
  const RestartAppWidgetx({super.key, required this.child});

  @override
  RestartAppWidgetxState createState() => RestartAppWidgetxState();

  static void init(BuildContext context) => context.findAncestorStateOfType<RestartAppWidgetxState>()?.restartApp();
}

class RestartAppWidgetxState extends State<RestartAppWidgetx> {
  Key key = UniqueKey();
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(key: key, child: widget.child);
  }
}
