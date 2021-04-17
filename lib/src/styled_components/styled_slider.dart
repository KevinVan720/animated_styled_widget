import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledSlider extends StatefulWidget {
  final Style trackStyle;
  final Style thumbStyle;
  final Style? thumbPressedStyle;
  final Style? thumbHoveredStyle;
  final Style? thumbDisabledStyle;

  final Style? activeTrackStyle;
  final Style? toolTipStyle;

  final Widget? thumbChild;

  final Curve curve;
  final Duration duration;

  final double value;
  final String? label;

  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  final int? divisions;

  final Axis direction;

  StyledSlider({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.trackStyle,
    required this.thumbStyle,
    this.thumbPressedStyle,
    this.thumbHoveredStyle,
    this.thumbDisabledStyle,
    this.activeTrackStyle,
    this.toolTipStyle,
    this.thumbChild,
    this.direction = Axis.horizontal,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.label,
  })  : assert(
            (direction == Axis.horizontal && trackStyle.width != null) ||
                (direction == Axis.vertical && trackStyle.height != null),
            "Slider track needs a specific Dimension in the slider direction"),
        assert(
            thumbStyle.width != null &&
                thumbStyle.width!.isAbsolute &&
                thumbStyle.height != null &&
                thumbStyle.height!.isAbsolute,
            "Thumb needs to have a absolute size");

  bool get enabled => onChanged != null;

  @override
  _StyledSliderState createState() => _StyledSliderState();
}

class _StyledSliderState extends State<StyledSlider> {
  double _percent = 0.5;
  double _roundedPercent = 0.5;

  bool isOverlayShowed = false;
  final LayerLink layerLink = LayerLink();
  OverlayEntry? overlayEntry;

  final Set<StyledComponentState> _thumbStates = <StyledComponentState>{};

  bool get _thumbHovered => _thumbStates.contains(StyledComponentState.hovered);
  bool get _thumbSelected =>
      _thumbStates.contains(StyledComponentState.pressed);
  bool get _thumbDisabled =>
      _thumbStates.contains(StyledComponentState.disabled);

  void _updateThumbState(StyledComponentState state, bool value) {
    value ? _thumbStates.add(state) : _thumbStates.remove(state);
  }

  late dynamic thumbStyle;
  late dynamic thumbHoveredStyle;
  late dynamic thumbSelectedStyle;
  late dynamic thumbDisabledStyle;

  @override
  void initState() {
    _percent = (((widget.value.clamp(widget.min, widget.max)) - widget.min) /
        ((widget.max - widget.min)));
    if (widget.divisions != null)
      _roundedPercent = roundPercentWithDivisions(_percent);
    super.initState();
  }

