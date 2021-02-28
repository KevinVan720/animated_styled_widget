library responsive_styled_widget;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/animated_shadowd_shape.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'screen_scope.dart';
import 'style.dart';

export 'animated_styled_container.dart';
export 'dynamic_shadow.dart';
export 'dynamic_text_style.dart';
export 'parse_json.dart';
export 'screen_scope.dart';
export 'screen_scope.dart';
export 'smooth_matrix4.dart';
export 'style.dart';
export 'styled_container.dart';
export 'to_json.dart';

abstract class StyledWidget extends StatefulWidget {
  final dynamic style;
  final PointerEnterEventListener? onMouseEnter;
  final PointerHoverEventListener? onMouseHover;
  final PointerExitEventListener? onMouseExit;
  StyledWidget(
      {Key? key,
      required this.style,
      this.onMouseEnter,
      this.onMouseExit,
      this.onMouseHover})
      : assert(style is Style || style is Map<ScreenScope, Style>),
        super(key: key);
}

abstract class StyledWidgetState<T extends StyledWidget> extends State<T> {
  ///constraint from parent
  double parentMaxWidth = double.infinity;
  double parentMaxHeight = double.infinity;

  late Style style;
  late Size screenSize;

  Alignment alignment = Alignment.center;
  double? width;
  double? height;

  EdgeInsets margin = EdgeInsets.all(0);
  EdgeInsets padding = EdgeInsets.all(0);

  bool visible = true;
  double opacity = 1;
  BoxDecoration backgroundDecoration = BoxDecoration();
  Color borderColor = Colors.transparent;
  double borderThickness = 0.0;
  Shape shape = RectangleShape();

  List<ShapeShadow> shadows = [];

  Alignment childAlignment = Alignment.center;

  Matrix4 transform = Matrix4.identity();
  Alignment transformAlignment = Alignment.center;

  late TextStyle textStyle;
  TextAlign textAlign = TextAlign.start;

  SystemMouseCursor mouseCursor = SystemMouseCursors.basic;

  void prepareStyle() {
    screenSize = MediaQuery.of(context).size;
    style = cascadeStyle(widget.style, MediaQuery.of(context));
  }

  void prepareProperties() {
    margin = style.margin?.toEdgeInsets(
            constraintSize: Size(parentMaxWidth, parentMaxHeight),
            screenSize: screenSize) ??
        EdgeInsets.all(0.0);

    width = style.width
        ?.toPX(constraint: parentMaxWidth, screenSize: screenSize)
        ?.clamp(0.0, max(0.0, parentMaxWidth - margin.left - margin.right));
    height = style.height
        ?.toPX(constraint: parentMaxHeight, screenSize: screenSize)
        ?.clamp(0.0, max(0.0, parentMaxHeight - margin.top - margin.right));

    alignment = style.alignment ?? Alignment.center;

    padding = style.padding?.toEdgeInsets(
            constraintSize: Size(parentMaxWidth, parentMaxHeight),
            screenSize: screenSize) ??
        EdgeInsets.all(0.0);

    visible = style.visible ?? true;
    opacity = style.opacity ?? 1;
    backgroundDecoration = style.backgroundDecoration ?? BoxDecoration();

    Size constraintSize =
        Size(width ?? parentMaxWidth, height ?? parentMaxHeight);

    shadows = style.shadows
            ?.map((e) => e.toShapeShadow(
                constraintSize: constraintSize, screenSize: screenSize))
            .toList() ??
        [];
    shape = style.shape ?? RectangleShape();

    transform = style.transform?.toMatrix4(
            screenSize: screenSize, constraintSize: constraintSize) ??
        Matrix4.identity();
    transformAlignment = style.transformAlignment ?? Alignment.center;

    childAlignment = style.childAlignment ?? Alignment.center;
    textStyle = style.textStyle?.toTextStyle(
            constraintSize: constraintSize, screenSize: screenSize) ??
        DefaultTextStyle.of(context).style;
    textAlign = style.textAlign ?? TextAlign.start;

    mouseCursor = style.mouseCursor ?? SystemMouseCursors.basic;
  }

  Widget updateDefaultTextStyle({required Widget child}) {
    TextStyle finalTextStyle = textStyle;
    return DefaultTextStyle(
        style: finalTextStyle, textAlign: textAlign, child: child);
  }

  Widget updateAnimatedDefaultTextStyle(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    TextStyle finalTextStyle = textStyle;
    return AnimatedDefaultTextStyle(
        style: finalTextStyle,
        textAlign: textAlign,
        curve: curve,
        duration: duration,
        child: child);
  }

  Widget buildShadowedShape({required Widget child}) {
    ShapeBorder materialShape = MorphableShapeBorder(shape: shape);
    return ShadowedShape(shape: materialShape, shadows: shadows, child: child);
  }

  Widget buildAnimatedShadowedShape(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    ShapeBorder materialShape = MorphableShapeBorder(shape: shape);
    return AnimatedShadowedShape(
      shape: materialShape,
      shadows: shadows,
      child: child,
      duration: duration,
      curve: curve,
    );
  }

  Widget buildStyledContainer({required Widget child}) {
    Widget innerContainer = MouseRegion(
        onEnter: widget.onMouseEnter,
        onHover: widget.onMouseHover,
        onExit: widget.onMouseExit,
        cursor: mouseCursor,
        child: Container(
            width: width,
            height: height,
            padding: padding.add(shape.dimensions),
            alignment: childAlignment,
            decoration: backgroundDecoration,
            child: updateDefaultTextStyle(child: child)));

    Widget materialContainer = buildShadowedShape(child: innerContainer);

    return Visibility(
        visible: visible,
        child: Container(
            alignment: alignment,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            child: Opacity(
              opacity: opacity,
              child: materialContainer,
            )));
  }

  Widget buildAnimatedStyledContainer(
      {required Widget child, required Duration duration, Curve? curve}) {
    curve = curve ?? Curves.linear;
    Widget innerContainer = MouseRegion(
        onEnter: widget.onMouseEnter,
        onHover: widget.onMouseHover,
        onExit: widget.onMouseExit,
        cursor: mouseCursor,
        child: AnimatedContainer(
            duration: duration,
            curve: curve,
            width: width,
            height: height,
            padding: padding.add(shape.dimensions),
            alignment: childAlignment,
            decoration: backgroundDecoration,
            child: updateAnimatedDefaultTextStyle(
                child: child, curve: curve, duration: duration)));

    Widget materialContainer = buildAnimatedShadowedShape(
        child: innerContainer, curve: curve, duration: duration);

    return Visibility(
        visible: visible,
        child: AnimatedContainer(
            duration: duration,
            curve: curve,
            alignment: alignment,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            child: AnimatedOpacity(
              duration: duration,
              curve: curve,
              opacity: opacity,
              child: materialContainer,
            )));
  }
}
