import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// A container that is styled by a [Style].
class StyledContainer extends StyledWidget {
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;

  const StyledContainer({
    super.key,
    super.id,
    required super.style,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  });

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
