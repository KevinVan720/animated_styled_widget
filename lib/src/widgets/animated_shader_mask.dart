import 'package:flutter/widgets.dart';

import '../custom_tweens.dart';

/// A [ShaderMask] with a gradient that animates implicitly. Without a
/// gradient, the child is not masked.
class AnimatedShaderMask extends ImplicitlyAnimatedWidget {
  /// Creates a shader mask whose [shaderGradient] animates implicitly.
  const AnimatedShaderMask({
    super.key,
    required this.shaderGradient,
    this.child,
    super.curve,
    required super.duration,
    super.onEnd,
  });

  /// The gradient of the mask.
  final Gradient? shaderGradient;

  /// The widget below this widget in the tree.
  final Widget? child;

  @override
  AnimatedWidgetBaseState<AnimatedShaderMask> createState() =>
      _AnimatedShaderMaskState();
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
