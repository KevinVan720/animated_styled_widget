import 'package:flutter/material.dart';

import '../styled_widget.dart';

class StyledSlider extends StatefulWidget {
  final dynamic trackStyle;

  final dynamic thumbStyle;

  final Curve curve;
  final Duration duration;

  final double value;

  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  final int? divisions;

  StyledSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.trackStyle,
    required this.thumbStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
  });

  @override
  _StyledSliderState createState() => _StyledSliderState();
}

class _StyledSliderState extends State<StyledSlider> {
  double _percent = 0.5;

  @override
  void initState() {
    _percent = (((widget.value.clamp(widget.min, widget.max)) - widget.min) /
        ((widget.max - widget.min)));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        children: [
          GestureDetector(
            onTapUp: (TapUpDetails details) {
              final newPercent =
                  (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
              final newValue =
                  ((widget.min + (widget.max - widget.min) * newPercent))
                      .clamp(widget.min, widget.max);

              if (widget.onChanged != null) {
                widget.onChanged!(newValue);
              }
              setState(() {
                _percent = newPercent;
              });
            },
            child: AnimatedStyledContainer(
              duration: widget.duration,
              curve: widget.curve,
              style: widget.trackStyle,
              child: Container(),
            ),
          ),
          Align(
              //duration: widget.duration,
              //curve: widget.curve,
              alignment: Alignment(_percent * 2 - 1.0, 0.0),
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails details) {
                  final newPercent =
                      (details.delta.dx / constraints.maxWidth + _percent)
                          .clamp(0.0, 1.0);
                  final newValue =
                      ((widget.min + (widget.max - widget.min) * newPercent))
                          .clamp(widget.min, widget.max);

                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                  setState(() {
                    _percent = newPercent;
                  });
                },
                onPanStart: (DragStartDetails details) {
                  if (widget.onChangeStart != null) {
                    widget.onChangeStart!(widget.value);
                  }
                },
                onPanEnd: (details) {
                  if (widget.onChangeEnd != null) {
                    widget.onChangeEnd!(widget.value);
                  }
                },
                child: StyledButton(
                  duration: widget.duration,
                  curve: widget.curve,
                  style: widget.thumbStyle,
                ),
              ))
        ],
      );
    });
  }
}
