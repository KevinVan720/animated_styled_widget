import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class AnimatedStyledContainer extends StyledWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final VoidCallback? onEnd;

  AnimatedStyledContainer({
    Key? key,
    String? id,
    required Style style,
    required this.duration,
    this.curve = Curves.linear,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
    this.onEnd,
  }) : super(
          key: key,
          id: id,
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
    resolveStyle();
    resolveProperties();

    return buildAnimatedStyledContainer(
        child: widget.child,
        duration: widget.duration,
        curve: widget.curve,
        onMouseEnter: widget.onMouseEnter,
        onMouseExit: widget.onMouseExit,
        onEnd: widget.onEnd);
  }
}
