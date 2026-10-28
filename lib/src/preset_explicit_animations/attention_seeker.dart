import 'dart:math';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';

class FlipAnimation extends PresetAnimation {
  final Axis direction;
  final double angle;
  const FlipAnimation(
      {this.direction = Axis.vertical,
      this.angle = pi,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    switch (direction) {
      case Axis.vertical:
        transform.rotateY(angle);
        break;
      case Axis.horizontal:
        transform.rotateX(angle);
        break;
    }

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(value: transform, duration: duration, delay: delay, curve: curve),
    });
  }
}

class FlashAnimation extends PresetAnimation {
  final int repeats;
  const FlashAnimation(
      {this.repeats = 3,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve});

  @override
  MultiAnimationSequence getAnimationSequence() {
    Duration singleDuration =
        Duration(milliseconds: (duration.inMilliseconds / repeats / 2).round());
    var sequence = AnimationSequence<double>();

    for (int i = 0; i < repeats; i++) {
      if (i == 0) {
        sequence.add(value: 1, duration: Duration.zero, delay: delay);
      } else {
        sequence.add(value: 1, duration: singleDuration, curve: curve);
      }
      sequence.add(value: 0, duration: singleDuration, curve: curve);
    }
    sequence.add(value: 1, duration: singleDuration, curve: curve);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.opacity: sequence,
    });
  }
}

class PulseAnimation extends PresetAnimation {
  final double scale;
  const PulseAnimation(
      {this.scale = 1.5,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    SmoothMatrix4 transform = SmoothMatrix4();
    transform.scale(scale);

    Duration halfDuration =
        Duration(milliseconds: (duration.inMilliseconds / 2).round());

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(
            value: transform,
            duration: halfDuration,
            delay: delay,
            curve: curve)
        ..add(value: SmoothMatrix4(), duration: halfDuration, curve: curve),
    });
  }
}

class SwingAnimation extends PresetAnimation {
  final int repeats;
  final double angle;
  final Alignment alignment;
  const SwingAnimation(
      {this.alignment = Alignment.topCenter,
      this.repeats = 2,
      this.angle = pi / 12,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    Duration singleDuration =
        Duration(milliseconds: (duration.inMilliseconds / repeats / 2).round());
    var sequence = AnimationSequence<SmoothMatrix4>();

    for (int i = 0; i < repeats; i++) {
      if (i == 0) {
        sequence.add(
            value: SmoothMatrix4()..rotateZ(angle),
            duration: Duration.zero,
            delay: delay);
      } else {
        sequence.add(
            value: SmoothMatrix4()..rotateZ(angle - i / repeats * angle),
            duration: singleDuration,
            curve: curve);
      }

      sequence.add(
          value: SmoothMatrix4()..rotateZ(-(angle - i / repeats * angle)),
          duration: singleDuration,
          curve: curve);
    }
    sequence.add(
        value: SmoothMatrix4()..rotateZ(0),
        duration: singleDuration,
        curve: curve);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transformAlignment: AnimationSequence<Alignment>()
        ..add(value: alignment, duration: Duration.zero),
      AnimationProperty.transform: sequence,
    });
  }
}

class WobbleAnimation extends PresetAnimation {
  final int repeats;
  final double angle;
  final Dimension translation;
  final Alignment alignment;
  const WobbleAnimation(
      {this.alignment = Alignment.bottomCenter,
      this.repeats = 3,
      this.angle = pi / 30,
      this.translation = const Length(5),
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    Duration singleDuration =
        Duration(milliseconds: (duration.inMilliseconds / repeats / 2).round());
    var sequence = AnimationSequence<SmoothMatrix4>();

    for (int i = 0; i < repeats; i++) {
      if (i == 0) {
        sequence.add(
            value: SmoothMatrix4()
              ..translate(translation)
              ..rotateZ(angle),
            duration: Duration.zero,
            delay: delay);
      } else {
        sequence.add(
            value: SmoothMatrix4()
              ..translate(translation..scale(i / repeats))
              ..rotateZ(angle - i / repeats * angle),
            duration: singleDuration,
            curve: curve);
      }

      sequence.add(
          value: SmoothMatrix4()
            ..translate(-translation
              ..scale(i / repeats))
            ..rotateZ(-(angle - i / repeats * angle)),
          duration: singleDuration,
          curve: curve);
    }
    sequence.add(
        value: SmoothMatrix4(), duration: singleDuration, curve: curve);

    return MultiAnimationSequence(control: control, sequences: {
      AnimationProperty.transformAlignment: AnimationSequence<Alignment>()
        ..add(value: alignment, duration: Duration.zero),
      AnimationProperty.transform: sequence,
    });
  }
}

// The primary colors of the material color swatches, which were used before.
const Color _red = Color(0xFFF44336);
const Color _orange = Color(0xFFFF9800);
const Color _yellow = Color(0xFFFFEB3B);
const Color _green = Color(0xFF4CAF50);
const Color _blue = Color(0xFF2196F3);
const Color _indigo = Color(0xFF3F51B5);
const Color _purple = Color(0xFF9C27B0);

class RainbowAnimation extends PresetAnimation {
  const RainbowAnimation(
      {super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    // Characterization: the six transitions take 6/7 of the duration.
    Duration singleDuration =
        Duration(milliseconds: (duration.inMilliseconds / 7).round());
    var sequence = AnimationSequence<BoxDecoration>();

    sequence.add(
        value: const BoxDecoration(color: _red),
        duration: Duration.zero,
        delay: delay);
    sequence.add(
        value: const BoxDecoration(color: _orange),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(color: _yellow),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(color: _green),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(color: _blue),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(color: _indigo),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(color: _purple),
        duration: singleDuration,
        curve: curve);

    return MultiAnimationSequence(
        control: control,
        sequences: {AnimationProperty.backgroundDecoration: sequence});
  }
}

class RainbowLinearGradientAnimation extends PresetAnimation {
  const RainbowLinearGradientAnimation(
      {super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    // Characterization: the six transitions take 6/7 of the duration.
    Duration singleDuration =
        Duration(milliseconds: (duration.inMilliseconds / 7).round());
    var sequence = AnimationSequence<BoxDecoration>();

    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_red, _orange])),
        duration: Duration.zero,
        delay: delay);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_orange, _yellow])),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_yellow, _green])),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_green, _blue])),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_blue, _indigo])),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_indigo, _purple])),
        duration: singleDuration,
        curve: curve);
    sequence.add(
        value: const BoxDecoration(
            gradient: LinearGradient(colors: [_purple, _red])),
        duration: singleDuration,
        curve: curve);

    return MultiAnimationSequence(
        control: control,
        sequences: {AnimationProperty.backgroundDecoration: sequence});
  }
}

class ElevateAnimation extends PresetAnimation {
  final int beginElevation;
  final int endElevation;
  const ElevateAnimation(
      {this.beginElevation = 1,
      this.endElevation = 6,
      super.duration = const Duration(seconds: 1),
      super.delay,
      super.curve,
      super.control});

  @override
  MultiAnimationSequence getAnimationSequence() {
    var sequence = AnimationSequence<List<ShapeShadow>>();

    sequence.add(
        value: preDefinedShapeShadow[beginElevation] ?? [],
        delay: delay,
        duration: Duration.zero);
    sequence.add(
        value: preDefinedShapeShadow[endElevation] ?? [], duration: duration);

    return MultiAnimationSequence(
        control: control, sequences: {AnimationProperty.shadows: sequence});
  }
}
