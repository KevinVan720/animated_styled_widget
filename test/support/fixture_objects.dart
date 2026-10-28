import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animations/simple_animations.dart';

/// Objects whose JSON is stored in `test/fixtures/<name>.json`.
///
/// The fixtures were produced by version 0.5.0 of this package (with the
/// dependency versions it was released with), so comparing against them
/// checks that the JSON format stays byte-compatible.
///
/// Only uses API that exists in 0.5.0, so that the same file can be used to
/// regenerate the fixtures with the old code.
Map<String, dynamic Function()> fixtureObjects = {
  'style_empty': () => Style(),
  'style_full': () => fullStyle(),
  'style_responsive': () => responsiveStyle(),
  'text_style_full': () => fullTextStyle(),
  'smooth_matrix4': () => fullSmoothMatrix4(),
  'animation_custom': () => customMultiAnimationSequence(),
  'global_animation': () => GlobalAnimation(
        sequences: {
          'first': const FadeInAnimation().getAnimationSequence(),
          'second': customMultiAnimationSequence(),
        },
        beginShift: 0.25,
        endShift: 0.75,
        control: Control.loop,
      ),
  'preset_fade_in': () => const FadeInAnimation().getAnimationSequence(),
  'preset_slide_in': () => const SlideInAnimation(
          direction: AxisDirection.left, duration: Duration(milliseconds: 600))
      .getAnimationSequence(),
  'preset_zoom_in': () => const ZoomInAnimation().getAnimationSequence(),
  'preset_fade_out': () => const FadeOutAnimation().getAnimationSequence(),
  'preset_slide_out': () => const SlideOutAnimation().getAnimationSequence(),
  'preset_zoom_out': () => const ZoomOutAnimation().getAnimationSequence(),
  'preset_flip': () => const FlipAnimation().getAnimationSequence(),
  'preset_flash': () => const FlashAnimation().getAnimationSequence(),
  'preset_pulse': () => const PulseAnimation().getAnimationSequence(),
  'preset_swing': () => const SwingAnimation().getAnimationSequence(),
  'preset_wobble': () => const WobbleAnimation().getAnimationSequence(),
  'preset_rainbow': () => const RainbowAnimation().getAnimationSequence(),
  'preset_rainbow_linear_gradient': () =>
      const RainbowLinearGradientAnimation().getAnimationSequence(),
};

const Color red = Color(0xFFF44336);
const Color blue = Color(0xFF2196F3);
const Color green = Color(0xFF4CAF50);

Style fullStyle() {
  return Style(
    visible: true,
    opacity: 0.8,
    alignment: Alignment.topRight,
    width: 120.toPXLength,
    height: 50.toPercentLength,
    margin: const EdgeInsets.fromLTRB(1, 2, 3, 4),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    backgroundDecoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [red, blue],
        stops: [0.25, 0.75],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    foregroundDecoration: const BoxDecoration(color: Color(0x33000000)),
    shadows: const [
      ShapeShadow(
          color: Color(0x80000000),
          offset: Offset(2, 3),
          blurRadius: 4,
          spreadRadius: 1),
      ShapeShadow(
          offset: Offset(-1, -1),
          blurRadius: 2,
          gradient: LinearGradient(colors: [red, green])),
    ],
    insetShadows: const [
      ShapeShadow(color: Color(0xFF123456), offset: Offset(1, 1)),
    ],
    shapeBorder: RoundedRectangleShapeBorder(
      borderRadius:
          DynamicBorderRadius.all(DynamicRadius.circular(12.toPXLength)),
      borderSides:
          RectangleBorderSides.all(DynamicBorderSide(width: 2, color: green)),
    ),
    transform: fullSmoothMatrix4(),
    transformAlignment: Alignment.bottomLeft,
    childAlignment: Alignment.center,
    textStyle: fullTextStyle(),
    textAlign: TextAlign.center,
    shaderGradient: const RadialGradient(colors: [red, blue], radius: 0.7),
    imageFilter:
        ImageFilter.blur(sigmaX: 2, sigmaY: 3, tileMode: TileMode.clamp),
    backdropFilter:
        ImageFilter.blur(sigmaX: 5, sigmaY: 5, tileMode: TileMode.mirror),
    mouseCursor: SystemMouseCursors.click,
  );
}

Style responsiveStyle() {
  return Style(
    width: Dimension.min(50.toVWLength, 300.toPXLength),
    height: 30.toVHLength + 10.toPXLength,
    margin: const EdgeInsets.all(10),
    shapeBorder: CircleShapeBorder(),
    textStyle: DynamicTextStyle(
        fontSize: 150.toPercentLength, letterSpacing: 1.toVWLength),
    transform: SmoothMatrix4()..translate(10.toVWLength, 5.toVHLength),
  );
}

DynamicTextStyle fullTextStyle() {
  return DynamicTextStyle(
    color: red,
    backgroundColor: const Color(0x11223344),
    fontFamily: 'Roboto',
    fontSize: 16.toPXLength,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    letterSpacing: 2.toPXLength,
    wordSpacing: 10.toPercentLength,
    height: 1.5,
    decoration: TextDecoration.underline,
    decorationColor: blue,
    decorationStyle: TextDecorationStyle.dashed,
    decorationThickness: 2.0,
    shadows: const [Shadow(color: green, offset: Offset(1, 2), blurRadius: 3)],
  );
}

SmoothMatrix4 fullSmoothMatrix4() {
  return SmoothMatrix4()
    ..rotateX(0.1)
    ..rotateY(0.2)
    ..rotateZ(math.pi / 4)
    ..scale(2.0)
    ..scale(1.5, 0.5)
    ..translate(10.toPXLength, 5.toVWLength);
}

MultiAnimationSequence customMultiAnimationSequence() {
  return MultiAnimationSequence(
    control: Control.mirror,
    beginShift: 0.2,
    endShift: 0.5,
    sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()
        ..add(value: 0.5, duration: const Duration(milliseconds: 300))
        ..add(
            value: 1.0,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn),
      AnimationProperty.width: AnimationSequence<Dimension>()
        ..add(value: 100.toPXLength, curve: Curves.easeOut)
        ..add(value: 50.toVWLength),
      AnimationProperty.alignment: AnimationSequence<Alignment>()
        ..add(value: Alignment.bottomCenter),
      AnimationProperty.margin: AnimationSequence<EdgeInsets>()
        ..add(value: const EdgeInsets.all(4)),
      AnimationProperty.backgroundDecoration: AnimationSequence<BoxDecoration>()
        ..add(value: const BoxDecoration(color: red))
        ..add(
            value: const BoxDecoration(
                gradient: LinearGradient(colors: [red, blue]))),
      AnimationProperty.shapeBorder: AnimationSequence<MorphableShapeBorder>()
        ..add(value: CircleShapeBorder()),
      AnimationProperty.transform: AnimationSequence<SmoothMatrix4>()
        ..add(value: SmoothMatrix4()..rotateZ(1.0)),
      AnimationProperty.textStyle: AnimationSequence<DynamicTextStyle>()
        ..add(
            value: DynamicTextStyle(
                color: blue, fontSize: 20.toPXLength, height: 1.2)),
    },
  );
}
