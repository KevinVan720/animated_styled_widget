import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';

/// Parses a [Style] from [map].
///
/// A map with a key that contains both "minWidth" and "maxWidth" (a map of
/// styles for different screen sizes) is returned unchanged.
dynamic parseStyleBase(Map<String, dynamic>? map) {
  if (map == null) return null;
  if (map.keys.any((element) =>
      element.contains("minWidth") && element.contains("maxWidth"))) {
    return map;
  }
  return Style.fromJson(map);
}

/// Parses the output of [DynamicTextStyle.toJson].
///
/// Missing values are null.
DynamicTextStyle? parseDynamicTextStyle(Map<String, dynamic>? map) {
  if (map == null) return null;

  Color? color = parseColor(map['color']);
  Color? backgroundColor = parseColor(map['backgroundColor']);

  String? fontFamily = map['fontFamily'];
  Dimension? fontSize = parseDimension(map['fontSize']);
  FontStyle? fontStyle = parseFontStyle(map['fontStyle']);
  FontWeight? fontWeight = parseFontWeight(map['fontWeight']);

  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness =
      (map['decorationThickness'] as num?)?.toDouble();

  double? height = (map['height'] as num?)?.toDouble();
  Dimension? letterSpacing = parseDimension(map['letterSpacing']);
  Dimension? wordSpacing = parseDimension(map['wordSpacing']);

  List<Shadow>? shadows = (map["shadows"] as List?)
      ?.map((e) => parseShadow(e))
      .whereType<Shadow>()
      .toList();

  return DynamicTextStyle(
      color: color,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      height: height,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      shadows: shadows);
}

SmoothMatrix4OperationType? parseSmoothSupportedOperations(String? string) {
  for (final SmoothMatrix4OperationType element
      in SmoothMatrix4OperationType.values) {
    if (string == element.toJson()) return element;
  }
  return null;
}

SmoothMatrix4? parseSmoothMatrix4(List<dynamic>? list) {
  if (list == null) return null;
  return SmoothMatrix4.fromJson(list);
}

AnimationTrigger? parseAnimationTrigger(String? str) {
  for (final AnimationTrigger element in AnimationTrigger.values) {
    if (element.toJson() == str) return element;
  }
  return null;
}

/// Unknown names are parsed as [AnimationProperty.opacity].
AnimationProperty parseAnimationProperty(String? str) {
  for (final AnimationProperty element in AnimationProperty.values) {
    if (element.toJson() == str) return element;
  }
  return AnimationProperty.opacity;
}

Control? parseCustomAnimationControl(String? str) {
  for (final Control element in Control.values) {
    if (element.toJson() == str) return element;
  }
  return null;
}
