import 'package:flutter/material.dart';

import 'style.dart';

class NamedStyleMap extends InheritedWidget {
  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NamedStyleMap>();

  final Map<String, StyleBase> styles;

  NamedStyleMap({
    Key? key,
    required Widget child,
    required this.styles,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(NamedStyleMap oldWidget) {
    return this.styles != oldWidget.styles;
  }
}
