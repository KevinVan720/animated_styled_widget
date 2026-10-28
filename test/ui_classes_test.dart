import 'dart:math' as math;

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixture_objects.dart';

void main() {
  group('DynamicTextStyle', () {
    test('equality', () {
      expect(fullTextStyle(), fullTextStyle());
      expect(fullTextStyle().hashCode, fullTextStyle().hashCode);
      expect(const DynamicTextStyle(), const DynamicTextStyle());
      expect(fullTextStyle(), isNot(fullTextStyle().copyWith(height: 1.6)));
      expect(fullTextStyle(),
          isNot(fullTextStyle().copyWith(shadows: const <Shadow>[])));
      expect(const DynamicTextStyle(color: red),
          isNot(const DynamicTextStyle(color: blue)));
    });

    test('copyWith', () {
      final DynamicTextStyle style = fullTextStyle();
      expect(style.copyWith(), style);
      final DynamicTextStyle copy =
          style.copyWith(fontSize: 2.toVWLength, color: green);
      expect(copy.fontSize, 2.toVWLength);
      expect(copy.color, green);
      expect(copy.fontFamily, style.fontFamily);
      expect(copy.shadows, style.shadows);
    });

    test('toTextStyle converts the values', () {
      final TextStyle style = fullTextStyle()
          .toTextStyle(screenSize: const Size(400, 800), parentFontSize: 20);
      expect(style.color, red);
      expect(style.backgroundColor, const Color(0x11223344));
      expect(style.fontFamily, 'Roboto');
      expect(style.fontSize, 16);
      expect(style.fontWeight, FontWeight.w700);
      expect(style.fontStyle, FontStyle.italic);
      expect(style.letterSpacing, 2);
      // percentages are relative to the parent font size
      expect(style.wordSpacing, 2);
      expect(style.height, 1.5);
      expect(style.decoration, TextDecoration.underline);
      expect(style.decorationColor, blue);
      expect(style.decorationStyle, TextDecorationStyle.dashed);
      expect(style.decorationThickness, 2);
      expect(style.shadows, fullTextStyle().shadows);
    });

    test('toTextStyle resolves relative sizes', () {
      final DynamicTextStyle style = DynamicTextStyle(
          fontSize: 150.toPercentLength,
          letterSpacing: 1.toVWLength,
          wordSpacing: 10.toVHLength);
      final TextStyle small = style.toTextStyle(
          screenSize: const Size(400, 800), parentFontSize: 10);
      expect(small.fontSize, 15);
      expect(small.letterSpacing, 4);
      expect(small.wordSpacing, 80);
      final TextStyle large = style.toTextStyle(
          screenSize: const Size(1000, 500), parentFontSize: 20);
      expect(large.fontSize, 30);
      expect(large.letterSpacing, 10);
      expect(large.wordSpacing, 50);
    });

    test('toTextStyle uses a font size of 10 if none is given', () {
      final TextStyle style = const DynamicTextStyle()
          .toTextStyle(screenSize: const Size(400, 800), parentFontSize: 20);
      expect(style.fontSize, 10);
      expect(style.letterSpacing, isNull);
      expect(style.fontWeight, isNull);
    });
  });

  group('SmoothMatrix4', () {
    test('starts without operations', () {
      expect(SmoothMatrix4().operations, isEmpty);
      expect(SmoothMatrix4().toMatrix4(screenSize: const Size(100, 100)),
          Matrix4.identity());
    });

    test('records the operations', () {
      final SmoothMatrix4 matrix = fullSmoothMatrix4();
      expect(matrix.operations.map((e) => e.operation), [
        SmoothMatrix4OperationType.rotate,
        SmoothMatrix4OperationType.rotate,
        SmoothMatrix4OperationType.rotate,
        SmoothMatrix4OperationType.scale,
        SmoothMatrix4OperationType.scale,
        SmoothMatrix4OperationType.translate,
      ]);
      expect(matrix.operations[0].rotationX, 0.1);
      expect(matrix.operations[3].scaleX, 2.0);
      expect(matrix.operations[3].scaleY, isNull);
      expect(matrix.operations[5].translateY, 5.toVWLength);
    });

    test('translate defaults to no vertical translation', () {
      final SmoothMatrix4 matrix = SmoothMatrix4()..translate(3.toPXLength);
      expect(matrix.operations.single.translateY, 0.toPXLength);
    });

    test('toMatrix4 applies the operations in order', () {
      const Size screenSize = Size(400, 800);
      final Matrix4 expected = Matrix4.identity()
        ..rotateX(0.1)
        ..rotateY(0.2)
        ..rotateZ(math.pi / 4)
        // scaling by one value also scales z, like Matrix4.scale(x)
        ..scaleByDouble(2.0, 2.0, 2.0, 1.0)
        ..scaleByDouble(1.5, 0.5, 1.5, 1.0)
        ..translateByDouble(10.0, 20.0, 0.0, 1.0);
      final Matrix4 actual =
          fullSmoothMatrix4().toMatrix4(screenSize: screenSize);
      for (int i = 0; i < 16; i++) {
        expect(actual.storage[i], moreOrLessEquals(expected.storage[i]));
      }
    });

    test('toMatrix4 resolves viewport units with the screen size', () {
      final SmoothMatrix4 matrix = SmoothMatrix4()
        ..translate(10.toVWLength, 50.toVHLength);
      expect(
          matrix
              .toMatrix4(screenSize: const Size(400, 800))
              .getTranslation()
              .storage,
          [40.0, 400.0, 0.0]);
      expect(
          matrix
              .toMatrix4(screenSize: const Size(1000, 100))
              .getTranslation()
              .storage,
          [100.0, 50.0, 0.0]);
    });

    test('operations without values do nothing', () {
      final SmoothMatrix4 matrix = SmoothMatrix4()
        ..operations.addAll([
          SmoothOperation(operation: SmoothMatrix4OperationType.rotate),
          SmoothOperation(operation: SmoothMatrix4OperationType.scale),
          SmoothOperation(operation: SmoothMatrix4OperationType.translate),
          SmoothOperation(),
        ]);
      expect(matrix.toMatrix4(screenSize: const Size(100, 100)),
          Matrix4.identity());
    });

    test('translations need absolute dimensions', () {
      expect(
          () => SmoothOperation(
              operation: SmoothMatrix4OperationType.translate,
              translateX: 10.toPercentLength),
          throwsAssertionError);
    });

    test('equality', () {
      expect(fullSmoothMatrix4(), fullSmoothMatrix4());
      expect(fullSmoothMatrix4().hashCode, fullSmoothMatrix4().hashCode);
      expect(SmoothMatrix4(), SmoothMatrix4());
      expect(SmoothMatrix4()..rotateX(1), isNot(SmoothMatrix4()..rotateY(1)));
      expect(SmoothMatrix4()..scale(1), isNot(SmoothMatrix4()..scale(1, 1)));
      expect(SmoothMatrix4()..translate(1.toPXLength),
          isNot(SmoothMatrix4()..translate(1.toVWLength)));
      expect(
          SmoothOperation(
              operation: SmoothMatrix4OperationType.rotate, rotationZ: 1),
          SmoothOperation(
              operation: SmoothMatrix4OperationType.rotate, rotationZ: 1));
    });
  });

  group('predefined shadows', () {
    test('are defined for the material elevations', () {
      expect(preDefinedShapeShadow.keys,
          containsAll([0, 1, 2, 3, 4, 6, 8, 9, 12, 16, 24]));
      expect(preDefinedShapeShadow[0], isEmpty);
      for (final int elevation in preDefinedShapeShadow.keys) {
        if (elevation == 0) continue;
        expect(preDefinedShapeShadow[elevation], hasLength(3));
      }
    });
  });
}
