import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/to_json.dart';
import 'package:morphable_shape/morphable_shape.dart';

class DynamicShadow {
  final Color color;
  final DynamicOffset offset;
  final Dimension blurRadius;

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
    Dimension? blurRadius,
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
    double blurRadius = this
        .blurRadius
        .toPX(constraint: constraintSize.shortestSide, screenSize: screenSize);
    return Shadow(color: this.color, offset: offset, blurRadius: blurRadius);
  }
}

class DynamicShapeShadow extends DynamicShadow {
  final Gradient? gradient;

  const DynamicShapeShadow({
    this.gradient,
    color = Colors.black,
    offset = const DynamicOffset(Length(0), Length(0)),
    blurRadius = const Length(0),
  }) : super(color: color, offset: offset, blurRadius: blurRadius);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = super.toJson();
    rst.updateNotNull("gradient", gradient?.toJson());
    return rst;
  }

  DynamicShadow copyWith({
    Color? color,
    DynamicOffset? offset,
    Dimension? blurRadius,
    Gradient? gradient,
  }) {
    return DynamicShapeShadow(
      color: color ?? this.color,
      offset: offset ?? this.offset,
      blurRadius: blurRadius ?? this.blurRadius,
      gradient: gradient ?? this.gradient,
    );
  }

  ShapeShadow toShapeShadow(
      {required Size screenSize, required Size constraintSize}) {
    Offset offset =
        this.offset.toOffset(size: constraintSize, screenSize: screenSize);
    double blurRadius = this
        .blurRadius
        .toPX(constraint: constraintSize.shortestSide, screenSize: screenSize);
    return ShapeShadow(
        color: this.color,
        offset: offset,
        blurRadius: blurRadius,
        gradient: this.gradient);
  }
}
