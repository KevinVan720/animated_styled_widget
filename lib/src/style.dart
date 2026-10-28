import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'dynamic_ui_classes/dynamic_text_style.dart';
import 'dynamic_ui_classes/smooth_matrix4.dart';
import 'serialization/parse_json.dart';

/// A serializable collection of the properties used by the styled widgets,
/// for example [StyledContainer] and [AnimatedStyledContainer].
///
/// Null properties use the default value of the widget, or the value of the
/// other style when styles are merged.
class Style {
  bool? visible;
  double? opacity;

  Alignment? alignment;

  Dimension? width;
  Dimension? height;

  EdgeInsets? margin;
  EdgeInsets? padding;

  Decoration? foregroundDecoration;
  Decoration? backgroundDecoration;
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
  });

  Style.fromJson(Map<String, dynamic> map) {
    width = parseDimension(map["width"]);
    height = parseDimension(map["height"]);
    alignment = parseAlignment(map["alignment"]);

    margin = parseEdgeInsets(map["margin"]);
    padding = parseEdgeInsets(map["padding"]);

    visible = map["visible"];
    opacity = (map["opacity"] as num?)?.toDouble();
    backgroundDecoration = parseBoxDecoration(map["backgroundDecoration"]);
    foregroundDecoration = parseBoxDecoration(map["foregroundDecoration"]);

    shadows = _parseShapeShadows(map["shadows"]);
    insetShadows = _parseShapeShadows(map["insetShadows"]);

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

  static List<ShapeShadow>? _parseShapeShadows(dynamic list) {
    return (list as List?)
        ?.map((e) => parseShapeShadow(e))
        .whereType<ShapeShadow>()
        .toList();
  }

  /// Only [BoxDecoration]s are serialized, other decorations are left out.
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("alignment", alignment?.toJson());
    rst.updateNotNull("width", width?.toJson());
    rst.updateNotNull("height", height?.toJson());

    rst.updateNotNull("margin", margin?.toJson());
    rst.updateNotNull("padding", padding?.toJson());

    rst.updateNotNull("visible", visible);
    rst.updateNotNull("opacity", opacity);
    final Decoration? backgroundDecoration = this.backgroundDecoration;
    if (backgroundDecoration is BoxDecoration) {
      rst.updateNotNull("backgroundDecoration", backgroundDecoration.toJson());
    }
    final Decoration? foregroundDecoration = this.foregroundDecoration;
    if (foregroundDecoration is BoxDecoration) {
      rst.updateNotNull("foregroundDecoration", foregroundDecoration.toJson());
    }

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
    Decoration? backgroundDecoration,
    Decoration? foregroundDecoration,
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
  }) {
    return Style(
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

  /// Returns a copy of this style where the non-null properties of [style]
  /// replace the ones of this style.
  Style merge(Style? style) {
    if (style == null) {
      return this;
    } else {
      return copyWith(
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
  int get hashCode => Object.hashAll([
        visible,
        alignment,
        width,
        height,
        margin,
        padding,
        opacity,
        foregroundDecoration,
        backgroundDecoration,
        shadows == null ? null : Object.hashAll(shadows!),
        insetShadows == null ? null : Object.hashAll(insetShadows!),
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
      ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
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
        listEquals(other.shadows, shadows) &&
        listEquals(other.insetShadows, insetShadows) &&
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
}
