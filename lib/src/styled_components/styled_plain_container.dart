import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class StyledPlainContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  const StyledPlainContainer({
    super.key,
    super.id,
    required super.style,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  });

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

  const AnimatedStyledPlainContainer({
    super.key,
    super.id,
    required super.style,
    required this.duration,
    this.curve = Curves.linear,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
    this.onEnd,
  });

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
