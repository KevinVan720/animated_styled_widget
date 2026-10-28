import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixture_objects.dart';
import 'support/test_utils.dart';

void main() {
  final Finder container = find.byType(StyledContainer);
  final Finder animated = find.byType(AnimatedStyledContainer);

  group('StyledContainer', () {
    testWidgets('builds an empty style', (tester) async {
      await tester.pumpWidget(wrap(StyledContainer(
          style: Style(), child: const SizedBox(width: 10, height: 20))));
      expect(styledBoxSize(tester, container), const Size(10, 20));
      expect(styledOpacity(tester, container), 1.0);
    });

    testWidgets('builds every property', (tester) async {
      setScreenSize(tester, const Size(800, 600));
      await tester.pumpWidget(wrap(StyledContainer(
          key: const ValueKey('container'),
          style: fullStyle(),
          child: const Text('child'))));
      expect(tester.takeException(), isNull);
      expect(find.byKey(const ValueKey('container')), findsOneWidget);
      expect(find.text('child'), findsOneWidget);

      // 50% of the height available inside the vertical margin of 6
      expect(styledBoxSize(tester, container), const Size(120, 297));
      expect(styledOpacity(tester, container), 0.8);
      expect(
          find.descendant(of: container, matching: find.byType(ImageFiltered)),
          findsOneWidget);
      expect(
          find.descendant(of: container, matching: find.byType(BackdropFilter)),
          findsOneWidget);
      expect(find.descendant(of: container, matching: find.byType(ShaderMask)),
          findsOneWidget);
      expect(
          find.descendant(
              of: container, matching: find.byType(DecoratedShadowedShape)),
          findsOneWidget);

      final MouseRegion region = tester.widget(
          find.descendant(of: container, matching: find.byType(MouseRegion)));
      expect(region.cursor, SystemMouseCursors.click);

      final DefaultTextStyle textStyle = tester.widget(find
          .ancestor(
              of: find.text('child'), matching: find.byType(DefaultTextStyle))
          .first);
      expect(textStyle.style.fontSize, 16);
      expect(textStyle.style.color, red);
      expect(textStyle.style.fontWeight, FontWeight.w700);
      expect(textStyle.textAlign, TextAlign.center);

      // the child is inset by the padding and the border width
      expect(tester.getSize(find.text('child')).width,
          lessThanOrEqualTo(120 - 2 * 8 - 2 * 2));
    });

    testWidgets('margin, padding and alignment', (tester) async {
      setScreenSize(tester, const Size(800, 600));
      await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: StyledContainer(
              style: Style(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 10, top: 20),
                padding: const EdgeInsets.all(5),
                width: 100.toPXLength,
                height: 50.toPXLength,
                childAlignment: Alignment.bottomRight,
              ),
              child: const SizedBox(
                  key: ValueKey('child'), width: 10, height: 10))));
      expect(
          tester.getRect(find
              .descendant(
                  of: container, matching: find.byType(DimensionSizedBox))
              .first),
          const Rect.fromLTWH(10, 20, 100, 50));
      expect(tester.getRect(find.byKey(const ValueKey('child'))),
          const Rect.fromLTWH(95, 55, 10, 10));
    });

    testWidgets('visible false hides the child', (tester) async {
      await tester.pumpWidget(wrap(StyledContainer(
          style: Style(visible: false), child: const Text('hidden'))));
      expect(find.text('hidden'), findsNothing);
    });

    testWidgets('transform', (tester) async {
      setScreenSize(tester, const Size(400, 800));
      await tester.pumpWidget(wrap(StyledContainer(
          style: Style(
              transform: SmoothMatrix4()
                ..translate(10.toVWLength, 5.toPXLength),
              transformAlignment: Alignment.topLeft),
          child: const SizedBox(width: 10, height: 10))));
      final Transform transform = tester.widget(
          find.descendant(of: container, matching: find.byType(Transform)));
      expect(transform.transform.getTranslation().x, 40);
      expect(transform.transform.getTranslation().y, 5);
      expect(transform.alignment, Alignment.topLeft);
    });

    testWidgets('mouse callbacks', (tester) async {
      int enters = 0, exits = 0;
      await tester.pumpWidget(wrap(StyledContainer(
          style: Style(width: 50.toPXLength, height: 50.toPXLength),
          onMouseEnter: (_) => enters++,
          onMouseExit: (_) => exits++,
          child: const SizedBox())));
      final TestGesture gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(tester.getCenter(container));
      await tester.pump();
      expect(enters, 1);
      await gesture.moveTo(Offset.zero);
      await tester.pump();
      expect(exits, 1);
      await gesture.removePointer();
    });
  });

  group('responsive', () {
    Widget responsive() => wrap(StyledContainer(
        style: Style(
          width: 50.toVWLength,
          height: 25.toVHLength,
          textStyle: DynamicTextStyle(fontSize: 5.toVWLength),
        ),
        child: const Text('text')));

    for (final Size size in const [Size(400, 800), Size(1000, 600)]) {
      testWidgets('viewport units on a $size screen', (tester) async {
        setScreenSize(tester, size);
        await tester.pumpWidget(responsive());
        expect(styledBoxSize(tester, container),
            Size(size.width / 2, size.height / 4));
        final DefaultTextStyle textStyle = tester.widget(find
            .ancestor(
                of: find.text('text'), matching: find.byType(DefaultTextStyle))
            .first);
        expect(textStyle.style.fontSize, size.width * 0.05);
      });
    }

    testWidgets('updates when the screen size changes', (tester) async {
      setScreenSize(tester, const Size(400, 800));
      await tester.pumpWidget(responsive());
      expect(styledBoxSize(tester, container), const Size(200, 200));
      tester.view.physicalSize = const Size(600, 400);
      await tester.pump();
      expect(styledBoxSize(tester, container), const Size(300, 100));
    });

    testWidgets('min and max', (tester) async {
      setScreenSize(tester, const Size(400, 800));
      Widget build() => wrap(StyledContainer(
          style: Style(
              width: Dimension.min(50.toVWLength, 300.toPXLength),
              height: Dimension.max(10.toVHLength, 100.toPXLength)),
          child: const SizedBox()));
      await tester.pumpWidget(build());
      expect(styledBoxSize(tester, container), const Size(200, 100));
      tester.view.physicalSize = const Size(1000, 2000);
      await tester.pumpWidget(build());
      expect(styledBoxSize(tester, container), const Size(300, 200));
    });

    testWidgets('percentages are relative to the parent', (tester) async {
      await tester.pumpWidget(Directionality(
          textDirection: TextDirection.ltr,
          child: Center(
              child: SizedBox(
                  width: 200,
                  height: 100,
                  child: StyledContainer(
                      style: Style(
                          alignment: Alignment.center,
                          width: 50.toPercentLength,
                          height: 20.toPercentLength),
                      child: const SizedBox())))));
      expect(styledBoxSize(tester, container), const Size(100, 20));
    });

    testWidgets('font sizes are relative to the parent font size',
        (tester) async {
      await tester.pumpWidget(wrap(
          StyledContainer(
              style: Style(
                  textStyle: DynamicTextStyle(fontSize: 150.toPercentLength)),
              child: const Text('text')),
          fontSize: 20));
      final DefaultTextStyle textStyle = tester.widget(find
          .ancestor(
              of: find.text('text'), matching: find.byType(DefaultTextStyle))
          .first);
      expect(textStyle.style.fontSize, 30);
    });

    testWidgets('without a text style the parent text style is used',
        (tester) async {
      await tester.pumpWidget(wrap(
          StyledContainer(style: Style(), child: const Text('text')),
          fontSize: 20));
      final DefaultTextStyle textStyle = tester.widget(find
          .ancestor(
              of: find.text('text'), matching: find.byType(DefaultTextStyle))
          .first);
      expect(textStyle.style.fontSize, 20);
      expect(textStyle.style.color, const Color(0xFF000000));
    });
  });

  group('NamedStyleMap', () {
    testWidgets('applies the style with the id of the widget', (tester) async {
      await tester.pumpWidget(wrap(NamedStyleMap(
          styles: {
            'named': Style(width: 200.toPXLength, opacity: 0.5),
          },
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            StyledContainer(
                key: const ValueKey('named'),
                id: 'named',
                style: Style(width: 100.toPXLength, height: 10.toPXLength),
                child: const SizedBox()),
            StyledContainer(
                key: const ValueKey('other'),
                id: 'other',
                style: Style(width: 100.toPXLength, height: 10.toPXLength),
                child: const SizedBox()),
          ]))));
      expect(styledBoxSize(tester, find.byKey(const ValueKey('named'))),
          const Size(200, 10));
      expect(styledOpacity(tester, find.byKey(const ValueKey('named'))), 0.5);
      expect(styledBoxSize(tester, find.byKey(const ValueKey('other'))),
          const Size(100, 10));
    });

    testWidgets('does not modify the style of the widget', (tester) async {
      final Style style = Style(width: 100.toPXLength);
      await tester.pumpWidget(wrap(NamedStyleMap(
          styles: {'named': Style(width: 200.toPXLength)},
          child: StyledContainer(
              id: 'named', style: style, child: const SizedBox()))));
      expect(style.width, 100.toPXLength);
    });

    test('updateShouldNotify', () {
      final Map<String, Style> styles = {};
      final NamedStyleMap map =
          NamedStyleMap(styles: styles, child: const SizedBox());
      expect(
          map.updateShouldNotify(
              NamedStyleMap(styles: styles, child: const SizedBox())),
          isFalse);
      expect(
          map.updateShouldNotify(
              NamedStyleMap(styles: {}, child: const SizedBox())),
          isTrue);
    });

    testWidgets('of returns null without a map', (tester) async {
      late BuildContext context;
      await tester.pumpWidget(Builder(builder: (c) {
        context = c;
        return const SizedBox();
      }));
      expect(NamedStyleMap.of(context), isNull);
    });
  });

  group('AnimatedStyledContainer', () {
    Widget build(Style style, {VoidCallback? onEnd, Curve? curve}) {
      return wrap(AnimatedStyledContainer(
          style: style,
          duration: const Duration(seconds: 1),
          curve: curve ?? Curves.linear,
          onEnd: onEnd,
          child: const Text('child')));
    }

    testWidgets('animates between styles', (tester) async {
      int ends = 0;
      await tester.pumpWidget(build(
          Style(width: 100.toPXLength, height: 50.toPXLength, opacity: 1.0),
          onEnd: () => ends++));
      expect(styledBoxSize(tester, animated), const Size(100, 50));

      await tester.pumpWidget(build(
          Style(width: 200.toPXLength, height: 50.toPXLength, opacity: 0.0),
          onEnd: () => ends++));
      await tester.pump(const Duration(milliseconds: 500));
      expect(styledBoxSize(tester, animated).width,
          moreOrLessEquals(150, epsilon: 0.5));
      expect(styledOpacity(tester, animated),
          moreOrLessEquals(0.5, epsilon: 0.01));

      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, animated), const Size(200, 50));
      expect(styledOpacity(tester, animated), 0.0);
      expect(ends, 1);
    });

    testWidgets('animates every property', (tester) async {
      setScreenSize(tester, const Size(800, 600));
      await tester.pumpWidget(build(fullStyle()));
      await tester.pumpWidget(build(responsiveStyle()));
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
      }
      await tester.pumpWidget(build(fullStyle(), curve: Curves.easeOutBack));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpWidget(build(Style()));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(build(fullStyle()));
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, animated), const Size(120, 297));
    });

    testWidgets('rebuilding with an equal style does not restart',
        (tester) async {
      await tester.pumpWidget(build(fullStyle()));
      await tester.pumpWidget(build(responsiveStyle()));
      await tester.pump(const Duration(milliseconds: 500));
      final Size size = styledBoxSize(tester, animated);
      await tester.pumpWidget(build(responsiveStyle()));
      await tester.pump(const Duration(milliseconds: 1));
      expect(styledBoxSize(tester, animated).width,
          moreOrLessEquals(size.width, epsilon: 1));
      await tester.pumpAndSettle();
    });

    testWidgets('animates the text style', (tester) async {
      await tester.pumpWidget(build(Style()));
      await tester.pumpWidget(build(Style(
          textStyle: DynamicTextStyle(fontSize: 34.toPXLength, color: red))));
      await tester.pump(const Duration(milliseconds: 500));
      final DefaultTextStyle textStyle = tester.widget(find
          .ancestor(
              of: find.text('child'), matching: find.byType(DefaultTextStyle))
          .first);
      expect(textStyle.style.fontSize, moreOrLessEquals(24, epsilon: 0.5));
      await tester.pumpAndSettle();
    });

    testWidgets('animates a shader gradient in and out', (tester) async {
      await tester.pumpWidget(build(Style()));
      expect(find.descendant(of: animated, matching: find.byType(ShaderMask)),
          findsNothing);
      await tester.pumpWidget(build(
          Style(shaderGradient: const LinearGradient(colors: [red, blue]))));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.descendant(of: animated, matching: find.byType(ShaderMask)),
          findsOneWidget);
      await tester.pumpAndSettle();
      await tester.pumpWidget(build(Style()));
      await tester.pumpAndSettle();
      expect(find.text('child'), findsOneWidget);
    });
  });

  group('AnimatedShaderMask', () {
    testWidgets('builds the child without a gradient', (tester) async {
      await tester.pumpWidget(wrap(AnimatedShaderMask(
          shaderGradient: null,
          duration: Duration(milliseconds: 100),
          child: Text('child'))));
      expect(find.text('child'), findsOneWidget);
      expect(find.byType(ShaderMask), findsNothing);
      await tester.pumpWidget(wrap(AnimatedShaderMask(
          shaderGradient: null, duration: Duration(milliseconds: 100))));
      expect(tester.takeException(), isNull);
    });
  });
}
