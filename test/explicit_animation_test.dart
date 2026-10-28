import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

import 'support/fixture_objects.dart';
import 'support/test_utils.dart';

class _CountingScrollController extends ScrollController {
  int listeners = 0;

  @override
  void addListener(VoidCallback listener) {
    listeners++;
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    listeners--;
    super.removeListener(listener);
  }
}

MultiAnimationSequence widthTo(Dimension width,
        {Duration duration = const Duration(seconds: 1)}) =>
    MultiAnimationSequence(sequences: {
      AnimationProperty.width: AnimationSequence<Dimension>()
        ..add(value: width, duration: duration),
    });

void main() {
  final Finder explicit = find.byType(ExplicitAnimatedStyledContainer);
  final Style boxStyle =
      Style(width: 100.toPXLength, height: 100.toPXLength, opacity: 1.0);

  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  testWidgets('builds without animations', (tester) async {
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        key: const ValueKey('explicit'),
        style: fullStyle(),
        child: const Text('child'))));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('explicit')), findsOneWidget);
    expect(find.text('child'), findsOneWidget);
    expect(styledOpacity(tester, explicit), 0.8);
  });

  testWidgets('tap animation', (tester) async {
    int taps = 0;
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: boxStyle,
        onTap: () => taps++,
        localAnimations: {
          AnimationTrigger.tap: const FadeOutAnimation().getAnimationSequence(),
        },
        child: const SizedBox())));
    await tester.pumpAndSettle();
    expect(styledOpacity(tester, explicit), 1.0);

    await tester.tap(explicit);
    expect(taps, 1);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(
        styledOpacity(tester, explicit), moreOrLessEquals(0.5, epsilon: 0.01));
    await tester.pumpAndSettle();
    expect(styledOpacity(tester, explicit), 0.0);
  });

  testWidgets('mouse enter and exit animations', (tester) async {
    int enters = 0, exits = 0;
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: boxStyle,
        onMouseEnter: (_) => enters++,
        onMouseExit: (_) => exits++,
        localAnimations: {
          AnimationTrigger.mouseEnter: widthTo(200.toPXLength),
          AnimationTrigger.mouseExit: widthTo(100.toPXLength),
        },
        child: const SizedBox())));
    await tester.pumpAndSettle();

    final TestGesture gesture =
        await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(tester.getCenter(explicit));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(enters, 1);
    expect(styledBoxSize(tester, explicit).width,
        moreOrLessEquals(150, epsilon: 1));
    await tester.pumpAndSettle();
    expect(styledBoxSize(tester, explicit).width, 200);

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(exits, 1);
    expect(styledBoxSize(tester, explicit).width, 100);
  });

  testWidgets('visible animation', (tester) async {
    final List<VisibilityInfo> infos = [];
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: boxStyle,
        onVisible: infos.add,
        localAnimations: {
          AnimationTrigger.visible:
              const FadeInAnimation().getAnimationSequence()
                ..merge(const SlideInAnimation().getAnimationSequence()),
        },
        child: const SizedBox())));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(infos, isNotEmpty);
    expect(infos.last.visibleFraction, 1.0);
    expect(
        styledOpacity(tester, explicit), moreOrLessEquals(0.5, epsilon: 0.01));
    await tester.pumpAndSettle();
    expect(styledOpacity(tester, explicit), 1.0);
  });

  testWidgets('controlled from the child', (tester) async {
    late BuildContext childContext;
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: boxStyle,
        child: Builder(builder: (context) {
          childContext = context;
          return const SizedBox();
        }))));
    Provider.of<LocalAnimationNotifier>(childContext, listen: false)
        .updateAnimationStatus(
            widthTo(300.toPXLength,
                duration: const Duration(milliseconds: 200)),
            Control.play);
    await tester.pumpAndSettle();
    expect(styledBoxSize(tester, explicit).width, 300);
  });

  testWidgets('global animations', (tester) async {
    final GlobalAnimationNotifier notifier =
        GlobalAnimationNotifier(animationPool: {
      'grow': GlobalAnimation(sequences: {
        'box': widthTo(200.toPXLength),
        'other': widthTo(50.toPXLength),
      }),
    });
    await tester.pumpWidget(wrap(ChangeNotifierProvider.value(
        value: notifier,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ExplicitAnimatedStyledContainer(
              key: const ValueKey('first'),
              id: 'box',
              style: boxStyle,
              globalAnimationIds: const {AnimationTrigger.tap: 'grow'},
              child: const SizedBox()),
          ExplicitAnimatedStyledContainer(
              key: const ValueKey('second'),
              id: 'box',
              style: boxStyle,
              child: const SizedBox()),
          ExplicitAnimatedStyledContainer(
              key: const ValueKey('third'),
              id: 'other',
              style: boxStyle,
              child: const SizedBox()),
          ExplicitAnimatedStyledContainer(
              key: const ValueKey('fourth'),
              id: 'unused',
              style: boxStyle,
              child: const SizedBox()),
        ]))));
    await tester.tap(find.byKey(const ValueKey('first')));
    await tester.pumpAndSettle();
    expect(
        styledBoxSize(tester, find.byKey(const ValueKey('first'))).width, 200);
    expect(
        styledBoxSize(tester, find.byKey(const ValueKey('second'))).width, 200);
    expect(
        styledBoxSize(tester, find.byKey(const ValueKey('third'))).width, 50);
    expect(
        styledBoxSize(tester, find.byKey(const ValueKey('fourth'))).width, 100);
    expect(notifier.currentAnimationsControl['box'], Control.play);
  });

  group('scroll animation', () {
    late _CountingScrollController controller;

    setUp(() => controller = _CountingScrollController());
    tearDown(() => controller.dispose());

    Widget build(
        {bool show = true,
        Map<AnimationTrigger, MultiAnimationSequence> localAnimations =
            const {},
        Map<AnimationTrigger, String> globalAnimationIds = const {},
        GlobalAnimationNotifier? notifier}) {
      Widget child = ParentScroll(
          controller: controller,
          direction: Axis.vertical,
          child: SizedBox(
              height: 600,
              child: ListView(controller: controller, children: [
                const SizedBox(height: 300),
                if (show)
                  ExplicitAnimatedStyledContainer(
                      id: globalAnimationIds.isEmpty ? null : 'box',
                      style: boxStyle,
                      localAnimations: localAnimations,
                      globalAnimationIds: globalAnimationIds,
                      child: const SizedBox()),
                const SizedBox(height: 2000),
              ])));
      if (notifier != null) {
        child = ChangeNotifierProvider.value(value: notifier, child: child);
      }
      return wrap(child);
    }

    testWidgets('local', (tester) async {
      setScreenSize(tester, const Size(800, 600));
      await tester.pumpWidget(build(localAnimations: {
        AnimationTrigger.scroll: const FadeInAnimation().getAnimationSequence(),
      }));
      await tester.pumpAndSettle();
      // the box is at the middle of the screen
      expect(styledOpacity(tester, explicit),
          moreOrLessEquals(0.5, epsilon: 0.01));
      expect(controller.listeners, 1);

      controller.jumpTo(150);
      await tester.pump();
      expect(styledOpacity(tester, explicit),
          moreOrLessEquals(0.75, epsilon: 0.01));

      controller.jumpTo(0);
      await tester.pump();
      expect(styledOpacity(tester, explicit),
          moreOrLessEquals(0.5, epsilon: 0.01));

      await tester.pumpWidget(build(show: false));
      await tester.pumpAndSettle();
      expect(controller.listeners, 0);
      controller.jumpTo(100);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('global', (tester) async {
      setScreenSize(tester, const Size(800, 600));
      final GlobalAnimationNotifier notifier =
          GlobalAnimationNotifier(animationPool: {
        'fade': GlobalAnimation(sequences: {
          'box': const FadeInAnimation().getAnimationSequence(),
        }),
      });
      await tester.pumpWidget(build(
          globalAnimationIds: {AnimationTrigger.scroll: 'fade'},
          notifier: notifier));
      await tester.pumpAndSettle();
      expect(styledOpacity(tester, explicit),
          moreOrLessEquals(0.5, epsilon: 0.01));
      expect(controller.listeners, 1);

      controller.jumpTo(150);
      await tester.pump();
      expect(styledOpacity(tester, explicit),
          moreOrLessEquals(0.75, epsilon: 0.01));

      await tester.pumpWidget(build(show: false, notifier: notifier));
      await tester.pumpAndSettle();
      expect(controller.listeners, 0);
      controller.jumpTo(100);
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });

  // the transform of the full style can move the container away from where
  // it is tapped
  Style untransformedFullStyle() => fullStyle()..transform = null;

  // the full style aligns the box to the top right of the container
  final Finder styledBox = find
      .descendant(of: explicit, matching: find.byType(DimensionSizedBox))
      .first;

  testWidgets('every preset animation plays', (tester) async {
    for (final String name in presetAllAnimations.keys) {
      await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
          key: ValueKey(name),
          style: untransformedFullStyle(),
          localAnimations: {
            AnimationTrigger.tap:
                presetAllAnimations[name]!.getAnimationSequence(),
          },
          child: const Text('child'))));
      await tester.tap(styledBox);
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: name);
    }
  });

  testWidgets('animates every property', (tester) async {
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: untransformedFullStyle(),
        localAnimations: {
          AnimationTrigger.tap: customMultiAnimationSequence()
            ..control = Control.play
            ..merge(MultiAnimationSequence(sequences: {
              AnimationProperty.foregroundDecoration:
                  AnimationSequence<BoxDecoration>()
                    ..add(value: const BoxDecoration(color: blue)),
              AnimationProperty.padding: AnimationSequence<EdgeInsets>()
                ..add(value: const EdgeInsets.all(10)),
              AnimationProperty.height: AnimationSequence<Dimension>()
                ..add(value: 20.toVHLength),
              AnimationProperty.shadows: AnimationSequence<List<ShapeShadow>>()
                ..add(value: preDefinedShapeShadow[4]!),
              AnimationProperty.insetShadows:
                  AnimationSequence<List<ShapeShadow>>()..add(value: const []),
              AnimationProperty.transformAlignment:
                  AnimationSequence<Alignment>()..add(value: Alignment.topLeft),
              AnimationProperty.childAlignment: AnimationSequence<Alignment>()
                ..add(value: Alignment.bottomLeft),
            })),
        },
        child: const Text('child'))));
    await tester.tap(styledBox);
    for (int i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(styledOpacity(tester, explicit), 1.0);
    final Container foreground = tester
        .widgetList<Container>(
            find.descendant(of: explicit, matching: find.byType(Container)))
        .firstWhere((container) => container.foregroundDecoration != null);
    expect(foreground.foregroundDecoration, const BoxDecoration(color: blue));
  });

  testWidgets('a looping animation can be removed', (tester) async {
    await tester.pumpWidget(wrap(ExplicitAnimatedStyledContainer(
        style: boxStyle,
        localAnimations: {
          AnimationTrigger.visible: const PulseAnimation(control: Control.loop)
              .getAnimationSequence(),
        },
        child: const SizedBox())));
    for (int i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('text style animations inside a non inheriting text style',
      (tester) async {
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: DefaultTextStyle(
            style: const TextStyle(
                inherit: false, fontSize: 14, color: Color(0xFF000000)),
            child: Center(
                child: ExplicitAnimatedStyledContainer(
                    style: boxStyle,
                    localAnimations: {
                      AnimationTrigger.tap: MultiAnimationSequence(sequences: {
                        AnimationProperty.textStyle:
                            AnimationSequence<DynamicTextStyle>()
                              ..add(
                                  value: DynamicTextStyle(
                                      fontSize: 30.toPXLength, color: red)),
                      }),
                    },
                    child: const Text('child'))))));
    await tester.tap(explicit);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    final DefaultTextStyle textStyle = tester.widget(find
        .ancestor(
            of: find.text('child'), matching: find.byType(DefaultTextStyle))
        .first);
    expect(textStyle.style.fontSize, 30);
    expect(textStyle.style.color, red);
  });
}
