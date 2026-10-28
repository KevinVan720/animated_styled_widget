import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixture_objects.dart';

class _CustomGradient extends LinearGradient {
  const _CustomGradient({required super.colors});
}

void main() {
  group('GradientTween', () {
    test('interpolates between gradients', () {
      final GradientTween tween = GradientTween(
          begin: const LinearGradient(colors: [red, red]),
          end: const LinearGradient(colors: [blue, blue]));
      expect(tween.transform(0), const LinearGradient(colors: [red, red]));
      expect(tween.transform(1), const LinearGradient(colors: [blue, blue]));
      expect((tween.lerp(0.5) as LinearGradient).colors.first,
          Color.lerp(red, blue, 0.5));
    });

    test('handles null', () {
      expect(GradientTween().lerp(0.5), isNull);
      expect(
          GradientTween(end: const LinearGradient(colors: [red, red]))
              .lerp(1.0),
          const LinearGradient(colors: [red, red]));
    });
  });

  group('BoxDecorationTween', () {
    const BoxDecoration redBox = BoxDecoration(
        color: red,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        boxShadow: [BoxShadow(blurRadius: 2)]);
    const BoxDecoration blueBox = BoxDecoration(
        color: blue,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        shape: BoxShape.rectangle);

    test('returns the ends', () {
      final BoxDecorationTween tween =
          BoxDecorationTween(begin: redBox, end: blueBox);
      expect(tween.lerp(0.0), redBox);
      expect(tween.lerp(1.0), blueBox);
    });

    test('interpolates the properties', () {
      final BoxDecoration middle =
          BoxDecorationTween(begin: redBox, end: blueBox).lerp(0.5)!;
      expect(middle.color, Color.lerp(red, blue, 0.5));
      expect(middle.borderRadius, const BorderRadius.all(Radius.circular(6)));
      expect(middle.boxShadow, hasLength(1));
      expect(middle.boxShadow!.single.blurRadius, 1);
      expect(middle.gradient, isNull);
    });

    test('scales a missing end', () {
      expect(BoxDecorationTween().lerp(0.5), isNull);
      expect(BoxDecorationTween(end: redBox).lerp(0.5), redBox.scale(0.5));
      expect(BoxDecorationTween(begin: redBox).lerp(0.25), redBox.scale(0.75));
    });

    test('interpolates a color with a gradient', () {
      final BoxDecoration middle = BoxDecorationTween(
          begin: const BoxDecoration(color: red),
          end: const BoxDecoration(
              gradient: LinearGradient(colors: [blue, green]))).lerp(0.5)!;
      expect(middle.gradient, isA<LinearGradient>());
      expect(middle.gradient!.colors,
          [Color.lerp(red, blue, 0.5), Color.lerp(red, green, 0.5)]);
    });
  });

  group('lerpGradientWithColor', () {
    const LinearGradient linear = LinearGradient(colors: [blue, green]);
    const RadialGradient radial = RadialGradient(colors: [blue, green]);
    const SweepGradient sweep = SweepGradient(colors: [blue, green]);

    test('returns null without gradients', () {
      expect(lerpGradientWithColor(null, null, red, blue, 0.5), isNull);
    });

    test('lerps a color to a gradient of the same type', () {
      for (final Gradient gradient in [linear, radial, sweep]) {
        final Gradient? result =
            lerpGradientWithColor(null, gradient, red, null, 0.0);
        expect(result.runtimeType, gradient.runtimeType);
        expect(result!.colors, [red, red]);
        expect(lerpGradientWithColor(null, gradient, red, null, 1.0)!.colors,
            gradient.colors);
      }
    });

    test('lerps a gradient to a color', () {
      for (final Gradient gradient in [linear, radial, sweep]) {
        final Gradient? result =
            lerpGradientWithColor(gradient, null, null, red, 1.0);
        expect(result.runtimeType, gradient.runtimeType);
        expect(result!.colors, [red, red]);
      }
    });

    test('lerps from and to nothing', () {
      expect(lerpGradientWithColor(null, linear, null, null, 0.5),
          Gradient.lerp(null, linear, 0.5));
      expect(lerpGradientWithColor(linear, null, null, null, 0.5),
          Gradient.lerp(linear, null, 0.5));
    });

    test('lerps two gradients', () {
      final LinearGradient other = const LinearGradient(colors: [red, red]);
      expect(lerpGradientWithColor(linear, other, blue, green, 0.5),
          Gradient.lerp(linear, other, 0.5));
    });

    test('treats subclasses like the built-in gradient', () {
      final Gradient? result = lerpGradientWithColor(
          null, const _CustomGradient(colors: [blue, green]), red, null, 0.0);
      expect(result, isA<LinearGradient>());
      expect(result!.colors, [red, red]);
    });
  });
}
