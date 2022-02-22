import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

///A button that can be pressed, hovered or disabled while showing the corresponding styling.
class StyledButton extends StatefulWidget {
  final Style style;
  final Style? hoveredStyle;
  final Style? pressedStyle;
  final Style? disabledStyle;
  final VoidCallback? onPressed;
  final Curve curve;
  final Duration duration;
  late final StyledComponentStateChildBuilder builder;

  StyledButton(
      {Key? key,
      this.onPressed,
      required this.style,
      this.hoveredStyle,
      this.pressedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      Widget? child}) {
    builder = (context, state) {
      return child;
    };
  }

  StyledButton.builder(
      {Key? key,
      this.onPressed,
      required this.style,
      this.hoveredStyle,
      this.pressedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      required this.builder});

  bool get enabled => onPressed != null;

  @override
  _StyledButtonState createState() => _StyledButtonState();
}

class _StyledButtonState extends State<StyledButton> {
  final Set<StyledComponentState> _states = <StyledComponentState>{};

  bool get _hovered => _states.contains(StyledComponentState.hovered);
  bool get _pressed => _states.contains(StyledComponentState.pressed);
  bool get _disabled => _states.contains(StyledComponentState.disabled);

  void _updateState(StyledComponentState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  late Style style;
  late Style hoveredStyle;
  late Style pressedStyle;
  late Style disabledStyle;

  bool hasFinishedAnimationDown = false;
  bool hasTapUp = false;

  @override
  void initState() {
    super.initState();
    _updateState(StyledComponentState.disabled, !widget.enabled);
  }

  @override
  void didUpdateWidget(StyledButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(StyledComponentState.disabled, !widget.enabled);
    updateStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateStyle();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    dynamic resolvedStyle = resolveStyle();

    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        hasTapUp = false;
        if (widget.enabled) {
          _handleTapDown();
        }
      },
      onTapUp: (TapUpDetails details) {
        if (widget.enabled) {
          widget.onPressed!();
        }
        hasTapUp = true;
        _resetIfTapUp();
      },
      onTapCancel: () {
        hasTapUp = true;
        _resetIfTapUp();
      },
      child: AnimatedStyledContainer(
          onMouseEnter: (PointerEnterEvent event) {
            setState(() {
              _updateState(StyledComponentState.hovered, true);
            });
          },
          onMouseExit: (PointerExitEvent event) {
            setState(() {
              _updateState(StyledComponentState.hovered, false);
            });
          },
          style: resolvedStyle,
          curve: widget.curve,
          duration: widget.duration,
          child: widget.builder(context, resolveState()) ?? Container()),
    );
  }

  dynamic resolveStyle() {
    if (_disabled) {
      return disabledStyle;
    }
    if (_pressed) {
      return pressedStyle;
    }
    if (_hovered) {
      return hoveredStyle;
    }
    return style;
  }

  StyledComponentState resolveState() {
    if (_disabled) {
      return StyledComponentState.disabled;
    }
    if (_pressed) {
      return StyledComponentState.pressed;
    }
    if (_hovered) {
      return StyledComponentState.hovered;
    }
    return StyledComponentState.idle;
  }

  void updateStyle() {
    style = widget.style;
    hoveredStyle = widget.hoveredStyle ?? style;
    pressedStyle = widget.pressedStyle ?? style;
    disabledStyle = widget.disabledStyle ?? style;
  }

  Future<void> _handleTapDown() async {
    hasFinishedAnimationDown = false;
    setState(() {
      _updateState(StyledComponentState.pressed, true);
    });

    await Future.delayed(widget.duration); //wait until animation finished
    hasFinishedAnimationDown = true;

    _resetIfTapUp();
  }

  //used to stay pressed if no tap up
  void _resetIfTapUp() {
    if (hasFinishedAnimationDown == true && hasTapUp == true && mounted) {
      hasFinishedAnimationDown = false;
      hasTapUp = false;
      setState(() {
        _updateState(StyledComponentState.pressed, false);
      });
    }
  }
}
