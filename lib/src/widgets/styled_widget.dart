import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';

abstract class StyledWidget extends StatefulWidget {
  final String? id;
  final Style style;
  StyledWidget({
    Key? key,
    this.id,
    required this.style,
  }) : super(key: key);
}

abstract class StyledWidgetState<T extends StyledWidget> extends State<T>
    with StyledStateMixin {
  @override
  void resolveStyle() {
    screenSize = MediaQuery.of(context).size;
    Style? inheritedStyle;
    if (widget.id != null)
      inheritedStyle = NamedStyleMap.of(context)?.styles[widget.id];
    style = widget.style..merge(inheritedStyle);
  }
}
