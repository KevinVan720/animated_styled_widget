import 'dart:convert';

import 'package:flutter_class_parser/to_json.dart';
import 'package:flutter/material.dart';
import 'package:length_unit/length_unit.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'screen_scope.dart';
import 'dynamic_text_style.dart';
import 'dynamic_edge_insets.dart';
import 'dynamic_shadow.dart';
import 'parse_json.dart';
import 'to_json.dart';

class Style {

  ///children properties in layoutWidgets
  int? flex;
  int? gridColumnCount;
  int? gridRowCount;
  DynamicEdgeInsets? stackPosition;

  bool? visible;

  Alignment? alignment;

  Length? maxWidth;
  Length? maxHeight;
  Length? minWidth;
  Length? minHeight;
  Length? width;
  Length? height;

  DynamicEdgeInsets? margin;
  DynamicEdgeInsets? padding;

  double? opacity;
  BoxDecoration? backgroundDecoration;
  Color? borderColor;
  double? borderThickness;
  List<DynamicBoxShadow>? shadows;
  Shape? shape;

  double? rotationX;
  double? rotationY;
  double? rotationZ;
  double? skewX;
  double? skewY;
  double? translationX;
  double? translationY;

  //text related (works only for text and icon widgets)
  Alignment? childAlignment;
  DynamicTextStyle? textStyle;
  TextAlign? textAlign;
  Gradient? shaderMask;

  Style({
    this.flex,
    this.gridRowCount,
    this.gridColumnCount,
    this.stackPosition,

    this.visible,
    this.alignment,

    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
    this.minWidth,
    this.minHeight,
    this.margin,
    this.padding,
    this.opacity,
    this.backgroundDecoration,
    this.borderColor,
    this.borderThickness,

    this.shadows,
    this.shape,

    this.rotationX,
    this.rotationY,
    this.rotationZ,
    this.skewX,
    this.skewY,
    this.translationX,
    this.translationY,

    this.childAlignment,

    this.textStyle,
    this.textAlign,
    this.shaderMask,
  });

  Style.fromJson(Map<String, dynamic> map) {

    flex=map["flex"];
    gridRowCount=map["gridRowCount"];
    gridColumnCount=map["gridColumnCount"];
    stackPosition=parseDynamicEdgeInsets(map["stackPosition"]);

    width = parseLength(map["width"]);
    height = parseLength(map["height"]);
    maxWidth = parseLength(map["maxWidth"]);
    maxHeight = parseLength(map["maxHeight"]);
    minWidth = parseLength(map["minWidth"]);
    minHeight = parseLength(map["minHeight"]);
    alignment = parseAlignment(map["alignment"]);

    margin = parseDynamicEdgeInsets(map["margin"]);
    padding = parseDynamicEdgeInsets(map["padding"]);

    opacity = map["opacity"];
    backgroundDecoration = parseBoxDecoration(map["backgroundDecoration"]);
    borderColor = parseColor(map["borderColor"]);
    borderThickness = map["borderThickness"];

    shadows = (map["shadows"] as List?)?.map((e) => parseDynamicBoxShadow(e)!).toList();
    shape = parseShape(map["shape"]);

    rotationX = map["rotationX"];
    rotationY = map["rotationY"];
    rotationZ = map["rotationZ"];
    skewX = map["skewX"];
    skewY = map["skewY"];
    translationX = map["translationX"];
    translationY = map["translationY"];

    childAlignment = parseAlignment(map["childAlignment"]);

    textAlign = parseTextAlign(map["textAlign"]);
    textStyle = parseDynamicTextStyle(map["textStyle"]);
    shaderMask = parseGradient(map["shaderMask"]);

  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("flex", flex);
    rst.updateNotNull("gridColumnCount",gridColumnCount);
    rst.updateNotNull("gridRowCount",gridRowCount);
    rst.updateNotNull("stackPosition", stackPosition?.toJson());

    rst.updateNotNull("alignment", alignment?.toJson());
    rst.updateNotNull("width", width?.toJson());
    rst.updateNotNull("height", height?.toJson());
    rst.updateNotNull("maxWidth", maxWidth?.toJson());
    rst.updateNotNull("maxHeight", maxHeight?.toJson());
    rst.updateNotNull("minWidth", minWidth?.toJson());
    rst.updateNotNull("minHeight", minHeight?.toJson());
    rst.updateNotNull("margin", margin?.toJson());
    rst.updateNotNull("padding", padding?.toJson());
    rst.updateNotNull("opacity", opacity);
    rst.updateNotNull("backgroundDecoration", backgroundDecoration?.toJson());
    rst.updateNotNull("borderColor", borderColor?.toJson());
    rst.updateNotNull("borderThickness", borderThickness);
    rst.updateNotNull("shape", shape?.toJson());
    rst.updateNotNull("shadows", shadows?.map((e) => e.toJson()).toList());

    rst.updateNotNull("rotationX", rotationX);
    rst.updateNotNull("rotationY", rotationY);
    rst.updateNotNull("rotationZ", rotationZ);
    rst.updateNotNull("skewX", skewX);
    rst.updateNotNull("skewY", skewY);
    rst.updateNotNull("translationX", translationX);
    rst.updateNotNull("translationY", translationY);

    rst.updateNotNull("childAlignment", childAlignment?.toJson());
    rst.updateNotNull("textAlign", textAlign?.toJson());
    rst.updateNotNull("textStyle", textStyle?.toJson());
    rst.updateNotNull("shaderMask", shaderMask?.toJson());
    return rst;
  }

