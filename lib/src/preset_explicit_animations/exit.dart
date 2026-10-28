import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';

class SlideOutAnimation extends PresetAnimation {
  final AxisDirection direction;
  final Dimension distance;
  const SlideOutAnimation(
      {this.distance = const Length(100, unit: LengthUnit.vmax),
      this.direction = AxisDirection.up,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    switch (direction) {
      case AxisDirection.up:
        transform.translate(0.toPXLength, -distance);
        break;
      case AxisDirection.down:
        transform.translate(0.toPXLength, distance);
        break;
      case AxisDirection.left:
        transform.translate(-distance, 0.toPXLength);
        break;
      case AxisDirection.right:
        transform.translate(distance, 0.toPXLength);
        break;
    }
    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(value: transform, duration: duration, delay: delay, curve: curve),
    });
  }
}

class FadeOutAnimation extends PresetAnimation {
  const FadeOutAnimation(
      {super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()
        ..add(value: 1, duration: Duration.zero, delay: Duration.zero)
        ..add(value: 0, duration: duration, delay: delay, curve: curve),
    });
  }
}

class ZoomOutAnimation extends PresetAnimation {
  final double scale;
  const ZoomOutAnimation(
      {this.scale = 0.001,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    transform.scale(scale);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(value: transform, duration: duration, delay: delay, curve: curve),
    });
  }
}
