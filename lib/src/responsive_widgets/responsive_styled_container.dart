import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';

class ResponsiveStyledContainer extends StatefulWidget {
  final String? id;
  final Widget child;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final ResponsiveProperty<Style> styles;

  ResponsiveStyledContainer({
    Key? key,
    this.id,
    required this.styles,
    required this.child,
    this.onMouseEnter,
    this.onMouseExit,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() {
    return _StyledContainerState();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull(
        "styles", styles.toJson(encoder: (style) => style?.toJson()));
    return rst;
  }
}

class _StyledContainerState extends State<ResponsiveStyledContainer> {
  @override
  Widget build(BuildContext context) {
    Style? style = widget.styles.resolve(context,
            (previousValue, element) => previousValue?.merge(element)) ??
        Style();

    return StyledContainer(
        child: widget.child,
        style: style,
        onMouseEnter: widget.onMouseEnter,
        onMouseExit: widget.onMouseExit);
  }
}
