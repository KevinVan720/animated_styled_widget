import 'dart:convert';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import 'support/fixture_objects.dart';

const Size screenSize = Size(400, 800);

final Map<AnimationProperty, dynamic> initialValues = {
  AnimationProperty.opacity: 1.0,
  AnimationProperty.alignment: Alignment.center,
  AnimationProperty.width: 100.toPXLength,
  AnimationProperty.height: 50.toPXLength,
  AnimationProperty.margin: EdgeInsets.zero,
  AnimationProperty.padding: const EdgeInsets.all(2),
  AnimationProperty.backgroundDecoration: const BoxDecoration(color: red),
  AnimationProperty.foregroundDecoration: const BoxDecoration(),
  AnimationProperty.shadows: <ShapeShadow>[],
  AnimationProperty.insetShadows: <ShapeShadow>[],
  AnimationProperty.shapeBorder: const RectangleShapeBorder(),
  AnimationProperty.transform: Matrix4.identity(),
  AnimationProperty.transformAlignment: Alignment.center,
  AnimationProperty.childAlignment: Alignment.center,
  AnimationProperty.textStyle: const TextStyle(fontSize: 14),
};

MovieTween tweenOf(MultiAnimationSequence sequence,
    {Map<AnimationProperty, dynamic>? initial}) {
  return sequence.getAnimationTween(
      initialValues: initial ?? initialValues,
      parentFontSize: 14,
      screenSize: screenSize);
}

/// The value of [property] [time] after the start of the animation (the end
/// value if [time] is not before the end, which is up to a few microseconds
/// after the sum of the durations).
T valueAt<T>(MovieTween tween, AnimationProperty property, Duration time) {
  final double t = time.inMilliseconds >= tween.duration.inMilliseconds
      ? 1.0
      : time.inMicroseconds / tween.duration.inMicroseconds;
  return tween.transform(t).get<T>(property);
}

/// Whether the channels of two colors differ by at most 1%.
Matcher closeToColor(Color expected) => predicate<Color?>(
    (Color? actual) =>
        actual != null &&
        (actual.a - expected.a).abs() <= 0.01 &&
        (actual.r - expected.r).abs() <= 0.01 &&
        (actual.g - expected.g).abs() <= 0.01 &&
        (actual.b - expected.b).abs() <= 0.01,
    'close to $expected');

