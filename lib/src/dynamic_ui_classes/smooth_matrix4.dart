import 'package:dimension/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

import '../serialization/parse_json.dart';
import '../serialization/to_json.dart';

enum SmoothMatrix4OperationType { scale, rotate, translate }

/// A single operation of a [SmoothMatrix4].
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
        rotationX: (map["rotationX"] as num?)?.toDouble(),
        rotationY: (map["rotationY"] as num?)?.toDouble(),
        rotationZ: (map["rotationZ"] as num?)?.toDouble(),
        scaleX: (map["scaleX"] as num?)?.toDouble(),
        scaleY: (map["scaleY"] as num?)?.toDouble(),
        translateX: parseDimension(map["translateX"]),
        translateY: parseDimension(map["translateY"]));
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst.updateNotNull("operation", operation?.toJson());
    rst.updateNotNull("rotationX", rotationX);
    rst.updateNotNull("rotationY", rotationY);
    rst.updateNotNull("rotationZ", rotationZ);
    rst.updateNotNull("scaleX", scaleX);
    rst.updateNotNull("scaleY", scaleY);
    rst.updateNotNull("translateX", translateX?.toJson());
    rst.updateNotNull("translateY", translateY?.toJson());
    return rst;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmoothOperation &&
        other.operation == operation &&
        other.rotationX == rotationX &&
        other.rotationY == rotationY &&
        other.rotationZ == rotationZ &&
        other.scaleX == scaleX &&
        other.scaleY == scaleY &&
        other.translateX == translateX &&
        other.translateY == translateY;
  }

  @override
  int get hashCode => Object.hash(operation, rotationX, rotationY, rotationZ,
      scaleX, scaleY, translateX, translateY);
}

/// A list of rotations, scalings and translations that can be smoothly
/// interpolated, as opposed to the values of a [Matrix4].
///
/// Translations can use viewport units, which are resolved by [toMatrix4].
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

  /// The matrix of the operations, applied in order.
  ///
  /// Operations without values (e.g. a scale without [SmoothOperation.scaleX]
  /// and [SmoothOperation.scaleY]) are skipped.
  Matrix4 toMatrix4({required Size screenSize}) {
    Matrix4 matrix4 = Matrix4.identity();
    for (final SmoothOperation element in operations) {
      if (element.operation == SmoothMatrix4OperationType.rotate) {
        if (element.rotationX != null) {
          matrix4.rotateX(element.rotationX!);
        } else if (element.rotationY != null) {
          matrix4.rotateY(element.rotationY!);
        } else if (element.rotationZ != null) {
          matrix4.rotateZ(element.rotationZ!);
        }
      } else if (element.operation == SmoothMatrix4OperationType.scale) {
        final double? scaleX = element.scaleX;
        final double? scaleY = element.scaleY;
        if (scaleX == null && scaleY == null) continue;
        // Same as the deprecated Matrix4.scale(x, y): a single value also
        // scales y and z, and z is scaled by x.
        matrix4.multiply(Matrix4.diagonal3Values(
            scaleX ?? 1.0, scaleY ?? scaleX!, scaleX ?? 1.0));
      } else if (element.operation == SmoothMatrix4OperationType.translate) {
        // Same as the deprecated Matrix4.translate(x, y).
        matrix4.multiply(Matrix4.translationValues(
          element.translateX?.toPX(screenSize: screenSize) ?? 0.0,
          element.translateY?.toPX(screenSize: screenSize) ?? 0.0,
          0.0,
        ));
      }
    }
    return matrix4;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SmoothMatrix4 && listEquals(other.operations, operations);
  }

  @override
  int get hashCode => Object.hashAll(operations);
}
