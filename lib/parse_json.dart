import 'dart:convert';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/parse_json.dart';

import 'dynamic_shadow.dart';
import 'dynamic_text_style.dart';
import 'screen_scope.dart';
import 'style.dart';
import 'styled_widget.dart';

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

ScreenScope parseScreenScope(Map<String, dynamic> map) {
  double minWidth = map["minWidth"] ?? 0;
  double maxWidth = map["maxWidth"] ?? screenMaxDimension;
  double minHeight = map["minHeight"] ?? 0;
  double maxHeight = map["maxHeight"] ?? screenMaxDimension;
  return ScreenScope(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight);
}

dynamic? parsePossibleStyleMap(Map<String, dynamic>? style) {
  if (style == null) return null;
  if (style.keys.any((element) =>
      element.contains("minWidth") && element.contains("maxWidth"))) {
    return style.map((key, value) =>
        MapEntry(parseScreenScope(json.decode(key)), Style.fromJson(value)));
  }
  return Style.fromJson(style);
}

DynamicShadow? parseDynamicShadow(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color color = parseColor(map['color']) ?? Colors.black;
  DynamicOffset offset =
      parseDynamicOffset(map["offset"]) ?? DynamicOffset.zero;
  Length blurRadius = parseLength(map['blurRadius']) ?? Length(0);
  return DynamicShadow(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
  );
}

DynamicShapeShadow? parseDynamicShapeShadow(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color color = parseColor(map['color']) ?? Colors.black;
  DynamicOffset offset =
      parseDynamicOffset(map["offset"]) ?? DynamicOffset.zero;
  Length blurRadius = parseLength(map['blurRadius']) ?? Length(0);
  Gradient? gradient = parseGradient(map['gradient']);
  return DynamicShapeShadow(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
    gradient: gradient,
  );
}

DynamicTextStyle? parseDynamicTextStyle(Map<String, dynamic>? map) {
  if (map == null) return null;

  Color? color = parseColor(map['color']);
  Color? backgroundColor = parseColor(map['backgroundColor']);

  String? fontFamily = map['fontFamily'];
  Length? fontSize = parseLength(map['fontSize']);
  FontStyle? fontStyle =
      'italic' == map['fontStyle'] ? FontStyle.italic : FontStyle.normal;
  FontWeight? fontWeight =
      'w700' == map['fontWeight'] ? FontWeight.bold : FontWeight.normal;

  TextDecoration? decoration = parseTextDecoration(map['decoration']);
  Color? decorationColor = parseColor(map["decorationColor"]);
  TextDecorationStyle? decorationStyle =
      parseTextDecorationStyle(map['decorationStyle']);
  double? decorationThickness = map['decorationThickness'];

  double? height = map['height'];
  Length? letterSpacing = parseLength(map['letterSpacing']);
  Length? wordSpacing = parseLength(map['wordSpacing']);

  List<DynamicShadow>? shadows =
      map["shadows"]?.map((e) => parseDynamicShadow(e)!).toList();

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
