library responsive_styled_widget;

import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

import 'screen_scope.dart';
import 'style.dart';

export 'animated_styled_container.dart';
export 'animated_styled_container.dart';
export 'custom_visibility_detector/visibility_detector.dart';
export 'custom_visibility_detector/visibility_detector_controller.dart';
export 'dynamic_ui_classes/dynamic_shadow.dart';
export 'dynamic_ui_classes/dynamic_text_style.dart';
export 'dynamic_ui_classes/predefined_elevation_shadow.dart';
export 'dynamic_ui_classes/smooth_matrix4.dart';
export 'explicit_animated_styled_container.dart';
export 'explicit_animations/animation_provider.dart';
export 'explicit_animations/animation_sequence.dart';
export 'explicit_animations/global_animation.dart';
export 'parse_json.dart';
export 'screen_scope.dart';
export 'style.dart';
export 'styled_container.dart';
export 'to_json.dart';

abstract class StyledWidget extends StatefulWidget {
  final dynamic style;
  StyledWidget({
    Key? key,
    required this.style,
  })   : assert(style is Style || style is Map<ScreenScope, Style>),
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
  BoxDecoration foregroundDecoration = BoxDecoration();
  Color borderColor = Colors.transparent;
  double borderThickness = 0.0;
  MorphableShapeBorder shapeBorder =
      MorphableShapeBorder(shape: RectangleShape());

  List<ShapeShadow> shadows = <ShapeShadow>[];
  List<ShapeShadow> insetShadows = <ShapeShadow>[];

  Alignment childAlignment = Alignment.center;

  Matrix4 transform = Matrix4.identity();
  Alignment transformAlignment = Alignment.center;

  late TextStyle textStyle;
  TextAlign textAlign = TextAlign.start;

  MouseCursor mouseCursor = SystemMouseCursors.basic;

  void prepareStyle() {
    screenSize = MediaQuery.of(context).size;
    style = cascadeStyle(widget.style, MediaQuery.of(context));
  }

  void prepareProperties() {
    Size constraintSize = Size(parentMaxWidth, parentMaxHeight);
    margin = style.margin?.toEdgeInsets(
            constraintSize: constraintSize, screenSize: screenSize) ??
        EdgeInsets.all(0.0);

    width = style.width
        ?.toPX(constraint: parentMaxWidth, screenSize: screenSize)
        .clamp(0.0, max(0.0, parentMaxWidth - margin.left - margin.right));
    height = style.height
        ?.toPX(constraint: parentMaxHeight, screenSize: screenSize)
        .clamp(0.0, max(0.0, parentMaxHeight - margin.top - margin.right));

    alignment = style.alignment ?? Alignment.center;

    padding = style.padding?.toEdgeInsets(
            constraintSize: constraintSize, screenSize: screenSize) ??
        EdgeInsets.all(0.0);

    visible = style.visible ?? true;
    opacity = style.opacity ?? 1;
    backgroundDecoration = style.backgroundDecoration ?? BoxDecoration();
    foregroundDecoration = style.foregroundDecoration ?? BoxDecoration();

    shadows = style.shadows
            ?.map((e) => e.toShapeShadow(
                constraintSize: constraintSize, screenSize: screenSize))
            .toList() ??
        [];
    insetShadows = style.insetShadows
            ?.map((e) => e.toShapeShadow(
                constraintSize: constraintSize, screenSize: screenSize))
            .toList() ??
        [];
    shapeBorder =
        style.shapeBorder ?? MorphableShapeBorder(shape: RectangleShape());

    transform = style.transform?.toMatrix4(
            screenSize: screenSize, constraintSize: constraintSize) ??
        Matrix4.identity();
    transformAlignment = style.transformAlignment ?? Alignment.center;

    childAlignment = style.childAlignment ?? Alignment.center;
    textStyle = style.textStyle?.toTextStyle(
            parentFontSize: DefaultTextStyle.of(context).style.fontSize ?? 14.0,
            constraintSize: constraintSize,
            screenSize: screenSize) ??
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

  Widget buildDecoratedShadowedShape({required Widget child}) {
    return DecoratedShadowedShape(
        decoration: backgroundDecoration,
        shape: shapeBorder,
        shadows: shadows,
        insetShadows: insetShadows,
        child: child);
  }

  Widget buildAnimatedDecoratedShadowedShape(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    return AnimatedDecoratedShadowedShape(
      decoration: backgroundDecoration,
      shape: shapeBorder,
      shadows: shadows,
      insetShadows: insetShadows,
      child: child,
      duration: duration,
      curve: curve,
    );
  }

  Widget buildStyledContainer(
      {required Widget child,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    Widget innerContainer = MouseRegion(
        onEnter: onMouseEnter,
        onExit: onMouseExit,
        cursor: mouseCursor,
        child: Container(
            width: width,
            height: height,
            padding: padding.add(shapeBorder.shape.dimensions),
            alignment: childAlignment,
            foregroundDecoration: foregroundDecoration,
            child: updateDefaultTextStyle(child: child)));

    Widget materialContainer =
        buildDecoratedShadowedShape(child: innerContainer);

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
      {required Widget child,
      required Duration duration,
      Curve? curve,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    curve = curve ?? Curves.linear;
    Widget innerContainer = MouseRegion(
        onEnter: onMouseEnter,
        onExit: onMouseExit,
        cursor: mouseCursor,
        child: AnimatedContainer(
            duration: duration,
            curve: curve,
            width: width,
            height: height,
            padding: padding.add(shapeBorder.shape.dimensions),
            alignment: childAlignment,
            foregroundDecoration: foregroundDecoration,
            child: updateAnimatedDefaultTextStyle(
                child: child, curve: curve, duration: duration)));

    Widget materialContainer = buildAnimatedDecoratedShadowedShape(
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
