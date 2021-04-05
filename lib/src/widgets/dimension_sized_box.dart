import 'package:dimension/dimension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DimensionSizedBox extends SingleChildRenderObjectWidget {
  /// Creates a widget that sizes its child to a fraction of the total available space.
  ///
  /// If non-null, the [widthFactor] and [heightFactor] arguments must be
  /// non-negative.
  const DimensionSizedBox({
    Key? key,
    this.alignment = Alignment.center,
    this.width,
    this.height,
    Widget? child,
  }) : super(key: key, child: child);

  final Dimension? width;
  final Dimension? height;

  final AlignmentGeometry alignment;

  @override
  RenderDimensionSizedOverflowBox createRenderObject(BuildContext context) {
    return RenderDimensionSizedOverflowBox(
      alignment: alignment,
      width: width,
      height: height,
      screenSize: MediaQuery.of(context).size,
      textDirection: Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderDimensionSizedOverflowBox renderObject) {
    renderObject
      ..alignment = alignment
      ..width = width
      ..height = height
      ..textDirection = Directionality.maybeOf(context);
  }
}

class RenderDimensionSizedOverflowBox extends RenderAligningShiftedBox {
  RenderDimensionSizedOverflowBox({
    RenderBox? child,
    Dimension? width,
    Dimension? height,
    AlignmentGeometry alignment = Alignment.center,
    required Size screenSize,
    TextDirection? textDirection,
  })  : _width = width,
        _height = height,
        _screenSize = screenSize,
        super(child: child, alignment: alignment, textDirection: textDirection);

  Size get screenSize => _screenSize;
  Size _screenSize;
  set screenSize(Size value) {
    if (_screenSize == value) return;
    _screenSize = value;
    markNeedsLayout();
  }

  /// If non-null, the factor of the incoming width to use.
  ///
  /// If non-null, the child is given a tight width constraint that is the max
  /// incoming width constraint multiplied by this factor. If null, the child is
  /// given the incoming width constraints.
  Dimension? get width => _width;
  Dimension? _width;
  set width(Dimension? value) {
    if (_width == value) return;
    _width = value;
    markNeedsLayout();
  }

  /// If non-null, the factor of the incoming height to use.
  ///
  /// If non-null, the child is given a tight height constraint that is the max
  /// incoming width constraint multiplied by this factor. If null, the child is
  /// given the incoming width constraints.
  Dimension? get height => _height;
  Dimension? _height;
  set height(Dimension? value) {
    if (_height == value) return;
    _height = value;
    markNeedsLayout();
  }

  BoxConstraints _getInnerConstraints(BoxConstraints constraints) {
    double minWidth = constraints.minWidth;
    double maxWidth = constraints.maxWidth;
    if (_width != null) {
      final double width =
          _width!.toPX(constraint: maxWidth, screenSize: _screenSize);
      minWidth = width;
      maxWidth = width;
    }
    double minHeight = constraints.minHeight;
    double maxHeight = constraints.maxHeight;
    if (_height != null) {
      final double height =
          _height!.toPX(constraint: maxHeight, screenSize: _screenSize);
      minHeight = height;
      maxHeight = height;
    }
    return BoxConstraints(
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    if (_height != null) {
      return _height!.toPX(constraint: height, screenSize: _screenSize);
    }
    final double result;
    if (child == null) {
      result = super.computeMinIntrinsicWidth(height);
    } else {
      result = child!.getMinIntrinsicWidth(height);
    }
    assert(result.isFinite);
    return result;
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final double result;
    if (_height != null) {
      return _height!.toPX(constraint: height, screenSize: _screenSize);
    }
    if (child == null) {
      result = super.computeMaxIntrinsicWidth(height);
    } else {
      result = child!.getMaxIntrinsicWidth(height);
    }
    assert(result.isFinite);
    return result;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final double result;
    if (_width != null) {
      return _width!.toPX(constraint: width, screenSize: _screenSize);
    }
    if (child == null) {
      result = super.computeMinIntrinsicHeight(width);
    } else {
      result = child!.getMinIntrinsicHeight(width);
    }
    assert(result.isFinite);
    return result;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final double result;
    if (_width != null) {
      return _width!.toPX(constraint: width, screenSize: _screenSize);
    }
    if (child == null) {
      result = super.computeMaxIntrinsicHeight(width);
    } else {
      result = child!.getMaxIntrinsicHeight(width);
    }
    assert(result.isFinite);
    return result;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child != null) {
      final Size childSize =
          child!.getDryLayout(_getInnerConstraints(constraints));
      return constraints.constrain(childSize);
    }
    return constraints
        .constrain(_getInnerConstraints(constraints).constrain(Size.zero));
  }

  @override
  void performLayout() {
    if (child != null) {
      child!.layout(_getInnerConstraints(constraints), parentUsesSize: true);
      size = constraints.constrain(child!.size);
      alignChild();
    } else {
      size = constraints
          .constrain(_getInnerConstraints(constraints).constrain(Size.zero));
    }
  }
}
