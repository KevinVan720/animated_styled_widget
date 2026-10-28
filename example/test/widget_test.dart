import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:example/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    // Report visibility changes at the end of the frame instead of with a
    // timer, so that no timers are pending at the end of the test.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  testWidgets('every demo page builds and animates', (tester) async {
    tester.view.physicalSize = const Size(1600, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Network images can not be loaded in tests (all requests fail), ignore
    // these errors.
    final FlutterExceptionHandler? onError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException) return;
      onError?.call(details);
    };

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('Responsive Styled Widget'), findsOneWidget);

    final List<String> pages = [
      for (final Text text in tester.widgetList<Text>(find.descendant(
          of: find.byType(ElevatedButton), matching: find.byType(Text))))
        text.data!,
    ];
    expect(pages, hasLength(greaterThan(15)));

    for (final String page in pages) {
      final Finder button = find.widgetWithText(ElevatedButton, page);
      await tester.scrollUntilVisible(button, 100,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(button);
      // some pages loop their animations, so they never settle
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(tester.takeException(), isNull, reason: page);

      // tap the middle of the page, which triggers tap animations
      await tester.tapAt(tester.getCenter(find.byType(Scaffold).last));
      for (int i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(tester.takeException(), isNull, reason: page);

      // the tap can also have opened a menu
      final NavigatorState navigator =
          tester.state(find.byType(Navigator).first);
      navigator.popUntil((route) => route.isFirst);
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.text('Responsive Styled Widget'), findsOneWidget,
          reason: page);
    }

    // remove the app, which stops the looping animations
    await tester.pumpWidget(const SizedBox());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    FlutterError.onError = onError;
  });
}
