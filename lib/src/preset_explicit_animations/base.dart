import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

import 'attention_seeker.dart';
import 'entrance.dart';
import 'exit.dart';

abstract class PresetAnimation {
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final CustomAnimationControl control;

  const PresetAnimation(
      {this.delay = Duration.zero,
      this.duration = Duration.zero,
      this.curve = Curves.linear,
      this.control = CustomAnimationControl.PLAY});

  MultiAnimationSequence getAnimationSequence();
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
