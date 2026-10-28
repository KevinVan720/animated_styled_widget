import 'package:flutter/widgets.dart';

import 'style.dart';

/// Provides [styles] to the [StyledWidget]s below it: a widget whose
/// [StyledWidget.id] is a key of [styles] is styled by its own style merged
/// with that style.
class NamedStyleMap extends InheritedWidget {
  /// The closest [NamedStyleMap] ancestor, or null.
  // The return type is dynamic for compatibility.
  static dynamic of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NamedStyleMap>();

  final Map<String, Style> styles;

  const NamedStyleMap({
    super.key,
    required super.child,
    required this.styles,
  });

  @override
  bool updateShouldNotify(NamedStyleMap oldWidget) {
    return styles != oldWidget.styles;
  }
}
