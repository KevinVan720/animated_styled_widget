import 'package:flutter/material.dart';

import '../styled_widget.dart';

class StyledToggleButtons extends StatelessWidget {
  StyledToggleButtons({
    Key? key,
    this.children,
    this.builder,
    required this.isSelected,
    this.onPressed,
    this.direction = Axis.horizontal,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(children?.length == isSelected.length || builder != null);

  /// The toggle button widgets.
  ///
  /// These are typically [Icon] or [Text] widgets. The boolean selection
  /// state of each widget is defined by the corresponding [isSelected]
  /// list item.
  ///
  /// The length of children has to match the length of [isSelected]. If
  /// [focusNodes] is not null, the length of children has to also match
  /// the length of [focusNodes].
  final List<Widget>? children;

  final StyledComponentStateIndexedChildBuilder? builder;

  /// The corresponding selection state of each toggle button.
  ///
  /// Each value in this list represents the selection state of the [children]
  /// widget at the same index.
  ///
  /// The length of [isSelected] has to match the length of [children].
  final List<bool> isSelected;

  /// The callback that is called when a button is tapped.
  ///
  /// The index parameter of the callback is the index of the button that is
  /// tapped or otherwise activated.
  ///
  /// When the callback is null, all toggle buttons will be disabled.
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
      return StyledToggleable(
        child: children?[index],
        builder: builder != null
            ? (BuildContext context, StyledComponentState state) {
                return builder!(context, state, index);
              }
            : null,
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
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons,
          );
  }
}
