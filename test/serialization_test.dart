import 'dart:convert';
import 'dart:ui' show ImageFilter;

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_animations/simple_animations.dart';

import 'support/fixture_objects.dart';
import 'support/test_utils.dart';

void main() {
  group('JSON format', () {
    fixtureObjects.forEach((name, build) {
      test('$name is unchanged', () {
        expect(jsonEncode(build().toJson()), fixtureJson(name));
      });
    });

    test('toJson only contains JSON values', () {
      for (final build in fixtureObjects.values) {
        final dynamic json = build().toJson();
        expect(json, jsonRoundTrip(json));
      }
    });

    test('an empty style is an empty map', () {
      expect(Style().toJson(), isEmpty);
    });

    test('only BoxDecorations are serialized', () {
      final Style style = Style(
          backgroundDecoration: const ShapeDecoration(
              color: red, shape: RoundedRectangleBorder()),
          foregroundDecoration: const BoxDecoration(color: blue));
      expect(style.toJson(), {
        'foregroundDecoration': {'color': 'ff2196f3'}
      });
    });
  });

  group('Style.fromJson', () {
    for (final String name in [
      'style_empty',
      'style_full',
      'style_responsive',
    ]) {
      test('parses $name', () {
        final Style parsed = Style.fromJson(fixture(name));
        expect(parsed, fixtureObjects[name]!());
        expect(jsonEncode(parsed.toJson()), fixtureJson(name));
      });

      test('parses $name with whole numbers written as ints', () {
        final dynamic json = wholeDoublesToInts(fixture(name));
        final Style parsed = Style.fromJson(json);
        expect(parsed, fixtureObjects[name]!());
        expect(jsonEncode(parsed.toJson()), fixtureJson(name));
      });
    }

    test('parses the output of toJson without encoding it', () {
      final Style style = fullStyle();
      expect(Style.fromJson(style.toJson()), style);
      expect(Style.fromJson(responsiveStyle().toJson()), responsiveStyle());
    });

    test('ignores missing and unknown keys', () {
      expect(Style.fromJson({}), Style());
      expect(
          Style.fromJson({'unknown': 1, 'opacity': 0.5}), Style(opacity: 0.5));
    });

    test('reads ints as doubles', () {
      final Style style = Style.fromJson({
        'opacity': 1,
        'transform': [
          {'operation': 'rotate', 'rotationZ': 1},
          {'operation': 'scale', 'scaleX': 2, 'scaleY': 3},
        ],
        'textStyle': {'height': 2, 'decorationThickness': 1},
      });
      expect(style.opacity, 1.0);
      expect(style.transform!.operations[0].rotationZ, 1.0);
      expect(style.transform!.operations[1].scaleX, 2.0);
      expect(style.transform!.operations[1].scaleY, 3.0);
      expect(style.textStyle!.height, 2.0);
      expect(style.textStyle!.decorationThickness, 1.0);
    });

    test('reads the properties', () {
      final Style style = Style.fromJson({
        'visible': false,
        'alignment': 'bottomRight',
        'width': '10.0vw',
        'height': [
          '10.0px',
          '20.0%',
        ],
        'mouseCursor': 'click',
        'textAlign': 'end',
        'imageFilter': {'type': 'ImageFilter', 'sigmaX': 1, 'sigmaY': 2},
      });
      expect(style.visible, isFalse);
      expect(style.alignment, Alignment.bottomRight);
      expect(style.width, 10.toVWLength);
      expect(style.height!.toPX(constraint: 200), 50.0);
      expect(style.mouseCursor, SystemMouseCursors.click);
      expect(style.textAlign, TextAlign.end);
      expect(style.imageFilter,
          ImageFilter.blur(sigmaX: 1, sigmaY: 2, tileMode: TileMode.clamp));
    });
  });

  group('parseDynamicTextStyle', () {
    test('returns null for null', () {
      expect(parseDynamicTextStyle(null), isNull);
    });

    test('round trips', () {
      final DynamicTextStyle style = fullTextStyle();
      expect(parseDynamicTextStyle(style.toJson()), style);
      expect(parseDynamicTextStyle(fixture('text_style_full')), style);
      expect(
          parseDynamicTextStyle(
              wholeDoublesToInts(jsonRoundTrip(style.toJson()))),
          style);
    });

    test('missing keys are read as null', () {
      expect(parseDynamicTextStyle({}), const DynamicTextStyle());
      final DynamicTextStyle style =
          parseDynamicTextStyle({'color': 'ff000000'})!;
      expect(style.fontWeight, isNull);
      expect(style.fontStyle, isNull);
      expect(style.color, const Color(0xFF000000));
    });

    test('reads every font weight and style', () {
      for (final FontWeight weight in FontWeight.values) {
        expect(
            parseDynamicTextStyle(
                    DynamicTextStyle(fontWeight: weight).toJson())!
                .fontWeight,
            weight);
      }
      expect(parseDynamicTextStyle({'fontWeight': 'w700'})!.fontWeight,
          FontWeight.bold);
      expect(parseDynamicTextStyle({'fontStyle': 'italic'})!.fontStyle,
          FontStyle.italic);
      expect(parseDynamicTextStyle({'fontStyle': 'normal'})!.fontStyle,
          FontStyle.normal);
    });
  });

  group('SmoothMatrix4 JSON', () {
    test('round trips', () {
      final SmoothMatrix4 matrix = fullSmoothMatrix4();
      expect(parseSmoothMatrix4(matrix.toJson()), matrix);
      expect(parseSmoothMatrix4(fixture('smooth_matrix4')), matrix);
      expect(parseSmoothMatrix4(wholeDoublesToInts(fixture('smooth_matrix4'))),
          matrix);
      expect(SmoothMatrix4.fromJson(jsonRoundTrip(matrix.toJson())), matrix);
    });

    test('parseSmoothMatrix4 returns null for null', () {
      expect(parseSmoothMatrix4(null), isNull);
    });

    test('SmoothOperation reads missing keys as null', () {
      final SmoothOperation operation = SmoothOperation.fromJson({});
      expect(operation.operation, isNull);
      expect(operation.rotationX, isNull);
      expect(operation.scaleX, isNull);
      expect(operation.translateX, isNull);
      expect(operation.toJson(), isEmpty);
    });

    test('SmoothOperation.toJson writes dimensions as strings', () {
      final SmoothOperation operation = SmoothOperation(
          operation: SmoothMatrix4OperationType.translate,
          translateX: 1.toPXLength,
          translateY: 2.toVHLength);
      expect(operation.toJson(), {
        'operation': 'translate',
        'translateX': '1.0px',
        'translateY': '2.0vh',
      });
    });
  });

  group('enum names', () {
    test('toJson', () {
      expect(Control.play.toJson(), 'play');
      expect(Control.mirror.toJson(), 'mirror');
      expect(AnimationTrigger.mouseEnter.toJson(), 'mouseEnter');
      expect(AnimationProperty.backgroundDecoration.toJson(),
          'backgroundDecoration');
      expect(SmoothMatrix4OperationType.translate.toJson(), 'translate');
    });

    test('parse', () {
      for (final Control value in Control.values) {
        expect(parseCustomAnimationControl(value.toJson()), value);
      }
      for (final AnimationTrigger value in AnimationTrigger.values) {
        expect(parseAnimationTrigger(value.toJson()), value);
      }
      for (final AnimationProperty value in AnimationProperty.values) {
        expect(parseAnimationProperty(value.toJson()), value);
      }
      for (final SmoothMatrix4OperationType value
          in SmoothMatrix4OperationType.values) {
        expect(parseSmoothSupportedOperations(value.toJson()), value);
      }
    });

    test('parse unknown names', () {
      expect(parseCustomAnimationControl('unknown'), isNull);
      expect(parseAnimationTrigger('unknown'), isNull);
      expect(parseSmoothSupportedOperations('unknown'), isNull);
      expect(parseSmoothSupportedOperations(null), isNull);
      // unknown properties are read as opacity
      expect(parseAnimationProperty('unknown'), AnimationProperty.opacity);
    });
  });

  group('parseStyleBase', () {
    test('returns null for null', () {
      expect(parseStyleBase(null), isNull);
    });

    test('parses a style', () {
      expect(parseStyleBase(fullStyle().toJson()), fullStyle());
    });

    test('returns maps keyed by screen sizes unchanged', () {
      final Map<String, dynamic> map = {
        '{minWidth: 0, maxWidth: 600}': {'opacity': 0.5},
      };
      expect(identical(parseStyleBase(map), map), isTrue);
    });
  });

  group('animation JSON', () {
    final List<String> sequences = [
      'animation_custom',
      for (final String name in fixtureObjects.keys)
        if (name.startsWith('preset_')) name,
    ];

    for (final String name in sequences) {
      test('MultiAnimationSequence $name round trips', () {
        final MultiAnimationSequence parsed =
            MultiAnimationSequence.fromJson(fixture(name));
        expect(jsonEncode(parsed.toJson()), fixtureJson(name));
      });

      test('MultiAnimationSequence $name with ints round trips', () {
        final MultiAnimationSequence parsed =
            MultiAnimationSequence.fromJson(wholeDoublesToInts(fixture(name)));
        expect(jsonEncode(parsed.toJson()), fixtureJson(name));
      });
    }

    test('MultiAnimationSequence reads the values', () {
      final MultiAnimationSequence parsed =
          MultiAnimationSequence.fromJson(fixture('animation_custom'));
      final MultiAnimationSequence original = customMultiAnimationSequence();
      expect(parsed.control, Control.mirror);
      expect(parsed.beginShift, 0.2);
      expect(parsed.endShift, 0.5);
      expect(parsed.sequences.keys, original.sequences.keys);
      original.sequences.forEach((property, sequence) {
        final AnimationSequence parsedSequence = parsed.sequences[property]!;
        expect(parsedSequence.data.length, sequence.data.length);
        for (int i = 0; i < sequence.data.length; i++) {
          expect(parsedSequence.data[i].value, sequence.data[i].value,
              reason: '$property $i');
          expect(parsedSequence.data[i].duration, sequence.data[i].duration);
          expect(parsedSequence.data[i].delay, sequence.data[i].delay);
          expect(parsedSequence.data[i].curve, sequence.data[i].curve);
        }
      });
    });

    test('GlobalAnimation round trips', () {
      final GlobalAnimation parsed =
          GlobalAnimation.fromJson(fixture('global_animation'));
      expect(parsed.control, Control.loop);
      expect(parsed.beginShift, 0.25);
      expect(parsed.endShift, 0.75);
      expect(parsed.sequences.keys, ['first', 'second']);
      expect(jsonEncode(parsed.toJson()), fixtureJson('global_animation'));

      final GlobalAnimation parsedInts = GlobalAnimation.fromJson(
          wholeDoublesToInts(fixture('global_animation')));
      expect(jsonEncode(parsedInts.toJson()), fixtureJson('global_animation'));
    });

    test('missing keys use the constructor defaults', () {
      final MultiAnimationSequence sequence =
          MultiAnimationSequence.fromJson({});
      expect(sequence.control, Control.play);
      expect(sequence.beginShift, 0.0);
      expect(sequence.endShift, 0.0);
      expect(sequence.sequences, isEmpty);

      final GlobalAnimation animation = GlobalAnimation.fromJson({});
      expect(animation.control, Control.play);
      expect(animation.beginShift, 0.0);
      expect(animation.endShift, 0.0);
      expect(animation.sequences, isEmpty);

      final AnimationData<double> data =
          AnimationData<double>.fromJson({'value': 0.5});
      expect(data.value, 0.5);
      expect(data.duration, const Duration(seconds: 1));
      expect(data.delay, Duration.zero);
      expect(data.curve, Curves.linear);

      expect(AnimationSequence<double>.fromJson({}).data, isEmpty);
    });

    test('AnimationData reads durations written as doubles', () {
      final AnimationData<double> data = AnimationData<double>.fromJson(
          {'value': 1, 'duration': 500.0, 'delay': 100.4});
      expect(data.value, 1.0);
      expect(data.duration, const Duration(milliseconds: 500));
      expect(data.delay, const Duration(milliseconds: 100));
    });

    test('AnimationData of shadows round trips', () {
      final AnimationSequence<List<ShapeShadow>> sequence =
          AnimationSequence<List<ShapeShadow>>()
            ..add(value: preDefinedShapeShadow[3]!)
            ..add(value: const []);
      final dynamic json = jsonRoundTrip(sequence.toJson());
      final AnimationSequence<List<ShapeShadow>> parsed =
          AnimationSequence<List<ShapeShadow>>.fromJson(json);
      expect(parsed.data[0].value, preDefinedShapeShadow[3]);
      expect(parsed.data[1].value, isEmpty);
      expect(parsed.toJson(), json);
    });

    test('ElevateAnimation round trips', () {
      final MultiAnimationSequence sequence =
          const ElevateAnimation(beginElevation: 2, endElevation: 8)
              .getAnimationSequence();
      final dynamic json = jsonRoundTrip(sequence.toJson());
      final MultiAnimationSequence parsed =
          MultiAnimationSequence.fromJson(json);
      final List data = parsed.sequences[AnimationProperty.shadows]!.data;
      expect(data[0].value, preDefinedShapeShadow[2]);
      expect(data[1].value, preDefinedShapeShadow[8]);
      expect(parsed.toJson(), json);
    });

    test('AnimationData.toJson', () {
      expect(
          AnimationData<Dimension>(
                  value: 10.toVWLength,
                  duration: const Duration(milliseconds: 20),
                  delay: const Duration(milliseconds: 30),
                  curve: Curves.easeInOut)
              .toJson(),
          {
            'duration': 20,
            'delay': 30,
            'curve': 'easeInOut',
            'value': '10.0vw',
          });
    });
  });
}
