import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  tearDown(() {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(milliseconds: 500);
  });

  const Key key = ValueKey('detector');

  Widget detector(VisibilityChangedCallback? onVisibilityChanged,
      {double top = 0}) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(children: [
          Positioned(
              left: 10,
              top: top,
              child: VisibilityDetector(
                  key: key,
                  onVisibilityChanged: onVisibilityChanged,
                  child: const SizedBox(width: 100, height: 100))),
        ]));
  }

  testWidgets('reports the visibility', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final List<VisibilityInfo> infos = [];
    await tester.pumpWidget(detector(infos.add));
    await tester.pump();
    expect(infos, hasLength(1));
    expect(infos.last.key, key);
    expect(infos.last.visibleFraction, 1.0);
    expect(infos.last.size, const Size(100, 100));
    expect(infos.last.widgetBounds, const Rect.fromLTWH(10, 0, 100, 100));
    expect(VisibilityDetectorController.instance.widgetBoundsFor(key),
        const Rect.fromLTWH(10, 0, 100, 100));

    // half of it is below the screen
    await tester.pumpWidget(detector(infos.add, top: 550));
    await tester.pump();
    expect(infos.last.visibleFraction, moreOrLessEquals(0.5));
    expect(infos.last.visibleBounds, const Rect.fromLTWH(0, 0, 100, 50));

    // moving without changing the visibility is not reported
    final int count = infos.length;
    await tester.pumpWidget(detector(infos.add, top: 550));
    await tester.pump();
    expect(infos, hasLength(count));

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(infos.last.visibleFraction, 0.0);
    expect(VisibilityDetectorController.instance.widgetBoundsFor(key), isNull);
  });

  testWidgets('clipping', (tester) async {
    final List<VisibilityInfo> infos = [];
    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
            child: SizedBox(
                width: 100,
                height: 100,
                child: ClipRect(
                    child: OverflowBox(
                        maxWidth: 400,
                        alignment: Alignment.centerLeft,
                        child: VisibilityDetector(
                            key: key,
                            onVisibilityChanged: infos.add,
                            child:
                                const SizedBox(width: 400, height: 100))))))));
    await tester.pump();
    expect(infos.last.visibleFraction, moreOrLessEquals(0.25));
  });

  testWidgets('without a callback', (tester) async {
    await tester.pumpWidget(detector(null));
    await tester.pump();
    final List<VisibilityInfo> infos = [];
    await tester.pumpWidget(detector(infos.add));
    await tester.pump();
    expect(infos.last.visibleFraction, 1.0);
    await tester.pumpWidget(detector(null));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('notifyNow and forget', (tester) async {
    VisibilityDetectorController.instance.updateInterval =
        const Duration(seconds: 1);
    final List<VisibilityInfo> infos = [];
    await tester.pumpWidget(detector(infos.add));
    expect(infos, isEmpty);
    VisibilityDetectorController.instance.notifyNow();
    expect(infos, hasLength(1));

    await tester.pumpWidget(detector(infos.add, top: 50));
    VisibilityDetectorController.instance.forget(key);
    await tester.pump(const Duration(seconds: 2));
    expect(infos, hasLength(1));
    await tester.pumpWidget(const SizedBox());
    VisibilityDetectorController.instance.forget(key);
  });

  test('VisibilityInfo', () {
    final VisibilityInfo info = VisibilityInfo.fromRects(
        key: key,
        widgetBounds: const Rect.fromLTWH(0, 0, 100, 100),
        clipRect: const Rect.fromLTWH(50, 0, 100, 100));
    expect(info.visibleFraction, 0.5);
    expect(info.visibleBounds, const Rect.fromLTWH(50, 0, 50, 100));
    expect(info.matchesVisibility(info), isTrue);

    final VisibilityInfo hidden = VisibilityInfo.fromRects(
        key: key,
        widgetBounds: const Rect.fromLTWH(0, 0, 100, 100),
        clipRect: const Rect.fromLTWH(200, 0, 100, 100));
    expect(hidden.visibleFraction, 0.0);
    expect(hidden.matchesVisibility(info), isFalse);

    expect(const VisibilityInfo(key: key).visibleFraction, 0.0);
    expect(const VisibilityInfo(key: key).size, Size.zero);
  });
}
