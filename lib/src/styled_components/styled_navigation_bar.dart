import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';

class StyledNavigationBar extends StatelessWidget {
  StyledNavigationBar({
    Key? key,
    required List<Widget> children,
    required this.currentIndex,
    this.onTap,
    this.direction = Axis.horizontal,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
  })  : assert(children.length > currentIndex),
        itemCount = children.length {
    itemBuilder = (context, state, int index) {
      return children[index];
    };
  }

  StyledNavigationBar.builder({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.currentIndex,
    this.onTap,
    this.direction = Axis.horizontal,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
  }) : assert(itemBuilder != null);

  final int itemCount;

  late final StyledComponentStateIndexedChildBuilder? itemBuilder;

  /// The corresponding selection state of each toggle button.
  ///
  /// Each value in this list represents the selection state of the [children]
  /// widget at the same index.
  ///
  /// The length of [isSelected] has to match the length of [children].
  final int currentIndex;

  /// The callback that is called when a button is tapped.
  ///
  /// The index parameter of the callback is the index of the button that is
  /// tapped or otherwise activated.
  ///
  /// When the callback is null, all toggle buttons will be disabled.
  final ValueChanged<int>? onTap;

  final Axis direction;

  final Style style;
  final Style? hoveredStyle;
  final Style? selectedStyle;
  final Style? disabledStyle;

  final Curve curve;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = List<Widget>.generate(itemCount, (int index) {
      return StyledToggleable(
        key: UniqueKey(),
        builder: itemBuilder != null
            ? (BuildContext context, StyledComponentState state) {
                return itemBuilder!(context, state, index);
              }
            : null,
        onChanged: onTap != null
            ? () {
                onTap!(index);
              }
            : null,
        selected: currentIndex == index,
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
              //mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buttons,
            ),
          )
        : Column(
            //mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buttons,
          );
  }
}
