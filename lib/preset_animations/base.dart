import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

import '../animation_provider.dart';
import '../named_animation.dart';
import 'entrance.dart';
import 'exit.dart';

abstract class PresetAnimation {
  Duration delay;
  Duration duration;
  Curve curve;
  CustomAnimationControl control;

  PresetAnimation(
      {this.delay = Duration.zero,
      this.duration = Duration.zero,
      this.curve = Curves.linear,
      this.control = CustomAnimationControl.PLAY});

  MultiAnimationSequence getAnimationSequences();
}

Map<String, PresetAnimation> presetEntranceAnimations = {
  "FadeIn": FadeInAnimation(),
  "SlideIn": SlideInAnimation(),
  "ZoomIn": ZoomInAnimation(),
};

Map<String, PresetAnimation> presetExitAnimations = {
  "FadeOut": FadeOutAnimation(),
  "SlideOut": SlideOutAnimation(),
  "ZoomOut": ZoomOutAnimation(),
};

Map<String, PresetAnimation> presetAttensionSeekerAnimations = {
  "Flip": FlipAnimation(),
  "Flash": FlashAnimation(),
  "Pulse": PulseAnimation(),
  "Swing": SwingAnimation(),
  "Wobble": WobbleAnimation(),
  "Rainbow": RainbowAnimation(),
  "RainbowLinearGradient": RainbowLinearGradientAnimation(),
  "Elevate": ElevateAnimation(),
};

Map<String, PresetAnimation> presetAllAnimations = presetEntranceAnimations
  ..addAll(presetExitAnimations)
  ..addAll(presetAttensionSeekerAnimations);
