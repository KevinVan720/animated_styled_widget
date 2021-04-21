import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StyledPlainContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  StyledPlainContainer({
    Key? key,
    String? id,
    required Style style,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  }) : super(
          key: key,
          id: id,
          style: style,
        );

  @override
  State<StatefulWidget> createState() {
    return _StyledPlainContainerState();
  }
}

class _StyledPlainContainerState
    extends StyledWidgetState<StyledPlainContainer> {
  @override
  Widget build(BuildContext context) {
    resolveStyle();
    resolveProperties();

    return buildPlainContainer(
        child: widget.child,
        onMouseEnter: widget.onMouseEnter,
        onMouseExit: widget.onMouseExit);
  }
}

class AnimatedStyledPlainContainer extends StyledWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final VoidCallback? onEnd;

  AnimatedStyledPlainContainer({
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
    return _AnimatedStyledPlainContainerState();
  }
}

class _AnimatedStyledPlainContainerState
    extends StyledWidgetState<AnimatedStyledPlainContainer> {
  @override
  Widget build(BuildContext context) {
    resolveStyle();
    resolveProperties();

    return buildAnimatedPlainContainer(
        child: widget.child,
        duration: widget.duration,
        curve: widget.curve,
        onMouseEnter: widget.onMouseEnter,
        onMouseExit: widget.onMouseExit,
        onEnd: widget.onEnd);
  }
}
