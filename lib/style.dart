import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_class_parser/parse_json.dart';
import 'package:flutter_class_parser/to_json.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'dynamic_shadow.dart';
import 'dynamic_text_style.dart';
import 'parse_json.dart';
import 'screen_scope.dart';
import 'styled_widget.dart';

class Style {
  ///children properties in layoutWidgets
  int? flex;
  int? gridColumnCount;
  int? gridRowCount;
  DynamicEdgeInsets? stackPosition;

  bool? visible;
  double? opacity;

  Alignment? alignment;

  Dimension? width;
  Dimension? height;

  DynamicEdgeInsets? margin;
  DynamicEdgeInsets? padding;

  BoxDecoration? backgroundDecoration;
  List<DynamicShapeShadow>? shadows;
  MorphableShapeBorder? shapeBorder;

  SmoothMatrix4? transform;
  Alignment? transformAlignment;

  //text related (works only for text and icon widgets)
  Alignment? childAlignment;
  DynamicTextStyle? textStyle;
  TextAlign? textAlign;

  SystemMouseCursor? mouseCursor;

  Style({
    this.flex,
    this.gridRowCount,
    this.gridColumnCount,
    this.stackPosition,
    this.visible,
    this.alignment,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.opacity,
    this.backgroundDecoration,
    this.shadows,
    this.shapeBorder,
    this.transform,
    this.transformAlignment,
    this.childAlignment,
    this.textStyle,
    this.textAlign,
    this.mouseCursor,
  });

  Style.fromJson(Map<String, dynamic> map) {
    flex = map["flex"];
    gridRowCount = map["gridRowCount"];
    gridColumnCount = map["gridColumnCount"];
    stackPosition = parseDynamicEdgeInsets(map["stackPosition"]);

    width = parseDimension(map["width"]);
    height = parseDimension(map["height"]);
    alignment = parseAlignment(map["alignment"]);

    margin = parseDynamicEdgeInsets(map["margin"]);
    padding = parseDynamicEdgeInsets(map["padding"]);

    visible = map["visible"];
    opacity = map["opacity"];
    backgroundDecoration = parseBoxDecoration(map["backgroundDecoration"]);

    shadows = (map["shadows"] as List?)
        ?.map((e) => parseDynamicShapeShadow(e)!)
        .toList();
    shapeBorder = parseMorphableShapeBorder(map["shapeBorder"]);

    transform = parseSmoothMatrix4(map["transform"]);
    transformAlignment = parseAlignment(map["transformAlignment"]);

    childAlignment = parseAlignment(map["childAlignment"]);

    textAlign = parseTextAlign(map["textAlign"]);
    textStyle = parseDynamicTextStyle(map["textStyle"]);

    mouseCursor = parseSystemMouseCursor(map["mouseCursor"]);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("flex", flex);
    rst.updateNotNull("gridColumnCount", gridColumnCount);
    rst.updateNotNull("gridRowCount", gridRowCount);
    rst.updateNotNull("stackPosition", stackPosition?.toJson());

    rst.updateNotNull("alignment", alignment?.toJson());
    rst.updateNotNull("width", width?.toJson());
    rst.updateNotNull("height", height?.toJson());

    rst.updateNotNull("margin", margin?.toJson());
    rst.updateNotNull("padding", padding?.toJson());

    rst.updateNotNull("visible", visible);
    rst.updateNotNull("opacity", opacity);
    rst.updateNotNull("backgroundDecoration", backgroundDecoration?.toJson());
    rst.updateNotNull("shapeBorder", shapeBorder?.toJson());
    rst.updateNotNull("shadows", shadows?.map((e) => e.toJson()).toList());

    rst.updateNotNull("transform", transform?.toJson());
    rst.updateNotNull("transformAlignment", transformAlignment?.toJson());

    rst.updateNotNull("childAlignment", childAlignment?.toJson());
    rst.updateNotNull("textAlign", textAlign?.toJson());
    rst.updateNotNull("textStyle", textStyle?.toJson());

    rst.updateNotNull("mouseCursor", mouseCursor?.toJson());
    return rst;
  }

  Style copyWith({
    int? flex,
    int? gridColumnCount,
    int? gridRowCount,
    DynamicEdgeInsets? stackPosition,
    Alignment? alignment,
    Dimension? width,
    Dimension? height,
    DynamicEdgeInsets? margin,
    DynamicEdgeInsets? padding,
    bool? visible,
    double? opacity,
    BoxDecoration? backgroundDecoration,
    List<DynamicShapeShadow>? shadows,
    MorphableShapeBorder? shapeBorder,
    SmoothMatrix4? transform,
    Alignment? transformAlignment,
    Alignment? childAlignment,
    DynamicTextStyle? textStyle,
    TextAlign? textAlign,
    SystemMouseCursor? mouseCursor,
  }) {
    return Style(
      flex: flex ?? this.flex,
      gridColumnCount: gridColumnCount ?? this.gridColumnCount,
      gridRowCount: gridRowCount ?? this.gridRowCount,
      stackPosition: stackPosition ?? this.stackPosition,
      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      height: height ?? this.height,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      visible: visible ?? this.visible,
      opacity: opacity ?? this.opacity,
      backgroundDecoration: backgroundDecoration ?? this.backgroundDecoration,
      shadows: shadows ?? this.shadows,
      shapeBorder: shapeBorder ?? this.shapeBorder,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      childAlignment: childAlignment ?? this.childAlignment,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      mouseCursor: mouseCursor ?? this.mouseCursor,
    );
  }

  Style merge(Style? style) {
    if (style == null) {
      return this;
    } else {
      return copyWith(
        flex: style.flex,
        gridRowCount: style.gridRowCount,
        gridColumnCount: style.gridColumnCount,
        stackPosition: style.stackPosition,
        alignment: style.alignment,
        width: style.width,
        height: style.height,
        margin: style.margin,
        padding: style.padding,
        visible: style.visible,
        opacity: style.opacity,
        backgroundDecoration: style.backgroundDecoration,
        shadows: style.shadows,
        shapeBorder: style.shapeBorder,
        transform: style.transform,
        transformAlignment: style.transformAlignment,
        childAlignment: style.childAlignment,
        textStyle: style.textStyle,
        textAlign: style.textAlign,
        mouseCursor: style.mouseCursor,
      );
    }
  }
}

dynamic chooseFrom(dynamic input, MediaQueryData data) {
  dynamic rst;

  if (input is Map<ScreenScope, dynamic>) {
    input.forEach((key, value) {
      if (key.isOfScreenScope(data)) {
        rst = value;
      }
    });
  } else {
    rst = input;
  }

  return rst;
}

Style cascadeStyle(dynamic input, MediaQueryData data) {
  Style rst = Style();
  if (input is Map<ScreenScope, Style>) {
    input.forEach((key, value) {
      if (key.isOfScreenScope(data)) {
        rst = rst.merge(value);
      }
    });
  } else {
    assert(input is Style);
    rst = input;
  }

  return rst;
}
