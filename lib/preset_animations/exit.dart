import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/smooth_matrix4.dart';
import 'package:responsive_styled_widget/styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

import '../named_animation.dart';
import 'base.dart';

class SlideOutAnimation extends PresetAnimation {
  AxisDirection direction;
  Dimension? distance;
  SlideOutAnimation(
      {this.distance,
      this.direction = AxisDirection.up,
      Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(
            duration: duration, delay: delay, curve: curve, control: control) {
    if (distance == null) {
      if (direction == AxisDirection.up || direction == AxisDirection.down) {
        distance = 100.toVHLength;
      } else {
        distance = 100.toVWLength;
      }
    }
  }

  MultiAnimationSequence getAnimationSequences() {
    SmoothMatrix4 transform = SmoothMatrix4();
    switch (direction) {
      case AxisDirection.up:
        transform.translate(0.toPXLength, -distance!);
        break;
      case AxisDirection.down:
        transform.translate(0.toPXLength, distance!);
        break;
      case AxisDirection.left:
        transform.translate(-distance!, 0.toPXLength);
        break;
      case AxisDirection.right:
        transform.translate(distance!, 0.toPXLength);
        break;
    }
    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty
          .transform: AnimationSequence<SmoothMatrix4>(animationData: [])
        ..add(value: transform, duration: duration, delay: delay, curve: curve),
    });
  }
}

class FadeOutAnimation extends PresetAnimation {
  FadeOutAnimation(
      {Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(duration: duration, delay: delay, curve: curve, control: control);

  MultiAnimationSequence getAnimationSequences() {
    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.opacity: AnimationSequence<double>(animationData: [])
        ..add(value: 1, duration: Duration.zero, delay: Duration.zero)
        ..add(value: 0, duration: duration, delay: delay, curve: curve),
    });
  }
}

class ZoomOutAnimation extends PresetAnimation {
  double scale;
  ZoomOutAnimation(
      {this.scale = 0.01,
      Duration duration = const Duration(seconds: 1),
      Duration delay = Duration.zero,
      Curve curve = Curves.linear,
      CustomAnimationControl control = CustomAnimationControl.PLAY})
      : super(duration: duration, delay: delay, curve: curve, control: control);

  MultiAnimationSequence getAnimationSequences() {
    SmoothMatrix4 transform = SmoothMatrix4();
    transform.scale(scale);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty
          .transform: AnimationSequence<SmoothMatrix4>(animationData: [])
        ..add(value: transform, duration: duration, delay: delay, curve: curve),
    });
  }
}
