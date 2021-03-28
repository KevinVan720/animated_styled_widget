import 'package:flutter/material.dart';

import '../styled_widget.dart';

class StyledSwitch extends StatefulWidget {
  final dynamic thumbStyle;
  final dynamic? thumbHoveredStyle;
  final dynamic? thumbSelectedStyle;
  final dynamic? thumbDisabledStyle;

  final dynamic trackStyle;
  final dynamic? trackHoveredStyle;
  final dynamic? trackSelectedStyle;
  final dynamic? trackDisabledStyle;

  final Curve curve;
  final Duration duration;

  final bool value;

  final ValueChanged<bool>? onChanged;
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  StyledSwitch(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.thumbStyle,
      this.thumbHoveredStyle,
      this.thumbSelectedStyle,
      this.thumbDisabledStyle,
      required this.trackStyle,
      this.trackSelectedStyle,
      this.trackHoveredStyle,
      this.trackDisabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      this.child,
      this.builder});

  @override
  _StyledSwitchState createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  @override
  Widget build(BuildContext context) {
    return StyledSelectablePlainButton(
      selected: widget.value,
      onChanged: widget.onChanged != null
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      duration: widget.duration,
      curve: widget.curve,
      style: widget.trackStyle,
      selectedStyle: widget.trackSelectedStyle,
      hoveredStyle: widget.trackHoveredStyle,
      disabledStyle: widget.trackDisabledStyle,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          StyledSelectableButton(
            selected: widget.value,
            onChanged: widget.onChanged != null
                ? () {
                    widget.onChanged!(!widget.value);
                  }
                : null,
            duration: widget.duration,
            curve: widget.curve,
            style: widget.trackStyle,
            selectedStyle: widget.trackSelectedStyle,
            hoveredStyle: widget.trackHoveredStyle,
            disabledStyle: widget.trackDisabledStyle,
            child: StyledSelectableButton(
              selected: widget.value,
              onChanged: widget.onChanged != null
                  ? () {
                      widget.onChanged!(!widget.value);
                    }
                  : null,
              duration: widget.duration,
              curve: widget.curve,
              style: widget.thumbStyle.copyWith(opacity: 0.0),
            ),
          ),
          AnimatedAlign(
            duration: widget.duration,
            curve: widget.curve,
            alignment:
                widget.value ? Alignment.centerRight : Alignment.centerLeft,
            child: StyledSelectableButton(
              builder: widget.builder,
              child: widget.child,
              selected: widget.value,
              onChanged: widget.onChanged != null
                  ? () {
                      widget.onChanged!(!widget.value);
                    }
                  : null,
              duration: widget.duration,
              curve: widget.curve,
              style: widget.thumbStyle,
              selectedStyle: widget.thumbSelectedStyle,
              hoveredStyle: widget.thumbHoveredStyle,
              disabledStyle: widget.thumbDisabledStyle,
            ),
          )
        ],
      ),
    );
  }
}
