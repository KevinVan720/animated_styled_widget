import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' show MaterialApp, Scaffold;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fixture_objects.dart';
import 'support/test_utils.dart';

Style box(double width, [double height = 40]) =>
    Style(width: width.toPXLength, height: height.toPXLength);

/// Wraps [child] in an [Overlay] (needed by the slider's tooltip).
///
/// The overlay only builds the child of its first build, unless the [key]
/// changes.
Widget wrapWithOverlay(Widget child, {Key? key}) {
  return wrap(Overlay(key: key, initialEntries: [
    OverlayEntry(builder: (context) => Center(child: child)),
  ]));
}

Future<TestGesture> hover(WidgetTester tester, Finder finder) async {
  final TestGesture gesture =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(finder));
  return gesture;
}

void main() {
  group('StyledButton', () {
    final Finder button = find.byType(StyledButton);

    Widget build({VoidCallback? onPressed, Key? key, Style? textStyle}) {
      return wrap(StyledButton(
          key: key,
          onPressed: onPressed,
          style: box(100),
          hoveredStyle: box(120).merge(textStyle),
          pressedStyle: box(80),
          disabledStyle: box(60),
          child: const Text('button')));
    }

    testWidgets('idle, hovered, pressed', (tester) async {
      int presses = 0;
      await tester.pumpWidget(build(onPressed: () => presses++));
      expect(styledBoxSize(tester, button), const Size(100, 40));

      final TestGesture mouse = await hover(tester, button);
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, button), const Size(120, 40));
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, button), const Size(100, 40));

      final TestGesture touch =
          await tester.startGesture(tester.getCenter(button));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(styledBoxSize(tester, button), const Size(80, 40));
      expect(presses, 0);
      await touch.up();
      await tester.pumpAndSettle();
      expect(presses, 1);
      expect(styledBoxSize(tester, button), const Size(100, 40));

      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(presses, 2);
      expect(styledBoxSize(tester, button), const Size(100, 40));
    });

    testWidgets('a cancelled press does not call onPressed', (tester) async {
      int presses = 0;
      await tester.pumpWidget(build(onPressed: () => presses++));
      final TestGesture touch =
          await tester.startGesture(tester.getCenter(button));
      await tester.pump(const Duration(milliseconds: 200));
      await touch.moveBy(const Offset(0, 300));
      await touch.up();
      await tester.pumpAndSettle();
      expect(presses, 0);
      expect(styledBoxSize(tester, button), const Size(100, 40));
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(build());
      expect(styledBoxSize(tester, button), const Size(60, 40));
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, button), const Size(60, 40));

      await tester.pumpWidget(build(onPressed: () {}));
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, button), const Size(100, 40));
    });

    testWidgets('uses the key', (tester) async {
      await tester
          .pumpWidget(build(key: const ValueKey('button'), onPressed: () {}));
      expect(find.byKey(const ValueKey('button')), findsOneWidget);
    });

    testWidgets('builder gets the state', (tester) async {
      final List<StyledComponentState> states = [];
      await tester.pumpWidget(wrap(StyledButton.builder(
          onPressed: () {},
          style: box(100),
          builder: (context, state) {
            states.add(state);
            return Text(state.name);
          })));
      expect(find.text('idle'), findsOneWidget);
      final TestGesture mouse = await hover(tester, button);
      await tester.pumpAndSettle();
      expect(find.text('hovered'), findsOneWidget);
      await mouse.down(tester.getCenter(button));
      await tester.pump();
      expect(find.text('pressed'), findsOneWidget);
      await mouse.up();
      await tester.pumpAndSettle();
      expect(find.text('hovered'), findsOneWidget);
      expect(
          states,
          containsAll(StyledComponentState.values.toSet()
            ..remove(StyledComponentState.selected)
            ..remove(StyledComponentState.disabled)));
    });

    testWidgets('can be removed while pressed', (tester) async {
      await tester.pumpWidget(build(onPressed: () {}));
      final TestGesture touch =
          await tester.startGesture(tester.getCenter(button));
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pumpWidget(const SizedBox());
      await touch.up();
      await tester.pump(const Duration(seconds: 1));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a text style in a non inheriting text style', (tester) async {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: Center(
                  child: StyledButton(
                      onPressed: () {},
                      style: box(100),
                      hoveredStyle: box(120).copyWith(
                          textStyle: const DynamicTextStyle(color: red)),
                      child: const Text('button'))))));
      await hover(tester, button);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      final DefaultTextStyle textStyle = tester.widget(find
          .ancestor(
              of: find.text('button'), matching: find.byType(DefaultTextStyle))
          .first);
      expect(textStyle.style.color, red);
    });
  });

  group('toggleables', () {
    testWidgets('StyledToggleable without selected keeps its own state',
        (tester) async {
      int changes = 0;
      final Finder toggleable = find.byType(StyledToggleable);
      await tester.pumpWidget(wrap(StyledToggleable(
          key: const ValueKey('toggleable'),
          onChanged: () => changes++,
          style: box(40),
          selectedStyle: box(60),
          child: const Text('toggle'))));
      expect(find.byKey(const ValueKey('toggleable')), findsOneWidget);
      expect(styledBoxSize(tester, toggleable).width, 40);
      await tester.tap(toggleable);
      await tester.pumpAndSettle();
      expect(changes, 1);
      expect(styledBoxSize(tester, toggleable).width, 60);
      await tester.tap(toggleable);
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, toggleable).width, 40);
    });

    testWidgets('StyledToggleable needs selected or onChanged', (tester) async {
      expect(() => StyledToggleable(style: Style()), throwsAssertionError);
    });

    testWidgets('StyledCheckbox', (tester) async {
      bool value = false;
      final Finder checkbox = find.byType(StyledCheckbox);
      await tester.pumpWidget(wrap(StatefulBuilder(
          builder: (context, setState) => StyledCheckbox(
              key: const ValueKey('checkbox'),
              value: value,
              onChanged: (newValue) => setState(() => value = newValue),
              style: box(40),
              hoveredStyle: box(50),
              selectedStyle: box(60),
              disabledStyle: box(20),
              child: const Text('check')))));
      expect(find.byKey(const ValueKey('checkbox')), findsOneWidget);
      expect(styledBoxSize(tester, checkbox).width, 40);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(value, isTrue);
      expect(styledBoxSize(tester, checkbox).width, 60);

      await tester.tap(checkbox);
      await tester.pumpAndSettle();
      expect(value, isFalse);
      expect(styledBoxSize(tester, checkbox).width, 40);

      final TestGesture mouse = await hover(tester, checkbox);
      await tester.pumpAndSettle();
      expect(styledBoxSize(tester, checkbox).width, 50);
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
    });

    testWidgets('StyledCheckbox disabled', (tester) async {
      await tester.pumpWidget(wrap(StyledCheckbox.builder(
          value: true,
          onChanged: null,
          style: box(40),
          disabledStyle: box(20),
          builder: (context, state) => Text(state.name))));
      expect(find.text('disabled'), findsOneWidget);
      expect(styledBoxSize(tester, find.byType(StyledCheckbox)).width, 20);
    });

    testWidgets('StyledRadio', (tester) async {
      int? groupValue = 1;
      await tester.pumpWidget(wrap(StatefulBuilder(
          builder: (context, setState) =>
              Column(mainAxisSize: MainAxisSize.min, children: [
                for (int i = 1; i <= 3; i++)
                  StyledRadio<int>(
                      key: ValueKey(i),
                      value: i,
                      groupValue: groupValue,
                      onChanged: (value) => setState(() => groupValue = value),
                      style: box(40),
                      selectedStyle: box(60),
                      child: Text('$i')),
              ]))));
      double width(int i) =>
          styledBoxSize(tester, find.byKey(ValueKey(i))).width;
      expect([width(1), width(2), width(3)], [60, 40, 40]);
      await tester.tap(find.text('2'));
      await tester.pumpAndSettle();
      expect(groupValue, 2);
      expect([width(1), width(2), width(3)], [40, 60, 40]);
    });

    testWidgets('StyledToggleButtons', (tester) async {
      final List<bool> isSelected = [true, false, false];
      final List<int> presses = [];
      for (final Axis direction in Axis.values) {
        await tester.pumpWidget(wrap(StatefulBuilder(
            builder: (context, setState) => StyledToggleButtons(
                key: ValueKey(direction),
                direction: direction,
                isSelected: isSelected,
                onPressed: (index) => setState(() {
                      presses.add(index);
                      isSelected[index] = !isSelected[index];
                    }),
                style: box(40),
                selectedStyle: box(60),
                children: const [Text('a'), Text('b'), Text('c')]))));
        expect(find.byKey(ValueKey(direction)), findsOneWidget);
        await tester.tap(find.text('b'));
        await tester.pumpAndSettle();
      }
      expect(presses, [1, 1]);
      expect(isSelected, [true, false, false]);
    });

    testWidgets('StyledToggleButtons.builder', (tester) async {
      await tester.pumpWidget(wrap(StyledToggleButtons.builder(
          isSelected: const [false, true],
          style: box(40),
          builder: (context, state, index) => Text('$index ${state.name}'))));
      expect(find.text('0 disabled'), findsOneWidget);
      expect(find.text('1 disabled'), findsOneWidget);
    });

    testWidgets('StyledNavigationBar', (tester) async {
      int index = 0;
      for (final Axis direction in Axis.values) {
        await tester.pumpWidget(wrap(SizedBox(
            width: 300,
            height: 300,
            child: StatefulBuilder(
                builder: (context, setState) => StyledNavigationBar(
                    key: ValueKey(direction),
                    direction: direction,
                    currentIndex: index,
                    onTap: (newIndex) => setState(() => index = newIndex),
                    style: box(40),
                    selectedStyle: box(60),
                    children: const [Text('a'), Text('b'), Text('c')])))));
        expect(find.byKey(ValueKey(direction)), findsOneWidget);
        await tester.tap(find.text(direction == Axis.horizontal ? 'c' : 'a'));
        await tester.pumpAndSettle();
      }
      expect(index, 0);
    });

    testWidgets('StyledNavigationBar.builder', (tester) async {
      await tester.pumpWidget(wrap(SizedBox(
          width: 300,
          height: 100,
          child: StyledNavigationBar.builder(
              itemCount: 2,
              currentIndex: 1,
              onTap: (_) {},
              style: box(40),
              itemBuilder: (context, state, index) =>
                  Text('$index ${state.name}')))));
      expect(find.text('0 idle'), findsOneWidget);
      expect(find.text('1 selected'), findsOneWidget);
    });
  });

  group('StyledSwitch', () {
    final Finder switchFinder = find.byType(StyledSwitch);

    Widget build(
        {required bool value,
        ValueChanged<bool>? onChanged,
        Axis direction = Axis.horizontal,
        Style? thumbStyle,
        Style? trackDisabledStyle,
        Key? key}) {
      return wrap(StyledSwitch(
          key: key,
          value: value,
          onChanged: onChanged,
          direction: direction,
          thumbStyle: thumbStyle ?? box(20, 20),
          thumbSelectedStyle: box(24, 24),
          trackStyle: direction == Axis.horizontal ? box(60, 30) : box(30, 60),
          trackSelectedStyle:
              direction == Axis.horizontal ? box(60, 30) : box(30, 60),
          trackDisabledStyle: trackDisabledStyle,
          thumbChild: const Text('thumb')));
    }

    Alignment thumbAlignment(WidgetTester tester) => tester
        .widget<AnimatedAlign>(find.descendant(
            of: switchFinder, matching: find.byType(AnimatedAlign)))
        .alignment as Alignment;

    testWidgets('toggles', (tester) async {
      bool value = false;
      for (final Axis direction in Axis.values) {
        value = false;
        await tester.pumpWidget(StatefulBuilder(
            builder: (context, setState) => build(
                key: ValueKey(direction),
                value: value,
                direction: direction,
                onChanged: (newValue) => setState(() => value = newValue))));
        expect(find.byKey(ValueKey(direction)), findsOneWidget);
        expect(
            thumbAlignment(tester),
            direction == Axis.horizontal
                ? Alignment.centerLeft
                : Alignment.bottomCenter);
        await tester.tap(find.text('thumb'));
        await tester.pumpAndSettle();
        expect(value, isTrue);
        expect(
            thumbAlignment(tester),
            direction == Axis.horizontal
                ? Alignment.centerRight
                : Alignment.topCenter);
        expect(tester.takeException(), isNull);
      }
    });

    testWidgets('does not modify the styles', (tester) async {
      final Style thumbStyle =
          box(20, 20).copyWith(alignment: Alignment.center);
      await tester.pumpWidget(
          build(value: false, onChanged: (_) {}, thumbStyle: thumbStyle));
      expect(thumbStyle.alignment, Alignment.center);
    });

    testWidgets('uses the disabled track style', (tester) async {
      await tester
          .pumpWidget(build(value: false, trackDisabledStyle: box(80, 30)));
      await tester.pumpAndSettle();
      expect(tester.getSize(switchFinder).width, 80);
    });
  });

  group('StyledSlider', () {
    final Finder slider = find.byType(StyledSlider);
    final Finder thumb = find.descendant(
        of: find.byType(CompositedTransformTarget),
        matching: find.byType(AnimatedStyledContainer));

    Widget build(
        {double value = 0.5,
        ValueChanged<double>? onChanged,
        ValueChanged<double>? onChangeStart,
        ValueChanged<double>? onChangeEnd,
        int? divisions,
        Axis direction = Axis.horizontal,
        Style? thumbStyle,
        bool isTrackContained = false}) {
      return StyledSlider(
        key: const ValueKey('slider'),
        value: value,
        onChanged: onChanged,
        onChangeStart: onChangeStart,
        onChangeEnd: onChangeEnd,
        divisions: divisions,
        direction: direction,
        isTrackContained: isTrackContained,
        label: 'label',
        toolTipStyle: box(50, 20),
        trackStyle: direction == Axis.horizontal ? box(200, 10) : box(10, 200),
        activeTrackStyle:
            Style(backgroundDecoration: const BoxDecoration(color: blue)),
        thumbStyle: thumbStyle ?? box(20, 20),
        thumbPressedStyle: box(24, 24),
        thumbDisabledStyle: box(30, 30),
      );
    }

    /// Pumps the widget built by [builder] in an [Overlay] (needed by the
    /// tooltip), it is built again when [rebuild] notifies.
    Future<void> pumpSlider(WidgetTester tester, Widget Function() builder,
        {Listenable? rebuild, Key? key}) async {
      await tester.pumpWidget(wrapWithOverlay(
          ListenableBuilder(
              listenable: rebuild ?? Listenable.merge(const []),
              builder: (context, child) => builder()),
          key: key));
    }

    testWidgets('drag and tap', (tester) async {
      final List<double> starts = [], ends = [];
      for (final Axis direction in Axis.values) {
        for (final bool contained in [false, true]) {
          double value = 0.5;
          final ValueNotifier<int> rebuild = ValueNotifier(0);
          addTearDown(rebuild.dispose);
          await pumpSlider(
              tester,
              () => build(
                  value: value,
                  direction: direction,
                  isTrackContained: contained,
                  onChangeStart: starts.add,
                  onChangeEnd: ends.add,
                  onChanged: (newValue) {
                    value = newValue;
                    rebuild.value++;
                  }),
              rebuild: rebuild,
              key: ValueKey('$direction $contained'));
          expect(find.byKey(const ValueKey('slider')), findsOneWidget);
          await tester.drag(
              thumb,
              direction == Axis.horizontal
                  ? const Offset(60, 0)
                  : const Offset(0, -60));
          await tester.pumpAndSettle();
          expect(value, greaterThan(0.6));
          expect(tester.takeException(), isNull);

          final Rect rect = tester.getRect(slider);
          await tester.tapAt(direction == Axis.horizontal
              ? rect.centerLeft + const Offset(15, 0)
              : rect.bottomCenter - const Offset(0, 15));
          await tester.pumpAndSettle();
          expect(value, lessThan(0.2));
        }
      }
      expect(starts, hasLength(4));
      expect(ends, hasLength(4));
    });

    testWidgets('divisions', (tester) async {
      final List<double> values = [];
      await pumpSlider(
          tester, () => build(value: 0.5, divisions: 4, onChanged: values.add));
      await tester.drag(thumb, const Offset(100, 0));
      await tester.pumpAndSettle();
      expect(values, isNotEmpty);
      for (final double value in values) {
        expect(value * 4, moreOrLessEquals((value * 4).roundToDouble()));
      }
    });

    testWidgets('follows the value', (tester) async {
      double value = 0.5;
      final ValueNotifier<int> rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);
      await pumpSlider(tester, () => build(value: value, onChanged: (_) {}),
          rebuild: rebuild);
      final double left = tester.getRect(slider).left;
      expect(tester.getCenter(thumb).dx - left, moreOrLessEquals(110));
      value = 0.1;
      rebuild.value++;
      await tester.pumpAndSettle();
      expect(tester.getCenter(thumb).dx - left, moreOrLessEquals(30));
    });

    testWidgets('disabled', (tester) async {
      await pumpSlider(tester, () => build());
      await tester.pumpAndSettle();
      expect(tester.getSize(thumb), const Size(30, 30));
    });

    testWidgets('does not modify the thumb style', (tester) async {
      final Style thumbStyle =
          box(20, 20).copyWith(alignment: Alignment.center);
      await pumpSlider(
          tester, () => build(thumbStyle: thumbStyle, onChanged: (_) {}));
      expect(thumbStyle.alignment, Alignment.center);
    });

    testWidgets('shows the label while pressed', (tester) async {
      await pumpSlider(tester, () => build(onChanged: (_) {}));
      final TestGesture touch =
          await tester.startGesture(tester.getCenter(thumb));
      await tester.pumpAndSettle();
      expect(find.text('label'), findsOneWidget);
      await touch.up();
      await tester.pumpAndSettle();
      expect(find.text('label'), findsNothing);
    });

    testWidgets('removes the label when removed', (tester) async {
      bool show = true;
      final ValueNotifier<int> rebuild = ValueNotifier(0);
      addTearDown(rebuild.dispose);
      await pumpSlider(
          tester, () => show ? build(onChanged: (_) {}) : const SizedBox(),
          rebuild: rebuild);
      final TestGesture touch =
          await tester.startGesture(tester.getCenter(thumb));
      await tester.pumpAndSettle();
      expect(find.text('label'), findsOneWidget);
      show = false;
      rebuild.value++;
      await tester.pumpAndSettle();
      expect(find.text('label'), findsNothing);
      await touch.up();
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('needs sizes', (tester) async {
      expect(
          () => StyledSlider(
              value: 0,
              onChanged: null,
              trackStyle: Style(),
              thumbStyle: box(20)),
          throwsAssertionError);
      expect(
          () => StyledSlider(
              value: 0,
              onChanged: null,
              trackStyle: box(100),
              thumbStyle: Style(width: 10.toPercentLength)),
          throwsAssertionError);
    });
  });

  group('StyledPopupMenuButton', () {
    final Finder menuButton = find.byType(StyledPopupMenuButton<int>);

    double itemHeight(WidgetTester tester, String text) => styledBoxSize(
        tester,
        find.ancestor(
            of: find.text(text),
            matching: find.byWidgetPredicate(
                (widget) => widget is StyledPopupMenuItem))).height;

    Widget build(
        {int? initialValue,
        bool enabled = true,
        ValueChanged<int>? onSelected,
        VoidCallback? onCanceled}) {
      return MaterialApp(
          home: Scaffold(
              body: Center(
                  child: StyledPopupMenuButton<int>(
                      key: const ValueKey('menu'),
                      enabled: enabled,
                      initialValue: initialValue,
                      onSelected: onSelected,
                      onCanceled: onCanceled,
                      style: box(100),
                      disabledStyle: box(60),
                      menuStyle: Style(
                          backgroundDecoration:
                              const BoxDecoration(color: blue)),
                      itemBuilder: (context) => [
                            for (int i = 1; i <= 3; i++)
                              StyledPopupMenuItem<int>(
                                  value: i,
                                  enabled: i != 3,
                                  style: box(100, 40),
                                  selectedStyle: box(100, 50),
                                  disabledStyle: box(100, 30),
                                  child: Text('item $i')),
                          ],
                      child: const Text('open')))));
    }

    testWidgets('selects an item', (tester) async {
      final List<int> selected = [];
      int canceled = 0;
      await tester.pumpWidget(
          build(onSelected: selected.add, onCanceled: () => canceled++));
      expect(find.byKey(const ValueKey('menu')), findsOneWidget);
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(find.text('item 1'), findsOneWidget);
      await tester.tap(find.text('item 2'));
      await tester.pumpAndSettle();
      expect(selected, [2]);
      expect(canceled, 0);
      expect(find.text('item 1'), findsNothing);
    });

    testWidgets('cancels', (tester) async {
      final List<int> selected = [];
      int canceled = 0;
      await tester.pumpWidget(
          build(onSelected: selected.add, onCanceled: () => canceled++));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(1, 1));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(canceled, 1);
    });

    testWidgets('selects the initial value', (tester) async {
      final List<int> selected = [];
      int canceled = 0;
      await tester.pumpWidget(build(
          initialValue: 2,
          onSelected: selected.add,
          onCanceled: () => canceled++));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(itemHeight(tester, 'item 1'), 40);
      expect(itemHeight(tester, 'item 2'), 50);
      await tester.tap(find.text('item 2'));
      await tester.pumpAndSettle();
      expect(selected, [2]);
      expect(canceled, 0);
    });

    testWidgets('disabled items can not be selected', (tester) async {
      final List<int> selected = [];
      await tester.pumpWidget(build(onSelected: selected.add));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(itemHeight(tester, 'item 1'), 40);
      expect(itemHeight(tester, 'item 3'), 30);
      await tester.tap(find.text('item 3'));
      await tester.pumpAndSettle();
      expect(selected, isEmpty);
      expect(find.text('item 3'), findsOneWidget);
    });

    testWidgets('disabled button', (tester) async {
      await tester.pumpWidget(build(enabled: false));
      expect(styledBoxSize(tester, menuButton), const Size(60, 40));
      await tester.tap(menuButton);
      await tester.pumpAndSettle();
      expect(find.text('item 1'), findsNothing);
    });
  });
}
