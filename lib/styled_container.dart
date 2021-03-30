import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'styled_widget.dart';

class StyledContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  StyledContainer({
    Key? key,
    required StyleBase style,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  }) : super(
          key: key,
          style: style,
        );

  @override
  State<StatefulWidget> createState() {
    return _StyledContainerState();
  }
}

class _StyledContainerState extends StyledWidgetState<StyledContainer> {
  @override
  Widget build(BuildContext context) {
    resolveStyle();
    resolveProperties();

    return buildStyledContainer(
        child: widget.child,
        onMouseEnter: widget.onMouseEnter,
        onMouseExit: widget.onMouseExit);
  }
}
