import 'dart:convert';
import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_class_parser/parse_json.dart';
import 'package:flutter_class_parser/to_json.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'dynamic_ui_classes/dynamic_text_style.dart';
import 'dynamic_ui_classes/smooth_matrix4.dart';
import 'parse_json.dart';
import 'screen_scope.dart';
import 'styled_widget.dart';

class ResponsiveProperty<T> {
  Map<ScreenScope, T> values;

  ResponsiveProperty({required this.values});

  T? resolveProperty(MediaQueryData data) {
    T? rst;
    values.forEach((key, value) {
      if (key.isOfScreenScope(data)) {
        rst = value;
      }
    });

    return rst;
  }
}

abstract class StyleBase {
  StyleBase();

  StyleBase.fromJson(Map<String, dynamic> map);

  Map<String, dynamic> toJson();

  StyleBase copyWith({
    Alignment? alignment,
    Dimension? width,
    Dimension? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool? visible,
    double? opacity,
    BoxDecoration? backgroundDecoration,
    BoxDecoration? foregroundDecoration,
    List<ShapeShadow>? shadows,
    List<ShapeShadow>? insetShadows,
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
    int? flex,
    int? gridColumnCount,
    int? gridRowCount,
    DynamicEdgeInsets? stackPosition,
  });

  Style resolveStyle(MediaQueryData data);

  static StyleBase setWidth(StyleBase style, Dimension? width) {
    StyleBase rst = style.copyWith();
    if (style is Style) {
      (rst as Style).width = width;
    }
    if (style is ScopedStyles) {
      (rst as ScopedStyles).styles.forEach((key, value) {
        value.width = width;
      });
    }
    return rst;
  }

  static StyleBase setHeight(StyleBase style, Dimension? height) {
    StyleBase rst = style.copyWith();
    if (style is Style) {
      (rst as Style).height = height;
    }
    if (style is ScopedStyles) {
      (rst as ScopedStyles).styles.forEach((key, value) {
        value.height = height;
      });
    }
    return rst;
  }
}

class Style extends StyleBase {
  bool? visible;
  double? opacity;

  Alignment? alignment;

  Dimension? width;
  Dimension? height;

  EdgeInsets? margin;
  EdgeInsets? padding;

  BoxDecoration? foregroundDecoration;
  BoxDecoration? backgroundDecoration;
  List<ShapeShadow>? shadows;
  List<ShapeShadow>? insetShadows;

  MorphableShapeBorder? shapeBorder;

  SmoothMatrix4? transform;
  Alignment? transformAlignment;

