import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'styled_widget.dart';

class AnimatedStyledContainer extends StyledWidget {
  final Widget child;
  final Duration duration;
  final Curve? curve;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  AnimatedStyledContainer({
    Key? key,
    dynamic style,
    required this.duration,
    this.curve,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
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
      prepareStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      prepareProperties();

      return buildAnimatedStyledContainer(
          child: widget.child,
          duration: widget.duration,
          curve: widget.curve,
          onMouseEnter: widget.onMouseEnter,
          onMouseExit: widget.onMouseExit);
    });
  }
}