void main() {
  group('AnimationSequence', () {
    test('add appends the data', () {
      final AnimationSequence<double> sequence = AnimationSequence<double>()
        ..add(value: 0.5)
        ..add(
            value: 1.0,
            duration: const Duration(milliseconds: 200),
            delay: const Duration(milliseconds: 100),
            curve: Curves.easeIn);
      expect(sequence.data, hasLength(2));
      expect(sequence.data[0].duration, const Duration(seconds: 1));
      expect(sequence.data[0].delay, Duration.zero);
      expect(sequence.data[0].curve, Curves.linear);
      expect(sequence.data[1].value, 1.0);
      expect(sequence.data[1].curve, Curves.easeIn);
      expect(AnimationSequence<double>().data, isEmpty);
      expect(
          AnimationSequence<double>(data: sequence.data).data, sequence.data);
    });

    test('getAllTimeStamps', () {
      final AnimationSequence<double> sequence = AnimationSequence<double>()
        ..add(value: 0.5, duration: const Duration(milliseconds: 300))
        ..add(
            value: 1.0,
            duration: const Duration(milliseconds: 200),
            delay: const Duration(milliseconds: 100))
        ..add(value: 0.0, duration: Duration.zero);
      expect(sequence.getAllTimeStamps(), [0.0, 300.0, 400.0, 600.0]);
      expect(AnimationSequence<double>().getAllTimeStamps(), [0.0]);
    });

    test('getMaxValue and getMinValue', () {
      final AnimationSequence<double> sequence = AnimationSequence<double>()
        ..add(value: 0.5)
        ..add(value: 2.0)
        ..add(value: -1.0);
      expect(sequence.getMaxValue(), 2.0);
      expect(sequence.getMinValue(), -1.0);
      expect(sequence.getMaxValue(initialValue: 3.0), 3.0);
      expect(AnimationSequence<double>().getMaxValue(), -double.infinity);
      expect(AnimationSequence<Dimension>().getMinValue(), double.infinity);
    });
  });

  group('MultiAnimationSequence', () {
    MultiAnimationSequence twoSteps() => MultiAnimationSequence(sequences: {
          AnimationProperty.opacity: AnimationSequence<double>()
            ..add(value: 0.0, duration: const Duration(milliseconds: 100))
            ..add(
                value: 1.0,
                delay: const Duration(milliseconds: 100),
                duration: const Duration(milliseconds: 100)),
        });

    test('defaults', () {
      final MultiAnimationSequence sequence =
          MultiAnimationSequence(sequences: {});
      expect(sequence.control, Control.play);
      expect(sequence.beginShift, 0.0);
      expect(sequence.endShift, 0.0);
    });

    test('getAllTimeStamps', () {
      expect(twoSteps().getAllTimeStamps(), [0.0, 100.0, 200.0, 300.0]);
      expect(customMultiAnimationSequence().getAllTimeStamps().last, 2000.0);
    });

    test('merge adds the sequences of the other animation', () {
      final MultiAnimationSequence sequence = twoSteps()
        ..merge(const ZoomInAnimation().getAnimationSequence());
      expect(sequence.sequences.keys,
          [AnimationProperty.opacity, AnimationProperty.transform]);
    });

    test('extend plays the other animation afterwards', () {
      final MultiAnimationSequence other = MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>()
          ..add(value: 0.5, duration: const Duration(milliseconds: 50)),
        AnimationProperty.width: AnimationSequence<Dimension>()
          ..add(
              value: 10.toPXLength,
              delay: const Duration(milliseconds: 10),
              duration: const Duration(milliseconds: 50)),
      });
      final String otherJson = jsonEncode(other.toJson());

      final MultiAnimationSequence sequence = twoSteps()..extend(other);
      expect(sequence.sequences[AnimationProperty.opacity]!.getAllTimeStamps(),
          [0.0, 100.0, 200.0, 300.0, 350.0]);
      expect(sequence.sequences[AnimationProperty.width]!.getAllTimeStamps(),
          [0.0, 310.0, 360.0]);
      expect(sequence.getAllTimeStamps().last, 360.0);
      // the other animation is not modified
      expect(jsonEncode(other.toJson()), otherJson);
    });

    test('extend with an empty sequence', () {
      final MultiAnimationSequence sequence = twoSteps()
        ..extend(MultiAnimationSequence(sequences: {
          AnimationProperty.width: AnimationSequence<Dimension>(),
        }));
      expect(sequence.getAllTimeStamps().last, 300.0);
    });

    test('addDelay delays every property', () {
      final MultiAnimationSequence sequence = twoSteps()
        ..addDelay(const Duration(milliseconds: 50));
      expect(sequence.getAllTimeStamps(), [0.0, 50.0, 150.0, 250.0, 350.0]);
      // properties without data are skipped
      MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>(),
      }).addDelay(const Duration(milliseconds: 50));
    });

    test('rescaleTime', () {
      final MultiAnimationSequence sequence = twoSteps()
        ..rescaleTime(const Duration(milliseconds: 600));
      expect(sequence.getAllTimeStamps(), [0.0, 200.0, 400.0, 600.0]);
      // an animation without duration can not be rescaled
      final MultiAnimationSequence instant = MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>()
          ..add(value: 0, duration: Duration.zero)
      })
        ..rescaleTime(const Duration(seconds: 1));
      expect(instant.getAllTimeStamps(), [0.0]);
    });
  });

  group('MultiAnimationSequence.getAnimationTween', () {
    test('plays the steps of a sequence one after another', () {
      final MovieTween tween = tweenOf(MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>()
          ..add(value: 0.0, duration: const Duration(milliseconds: 100))
          ..add(
              value: 1.0,
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 100)),
      }));
      expect(tween.duration.inMilliseconds, 300);
      double opacity(int ms) => valueAt<double>(
          tween, AnimationProperty.opacity, Duration(milliseconds: ms));
      expect(opacity(0), 1.0);
      expect(opacity(50), moreOrLessEquals(0.5, epsilon: 0.01));
      expect(opacity(100), moreOrLessEquals(0.0, epsilon: 0.01));
      expect(opacity(150), 0.0);
      expect(opacity(250), moreOrLessEquals(0.5, epsilon: 0.01));
      expect(opacity(300), 1.0);
    });

    test('waits for the delay of the first step', () {
      final MovieTween tween = tweenOf(MultiAnimationSequence(sequences: {
        AnimationProperty.width: AnimationSequence<Dimension>()
          ..add(
              value: 200.toPXLength,
              delay: const Duration(milliseconds: 100),
              duration: const Duration(milliseconds: 100)),
      }));
      Dimension? width(int ms) => valueAt<Dimension?>(
          tween, AnimationProperty.width, Duration(milliseconds: ms));
      expect(width(50)!.toPX(), 100);
      expect(width(150)!.toPX(), moreOrLessEquals(150, epsilon: 1));
      expect(width(200)!.toPX(), 200);
      expect(width(199)!.toPX(), moreOrLessEquals(199, epsilon: 1));
    });

    test('keeps the initial values of properties that are not animated', () {
      final MovieTween tween = tweenOf(twoStepsOpacity());
      for (final int ms in [0, 100, 300]) {
        final Movie movie = tween.transform(ms / 300);
        expect(movie.get<Dimension?>(AnimationProperty.width), 100.toPXLength);
        expect(movie.get<EdgeInsets>(AnimationProperty.padding),
            const EdgeInsets.all(2));
        expect(movie.get<Decoration>(AnimationProperty.backgroundDecoration),
            const BoxDecoration(color: red));
        expect(movie.get<Matrix4>(AnimationProperty.transform),
            Matrix4.identity());
        expect(movie.get<TextStyle>(AnimationProperty.textStyle),
            const TextStyle(fontSize: 14));
      }
    });

    test('uses defaults for missing initial values', () {
      final MovieTween tween = tweenOf(twoStepsOpacity(), initial: {});
      final Movie movie = tween.transform(1.0);
      expect(movie.get<double>(AnimationProperty.opacity), 1.0);
      expect(
          movie.get<Alignment>(AnimationProperty.alignment), Alignment.center);
      expect(movie.get<EdgeInsets>(AnimationProperty.margin), EdgeInsets.zero);
      expect(movie.get<Dimension?>(AnimationProperty.width), isNull);
    });

    test('does not modify the sequence', () {
      final MultiAnimationSequence sequence = customMultiAnimationSequence();
      final String json = jsonEncode(sequence.toJson());
      final List<AnimationProperty> properties =
          sequence.sequences.keys.toList();
      tweenOf(sequence);
      tweenOf(sequence);
      expect(jsonEncode(sequence.toJson()), json);
      expect(sequence.sequences.keys, properties);
    });

    test('uses the current initial values every time', () {
      final MultiAnimationSequence sequence = twoStepsOpacity();
      tweenOf(sequence);
      final MovieTween tween = tweenOf(sequence, initial: {
        ...initialValues,
        AnimationProperty.width: 300.toPXLength,
      });
      expect(tween.transform(1.0).get<Dimension?>(AnimationProperty.width),
          300.toPXLength);
    });

    test('animates every property type', () {
      final MovieTween tween = tweenOf(customMultiAnimationSequence());
      for (final double t in [0.0, 0.25, 0.5, 0.75, 1.0]) {
        tween.transform(t);
      }
      final Movie end = tween.transform(1.0);
      expect(end.get<double>(AnimationProperty.opacity), 1.0);
      expect(end.get<Dimension?>(AnimationProperty.width), 50.toVWLength);
      expect(end.get<Alignment>(AnimationProperty.alignment),
          Alignment.bottomCenter);
      expect(end.get<EdgeInsets>(AnimationProperty.margin),
          const EdgeInsets.all(4));
      expect(end.get<Decoration>(AnimationProperty.backgroundDecoration),
          const BoxDecoration(gradient: LinearGradient(colors: [red, blue])));
      expect(end.get<MorphableShapeBorder>(AnimationProperty.shapeBorder),
          const CircleShapeBorder());
      expect(end.get<Matrix4>(AnimationProperty.transform),
          Matrix4.rotationZ(1.0));
      final TextStyle textStyle =
          end.get<TextStyle>(AnimationProperty.textStyle);
      expect(textStyle.color, blue);
      expect(textStyle.fontSize, 20);
    });

    test('animates text styles that do not inherit', () {
      final MovieTween tween = tweenOf(
          MultiAnimationSequence(sequences: {
            AnimationProperty.textStyle: AnimationSequence<DynamicTextStyle>()
              ..add(value: DynamicTextStyle(fontSize: 20.toPXLength)),
          }),
          initial: {
            ...initialValues,
            AnimationProperty.textStyle:
                const TextStyle(inherit: false, fontSize: 10, color: red),
          });
      expect(
          tween
              .transform(0.5)
              .get<TextStyle>(AnimationProperty.textStyle)
              .fontSize,
          moreOrLessEquals(15, epsilon: 0.01));
      expect(
          tween
              .transform(1.0)
              .get<TextStyle>(AnimationProperty.textStyle)
              .fontSize,
          20);
    });

    test('a step without duration at the end', () {
      final MovieTween tween = tweenOf(MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>()
          ..add(value: 0.5, duration: const Duration(milliseconds: 100))
          ..add(
              value: 0.0,
              duration: Duration.zero,
              delay: const Duration(milliseconds: 100)),
      }));
      expect(tween.transform(0.75).get<double>(AnimationProperty.opacity), 0.5);
      expect(tween.transform(1.0).get<double>(AnimationProperty.opacity), 0.0);
    });

    test('an animation without any duration', () {
      final MovieTween tween = tweenOf(MultiAnimationSequence(sequences: {
        AnimationProperty.opacity: AnimationSequence<double>()
          ..add(value: 0.5, duration: Duration.zero),
      }));
      expect(tween.transform(1.0).get<double>(AnimationProperty.opacity), 0.5);
    });
  });

  group('GlobalAnimation', () {
    test('defaults', () {
      final GlobalAnimation animation = GlobalAnimation(sequences: {});
      expect(animation.control, Control.play);
      expect(animation.beginShift, 0.0);
      expect(animation.endShift, 0.0);
    });

    test('getAllTimeStamps and rescaleTime', () {
      final GlobalAnimation animation = GlobalAnimation(sequences: {
        'a': twoStepsOpacity(),
        'b': const FadeInAnimation(duration: Duration(milliseconds: 600))
            .getAnimationSequence(),
      });
      expect(animation.getAllTimeStamps(), [0.0, 100.0, 200.0, 300.0, 600.0]);
      animation.rescaleTime(const Duration(milliseconds: 1200));
      expect(animation.sequences['a']!.getAllTimeStamps().last, 1200.0);
      expect(animation.sequences['b']!.getAllTimeStamps().last, 1200.0);
    });
  });

  group('ContinuousAnimationProgressNotifier', () {
    test('clamps the value and notifies once per change', () {
      final ContinuousAnimationProgressNotifier notifier =
          ContinuousAnimationProgressNotifier(0.5);
      int notifications = 0;
      notifier.addListener(() => notifications++);

      notifier.value = 0.7;
      expect(notifier.value, 0.7);
      expect(notifications, 1);

      notifier.value = 0.7;
      expect(notifications, 1);

      notifier.value = 3.0;
      expect(notifier.value, 1.0);
      expect(notifications, 2);

      notifier.value = 5.0;
      expect(notifier.value, 1.0);
      expect(notifications, 2);

      notifier.value = -1.0;
      expect(notifier.value, 0.0);
      expect(notifications, 3);
      notifier.dispose();
    });
  });

  group('notifiers', () {
    test('GlobalAnimationNotifier', () {
      final MultiAnimationSequence fadeIn =
          const FadeInAnimation().getAnimationSequence();
      final GlobalAnimationNotifier notifier =
          GlobalAnimationNotifier(animationPool: {
        'animation': GlobalAnimation(sequences: {'a': fadeIn, 'b': fadeIn}),
      });
      int notifications = 0;
      notifier.addListener(() => notifications++);

      notifier.updateAnimationStatus('animation', Control.playReverse);
      expect(notifier.currentAnimations, {'a': fadeIn, 'b': fadeIn});
      expect(notifier.currentAnimationsControl,
          {'a': Control.playReverse, 'b': Control.playReverse});
      expect(notifications, 1);

      notifier.updateContinuousAnimationStatus('animation', true);
      expect(notifier.currentContinuousAnimations, {'a': fadeIn, 'b': fadeIn});
      expect(notifier.currentContinuousAnimationNames,
          {'a': 'animation', 'b': 'animation'});
      notifier.updateContinuousAnimationStatus('animation', false);
      expect(notifier.currentContinuousAnimations, isEmpty);
      expect(notifier.currentContinuousAnimationNames, isEmpty);

      // unknown animations are ignored
      notifier.updateAnimationStatus('unknown', Control.play);
      expect(notifier.currentAnimations.keys, ['a', 'b']);
      notifier.dispose();
    });

    test('LocalAnimationNotifier', () {
      final MultiAnimationSequence fadeIn =
          const FadeInAnimation().getAnimationSequence();
      final LocalAnimationNotifier notifier = LocalAnimationNotifier();
      notifier.updateAnimationStatus(fadeIn, Control.loop);
      expect(notifier.currentAnimation, fadeIn);
      expect(notifier.currentAnimationControl, Control.loop);
      notifier.updateContinuousAnimationStatus(fadeIn, true);
      expect(notifier.currentContinuousAnimation, fadeIn);
      notifier.updateContinuousAnimationStatus(fadeIn, false);
      expect(notifier.currentContinuousAnimation, isNull);
      notifier.animationProgressNotifier =
          ContinuousAnimationProgressNotifier(0.0);
      notifier.dispose();
    });
  });

  group('preset animations', () {
    test('the preset maps', () {
      expect(presetAllAnimations.keys, [
        'FadeIn',
        'SlideIn',
        'ZoomIn',
        'FadeOut',
        'SlideOut',
        'ZoomOut',
        'Flip',
        'Flash',
        'Pulse',
        'Swing',
        'Wobble',
        'Rainbow',
        'RainbowLinearGradient',
        'Elevate',
      ]);
      expect(presetEntranceAnimations.keys, ['FadeIn', 'SlideIn', 'ZoomIn']);
      expect(presetExitAnimations.keys, ['FadeOut', 'SlideOut', 'ZoomOut']);
      expect(presetAttensionSeekerAnimations, hasLength(8));
    });

    test('use the given duration, delay and control', () {
      const Duration duration = Duration(milliseconds: 600);
      const Duration delay = Duration(milliseconds: 120);
      final List<PresetAnimation> presets = [
        const FadeInAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const SlideInAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const ZoomInAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const FadeOutAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const SlideOutAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const ZoomOutAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const FlipAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const FlashAnimation(duration: duration, delay: delay),
        const PulseAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const SwingAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const WobbleAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const RainbowAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const RainbowLinearGradientAnimation(
            duration: duration, delay: delay, control: Control.loop),
        const ElevateAnimation(
            duration: duration, delay: delay, control: Control.loop),
      ];
      for (final PresetAnimation preset in presets) {
        final MultiAnimationSequence sequence = preset.getAnimationSequence();
        final String name = preset.runtimeType.toString();
        // the rainbow animations only use 6/7 of the duration
        final double end = name.startsWith('Rainbow') ? 120 + 6 * 86 : 720;
        expect(sequence.getAllTimeStamps().last,
            moreOrLessEquals(end, epsilon: 10),
            reason: name);
        expect(sequence.control,
            preset is FlashAnimation ? Control.play : Control.loop,
            reason: name);
        final MovieTween tween = tweenOf(sequence);
        expect(tween.duration.inMilliseconds, closeTo(end, 10), reason: name);
        for (final double t in [0.0, 0.3, 0.6, 1.0]) {
          tween.transform(t);
        }
      }
    });

    test('FadeIn', () {
      final MovieTween tween = tweenOf(
          const FadeInAnimation(duration: Duration(milliseconds: 200))
              .getAnimationSequence());
      expect(tween.transform(0.0).get<double>(AnimationProperty.opacity), 0.0);
      expect(tween.transform(0.5).get<double>(AnimationProperty.opacity),
          moreOrLessEquals(0.5, epsilon: 0.01));
      expect(tween.transform(1.0).get<double>(AnimationProperty.opacity), 1.0);
    });

    test('Flash flashes the given number of times', () {
      final MovieTween tween = tweenOf(const FlashAnimation(
              duration: Duration(milliseconds: 600), repeats: 3)
          .getAnimationSequence());
      double opacity(int ms) => valueAt<double>(
          tween, AnimationProperty.opacity, Duration(milliseconds: ms));
      expect(opacity(0), 1.0);
      expect(opacity(100), moreOrLessEquals(0.0, epsilon: 0.01));
      expect(opacity(200), moreOrLessEquals(1.0, epsilon: 0.01));
      expect(opacity(300), moreOrLessEquals(0.0, epsilon: 0.01));
      expect(opacity(400), moreOrLessEquals(1.0, epsilon: 0.01));
      expect(opacity(500), moreOrLessEquals(0.0, epsilon: 0.01));
      expect(opacity(600), 1.0);
    });

    test('Pulse scales up and back', () {
      final MovieTween tween = tweenOf(
          const PulseAnimation(duration: Duration(milliseconds: 400), scale: 2)
              .getAnimationSequence());
      double scale(int ms) => valueAt<Matrix4>(
              tween, AnimationProperty.transform, Duration(milliseconds: ms))
          .getMaxScaleOnAxis();
      expect(scale(0), 1.0);
      expect(scale(200), moreOrLessEquals(2.0, epsilon: 0.01));
      expect(scale(400), moreOrLessEquals(1.0, epsilon: 0.01));
    });

    test('SlideIn starts translated', () {
      final MovieTween tween = tweenOf(const SlideInAnimation(
              distance: Length(100),
              direction: AxisDirection.left,
              duration: Duration(milliseconds: 200))
          .getAnimationSequence());
      double dx(int ms) => valueAt<Matrix4>(
              tween, AnimationProperty.transform, Duration(milliseconds: ms))
          .getTranslation()
          .x;
      expect(dx(1), moreOrLessEquals(-100.0, epsilon: 1));
      expect(dx(100), moreOrLessEquals(-50.0, epsilon: 1));
      expect(dx(200), moreOrLessEquals(0.0, epsilon: 0.01));
    });

    test('Rainbow changes the background color', () {
      final MovieTween tween = tweenOf(
          const RainbowAnimation(duration: Duration(milliseconds: 700))
              .getAnimationSequence());
      Color? color(int ms) => (valueAt<Decoration>(
              tween,
              AnimationProperty.backgroundDecoration,
              Duration(milliseconds: ms)) as BoxDecoration)
          .color;
      expect(color(1), closeToColor(const Color(0xFFF44336)));
      expect(color(100), closeToColor(const Color(0xFFFF9800)));
      expect(color(300), closeToColor(const Color(0xFF4CAF50)));
      expect(color(1000), const Color(0xFF9C27B0));
    });
  });
}

MultiAnimationSequence twoStepsOpacity() => MultiAnimationSequence(sequences: {
      AnimationProperty.opacity: AnimationSequence<double>()
        ..add(value: 0.0, duration: const Duration(milliseconds: 100))
        ..add(
            value: 1.0,
            delay: const Duration(milliseconds: 100),
            duration: const Duration(milliseconds: 100)),
    });
