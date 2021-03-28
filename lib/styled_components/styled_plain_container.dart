import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../styled_widget.dart';

class StyledPlainContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  StyledPlainContainer({
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

class _StyledContainerState extends StyledWidgetState<StyledPlainContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      resolveStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      resolveProperties();

      return buildPlainContainer(
          child: widget.child,
          onMouseEnter: widget.onMouseEnter,
          onMouseExit: widget.onMouseExit);
    });
  }
}

class AnimatedStyledPlainContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final Duration duration;
  final Curve curve;

  AnimatedStyledPlainContainer({
    Key? key,
    dynamic style,
    required this.duration,
    this.curve = Curves.linear,
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
    extends StyledWidgetState<AnimatedStyledPlainContainer> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      resolveStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      resolveProperties();

      return buildAnimatedPlainContainer(
          duration: widget.duration,
          curve: widget.curve,
          child: widget.child,
          onMouseEnter: widget.onMouseEnter,
          onMouseExit: widget.onMouseExit);
    });
  }
}
