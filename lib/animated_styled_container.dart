import 'package:flutter/material.dart';
import 'styled_widget.dart';

class AnimatedStyledContainer extends StyledWidget {
  final Widget child;
  final Duration duration;
  final Curve? curve;

  AnimatedStyledContainer({
    Key? key,
    dynamic style,
    required this.duration,
    this.curve,
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
    return _AnimatedStyledContainerState();
  }
}

class _AnimatedStyledContainerState
    extends StyledWidgetState<AnimatedStyledContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print(constraints);
      prepareStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      prepareProperties();

      return buildAnimatedStyledContainer(
          child: widget.child, duration: widget.duration, curve: widget.curve);
    });
  }
}
