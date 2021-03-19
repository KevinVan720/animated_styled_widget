import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_class_parser/parse_json.dart';
import 'package:flutter_class_parser/to_json.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'dynamic_ui_classes/dynamic_shadow.dart';
import 'dynamic_ui_classes/dynamic_text_style.dart';
import 'dynamic_ui_classes/smooth_matrix4.dart';
import 'parse_json.dart';
import 'screen_scope.dart';
import 'styled_widget.dart';

class Style {
  bool? visible;
  double? opacity;

  Alignment? alignment;

  Dimension? width;
  Dimension? height;

  DynamicEdgeInsets? margin;
  DynamicEdgeInsets? padding;

  BoxDecoration? foregroundDecoration;
  BoxDecoration? backgroundDecoration;
  List<DynamicShapeShadow>? shadows;
  List<DynamicShapeShadow>? insetShadows;

  MorphableShapeBorder? shapeBorder;

  SmoothMatrix4? transform;
  Alignment? transformAlignment;

  //text related (works only for text and icon widgets)
  Alignment? childAlignment;
  DynamicTextStyle? textStyle;
  TextAlign? textAlign;

  Gradient? shaderGradient;

  ImageFilter? imageFilter;
  ImageFilter? backdropFilter;

  SystemMouseCursor? mouseCursor;

  ///possible children properties in layoutWidgets like flex, grid, stack
  ///not used for now
  int? flex;
  int? gridColumnCount;
  int? gridRowCount;
  DynamicEdgeInsets? stackPosition;

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
    this.foregroundDecoration,
    this.backgroundDecoration,
    this.shadows,
    this.insetShadows,
    this.shapeBorder,
    this.transform,
    this.transformAlignment,
    this.childAlignment,
    this.textStyle,
    this.textAlign,
    this.shaderGradient,
    this.imageFilter,
    this.backdropFilter,
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
    foregroundDecoration = parseBoxDecoration(map["foregroundDecoration"]);

    shadows = (map["shadows"] as List?)
        ?.map((e) => parseDynamicShapeShadow(e)!)
        .toList();
    insetShadows = (map["insetShadows"] as List?)
        ?.map((e) => parseDynamicShapeShadow(e)!)
        .toList();

    shapeBorder = parseMorphableShapeBorder(map["shapeBorder"]);

    transform = parseSmoothMatrix4(map["transform"]);
    transformAlignment = parseAlignment(map["transformAlignment"]);

    childAlignment = parseAlignment(map["childAlignment"]);

    textAlign = parseTextAlign(map["textAlign"]);
    textStyle = parseDynamicTextStyle(map["textStyle"]);

    shaderGradient = parseGradient(map["shaderGradient"]);
    imageFilter = parseImageFilter(map['imageFilter']);
    backdropFilter = parseImageFilter(map['backdropFilter']);

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
    rst.updateNotNull("foregroundDecoration", foregroundDecoration?.toJson());
    rst.updateNotNull("shapeBorder", shapeBorder?.toJson());
    rst.updateNotNull("shadows", shadows?.map((e) => e.toJson()).toList());
    rst.updateNotNull(
        "insetShadows", insetShadows?.map((e) => e.toJson()).toList());

    rst.updateNotNull("transform", transform?.toJson());
    rst.updateNotNull("transformAlignment", transformAlignment?.toJson());

    rst.updateNotNull("childAlignment", childAlignment?.toJson());
    rst.updateNotNull("textAlign", textAlign?.toJson());
    rst.updateNotNull("textStyle", textStyle?.toJson());

    rst.updateNotNull('shaderGradient', shaderGradient?.toJson());
    rst.updateNotNull('imageFilter', imageFilter?.toJson());
    rst.updateNotNull('backdropFilter', backdropFilter?.toJson());

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
    BoxDecoration? foregroundDecoration,
    List<DynamicShapeShadow>? shadows,
    List<DynamicShapeShadow>? insetShadows,
    MorphableShapeBorder? shapeBorder,
    SmoothMatrix4? transform,
    Alignment? transformAlignment,
    Alignment? childAlignment,
    DynamicTextStyle? textStyle,
    TextAlign? textAlign,
    Gradient? shaderGradient,
    ImageFilter? imageFilter,
    ImageFilter? backdropFilter,
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
      foregroundDecoration: foregroundDecoration ?? this.foregroundDecoration,
      shadows: shadows ?? this.shadows,
      insetShadows: insetShadows ?? this.insetShadows,
      shapeBorder: shapeBorder ?? this.shapeBorder,
      transform: transform ?? this.transform,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      childAlignment: childAlignment ?? this.childAlignment,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      shaderGradient: shaderGradient ?? this.shaderGradient,
      imageFilter: imageFilter ?? this.imageFilter,
      backdropFilter: backdropFilter ?? this.backdropFilter,
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
        foregroundDecoration: style.foregroundDecoration,
        backgroundDecoration: style.backgroundDecoration,
        shadows: style.shadows,
        insetShadows: style.insetShadows,
        shapeBorder: style.shapeBorder,
        transform: style.transform,
        transformAlignment: style.transformAlignment,
        childAlignment: style.childAlignment,
        textStyle: style.textStyle,
        textAlign: style.textAlign,
        shaderGradient: style.shaderGradient,
        imageFilter: style.imageFilter,
        backdropFilter: style.backdropFilter,
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
