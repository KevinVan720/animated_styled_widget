import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';

///states a styled component can be in
enum StyledComponentState {
  idle,

  hovered,

  pressed,

  selected,

  disabled,
}

typedef StyledComponentStateChildBuilder = Widget? Function(
    BuildContext context, StyledComponentState state);

typedef StyledComponentStateIndexedChildBuilder = Widget? Function(
    BuildContext context, StyledComponentState state, int index);

/// A new style with the properties of [style] that position and size the
/// outer container of a component.
Style getStyleOuterContainer(Style style) {
  return Style(
      width: style.width,
      height: style.height,
      alignment: style.alignment,
      transform: style.transform,
      margin: style.margin,
      transformAlignment: style.transformAlignment);
}
