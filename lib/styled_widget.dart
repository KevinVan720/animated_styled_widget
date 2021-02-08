library styled_widget;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:morphable_shape/animated_shadowd_shape.dart';
import 'package:styled_widget/screen_scope.dart';
import 'style.dart';

export 'to_json.dart';
export 'parse_json.dart';
export 'style.dart';
export 'screen_scope.dart';
export 'screen_scope.dart';
export 'dynamic_text_style.dart';
export 'dynamic_edge_insets.dart';
export 'dynamic_shadow.dart';
export 'styled_container.dart';
export 'animated_styled_container.dart';

abstract class StyledWidget extends StatefulWidget {
  final dynamic style;
  StyledWidget({Key? key, required this.style})
      : assert(style is Style || style is Map<ScreenScope, Style>),
        super(key: key);
}

abstract class StyledWidgetState<T extends StyledWidget> extends State<T> {
  ///constraint from parent
  double parentMaxWidth = double.infinity;
  double parentMaxHeight = double.infinity;

  double maxWidth = double.infinity;
  double maxHeight = double.infinity;

  double minWidth = 0;
  double minHeight = 0;

  late Style style;

  Alignment alignment = Alignment.center;
  double? width;
  double? height;

  EdgeInsets margin = EdgeInsets.all(0);
  EdgeInsets padding = EdgeInsets.all(0);

  double opacity = 1;
  BoxDecoration backgroundDecoration = BoxDecoration();
  Color borderColor = Colors.transparent;
  double borderThickness = 0.0;
  Shape shape = RectangleShape();

  List<BoxShadow> shadows = [];

  Alignment childAlignment = Alignment.center;

  double rotationX = 0.0;
  double rotationY = 0.0;
  double rotationZ = 0.0;
  double skewX = 0.0;
  double skewY = 0.0;
  double translationX = 0.0;
  double translationY = 0.0;

  double? fontSize;
  Shadow? textShadow;
  TextStyle? textStyle;
  TextAlign? textAlign;
  Gradient? textGradient;

  void chooseStyle() {
    style = cascadeStyle(widget.style, MediaQuery.of(context));
  }

  void chooseProperties() {
    Size screenSize = MediaQuery.of(context).size;

    maxWidth = style.maxWidth
            ?.toPX(constraintSize: parentMaxWidth, screenSize: screenSize) ??
        parentMaxWidth;
    maxHeight = style.maxHeight
            ?.toPX(constraintSize: parentMaxHeight, screenSize: screenSize) ??
        parentMaxHeight;
    minWidth = style.minWidth
            ?.toPX(constraintSize: parentMaxWidth, screenSize: screenSize) ??
        0;
    minWidth = minWidth < maxWidth ? minWidth : maxWidth;
    minHeight = style.minHeight
            ?.toPX(constraintSize: parentMaxHeight, screenSize: screenSize) ??
        0;
    minHeight = minHeight < maxHeight ? minHeight : maxHeight;

    width = style.width
        ?.toPX(constraintSize: parentMaxWidth, screenSize: screenSize)
        ?.clamp(minWidth, maxWidth);
    height = style.height
        ?.toPX(constraintSize: parentMaxHeight, screenSize: screenSize)
        ?.clamp(minHeight, maxHeight);

    alignment = style.alignment ?? Alignment.center;

    margin = style.margin?.toEdgeInsets(
            constraintSize: Size(parentMaxWidth, parentMaxHeight),
            screenSize: screenSize) ??
        EdgeInsets.all(0.0);
    padding = style.padding?.toEdgeInsets(
            constraintSize: Size(parentMaxWidth, parentMaxHeight),
            screenSize: screenSize) ??
        EdgeInsets.all(0.0);

    opacity = style.opacity ?? 1;
    backgroundDecoration = style.backgroundDecoration ?? BoxDecoration();
    borderColor = style.borderColor ?? Colors.transparent;
    borderThickness = style.borderThickness ?? 0;
    shadows = style.shadows
            ?.map((e) => e.toBoxShadow(
                constraintSize: Size(maxWidth, maxHeight),
                screenSize: screenSize))
            .toList() ??
        [];
    shape = style.shape ?? RectangleShape();

    rotationX = style.rotationX ?? 0;
    rotationY = style.rotationY ?? 0;
    rotationZ = style.rotationZ ?? 0;
    skewY = style.skewY ?? 0;
    skewX = style.skewX ?? 0;
    translationX = style.translationX ?? 0;
    translationY = style.translationY ?? 0;

    textStyle = style.textStyle?.toTextStyle(
        constraintSize: Size(parentMaxWidth, parentMaxHeight),
        screenSize: screenSize);
    textAlign = style.textAlign;
    textGradient = style.shaderMask;
  }

  Widget updateDefaultTextStyle({required Widget child}) {
    TextStyle finalTextStyle = textStyle ?? DefaultTextStyle.of(context).style;
    return DefaultTextStyle(style: finalTextStyle, child: child);
  }

  Widget updateAnimatedDefaultTextStyle(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    TextStyle finalTextStyle = textStyle ?? DefaultTextStyle.of(context).style;
    return AnimatedDefaultTextStyle(
        style: finalTextStyle, curve: curve, duration: duration, child: child);
  }

  Widget buildShadowedShape({required Widget child}) {
    ShapeBorder materialShape = MorphableShapeBorder(
        shape: shape, borderWidth: borderThickness, borderColor: borderColor);
    return ShadowedShape(shape: materialShape, shadows: shadows, child: child);
  }

  Widget buildAnimatedShadowedShape(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    ShapeBorder materialShape = MorphableShapeBorder(
        shape: shape, borderWidth: borderThickness, borderColor: borderColor);
    return AnimatedShadowedShape(
      shape: materialShape,
      shadows: shadows,
      child: child,
      duration: duration,
      curve: curve,
    );
  }

  Widget buildStyledContainer({required Widget child}) {
    Widget innerContainer = Container(
        width: width,
        height: height,
        padding: padding,
        alignment: childAlignment,
        decoration: backgroundDecoration.copyWith(boxShadow: shadows),
        child: updateDefaultTextStyle(child: child));

    Widget materialContainer = buildShadowedShape(child: innerContainer);

    Matrix4 transform = Matrix4.skew(skewX * pi / 180, skewY * pi / 180)
      ..rotateX(rotationX * pi / 180)
      ..rotateY(rotationY * pi / 180);

    return Opacity(
        opacity: opacity,
        child: Container(
          alignment: alignment,
          margin: margin,
          transform: transform,
          transformAlignment: Alignment.center,
          child: materialContainer,
        ));
  }

  Widget buildAnimatedStyledContainer(
      {required Widget child, required Duration duration, Curve? curve}) {
    curve = curve ?? Curves.linear;
    Widget innerContainer = AnimatedContainer(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        padding: padding,
        alignment: childAlignment,
        decoration: backgroundDecoration.copyWith(boxShadow: shadows),
        child: updateAnimatedDefaultTextStyle(
            child: child, curve: curve, duration: duration));

    Widget materialContainer = buildAnimatedShadowedShape(
        child: innerContainer, curve: curve, duration: duration);

    Matrix4 transform = Matrix4.skew(skewX * pi / 180, skewY * pi / 180)
      ..rotateX(rotationX * pi / 180)
      ..rotateY(rotationY * pi / 180)
      ..translate(translationX, translationY);

    return AnimatedOpacity(
        duration: duration,
        curve: curve,
        opacity: opacity,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          alignment: alignment,
          margin: margin,
          transform: transform,
          transformAlignment: Alignment.center,
          child: materialContainer,
        ));
  }
}
