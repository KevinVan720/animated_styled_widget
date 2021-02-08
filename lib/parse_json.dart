import 'dart:convert';

import 'package:length_unit/length_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/parse_json.dart';

import 'style.dart';
import 'screen_scope.dart';
import 'dynamic_text_style.dart';
import 'dynamic_edge_insets.dart';
import 'dynamic_shadow.dart';

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

Length? parseLength(String? string) {
  return Length.fromJson(string);
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

DynamicBoxShadow? parseDynamicBoxShadow(Map<String, dynamic>? map) {
  if (map == null) return null;
  Color color = parseColor(map['color']) ?? Colors.black;
  DynamicOffset offset =
      parseDynamicOffset(map["offset"]) ?? DynamicOffset.zero;
  Length blurRadius = parseLength(map['blurRadius']) ?? Length(0);
  Length spreadRadius = parseLength(map['spreadRadius']) ?? Length(0);
  return DynamicBoxShadow(
    color: color,
    offset: offset,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
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
  double? letterSpacing = map['letterSpacing'];
  double? wordSpacing = map['wordSpacing'];

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

DynamicEdgeInsets? parseDynamicEdgeInsets(Map<String, dynamic>? map) {
  if (map == null) return null;
  Length? top = parseLength(map['top']);
  Length? bottom = parseLength(map['bottom']);
  Length? left = parseLength(map['left']);
  Length? right = parseLength(map['right']);
  return DynamicEdgeInsets.only(
    top: top,
    bottom: bottom,
    left: left,
    right: right,
  );
}
