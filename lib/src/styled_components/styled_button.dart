import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';

import 'styled_plain_container.dart';

enum StyledComponentState {
  idle,

  hovered,

  pressed,

  selected,

  disabled,
}

typedef Widget? StyledComponentStateChildBuilder(
    BuildContext context, StyledComponentState state);

typedef Widget? StyledComponentStateIndexedChildBuilder(
    BuildContext context, StyledComponentState state, int index);

class StyledButton extends StatefulWidget {
  final Style style;
  final Style? hoveredStyle;
  final Style? pressedStyle;
  final Style? disabledStyle;
  final VoidCallback? onPressed;
  final Curve curve;
  final Duration duration;
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  StyledButton(
      {Key? key,
      this.onPressed,
      required this.style,
      this.hoveredStyle,
      this.pressedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      this.child,
      this.builder});

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
        print("TAP DOWN");
        hasTapUp = false;
        if (widget.enabled) {
          _handleTapDown();
        }
      },
      onTapUp: (TapUpDetails details) {
        print("TAP UP");
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
          child: (widget.builder != null
                  ? widget.builder!(context, resolveState())
                  : widget.child) ??
              Container()),
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

class StyledToggleable extends StatefulWidget {
  final Style style;
  final Style? hoveredStyle;
  final Style? selectedStyle;
  final Style? disabledStyle;
  final VoidCallback? onChanged;
  final bool? selected;
  final Curve curve;
  final Duration duration;
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  StyledToggleable(
      {Key? key,
      this.onChanged,
      this.selected,
      required this.style,
      this.hoveredStyle,
      this.selectedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      this.child,
      this.builder})
      : assert(selected != null || onChanged != null);

  bool get enabled => onChanged != null;

  @override
  _StyledToggleableState createState() => _StyledToggleableState();
}

class _StyledToggleableState extends State<StyledToggleable> {
  final Set<StyledComponentState> _states = <StyledComponentState>{};

  bool get _hovered => _states.contains(StyledComponentState.hovered);
  bool get _selected => _states.contains(StyledComponentState.selected);
  bool get _disabled => _states.contains(StyledComponentState.disabled);

  void _updateState(StyledComponentState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  late Style style;
  late Style hoveredStyle;
  late Style selectedStyle;
  late Style disabledStyle;

  bool hasFinishedAnimationDown = false;
  bool hasTapUp = false;

  @override
  void initState() {
    super.initState();
    _updateState(StyledComponentState.disabled, !widget.enabled);
    if (widget.selected != null)
      _updateState(StyledComponentState.selected, widget.selected!);
  }

  @override
  void didUpdateWidget(StyledToggleable oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(StyledComponentState.disabled, !widget.enabled);
    if (widget.selected != null)
      _updateState(StyledComponentState.selected, widget.selected!);
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
      onTap: () {
        if (widget.enabled) {
          widget.onChanged!();
          setState(() {
            _updateState(StyledComponentState.selected, !_selected);
          });
        }
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
          child: (widget.builder != null
                  ? widget.builder!(context, resolveState())
                  : widget.child) ??
              Container()),
    );
  }

  dynamic resolveStyle() {
    if (_disabled) {
      return disabledStyle;
    }
    if (_selected) {
      return selectedStyle;
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
    if (_selected) {
      return StyledComponentState.selected;
    }
    if (_hovered) {
      return StyledComponentState.hovered;
    }
    return StyledComponentState.idle;
  }

  void updateStyle() {
    style = widget.style;
    hoveredStyle = widget.hoveredStyle ?? style;
    selectedStyle = widget.selectedStyle ?? style;
    disabledStyle = widget.disabledStyle ?? style;
  }
}

class StyledSelectablePlainButton extends StatefulWidget {
  final dynamic style;
  final dynamic? hoveredStyle;
  final dynamic? selectedStyle;
  final dynamic? disabledStyle;
  final VoidCallback? onChanged;
  final bool? selected;
  final Curve curve;
  final Duration duration;
  final Widget? child;
  final StyledComponentStateChildBuilder? builder;

  StyledSelectablePlainButton(
      {Key? key,
      this.onChanged,
      this.selected,
      required this.style,
      this.hoveredStyle,
      this.selectedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      this.child,
      this.builder})
      : assert(selected != null || onChanged != null);

  bool get enabled => onChanged != null;

  @override
  _StyledSelectablePlainButtonState createState() =>
      _StyledSelectablePlainButtonState();
}

class _StyledSelectablePlainButtonState
    extends State<StyledSelectablePlainButton> {
  final Set<StyledComponentState> _states = <StyledComponentState>{};

  bool get _hovered => _states.contains(StyledComponentState.hovered);
  bool get _selected => _states.contains(StyledComponentState.selected);
  bool get _disabled => _states.contains(StyledComponentState.disabled);

  void _updateState(StyledComponentState state, bool value) {
    value ? _states.add(state) : _states.remove(state);
  }

  late dynamic style;
  late dynamic hoveredStyle;
  late dynamic selectedStyle;
  late dynamic disabledStyle;

  bool hasFinishedAnimationDown = false;
  bool hasTapUp = false;

  @override
  void initState() {
    super.initState();
    _updateState(StyledComponentState.disabled, !widget.enabled);
    if (widget.selected != null)
      _updateState(StyledComponentState.selected, widget.selected!);
  }

  @override
  void didUpdateWidget(StyledSelectablePlainButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateState(StyledComponentState.disabled, !widget.enabled);
    if (widget.selected != null)
      _updateState(StyledComponentState.selected, widget.selected!);
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
      onTap: () {
        if (widget.enabled) {
          widget.onChanged!();
          setState(() {
            _updateState(StyledComponentState.selected, !_selected);
          });
        }
      },
      child: AnimatedStyledPlainContainer(
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
          child: (widget.builder != null
                  ? widget.builder!(context, resolveState())
                  : widget.child) ??
              Container()),
    );
  }

  dynamic resolveStyle() {
    if (_disabled) {
      return disabledStyle;
    }
    if (_selected) {
      return selectedStyle;
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
    if (_selected) {
      return StyledComponentState.selected;
    }
    if (_hovered) {
      return StyledComponentState.hovered;
    }
    return StyledComponentState.idle;
  }

  void updateStyle() {
    style = widget.style ?? Style();
    hoveredStyle = widget.hoveredStyle ?? style;
    selectedStyle = widget.selectedStyle ?? style;
    disabledStyle = widget.disabledStyle ?? style;
  }
}
