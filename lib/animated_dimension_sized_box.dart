import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/dimension_sized_box.dart';

class AnimatedDimensionSizedBox extends ImplicitlyAnimatedWidget {
  /// Creates a widget that insets its child by a value that animates
  /// implicitly.
  ///
  /// The [padding], [curve], and [duration] arguments must not be null.
  AnimatedDimensionSizedBox({
    Key? key,
    this.width,
    this.height,
    this.alignment,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// The amount of space by which to inset the child.
  final Dimension? width;
  final Dimension? height;
  final Alignment? alignment;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  _AnimatedDimensionSizedBoxState createState() =>
      _AnimatedDimensionSizedBoxState();
}

class _AnimatedDimensionSizedBoxState
    extends AnimatedWidgetBaseState<AnimatedDimensionSizedBox> {
  DimensionTween? _width;
  DimensionTween? _height;
  AlignmentTween? _alignment;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _width = visitor(_width, widget.width,
            (dynamic value) => DimensionTween(begin: value as Dimension?))
        as DimensionTween?;
    _height = visitor(_height, widget.height,
            (dynamic value) => DimensionTween(begin: value as Dimension?))
        as DimensionTween?;

    _alignment = visitor(_alignment, widget.alignment,
            (dynamic value) => AlignmentTween(begin: value as Alignment?))
        as AlignmentTween?;
  }

  @override
  Widget build(BuildContext context) {
    return DimensionSizedBox(
      child: widget.child,
      width: _width?.evaluate(animation),
      height: _height?.evaluate(animation),
      alignment: _alignment?.evaluate(animation) ?? Alignment.center,
    );
  }
}
