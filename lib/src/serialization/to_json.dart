import 'dart:convert';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';

extension CustomAnimationControlToJson on CustomAnimationControl {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension AnimationTriggerToJson on AnimationTrigger {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension AnimationPropertyToJson on AnimationProperty {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension SmoothMatrix4OperationTypesToJson on SmoothMatrix4OperationType {
  String toJson() {
    return this.toString().stripFirstDot();
  }
}

extension StyleMapToJson on Map<ScreenScope, Style> {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst =
        this.map((key, value) => MapEntry(json.encode(key.toJson()), value));
    return rst;
  }
}
