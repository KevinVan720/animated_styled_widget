library responsive_styled_widget;

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/animated_dimension_sized_box.dart';
import 'package:responsive_styled_widget/dimension_sized_box.dart';
import 'package:responsive_styled_widget/named_style_provider.dart';

import 'animated_shader_mask.dart';
import 'style.dart';

export 'animated_styled_container.dart';
export 'animated_styled_container.dart';
export 'custom_visibility_detector/visibility_detector.dart';
export 'custom_visibility_detector/visibility_detector_controller.dart';
export 'dynamic_ui_classes/dynamic_text_style.dart';
export 'dynamic_ui_classes/predefined_elevation_shadow.dart';
export 'dynamic_ui_classes/smooth_matrix4.dart';
export 'explicit_animated_styled_container.dart';
export 'explicit_animation/animation_provider.dart';
export 'explicit_animation/animation_sequence.dart';
export 'explicit_animation/global_animation.dart';
export 'parse_json.dart';
export 'screen_scope.dart';
export 'style.dart';
export 'styled_components/styled_button.dart';
export 'styled_components/styled_checkbox.dart';
export 'styled_components/styled_radio.dart';
export 'styled_components/styled_slider.dart';
export 'styled_components/styled_switch.dart';
export 'styled_components/styled_toggle_buttons.dart';
export 'styled_container.dart';
export 'to_json.dart';

abstract class StyledWidget extends StatefulWidget {
  final String? id;
  final StyleBase style;
  StyledWidget({
    Key? key,
    this.id,
    required this.style,
  }) : super(key: key);
}

abstract class StyledWidgetState<T extends StyledWidget> extends State<T> {
  late Style style;
  late Size screenSize;

  Alignment? alignment;
  Dimension? width;
  Dimension? height;

  EdgeInsets margin = EdgeInsets.all(0);
  EdgeInsets padding = EdgeInsets.all(0);

  bool visible = true;
  double opacity = 1;
  BoxDecoration backgroundDecoration = BoxDecoration();
  BoxDecoration foregroundDecoration = BoxDecoration();

  MorphableShapeBorder shapeBorder =
      MorphableShapeBorder(shape: RectangleShape());

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

  void resolveStyle() {
    screenSize = MediaQuery.of(context).size;
    StyleBase? inherited;
    Style? inheritedStyle;
    if (widget.id != null)
      inherited = NamedStyleMap.of(context)?.styles[widget.id];
    if (inherited != null)
      inheritedStyle = inherited.resolveStyle(MediaQuery.of(context));

    style = widget.style.resolveStyle(MediaQuery.of(context))
      ..merge(inheritedStyle);
  }

  void resolveProperties() {
    alignment = style.alignment;

    padding = style.padding ?? EdgeInsets.all(0);

    margin = style.margin ?? EdgeInsets.all(0);

    width = style.width;
    height = style.height;

    visible = style.visible ?? true;
    opacity = style.opacity ?? 1;
    backgroundDecoration = style.backgroundDecoration ?? BoxDecoration();
    foregroundDecoration = style.foregroundDecoration ?? BoxDecoration();

    shadows = style.shadows;
    insetShadows = style.insetShadows;
    shapeBorder =
        style.shapeBorder ?? MorphableShapeBorder(shape: RectangleShape());

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
    TextStyle finalTextStyle = textStyle;
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
      child: child,
      duration: duration,
      curve: curve,
    );
  }

  Widget buildPlainContainer(
      {required Widget child,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    Widget innerContainer =
        DimensionSizedBox(width: width, height: height, child: child);

    return Container(
      alignment: alignment,
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
              width: style.width,
              height: style.height,
              child: Container(
                  padding: padding.add(shapeBorder.shape.dimensions),
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

  Widget buildAnimatedPlainContainer(
      {required Widget child,
      required Duration duration,
      Curve curve = Curves.linear,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit}) {
    Widget innerContainer = AnimatedDimensionSizedBox(
        duration: duration,
        curve: curve,
        width: width,
        height: height,
        child: child);

    return AnimatedContainer(
      duration: duration,
      curve: curve,
      alignment: alignment,
      transform: transform,
      transformAlignment: transformAlignment,
      child: innerContainer,
    );
  }

  Widget buildAnimatedStyledContainer(
      {required Widget child,
      required Duration duration,
      Curve curve = Curves.linear,
      PointerEnterEventListener? onMouseEnter,
      PointerExitEventListener? onMouseExit,
      Function()? onEnd}) {
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
                  padding: padding.add(shapeBorder.shape.dimensions),
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
}
