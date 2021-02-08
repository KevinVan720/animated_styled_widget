import 'package:flutter/material.dart';
import 'package:length_unit/length_unit.dart';
import 'package:flutter_class_parser/to_json.dart';

class DynamicEdgeInsets {
  final Length? top;
  final Length? bottom;
  final Length? left;
  final Length? right;

  const DynamicEdgeInsets.all(Length value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const DynamicEdgeInsets.only({
    this.left = const Length(0.0),
    this.top = const Length(0.0),
    this.right = const Length(0.0),
    this.bottom = const Length(0.0),
  });

  const DynamicEdgeInsets.symmetric({
    Length vertical = const Length(0.0),
    Length horizontal = const Length(0.0),
  })  : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("top", top?.toJson());
    rst.updateNotNull("bottom", bottom?.toJson());
    rst.updateNotNull("left", left?.toJson());
    rst.updateNotNull("right", right?.toJson());
    return rst;
  }

  DynamicEdgeInsets copyWith({
    Length? top,
    Length? bottom,
    Length? left,
    Length? right,
  }) {
    return DynamicEdgeInsets.only(
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  EdgeInsets toEdgeInsets(
      {required Size constraintSize, required Size screenSize}) {
    double top = this.top?.toPX(
            constraintSize: constraintSize.height, screenSize: screenSize) ??
        0.0;
    double bottom = this.bottom?.toPX(
            constraintSize: constraintSize.height, screenSize: screenSize) ??
        0.0;
    double left = this.left?.toPX(
            constraintSize: constraintSize.width, screenSize: screenSize) ??
        0.0;
    double right = this.right?.toPX(
            constraintSize: constraintSize.width, screenSize: screenSize) ??
        0.0;
    return EdgeInsets.only(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
    );
  }
}
