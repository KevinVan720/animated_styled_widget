import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/screen_scope.dart';

import 'style.dart';

class NamedStyleMap extends InheritedWidget {
  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NamedStyleMap>();

  final Map<String, dynamic> styles;

  NamedStyleMap({
    Key? key,
    required Widget child,
    required this.styles,
  })   : assert(styles.values.every((element) {
          return element is Style || element is Map<ScreenScope, Style>;
        })),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(NamedStyleMap oldWidget) {
    return this.styles != oldWidget.styles;
  }
}
