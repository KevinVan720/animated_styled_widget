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
  }) : super(
          key: key,
          style: style,
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
      chooseStyle();
      parentMaxWidth = constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight;
      chooseProperties();

      return buildAnimatedStyledContainer(
          child: widget.child, duration: widget.duration, curve: widget.curve);
    });
  }
}
