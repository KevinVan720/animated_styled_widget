import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

extension CustomAnimationControlToJson on Control {
  String toJson() => name;
}

extension AnimationTriggerToJson on AnimationTrigger {
  String toJson() => name;
}

extension AnimationPropertyToJson on AnimationProperty {
  String toJson() => name;
}

extension SmoothMatrix4OperationTypesToJson on SmoothMatrix4OperationType {
  String toJson() => name;
}
