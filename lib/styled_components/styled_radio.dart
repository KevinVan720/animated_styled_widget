import 'package:flutter/material.dart';

import '../styled_widget.dart';

class StyledRadio<T> extends StatelessWidget {
  final dynamic style;
  final dynamic? hoveredStyle;
  final dynamic? selectedStyle;
  final dynamic? disabledStyle;

  final Curve curve;
  final Duration duration;
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  final T value;

  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  StyledRadio(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.style,
      this.hoveredStyle,
      this.selectedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      this.child,
      this.builder});

  @override
  Widget build(BuildContext context) {
    return StyledSelectableButton(
      child: child,
      builder: builder,
      selected: groupValue == value,
      onChanged: onChanged != null
          ? () {
              onChanged!(value);
            }
          : null,
      duration: duration,
      curve: curve,
      style: value == groupValue ? selectedStyle : style,
      selectedStyle: selectedStyle,
      hoveredStyle: value == groupValue ? selectedStyle : hoveredStyle,
      disabledStyle: disabledStyle,
    );
  }
}
