import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/material.dart';

class StyledSwitch extends StatefulWidget {
  final Style thumbStyle;
  final Style? thumbHoveredStyle;
  final Style? thumbSelectedStyle;
  final Style? thumbDisabledStyle;

  final Style trackStyle;
  final Style? trackHoveredStyle;
  final Style? trackSelectedStyle;
  final Style? trackDisabledStyle;

  final Curve curve;
  final Duration duration;

  final bool value;

  final ValueChanged<bool>? onChanged;
  late final StyledComponentStateChildBuilder thumbChildBuilder;

  final Axis direction;

  StyledSwitch({
    Key? key,
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
    this.direction = Axis.horizontal,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
    Widget? thumbChild,
  }) {
    thumbChildBuilder = (context, state) {
      return thumbChild;
    };
  }

  StyledSwitch.builder(
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
      this.direction = Axis.horizontal,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      required this.thumbChildBuilder});

  @override
  _StyledSwitchState createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  @override
  Widget build(BuildContext context) {
    return PlainToggleable(
      selected: widget.value,
      onChanged: widget.onChanged != null
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      duration: widget.duration,
      curve: widget.curve,
      style: widget.direction == Axis.horizontal
          ? (getStyleOuterContainer(widget.trackStyle)..height = null)
          : (getStyleOuterContainer(widget.trackStyle)..width = null),
      selectedStyle: widget.trackSelectedStyle != null
          ? widget.direction == Axis.horizontal
              ? (getStyleOuterContainer(widget.trackSelectedStyle!)
                ..height = null)
              : (getStyleOuterContainer(widget.trackSelectedStyle!).width =
                  null)
          : null,
      hoveredStyle: widget.trackHoveredStyle != null
          ? widget.direction == Axis.horizontal
              ? (getStyleOuterContainer(widget.trackHoveredStyle!).height =
                  null)
              : (getStyleOuterContainer(widget.trackHoveredStyle!).width = null)
          : null,
      disabledStyle: widget.trackDisabledStyle != null
          ? widget.direction == Axis.horizontal
              ? (getStyleOuterContainer(widget.trackDisabledStyle!).height =
                  null)
              : (getStyleOuterContainer(widget.trackDisabledStyle!).width =
                  null)
          : null,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          StyledToggleable(
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
          ),
          AnimatedAlign(
            duration: widget.duration,
            curve: widget.curve,
            alignment: _getAlignment(),
            child: StyledToggleable.builder(
              builder: widget.thumbChildBuilder,
              selected: widget.value,
              onChanged: widget.onChanged != null
                  ? () {
                      widget.onChanged!(!widget.value);
                    }
                  : null,
              duration: widget.duration,
              curve: widget.curve,
              style: widget.thumbStyle..alignment = null,
              selectedStyle: widget.thumbSelectedStyle?..alignment = null,
              hoveredStyle: widget.thumbHoveredStyle?..alignment = null,
              disabledStyle: widget.thumbDisabledStyle?..alignment = null,
            ),
          )
        ],
      ),
    );
  }

  Alignment _getAlignment() {
    if (widget.direction == Axis.horizontal) {
      return widget.value ? Alignment.centerRight : Alignment.centerLeft;
    } else {
      return widget.value ? Alignment.topCenter : Alignment.bottomCenter;
    }
  }
}
