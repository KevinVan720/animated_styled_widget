import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';

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
  final StyledComponentStateChildBuilder thumbChildBuilder;

  final Axis direction;

  StyledSwitch({
    super.key,
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
  }) : thumbChildBuilder = ((context, state) => thumbChild);

  const StyledSwitch.builder(
      {super.key,
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
  State<StyledSwitch> createState() => _StyledSwitchState();
}

class _StyledSwitchState extends State<StyledSwitch> {
  /// The outer container of the track: the size in the direction of the
  /// switch and the position of [trackStyle].
  Style? _outerTrackStyle(Style? trackStyle) {
    if (trackStyle == null) return null;
    final Style style = getStyleOuterContainer(trackStyle);
    if (widget.direction == Axis.horizontal) {
      style.height = null;
    } else {
      style.width = null;
    }
    return style;
  }

  /// A copy of [style] without alignment, the thumb is aligned by the switch.
  Style? _thumbStyle(Style? style) => style?.copyWith()?..alignment = null;

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
      style: _outerTrackStyle(widget.trackStyle)!,
      selectedStyle: _outerTrackStyle(widget.trackSelectedStyle),
      hoveredStyle: _outerTrackStyle(widget.trackHoveredStyle),
      disabledStyle: _outerTrackStyle(widget.trackDisabledStyle),
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
              style: _thumbStyle(widget.thumbStyle)!,
              selectedStyle: _thumbStyle(widget.thumbSelectedStyle),
              hoveredStyle: _thumbStyle(widget.thumbHoveredStyle),
              disabledStyle: _thumbStyle(widget.thumbDisabledStyle),
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
