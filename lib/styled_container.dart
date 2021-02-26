import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'styled_widget.dart';

class StyledContainer extends StyledWidget {
  final Widget child;

  StyledContainer({
    Key? key,
    dynamic style,
    required this.child,
    onMouseEnter,
    onMouseHover,
    onMouseExit,
  }) : super(
          key: key,
          style: style,
          onMouseEnter: onMouseEnter,
          onMouseHover: onMouseHover,
          onMouseExit: onMouseExit,
        );

  @override
  State<StatefulWidget> createState() {
    return _StyledContainerState();
  }
}

class _StyledContainerState extends StyledWidgetState<StyledContainer> {
  @override
  Widget build(BuildContext context) {
    ///in principle can make layoutwidget accept positioned as well, but that brings a lot of questions...
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

      return buildStyledContainer(child: widget.child);
    });
  }
}
