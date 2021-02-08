import 'package:flutter/material.dart';
import 'package:length_unit/length_unit.dart';
import 'package:flutter_class_parser/to_json.dart';

class DynamicShadow {
  final Color color;
  final DynamicOffset offset;
  final Length blurRadius;

  const DynamicShadow({
    this.color = Colors.black,
    this.offset = const DynamicOffset(Length(0), Length(0)),
    this.blurRadius = const Length(0),
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["color"] = color.toJson();
    rst["offset"] = offset.toJson();
    rst["blurRadius"] = blurRadius.toJson();
    return rst;
  }

  DynamicShadow copyWith({
    Color? color,
    DynamicOffset? offset,
    Length? blurRadius,
  }) {
    return DynamicShadow(
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurRadius: blurRadius ?? this.blurRadius,
    );
  }

  Shadow toShadow({required Size constraintSize, required Size screenSize}) {
    Offset offset =
        this.offset.toOffset(size: constraintSize, screenSize: screenSize);
    double blurRadius = this.blurRadius.toPX(
        constraintSize: constraintSize.shortestSide, screenSize: screenSize);
    return Shadow(color: this.color, offset: offset, blurRadius: blurRadius);
  }
}

class DynamicBoxShadow extends DynamicShadow {
  final Length spreadRadius;

  const DynamicBoxShadow({
    this.spreadRadius = const Length(0.0),
    color = Colors.black,
    offset = const DynamicOffset(Length(0), Length(0)),
    blurRadius = const Length(0),
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = super.toJson();
    rst["spreadRadius"] = spreadRadius.toJson();
    return rst;
  }

  DynamicShadow copyWith({
    Color? color,
    double? angle,
    DynamicOffset? offset,
    Length? blurRadius,
    Length? spreadRadius,
  }) {
    return DynamicBoxShadow(
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurRadius: blurRadius ?? this.blurRadius,
      spreadRadius: spreadRadius ?? this.spreadRadius,
    );
  }

  BoxShadow toBoxShadow(
      {required Size screenSize, required Size constraintSize}) {
    Offset offset =
        this.offset.toOffset(size: constraintSize, screenSize: screenSize);
    double blurRadius = this.blurRadius.toPX(
        constraintSize: constraintSize.shortestSide, screenSize: screenSize);
    double spreadRadius = this.spreadRadius.toPX(
        constraintSize: constraintSize.shortestSide, screenSize: screenSize);
    return BoxShadow(
        color: this.color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius);
  }
}