  Style copyWith({

    int? flex,
    int? gridColumnCount,
    int? gridRowCount,
    DynamicEdgeInsets? stackPosition,

    Alignment? alignment,
    Length? width,
    Length? height,
    Length? maxWidth,
    Length? maxHeight,
    Length? minWidth,
    Length? minHeight,

    DynamicEdgeInsets? margin,
    DynamicEdgeInsets? padding,
    double? opacity,
    BoxDecoration? backgroundDecoration,
    Color? borderColor,
    double? borderThickness,

    List<DynamicBoxShadow>? shadows,
    Shape? shape,
    double? rotationX,
    double? rotationY,
    double? rotationZ,
    double? skewX,
    double? skewY,
    double? translationX,
    double? translationY,
    Alignment? childAlignment,
    DynamicTextStyle? textStyle,
    TextAlign? textAlign,
    Gradient? textGradient,
  }) {
    return Style(

      flex: flex?? this.flex,
      gridColumnCount: gridColumnCount?? this.gridColumnCount,
      gridRowCount: gridRowCount?? this.gridRowCount,
      stackPosition: stackPosition??this.stackPosition,

      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      height: height ?? this.height,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      margin: margin??this.margin,
      padding: padding?? this.padding,
      opacity: opacity ?? this.opacity,
      backgroundDecoration: backgroundDecoration ?? this.backgroundDecoration,
      borderColor: borderColor ?? this.borderColor,
      borderThickness: borderThickness ?? this.borderThickness,

      shadows: shadows ?? this.shadows,
      shape: shape ?? this.shape,
      rotationX: rotationX ?? this.rotationX,
      rotationY: rotationY ?? this.rotationY,
      rotationZ: rotationZ ?? this.rotationZ,
      skewX: skewX ?? this.skewX,
      skewY: skewY ?? this.skewY,
      translationX: translationX ?? this.translationX,
      translationY: translationY ?? this.translationY,
      childAlignment: childAlignment ?? this.childAlignment,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      shaderMask: textGradient ?? this.shaderMask,
    );
  }

  Style merge(
    Style? style
  ) {
    if(style==null) {
      return this;
    }else {
      return copyWith(

        flex: style.flex,
        gridRowCount: style.gridRowCount,
        gridColumnCount: style.gridColumnCount,
        stackPosition: style.stackPosition,

        alignment: style.alignment,
        width: style.width,
        height: style.height,
        maxWidth: style.maxWidth,
        maxHeight: style.maxHeight,
        minWidth: style.minWidth,
        minHeight: style.minHeight,
        margin: style.margin,
        padding: style.padding,
        opacity: style.opacity,
        backgroundDecoration: style.backgroundDecoration,
        borderColor: style.borderColor,
        borderThickness: style.borderThickness,

        shadows: style.shadows,
        shape: style.shape,
        rotationX: style.rotationX,
        rotationY: style.rotationY,
        rotationZ: style.rotationZ,
        skewX: style.skewX,
        skewY: style.skewY,
        translationX: style.translationX,
        translationY: style.translationY,
        childAlignment: style.childAlignment,
        textStyle: style.textStyle,
        textAlign: style.textAlign,
        textGradient: style.shaderMask,
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

  Style rst=Style();
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
