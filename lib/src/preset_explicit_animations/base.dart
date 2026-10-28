import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/animation.dart';
import 'package:simple_animations/simple_animations.dart';

/// A predefined explicit animation, see [getAnimationSequence].
abstract class PresetAnimation {
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Control control;

  const PresetAnimation(
      {this.delay = Duration.zero,
      this.duration = Duration.zero,
      this.curve = Curves.linear,
      this.control = Control.play});

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

// The misspelled name is part of the public API.
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

Map<String, PresetAnimation> presetAllAnimations = {
  ...presetEntranceAnimations,
  ...presetExitAnimations,
  ...presetAttensionSeekerAnimations,
};
