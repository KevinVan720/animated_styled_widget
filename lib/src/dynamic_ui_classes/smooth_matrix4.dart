import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

enum SmoothMatrix4OperationType { scale, rotate, translate }

class SmoothOperation {
  SmoothMatrix4OperationType? operation;
  double? rotationX;
  double? rotationY;
  double? rotationZ;
  double? scaleX;
  double? scaleY;
  Dimension? translateX;
  Dimension? translateY;

  SmoothOperation({
    this.operation,
    this.rotationX,
    this.rotationY,
    this.rotationZ,
    this.scaleX,
    this.scaleY,
    this.translateX,
    this.translateY,
  })  : assert(translateX == null || translateX.isAbsolute),
        assert(translateY == null || translateY.isAbsolute);

  factory SmoothOperation.fromJson(Map<String, dynamic> map) {
    return SmoothOperation(
        operation: parseSmoothSupportedOperations(map["operation"]),
        rotationX: map["rotationX"],
        rotationY: map["rotationY"],
        rotationZ: map["rotationZ"],
        scaleX: map["scaleX"],
        scaleY: map["scaleY"],
        translateX: parseLength(map["translateX"]),
        translateY: parseLength(map["translateY"]));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("operation", operation?.toJson());
    rst.updateNotNull("rotationX", rotationX);
    rst.updateNotNull("rotationY", rotationY);
    rst.updateNotNull("rotationZ", rotationZ);
    rst.updateNotNull("scaleX", scaleX);
    rst.updateNotNull("scaleY", scaleY);
    rst.updateNotNull("translateX", translateX);
    rst.updateNotNull("translateY", translateY);
    return rst;
  }
}

class SmoothMatrix4 {
  late List<SmoothOperation> operations;

  SmoothMatrix4() {
    operations = [];
  }

  factory SmoothMatrix4.fromJson(List<dynamic> list) {
    List<SmoothOperation> operations =
        list.map((e) => SmoothOperation.fromJson(e)).toList();
    return SmoothMatrix4()..operations = operations;
  }

  List<dynamic> toJson() {
    return operations.map((e) => e.toJson()).toList();
  }

  Matrix4 toMatrix4({required Size screenSize}) {
    Matrix4 _matrix4 = Matrix4.identity();
    operations.forEach((element) {
      if (element.operation == SmoothMatrix4OperationType.rotate) {
        if (element.rotationX != null) {
          _matrix4.rotateX(element.rotationX!);
        } else if (element.rotationY != null) {
          _matrix4.rotateY(element.rotationY!);
        } else if (element.rotationZ != null) {
          _matrix4.rotateZ(element.rotationZ!);
        }
      } else if (element.operation == SmoothMatrix4OperationType.scale) {
        _matrix4.scale(element.scaleX, element.scaleY);
      } else if (element.operation == SmoothMatrix4OperationType.translate) {
        _matrix4.translate(
          element.translateX?.toPX(screenSize: screenSize) ?? 0.0,
          element.translateY?.toPX(screenSize: screenSize) ?? 0.0,
        );
      }
    });
    return _matrix4;
  }

  void rotateX(double angle) {
    operations.add(
      SmoothOperation(
          operation: SmoothMatrix4OperationType.rotate, rotationX: angle),
    );
  }

  void rotateY(double angle) {
    operations.add(
      SmoothOperation(
          operation: SmoothMatrix4OperationType.rotate, rotationY: angle),
    );
  }

  void rotateZ(double angle) {
    operations.add(
      SmoothOperation(
          operation: SmoothMatrix4OperationType.rotate, rotationZ: angle),
    );
  }

  void scale(double x, [double? y]) {
    operations.add(
      SmoothOperation(
          operation: SmoothMatrix4OperationType.scale, scaleX: x, scaleY: y),
    );
  }

  void translate(Dimension x, [Dimension y = const Length(0.0)]) {
    operations.add(
      SmoothOperation(
          operation: SmoothMatrix4OperationType.translate,
          translateX: x,
          translateY: y),
    );
  }
}
