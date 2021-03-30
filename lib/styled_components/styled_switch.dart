import 'package:flutter/material.dart';

import '../styled_widget.dart';

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
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  Axis direction;

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
      this.direction = Axis.horizontal,
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
    Style outerTrackStyle = widget.trackStyle.copyWith();
    if (widget.direction == Axis.horizontal) {
      outerTrackStyle.height = null;
    } else {
      outerTrackStyle.width = null;
    }

    return StyledSelectablePlainButton(
      selected: widget.value,
      onChanged: widget.onChanged != null
          ? () {
              widget.onChanged!(!widget.value);
            }
          : null,
      duration: widget.duration,
      curve: widget.curve,
      style: outerTrackStyle,
      selectedStyle: widget.trackSelectedStyle != null
          ? widget.direction == Axis.horizontal
              ? StyleBase.setHeight(widget.trackSelectedStyle!, null)
              : StyleBase.setWidth(widget.trackSelectedStyle!, null)
          : null,
      hoveredStyle: widget.trackHoveredStyle != null
          ? widget.direction == Axis.horizontal
              ? StyleBase.setHeight(widget.trackHoveredStyle!, null)
              : StyleBase.setWidth(widget.trackHoveredStyle!, null)
          : null,
      disabledStyle: widget.trackDisabledStyle != null
          ? widget.direction == Axis.horizontal
              ? StyleBase.setHeight(widget.trackDisabledStyle!, null)
              : StyleBase.setWidth(widget.trackDisabledStyle!, null)
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
            child: StyledToggleable(
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
