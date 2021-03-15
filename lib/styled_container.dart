import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'styled_widget.dart';

class StyledContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  StyledContainer({
    Key? key,
    dynamic style,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  }) : super(
          key: key,
          style: style,
        );

  @override
  State<StatefulWidget> createState() {
    return _StyledContainerState();
  }
}

class _StyledContainerState extends StyledWidgetState<StyledContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      prepareStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      prepareProperties();

      return buildStyledContainer(
          child: widget.child,
          onMouseEnter: widget.onMouseEnter,
          onMouseExit: widget.onMouseExit);
    });
  }
}
