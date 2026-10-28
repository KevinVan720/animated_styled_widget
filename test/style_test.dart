import 'dart:ui' show ImageFilter;

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixture_objects.dart';

void main() {
  group('Style construction', () {
    test('all properties default to null', () {
      final Style style = Style();
      expect(style.visible, isNull);
      expect(style.opacity, isNull);
      expect(style.alignment, isNull);
      expect(style.width, isNull);
      expect(style.height, isNull);
      expect(style.margin, isNull);
      expect(style.padding, isNull);
      expect(style.foregroundDecoration, isNull);
      expect(style.backgroundDecoration, isNull);
      expect(style.shadows, isNull);
      expect(style.insetShadows, isNull);
      expect(style.shapeBorder, isNull);
      expect(style.transform, isNull);
      expect(style.transformAlignment, isNull);
      expect(style.childAlignment, isNull);
      expect(style.textStyle, isNull);
      expect(style.textAlign, isNull);
      expect(style.shaderGradient, isNull);
      expect(style.imageFilter, isNull);
      expect(style.backdropFilter, isNull);
      expect(style.mouseCursor, isNull);
    });

    test('stores the given properties', () {
      final Style style = fullStyle();
      expect(style.visible, isTrue);
      expect(style.opacity, 0.8);
      expect(style.alignment, Alignment.topRight);
      expect(style.width, 120.toPXLength);
      expect(style.height, 50.toPercentLength);
      expect(style.margin, const EdgeInsets.fromLTRB(1, 2, 3, 4));
      expect(style.shadows, hasLength(2));
      expect(style.insetShadows, hasLength(1));
      expect(style.shapeBorder, isA<RoundedRectangleShapeBorder>());
      expect(style.transform!.operations, hasLength(6));
      expect(style.textAlign, TextAlign.center);
      expect(style.mouseCursor, SystemMouseCursors.click);
    });

    test('properties are mutable', () {
      final Style style = Style(width: 10.toPXLength);
      style.width = null;
      style.opacity = 0.5;
      expect(style.width, isNull);
      expect(style.opacity, 0.5);
    });
  });

  group('Style.copyWith', () {
    test('without arguments returns an equal but new style', () {
      final Style style = fullStyle();
      final Style copy = style.copyWith();
      expect(identical(copy, style), isFalse);
      expect(copy, style);
    });

    test('replaces only the given properties', () {
      final Style style = fullStyle();
      final Style copy = style.copyWith(
        opacity: 0.1,
        width: 5.toVWLength,
        shadows: const [],
        textAlign: TextAlign.end,
        mouseCursor: SystemMouseCursors.grab,
      );
      expect(copy.opacity, 0.1);
      expect(copy.width, 5.toVWLength);
      expect(copy.shadows, isEmpty);
      expect(copy.textAlign, TextAlign.end);
      expect(copy.mouseCursor, SystemMouseCursors.grab);

      expect(copy.height, style.height);
      expect(copy.margin, style.margin);
      expect(copy.shapeBorder, style.shapeBorder);
      expect(copy.transform, style.transform);
      expect(copy.textStyle, style.textStyle);
      expect(copy.imageFilter, style.imageFilter);
      // the original is not modified
      expect(style.opacity, 0.8);
      expect(style.shadows, hasLength(2));
    });

    test('cannot reset a property to null', () {
      final Style style = Style(width: 10.toPXLength);
      expect(style.copyWith(width: null).width, 10.toPXLength);
    });
  });

  group('Style.merge', () {
    test('with null returns the same style', () {
      final Style style = fullStyle();
      expect(identical(style.merge(null), style), isTrue);
    });

    test('with an empty style returns an equal style', () {
      final Style style = fullStyle();
      expect(style.merge(Style()), style);
    });

    test('non-null properties of the other style win', () {
      final Style base = Style(
        width: 10.toPXLength,
        height: 20.toPXLength,
        opacity: 0.5,
        visible: true,
      );
      final Style merged = base.merge(Style(
        height: 30.toPercentLength,
        visible: false,
        childAlignment: Alignment.bottomCenter,
      ));
      expect(merged.width, 10.toPXLength);
      expect(merged.height, 30.toPercentLength);
      expect(merged.opacity, 0.5);
      expect(merged.visible, isFalse);
      expect(merged.childAlignment, Alignment.bottomCenter);
      // neither style is modified
      expect(base.height, 20.toPXLength);
      expect(base.visible, isTrue);
    });

    test('merging every property', () {
      expect(Style().merge(fullStyle()), fullStyle());
      expect(responsiveStyle().merge(fullStyle()), fullStyle());
    });
  });

  group('Style equality', () {
    test('styles built from equal values are equal', () {
      expect(Style(), Style());
      expect(fullStyle(), fullStyle());
      expect(fullStyle().hashCode, fullStyle().hashCode);
      expect(responsiveStyle(), responsiveStyle());
      expect(responsiveStyle().hashCode, responsiveStyle().hashCode);
    });

    test('a style is not equal to other objects', () {
      expect(Style() == Object(), isFalse);
      // ignore: unrelated_type_equality_checks
      expect(Style() == 'Style', isFalse);
    });

    final Map<String, Style Function(Style)> changes = {
      'visible': (s) => s.copyWith(visible: false),
      'opacity': (s) => s.copyWith(opacity: 0.81),
      'alignment': (s) => s.copyWith(alignment: Alignment.topLeft),
      'width': (s) => s.copyWith(width: 121.toPXLength),
      'height': (s) => s.copyWith(height: 50.toPXLength),
      'margin': (s) => s.copyWith(margin: EdgeInsets.zero),
      'padding': (s) => s.copyWith(padding: EdgeInsets.zero),
      'foregroundDecoration': (s) =>
          s.copyWith(foregroundDecoration: const BoxDecoration()),
      'backgroundDecoration': (s) =>
          s.copyWith(backgroundDecoration: const BoxDecoration(color: red)),
      'shadows': (s) => s.copyWith(shadows: const [ShapeShadow()]),
      'insetShadows': (s) => s.copyWith(insetShadows: const []),
      'shapeBorder': (s) => s.copyWith(shapeBorder: const CircleShapeBorder()),
      'transform': (s) => s.copyWith(transform: SmoothMatrix4()..rotateZ(1)),
      'transformAlignment': (s) =>
          s.copyWith(transformAlignment: Alignment.center),
      'childAlignment': (s) => s.copyWith(childAlignment: Alignment.topLeft),
      'textStyle': (s) =>
          s.copyWith(textStyle: const DynamicTextStyle(color: blue)),
      'textAlign': (s) => s.copyWith(textAlign: TextAlign.left),
      'shaderGradient': (s) => s.copyWith(
          shaderGradient: const LinearGradient(colors: [red, green])),
      'imageFilter': (s) => s.copyWith(
          imageFilter: ImageFilter.blur(sigmaX: 1, tileMode: TileMode.clamp)),
      'backdropFilter': (s) => s.copyWith(
          backdropFilter:
              ImageFilter.blur(sigmaX: 1, tileMode: TileMode.clamp)),
      'mouseCursor': (s) =>
          s.copyWith(mouseCursor: SystemMouseCursors.forbidden),
    };

    changes.forEach((property, change) {
      test('styles that differ in $property are not equal', () {
        expect(change(fullStyle()), isNot(fullStyle()));
      });
    });

    test('shadow lists are compared by value', () {
      final Style a = Style(shadows: [const ShapeShadow(blurRadius: 1)]);
      final Style b = Style(shadows: [const ShapeShadow(blurRadius: 1)]);
      final Style c = Style(shadows: [const ShapeShadow(blurRadius: 2)]);
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(c));
      expect(Style(shadows: const []), isNot(Style()));
    });

    test('can be used as map keys', () {
      final Map<Style, int> map = {fullStyle(): 1, responsiveStyle(): 2};
      expect(map[fullStyle()], 1);
      expect(map[responsiveStyle()], 2);
      expect(map[Style()], isNull);
    });
  });
}
