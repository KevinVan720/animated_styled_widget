import 'dart:ui';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Resolves a [Style] to the values used to build the styled widgets.
mixin StyledStateMixin<T extends StatefulWidget> on State<T> {
  late Style style;
  late Size screenSize;

  Alignment? alignment;
  Dimension? width;
  Dimension? height;

  EdgeInsets margin = EdgeInsets.zero;
  EdgeInsets padding = EdgeInsets.zero;

  bool visible = true;
  double opacity = 1;
  Decoration backgroundDecoration = const BoxDecoration();
  Decoration foregroundDecoration = const BoxDecoration();

  MorphableShapeBorder shapeBorder = const RectangleShapeBorder();

  List<ShapeShadow>? shadows = <ShapeShadow>[];
  List<ShapeShadow>? insetShadows = <ShapeShadow>[];

  Alignment? childAlignment;

  Matrix4 transform = Matrix4.identity();
  Alignment transformAlignment = Alignment.center;

  late TextStyle textStyle;
  TextAlign textAlign = TextAlign.start;

  Gradient? shaderGradient;

  ImageFilter? imageFilter;
  ImageFilter? backdropFilter;

  MouseCursor mouseCursor = SystemMouseCursors.basic;

  void resolveStyle();

  void resolveProperties() {
    alignment = style.alignment;

    padding = style.padding ?? EdgeInsets.zero;

    margin = style.margin ?? EdgeInsets.zero;

    width = style.width;
    height = style.height;

    visible = style.visible ?? true;
    opacity = style.opacity ?? 1;
    backgroundDecoration = style.backgroundDecoration ?? const BoxDecoration();
    foregroundDecoration = style.foregroundDecoration ?? const BoxDecoration();

    shadows = style.shadows;
    insetShadows = style.insetShadows;
    shapeBorder = style.shapeBorder ?? const RectangleShapeBorder();

    transform = style.transform?.toMatrix4(screenSize: screenSize) ??
        Matrix4.identity();
    transformAlignment = style.transformAlignment ?? Alignment.center;

    childAlignment = style.childAlignment;
    textStyle = style.textStyle?.toTextStyle(
            parentFontSize: DefaultTextStyle.of(context).style.fontSize ?? 14.0,
            screenSize: screenSize) ??
        DefaultTextStyle.of(context).style;
    textAlign = style.textAlign ?? TextAlign.start;

    shaderGradient = style.shaderGradient;
    imageFilter = style.imageFilter;
    backdropFilter = style.backdropFilter;

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
    // Text styles can only be interpolated if they all inherit (like the ones
    // of a DynamicTextStyle) or not. The inherit flag of the default text
    // style makes no difference to the text below it.
    TextStyle finalTextStyle =
        textStyle.inherit ? textStyle : textStyle.copyWith(inherit: true);
    return AnimatedDefaultTextStyle(
        style: finalTextStyle,
        textAlign: textAlign,
        curve: curve,
        duration: duration,
        child: child);
  }

  Widget buildImageFiltered({required Widget child}) {
    return imageFilter != null
        ? ImageFiltered(
            imageFilter: imageFilter!,
            child: child,
          )
        : child;
  }

  Widget buildBackdropFilter({required Widget child}) {
    return backdropFilter != null
        ? BackdropFilter(
            filter: backdropFilter!,
            child: child,
          )
        : child;
  }

  Widget buildShaderMask({required Widget child}) {
    return shaderGradient != null
        ? ShaderMask(
            shaderCallback: (Rect bounds) {
              return shaderGradient!.createShader(bounds);
            },
            child: child,
          )
        : child;
  }

  Widget buildAnimatedShaderMask(
      {required Widget child,
      required Duration duration,
      required Curve curve}) {
    return AnimatedShaderMask(
      duration: duration,
      curve: curve,
      shaderGradient: shaderGradient,
      child: child,
    );
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
      duration: duration,
      curve: curve,
      child: child,
    );
  }

  Widget buildPlainContainer(
      {required Widget child,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    Widget innerContainer = DimensionSizedBox(
      width: width,
      height: height,
      child: Container(
          padding: padding.add(shapeBorder.dimensions),
          alignment: childAlignment,
          child: child),
    );

    return Container(
      alignment: alignment,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      child: innerContainer,
    );
  }

  Widget buildStyledContainer(
      {required Widget child,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    Widget innerContainer = buildBackdropFilter(
        child: MouseRegion(
            onEnter: onMouseEnter,
            onExit: onMouseExit,
            cursor: mouseCursor,
            child: DimensionSizedBox(
              width: width,
              height: height,
              child: Container(
                  padding: padding.add(shapeBorder.dimensions),
                  alignment: childAlignment,
                  foregroundDecoration: foregroundDecoration,
                  child: buildShaderMask(
                      child: updateDefaultTextStyle(child: child))),
            )));

    Widget materialContainer = buildImageFiltered(
        child: buildDecoratedShadowedShape(child: innerContainer));

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
          )),
    );
  }

  Widget buildAnimatedStyledContainer(
      {required Widget child,
      required Duration duration,
      Curve curve = Curves.linear,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit,
      VoidCallback? onEnd}) {
    Widget innerContainer = buildBackdropFilter(
        child: MouseRegion(
            onEnter: onMouseEnter,
            onExit: onMouseExit,
            cursor: mouseCursor,
            child: AnimatedDimensionSizedBox(
              duration: duration,
              curve: curve,
              width: width,
              height: height,
              onEnd: onEnd,
              child: AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  padding: padding.add(shapeBorder.dimensions),
                  alignment: childAlignment,
                  foregroundDecoration: foregroundDecoration,
                  child: buildAnimatedShaderMask(
                      child: updateAnimatedDefaultTextStyle(
                          child: child, curve: curve, duration: duration),
                      duration: duration,
                      curve: curve)),
            )));

    Widget materialContainer = buildImageFiltered(
        child: buildAnimatedDecoratedShadowedShape(
            child: innerContainer, curve: curve, duration: duration));

    return Visibility(
      visible: visible,
      child: AnimatedContainer(
          duration: duration,
          curve: curve,
          margin: margin,
          alignment: alignment,
          transform: transform,
          transformAlignment: transformAlignment,
          child: AnimatedOpacity(
            duration: duration,
            curve: curve,
            opacity: opacity,
            child: materialContainer,
          )),
    );
  }

  Widget buildAnimatedPlainContainer(
      {required Widget child,
      required Duration duration,
      Curve curve = Curves.linear,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit,
      VoidCallback? onEnd}) {
    Widget innerContainer = buildBackdropFilter(
        child: AnimatedDimensionSizedBox(
      duration: duration,
      curve: curve,
      width: width,
      height: height,
      onEnd: onEnd,
      child: AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: padding.add(shapeBorder.dimensions),
          alignment: childAlignment,
          child: child),
    ));

    return AnimatedContainer(
        duration: duration,
        curve: curve,
        margin: margin,
        alignment: alignment,
        transform: transform,
        transformAlignment: transformAlignment,
        child: innerContainer);
  }
}
