import 'package:flutter/material.dart';

class GradientTween extends Tween<Gradient?> {
  /// Provide a begin and end Gradient. To fade between.
  GradientTween({
    Gradient? begin,
    Gradient? end,
  }) : super(begin: begin, end: end);

  @override
  Gradient? lerp(double t) => Gradient.lerp(begin, end, t);
}

class AnimatedShaderMask extends ImplicitlyAnimatedWidget {
  /// Creates a widget that insets its child by a value that animates
  /// implicitly.
  ///
  /// The [padding], [curve], and [duration] arguments must not be null.
  AnimatedShaderMask({
    Key? key,
    required this.shaderGradient,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// The amount of space by which to inset the child.
  final Gradient? shaderGradient;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  _AnimatedShaderMaskState createState() => _AnimatedShaderMaskState();
}

class _AnimatedShaderMaskState
    extends AnimatedWidgetBaseState<AnimatedShaderMask> {
  GradientTween? _gradient;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gradient = visitor(_gradient, widget.shaderGradient,
            (dynamic value) => GradientTween(begin: value as Gradient?))
        as GradientTween?;
  }

  @override
  Widget build(BuildContext context) {
    Gradient? gradient = _gradient?.evaluate(animation);
    return gradient != null
        ? ShaderMask(
            shaderCallback: (Rect bounds) {
              return gradient.createShader(bounds);
            },
            child: widget.child,
          )
        : widget.child ?? Container();
  }
}
