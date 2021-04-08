import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';

class StyledToggleButtons extends StatelessWidget {
  StyledToggleButtons({
    Key? key,
    required List<Widget> children,
    required this.isSelected,
    this.onPressed,
    this.direction = Axis.horizontal,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(children?.length == isSelected.length) {
    builder = (context, state, index) {
      return children[index];
    };
  }

  StyledToggleButtons.builder({
    Key? key,
    required this.builder,
    required this.isSelected,
    this.onPressed,
    this.direction = Axis.horizontal,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
  });

  late final StyledComponentStateIndexedChildBuilder builder;

  final List<bool> isSelected;

  final void Function(int index)? onPressed;

  final Axis direction;

  final Style style;
  final Style? hoveredStyle;
  final Style? selectedStyle;
  final Style? disabledStyle;

  final Curve curve;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons =
        List<Widget>.generate(isSelected.length, (int index) {
      return StyledToggleable.builder(
        builder: (BuildContext context, StyledComponentState state) {
          return builder!(context, state, index);
        },
        onChanged: onPressed != null
            ? () {
                onPressed!(index);
              }
            : null,
        selected: isSelected[index],
        style: style,
        selectedStyle: selectedStyle,
        hoveredStyle: hoveredStyle,
        disabledStyle: disabledStyle,
        duration: duration,
        curve: curve,
      );
    });
    return direction == Axis.horizontal
        ? IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons,
            ),
          )
        : IntrinsicWidth(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons,
          ));
  }
}
