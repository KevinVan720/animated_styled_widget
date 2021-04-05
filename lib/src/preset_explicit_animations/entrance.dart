import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

import 'base.dart';

class SlideInAnimation extends PresetAnimation {
  final AxisDirection direction;
  final Dimension distance;
  const SlideInAnimation(
      {this.distance = const Length(100, unit: LengthUnit.vmax),
      this.direction = AxisDirection.up,
      Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(duration: duration, delay: delay, curve: curve, control: control);

  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    switch (direction) {
      case AxisDirection.up:
        transform.translate(0.toPXLength, distance);
        break;
      case AxisDirection.down:
        transform.translate(0.toPXLength, -distance);
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
        ..add(value: transform, duration: Duration.zero, delay: Duration.zero)
        ..add(
            value: SmoothMatrix4(),
            duration: duration,
            delay: delay,
            curve: curve),
    });
  }
}

class FadeInAnimation extends PresetAnimation {
  const FadeInAnimation(
      {Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(duration: duration, delay: delay, curve: curve, control: control);

  MultiAnimationSequence getAnimationSequence() {
    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()
        ..add(value: 0, duration: Duration.zero, delay: Duration.zero)
        ..add(value: 1, duration: duration, delay: delay, curve: curve),
    });
  }
}

class ZoomInAnimation extends PresetAnimation {
  final double scale;
  const ZoomInAnimation(
      {this.scale = 0.001,
      Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(duration: duration, delay: delay, curve: curve, control: control);

  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    transform.scale(scale);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(value: transform, duration: Duration.zero, delay: Duration.zero)
        ..add(
            value: SmoothMatrix4(),
            duration: duration,
            delay: delay,
            curve: curve),
    });
  }
}
