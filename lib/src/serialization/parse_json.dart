import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

ScreenScope parseScreenScope(Map<String, dynamic> map) {
  double minWidth = map["minWidth"].toDouble() ?? 0;
  double maxWidth = map["maxWidth"].toDouble() ?? screenMaxDimension;
  double minHeight = map["minHeight"].toDouble() ?? 0;
  double maxHeight = map["maxHeight"].toDouble() ?? screenMaxDimension;
  return ScreenScope(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight);
}

dynamic? parseStyleBase(Map<String, dynamic>? map) {
  if (map == null) return null;
  if (map.keys.any((element) =>
      element.contains("minWidth") && element.contains("maxWidth"))) {
    return map;
  }
  return Style.fromJson(map);
}

DynamicTextStyle? parseDynamicTextStyle(Map<String, dynamic>? map) {
  if (map == null) return null;

  Color? color = parseColor(map['color']);
  Color? backgroundColor = parseColor(map['backgroundColor']);

  String? fontFamily = map['fontFamily'];
  Dimension? fontSize = parseDimension(map['fontSize']);
  FontStyle? fontStyle =
      'italic' == map['fontStyle'] ? FontStyle.italic : FontStyle.normal;
  FontWeight? fontWeight =
      'w700' == map['fontWeight'] ? FontWeight.bold : FontWeight.normal;

  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness = map['decorationThickness']?.toDouble();

  double? height = map['height']?.toDouble();
  Dimension? letterSpacing = parseDimension(map['letterSpacing']);
  Dimension? wordSpacing = parseDimension(map['wordSpacing']);

  List<Shadow>? shadows =
      map["shadows"]?.map((e) => parseShadow(e)!).toList().cast<Shadow>();

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
  SmoothMatrix4OperationType? rst;
  SmoothMatrix4OperationType.values.forEach((element) {
    if (string == element.toJson()) rst = element;
  });
  return rst;
}

SmoothMatrix4? parseSmoothMatrix4(List<dynamic>? list) {
  if (list == null) return null;
  return SmoothMatrix4.fromJson(list);
}

AnimationTrigger? parseAnimationTrigger(String str) {
  AnimationTrigger? trigger;
  AnimationTrigger.values.forEach((element) {
    if (element.toJson() == str) trigger = element;
  });
  return trigger;
}

AnimationProperty parseAnimationProperty(String str) {
  AnimationProperty property = AnimationProperty.opacity;
  AnimationProperty.values.forEach((element) {
    if (element.toJson() == str) property = element;
  });
  return property;
}

CustomAnimationControl? parseCustomAnimationControl(String str) {
  CustomAnimationControl? control;
  CustomAnimationControl.values.forEach((element) {
    if (element.toJson() == str) control = element;
  });
  return control;
}
