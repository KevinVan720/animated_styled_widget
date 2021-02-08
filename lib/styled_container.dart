import 'package:flutter/material.dart';
import 'styled_widget.dart';

class StyledContainer extends StyledWidget {
  final Widget child;

  StyledContainer({
    Key? key,
    dynamic style,
    required this.child,
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
    ///in principle can make layoutwidget accept positioned as well, but that brings a lot of questions...
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      chooseStyle();
      parentMaxWidth = constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight;
      chooseProperties();

      return buildStyledContainer(child: widget.child);
    });
  }
}
