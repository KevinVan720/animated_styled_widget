import 'package:dimension/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

/// A text style whose sizes are [Dimension]s, so they can be relative to the
/// parent font size (percent) or to the screen size (vw, vh, vmin, vmax).
///
/// Converted to a [TextStyle] with [toTextStyle].
class DynamicTextStyle {
  const DynamicTextStyle({
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.shadows,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
  });

  final Color? color;
  final Color? backgroundColor;

  final String? fontFamily;
  final Dimension? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;

  final Dimension? letterSpacing;
  final Dimension? wordSpacing;
  final double? height;

  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;

  final List<Shadow>? shadows;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};

    rst.updateNotNull("color", color?.toJson());
    rst.updateNotNull("backgroundColor", backgroundColor?.toJson());

    rst.updateNotNull("fontSize", fontSize?.toJson());
    rst.updateNotNull("fontFamily", fontFamily);
    rst.updateNotNull("fontWeight", fontWeight?.toJson());
    rst.updateNotNull("fontStyle", fontStyle?.toJson());

    rst.updateNotNull("height", height);
    rst.updateNotNull("letterSpacing", letterSpacing?.toJson());
    rst.updateNotNull("wordSpacing", wordSpacing?.toJson());

    rst.updateNotNull("decoration", decoration?.toJson());
    rst.updateNotNull("decorationColor", decorationColor?.toJson());
    rst.updateNotNull("decorationStyle", decorationStyle?.toJson());
    rst.updateNotNull("decorationThickness", decorationThickness);

    rst.updateNotNull("shadows", shadows?.map((e) => e.toJson()).toList());

    return rst;
  }

  /// Returns a copy with the given values replaced.
  ///
  /// [foreground] and [background] are not supported and ignored.
  DynamicTextStyle copyWith({
    Color? color,
    Color? backgroundColor,
    String? fontFamily,
    Dimension? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    Dimension? letterSpacing,
    Dimension? wordSpacing,
    double? height,
    Paint? foreground,
    Paint? background,
    List<Shadow>? shadows,
    TextDecoration? decoration,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return DynamicTextStyle(
      color: color ?? this.color,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      fontWeight: fontWeight ?? this.fontWeight,
      fontStyle: fontStyle ?? this.fontStyle,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordSpacing: wordSpacing ?? this.wordSpacing,
      height: height ?? this.height,
      shadows: shadows ?? this.shadows,
      decoration: decoration ?? this.decoration,
      decorationColor: decorationColor ?? this.decorationColor,
      decorationStyle: decorationStyle ?? this.decorationStyle,
      decorationThickness: decorationThickness ?? this.decorationThickness,
    );
  }

  /// Converts the dimensions to px, percentages are relative to
  /// [parentFontSize]. The font size is 10 if [fontSize] is null.
  ///
  /// [constraintWidth] is not used.
  TextStyle toTextStyle(
      {required Size screenSize,
      required double parentFontSize,
      double constraintWidth = 100}) {
    double fontSize = this
            .fontSize
            ?.toPX(constraint: parentFontSize, screenSize: screenSize) ??
        10;
    double? letterSpacing = this
        .letterSpacing
        ?.toPX(constraint: parentFontSize, screenSize: screenSize);
    double? wordSpacing = this
        .wordSpacing
        ?.toPX(constraint: parentFontSize, screenSize: screenSize);

    return TextStyle(
      color: color,
      backgroundColor: backgroundColor,
      fontFamily: fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      shadows: shadows,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DynamicTextStyle &&
        other.color == color &&
        other.backgroundColor == backgroundColor &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.fontWeight == fontWeight &&
        other.fontStyle == fontStyle &&
        other.letterSpacing == letterSpacing &&
        other.wordSpacing == wordSpacing &&
        other.height == height &&
        other.decoration == decoration &&
        other.decorationColor == decorationColor &&
        other.decorationStyle == decorationStyle &&
        other.decorationThickness == decorationThickness &&
        listEquals(other.shadows, shadows);
  }

  @override
  int get hashCode => Object.hash(
        color,
        backgroundColor,
        fontFamily,
        fontSize,
        fontWeight,
        fontStyle,
        letterSpacing,
        wordSpacing,
        height,
        decoration,
        decorationColor,
        decorationStyle,
        decorationThickness,
        shadows == null ? null : Object.hashAll(shadows!),
      );
}
