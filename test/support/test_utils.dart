import 'dart:convert';
import 'dart:io';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Sets the logical size of the test view (with a device pixel ratio of 1)
/// and resets it at the end of the test.
void setScreenSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

/// Wraps [child] in the minimal set of widgets needed to lay out text.
Widget wrap(Widget child, {double fontSize = 14}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: DefaultTextStyle(
      style: TextStyle(fontSize: fontSize, color: const Color(0xFF000000)),
      child: Center(child: child),
    ),
  );
}

/// The size of the box sized by the style's width and height.
Size styledBoxSize(WidgetTester tester, Finder styledWidget) {
  return tester.getSize(find
      .descendant(of: styledWidget, matching: find.byType(DimensionSizedBox))
      .first);
}

/// The opacity of a styled container (the first [Opacity] or, for the
/// implicitly animated containers, [FadeTransition] below it).
double styledOpacity(WidgetTester tester, Finder styledWidget) {
  final Finder opacity =
      find.descendant(of: styledWidget, matching: find.byType(Opacity));
  if (opacity.evaluate().isNotEmpty) {
    return tester.widget<Opacity>(opacity.first).opacity;
  }
  final Finder fade =
      find.descendant(of: styledWidget, matching: find.byType(FadeTransition));
  return tester.widget<FadeTransition>(fade.first).opacity.value;
}

/// The JSON text of a fixture in test/fixtures, re-encoded without
/// whitespace.
String fixtureJson(String name) {
  final String text = File('test/fixtures/$name.json').readAsStringSync();
  return jsonEncode(jsonDecode(text));
}

/// The decoded JSON of a fixture in test/fixtures.
dynamic fixture(String name) => jsonDecode(fixtureJson(name));

/// Replaces doubles that are whole numbers by ints, like jsonEncode does
/// when running on the web.
dynamic wholeDoublesToInts(dynamic json) {
  if (json is double && json.isFinite && json == json.roundToDouble()) {
    return json.toInt();
  }
  if (json is List) return json.map(wholeDoublesToInts).toList();
  if (json is Map) {
    return json.map<String, dynamic>(
        (key, value) => MapEntry(key as String, wholeDoublesToInts(value)));
  }
  return json;
}

/// Encodes and decodes [json], like storing and loading it would.
dynamic jsonRoundTrip(dynamic json) => jsonDecode(jsonEncode(json));