  @override
  void didUpdateWidget(StyledSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateThumbState(StyledComponentState.disabled, !widget.enabled);
    updateThumbStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateThumbStyle();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.direction == Axis.horizontal) {
      return _buildHorizontalSlider();
    } else {
      return _buildVerticalSlider();
    }
  }

  Widget _buildHorizontalSlider() {
    double thumbWidth =
        widget.thumbStyle.width!.toPX(screenSize: MediaQuery.of(context).size);
    Style outerTrackStyle = Style();
    outerTrackStyle.height = null;
    outerTrackStyle.width =
        widget.trackStyle.width! + (widget.thumbStyle.width ?? 0.toPXLength);

    Style innerTrackStyle = widget.trackStyle.copyWith();
    innerTrackStyle.width = 100.toPercentLength - thumbWidth.toPXLength;

    return StyledContainer(
        style: getStyleOuterContainer(outerTrackStyle),
        child: Center(
          child: LayoutBuilder(
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
                    handlePercentUpdate(newPercent);
                  },
                  child: AnimatedStyledContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    style: innerTrackStyle,
                    child: Container(),
                  ),
                ),
                widget.activeTrackStyle != null
                    ? Positioned(
                        left: thumbWidth / 2,
                        child: ClipRect(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: widget.divisions == null
                                  ? _percent
                                  : _roundedPercent,
                              child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxHeight: constraints.maxHeight,
                                      maxWidth:
                                          constraints.maxWidth - thumbWidth),
                                  child: GestureDetector(
                                    onTapUp: (TapUpDetails details) {
                                      final newPercent =
                                          (details.localPosition.dx /
                                                  constraints.maxWidth)
                                              .clamp(0.0, 1.0);
                                      handlePercentUpdate(newPercent);
                                    },
                                    child: AnimatedStyledContainer(
                                      duration: widget.duration,
                                      curve: widget.curve,
                                      style: widget.activeTrackStyle!.copyWith()
                                        ..width = 100.toPercentLength
                                        ..shadows = [],
                                      child: Container(),
                                    ),
                                  ))),
                        ),
                      )
                    : Container(),
                Align(
                    alignment: widget.divisions == null
                        ? Alignment(_percent * 2 - 1.0, 0.0)
                        : Alignment(_roundedPercent * 2 - 1.0, 0.0),
                    child: GestureDetector(
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        double newPercent =
                            (details.delta.dx / constraints.maxWidth + _percent)
                                .clamp(0.0, 1.0);
                        handlePercentUpdate(newPercent);
                      },
                      onHorizontalDragStart: handleDragStart,
                      onHorizontalDragEnd: handleDragEnd,
                      onTapDown: handleTapDown,
                      onTapUp: handleTapUp,
                      child: _buildThumb(),
                    ))
              ],
            );
          }),
        ));
  }

  Widget _buildVerticalSlider() {
    double thumbHeight =
        widget.thumbStyle.height!.toPX(screenSize: MediaQuery.of(context).size);
    Style outerTrackStyle = Style();
    outerTrackStyle.width = null;
    outerTrackStyle.height =
        widget.trackStyle.height! + (widget.thumbStyle.height ?? 0.toPXLength);

    Style innerTrackStyle = widget.trackStyle.copyWith();
    innerTrackStyle.height = 100.toPercentLength - thumbHeight.toPXLength;

    return StyledContainer(
        style: getStyleOuterContainer(outerTrackStyle),
        child: Center(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                GestureDetector(
                  onTapUp: (TapUpDetails details) {
                    final newPercent = 1 -
                        (details.localPosition.dy / constraints.maxHeight)
                            .clamp(0.0, 1.0);
                    print(details.localPosition.dy);
                    print(constraints.maxHeight);
                    print(newPercent);
                    handlePercentUpdate(newPercent);
                  },
                  child: AnimatedStyledContainer(
                    duration: widget.duration,
                    curve: widget.curve,
                    style: innerTrackStyle,
                    child: Container(),
                  ),
                ),
                widget.activeTrackStyle != null
                    ? Positioned(
                        bottom: thumbHeight / 2,
                        child: ClipRect(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                heightFactor: widget.divisions == null
                                    ? _percent
                                    : _roundedPercent,
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxWidth: constraints.maxWidth,
                                        maxHeight: constraints.maxHeight -
                                            thumbHeight),
                                    child: GestureDetector(
                                      onTapUp: (TapUpDetails details) {
                                        final newPercent = 1 -
                                            ((details.localPosition.dy) /
                                                    (constraints.maxHeight))
                                                .clamp(0.0, 1.0);
                                        handlePercentUpdate(newPercent);
                                      },
                                      behavior: HitTestBehavior.translucent,
                                      child: AnimatedStyledContainer(
                                        duration: widget.duration,
                                        curve: widget.curve,
                                        style:
                                            widget.activeTrackStyle!.copyWith()
                                              ..height = 100.toPercentLength
                                              ..shadows = [],
                                        child: Container(),
                                      ),
                                    )))),
                      )
                    : Container(),
                Align(
                    alignment: widget.divisions == null
                        ? Alignment(0.0, -(_percent * 2 - 1.0))
                        : Alignment(0.0, -(_roundedPercent * 2 - 1.0)),
                    child: GestureDetector(
                      onVerticalDragUpdate: (DragUpdateDetails details) {
                        double newPercent =
                            (-details.delta.dy / constraints.maxHeight +
                                    _percent)
                                .clamp(0.0, 1.0);
                        handlePercentUpdate(newPercent);
                      },
                      onVerticalDragStart: handleDragStart,
                      onVerticalDragEnd: handleDragEnd,
                      onTapDown: handleTapDown,
                      onTapUp: handleTapUp,
                      child: _buildThumb(),
                    ))
              ],
            );
          }),
        ));
  }

  double roundPercentWithDivisions(double percent) {
    return percent.roundWithNumber(widget.divisions!.toDouble());
  }

  void showIndicator() {
    if (widget.label != null && widget.toolTipStyle != null) {
      overlayEntry = OverlayEntry(
        builder: (BuildContext context) {
          return Positioned(
              left: 0,
              top: 0,
              child: CompositedTransformFollower(
                followerAnchor: Alignment.center,
                targetAnchor: Alignment.center,
                offset: Offset.zero,
                link: layerLink,
                child: StyledContainer(
                  style: widget.toolTipStyle ?? Style(),
                  child: Text(widget.label ?? ""),
                ),
              ));
        },
      );
      Overlay.of(context)?.insert(overlayEntry!);
    }
  }

  void hideIndicator() {
    overlayEntry?.remove();
    overlayEntry = null;
  }

  void handlePercentUpdate(double newPercent) {
    if (widget.divisions == null) {
      final newValue = ((widget.min + (widget.max - widget.min) * newPercent))
          .clamp(widget.min, widget.max);
      if (widget.onChanged != null) {
        widget.onChanged!(newValue);
      }
    } else {
      double newRoundPercent = roundPercentWithDivisions(newPercent);
      if (newRoundPercent != _roundedPercent) {
        final newValue =
            ((widget.min + (widget.max - widget.min) * newRoundPercent))
                .clamp(widget.min, widget.max);
        if (widget.onChanged != null) {
          widget.onChanged!(newValue);
        }
        _roundedPercent = newRoundPercent;
      }
    }
    setState(() {
      _percent = newPercent;
      overlayEntry?.markNeedsBuild();
    });
  }

  void handleDragStart(DragStartDetails details) {
    if (widget.onChangeStart != null) {
      widget.onChangeStart!(widget.value);
    }
    setState(() {
      _updateThumbState(StyledComponentState.pressed, true);
      if (!isOverlayShowed) {
        isOverlayShowed = true;
        //showIndicator();
      }
    });
  }

  void handleDragEnd(DragEndDetails details) {
    if (widget.onChangeEnd != null) {
      widget.onChangeEnd!(widget.value);
    }
    setState(() {
      _updateThumbState(StyledComponentState.pressed, false);
      if (isOverlayShowed) {
        isOverlayShowed = false;
        hideIndicator();
      }
    });
  }

  void handleTapDown(TapDownDetails details) {
    setState(() {
      _updateThumbState(StyledComponentState.pressed, true);
      if (!isOverlayShowed) {
        isOverlayShowed = true;
      }
    });
  }

  void handleTapUp(TapUpDetails details) {
    setState(() {
      _updateThumbState(StyledComponentState.pressed, false);
      if (isOverlayShowed) {
        isOverlayShowed = false;
        hideIndicator();
      }
    });
  }

  Style resolveThumbStyle() {
    if (_thumbDisabled) {
      return thumbDisabledStyle;
    }
    if (_thumbSelected) {
      return thumbSelectedStyle;
    }
    if (_thumbHovered) {
      return thumbHoveredStyle;
    }
    return thumbStyle;
  }

  StyledComponentState resolveThumbState() {
    if (_thumbDisabled) {
      return StyledComponentState.disabled;
    }
    if (_thumbSelected) {
      return StyledComponentState.selected;
    }
    if (_thumbHovered) {
      return StyledComponentState.hovered;
    }
    return StyledComponentState.idle;
  }

  void updateThumbStyle() {
    thumbStyle = widget.thumbStyle;
    thumbHoveredStyle = widget.thumbHoveredStyle ?? thumbStyle;
    thumbSelectedStyle = widget.thumbPressedStyle ?? thumbStyle;
    thumbDisabledStyle = widget.thumbDisabledStyle ?? thumbStyle;
  }

  Widget _buildThumb() {
    return CompositedTransformTarget(
        link: layerLink,
        child: AnimatedStyledContainer(
          duration: widget.duration,
          curve: widget.curve,
          style: resolveThumbStyle()..alignment = null,
          child: widget.thumbChild ?? Container(),
          onEnd: () {
            if (isOverlayShowed && _thumbSelected) {
              showIndicator();
            }
            overlayEntry?.markNeedsBuild();
          },
        ));
  }
}
