import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:simple_animations/simple_animations.dart';

extension CustomAnimationControlToJson on Control {
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
