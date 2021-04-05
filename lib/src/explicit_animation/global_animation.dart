import 'package:flutter/material.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';

import 'animation_sequence.dart';

class GlobalAnimation {
  static const double progressMaxTime = 10000;

  CustomAnimationControl control = CustomAnimationControl.PLAY;
  double beginShift = 0.0;
  double endShift = 1.0;

  Map<String, MultiAnimationSequence> sequences = {};

  GlobalAnimation(
      {required this.sequences,
      this.beginShift = 0.0,
      this.endShift = 0.0,
      this.control = CustomAnimationControl.PLAY});

  GlobalAnimation.fromJson(Map map) {
    control = parseCustomAnimationControl(map["control"]) ??
        CustomAnimationControl.PLAY;
    beginShift = map['beginShift'];
    endShift = map['endShift'];
    sequences = (map["sequences"] as Map).map((key, value) {
      return MapEntry(key, MultiAnimationSequence.fromJson(value));
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst['beginShift'] = beginShift;
    rst['endShift'] = endShift;
    rst["control"] = control.toJson();
    rst["sequences"] =
        sequences.map((key, value) => MapEntry(key, value.toJson()));
    return rst;
  }

  List<double> getAllTimeStamps() {
    List<double> timeStamps = [];
    sequences.forEach((name, value) {
      value.getAllTimeStamps().forEach((time) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      });
    });
    timeStamps.sort();
    return timeStamps;
  }

  void rescaleTime(Duration maxDuration) {
    sequences.forEach((name, value) {
      value.rescaleTime(maxDuration);
    });
  }
}

class ContinuousAnimationProgressNotifier extends ValueNotifier<double> {
  ContinuousAnimationProgressNotifier(value) : super(value);

  @override
  double get value => super.value;

  @override
  set value(double newValue) {
    if (super.value == newValue) return;
    super.value = newValue.clamp(0.0, 1.0);
    notifyListeners();
  }
}
