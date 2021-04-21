import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';

///states a styled component can be in
enum StyledComponentState {
  idle,

  hovered,

  pressed,

  selected,

  disabled,
}

typedef Widget? StyledComponentStateChildBuilder(
    BuildContext context, StyledComponentState state);

typedef Widget? StyledComponentStateIndexedChildBuilder(
    BuildContext context, StyledComponentState state, int index);

Style getStyleOuterContainer(Style style) {
  return Style(
      width: style.width,
      height: style.height,
      alignment: style.alignment,
      transform: style.transform,
      margin: style.margin,
      transformAlignment: style.transformAlignment);
}