  ///text related
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
    this.flex,
    this.gridRowCount,
    this.gridColumnCount,
    this.stackPosition,
  });

  Style.fromJson(Map<String, dynamic> map) {
    flex = map["flex"];
    gridRowCount = map["gridRowCount"];
    gridColumnCount = map["gridColumnCount"];
    stackPosition = parseDynamicEdgeInsets(map["stackPosition"]);

    width = parseDimension(map["width"]);
    height = parseDimension(map["height"]);
    alignment = parseAlignment(map["alignment"]);

    margin = parseEdgeInsets(map["margin"]);
    padding = parseEdgeInsets(map["padding"]);

    visible = map["visible"];
    opacity = map["opacity"];
    backgroundDecoration = parseBoxDecoration(map["backgroundDecoration"]);
    foregroundDecoration = parseBoxDecoration(map["foregroundDecoration"]);

    shadows =
        (map["shadows"] as List?)?.map((e) => parseShapeShadow(e)!).toList();
    insetShadows = (map["insetShadows"] as List?)
        ?.map((e) => parseShapeShadow(e)!)
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
    Alignment? alignment,
    Dimension? width,
    Dimension? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool? visible,
    double? opacity,
    BoxDecoration? backgroundDecoration,
    BoxDecoration? foregroundDecoration,
    List<ShapeShadow>? shadows,
    List<ShapeShadow>? insetShadows,
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
    int? flex,
    int? gridColumnCount,
    int? gridRowCount,
    DynamicEdgeInsets? stackPosition,
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

  @override
  int get hashCode => hashList([
        visible,
        alignment,
        width,
        height,
        margin,
        padding,
        opacity,
        foregroundDecoration,
        backgroundDecoration,
        shadows,
        insetShadows,
        shapeBorder,
        transform,
        transformAlignment,
        childAlignment,
        textStyle,
        textAlign,
        shaderGradient,
        imageFilter,
        backdropFilter,
        mouseCursor,
        flex,
        gridRowCount,
        gridColumnCount,
        stackPosition
      ]);

  @override
  bool operator ==(dynamic other) {
    return other is Style &&
        other.visible == visible &&
        other.alignment == alignment &&
        other.width == width &&
        other.height == height &&
        other.margin == margin &&
        other.padding == padding &&
        other.opacity == opacity &&
        other.foregroundDecoration == foregroundDecoration &&
        other.backgroundDecoration == backgroundDecoration &&
        other.shadows == shadows &&
        other.insetShadows == insetShadows &&
        other.shapeBorder == shapeBorder &&
        other.transform == transform &&
        other.transformAlignment == transformAlignment &&
        other.childAlignment == childAlignment &&
        other.textStyle == textStyle &&
        other.textAlign == textAlign &&
        other.shaderGradient == shaderGradient &&
        other.imageFilter == imageFilter &&
        other.backdropFilter == backdropFilter &&
        other.mouseCursor == mouseCursor;
  }

  Style resolveStyle(MediaQueryData data) {
    return this;
  }
}

class ScopedStyles extends StyleBase {
  Map<ScreenScope, Style> styles;

  ScopedStyles({required this.styles});

  ScopedStyles.fromJson(Map<String, dynamic> stylesMap)
      : styles = stylesMap.map((key, value) => MapEntry(
            parseScreenScope(json.decode(key)), Style.fromJson(value)));

  Map<String, dynamic> toJson() {
    return styles.map(
        (key, value) => MapEntry(json.encode(key.toJson()), value.toJson()));
  }

  ScopedStyles copyWith({
    Alignment? alignment,
    Dimension? width,
    Dimension? height,
    EdgeInsets? margin,
    EdgeInsets? padding,
    bool? visible,
    double? opacity,
    BoxDecoration? backgroundDecoration,
    BoxDecoration? foregroundDecoration,
    List<ShapeShadow>? shadows,
    List<ShapeShadow>? insetShadows,
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
    int? flex,
    int? gridColumnCount,
    int? gridRowCount,
    DynamicEdgeInsets? stackPosition,
  }) {
    return ScopedStyles(
        styles: styles.map((key, value) => MapEntry(
            key,
            value.copyWith(
              flex: flex,
              gridColumnCount: gridColumnCount,
              gridRowCount: gridRowCount,
              stackPosition: stackPosition,
              alignment: alignment,
              width: width,
              height: height,
              margin: margin,
              padding: padding,
              visible: visible,
              opacity: opacity,
              backgroundDecoration: backgroundDecoration,
              foregroundDecoration: foregroundDecoration,
              shadows: shadows,
              insetShadows: insetShadows,
              shapeBorder: shapeBorder,
              transform: transform,
              transformAlignment: transformAlignment,
              childAlignment: childAlignment,
              textStyle: textStyle,
              textAlign: textAlign,
              shaderGradient: shaderGradient,
              imageFilter: imageFilter,
              backdropFilter: backdropFilter,
              mouseCursor: mouseCursor,
            ))));
  }

  Style resolveStyle(MediaQueryData data) {
    Style rst = Style();
    styles.forEach((key, value) {
      if (key.isOfScreenScope(data)) {
        rst = rst.merge(value);
      }
    });
    return rst;
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
