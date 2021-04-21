import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'styled_plain_container.dart';

///A button that can be selected, hovered or disabled while showing the corresponding styling.
class StyledToggleable extends StatefulWidget {
  final Style style;
  final Style? hoveredStyle;
  final Style? selectedStyle;
  final Style? disabledStyle;
  final VoidCallback? onChanged;
  final bool? selected;
  final Curve curve;
  final Duration duration;
  late final StyledComponentStateChildBuilder builder;

  StyledToggleable({
    Key? key,
    this.onChanged,
    this.selected,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
    Widget? child,
  }) : assert(selected != null || onChanged != null) {
    builder = (context, state) {
      return child;
    };
  }

  StyledToggleable.builder(
      {Key? key,
      this.onChanged,
      this.selected,
      required this.style,
      this.hoveredStyle,
      this.selectedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      required this.builder})
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
          child: widget.builder(context, resolveState()) ?? Container()),
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

///A button that can be selected, hovered or disabled while showing the corresponding styling.
class PlainToggleable extends StatefulWidget {
  final Style style;
  final Style? hoveredStyle;
  final Style? selectedStyle;
  final Style? disabledStyle;
  final VoidCallback? onChanged;
  final bool? selected;
  final Curve curve;
  final Duration duration;
  late final StyledComponentStateChildBuilder builder;

  PlainToggleable({
    Key? key,
    this.onChanged,
    this.selected,
    required this.style,
    this.hoveredStyle,
    this.selectedStyle,
    this.disabledStyle,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 100),
    Widget? child,
  }) : assert(selected != null || onChanged != null) {
    builder = (context, state) {
      return child;
    };
  }

  PlainToggleable.builder(
      {Key? key,
      this.onChanged,
      this.selected,
      required this.style,
      this.hoveredStyle,
      this.selectedStyle,
      this.disabledStyle,
      this.curve = Curves.linear,
      this.duration = const Duration(milliseconds: 100),
      required this.builder})
      : assert(selected != null || onChanged != null);

  bool get enabled => onChanged != null;

  @override
  _PlainToggleableState createState() => _PlainToggleableState();
}

class _PlainToggleableState extends State<PlainToggleable> {
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
  void didUpdateWidget(PlainToggleable oldWidget) {
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
          child: widget.builder(context, resolveState()) ?? Container()),
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
