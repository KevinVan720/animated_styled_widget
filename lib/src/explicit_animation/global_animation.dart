import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:simple_animations/simple_animations.dart';

/// Animations of several widgets, the keys of [sequences] are the ids of the
/// widgets (see [ExplicitAnimatedStyledContainer.id]).
class GlobalAnimation {
  Control control = Control.play;
  double beginShift = 0.0;
  double endShift = 1.0;

  Map<String, MultiAnimationSequence> sequences = {};

  GlobalAnimation(
      {required this.sequences,
      this.beginShift = 0.0,
      this.endShift = 0.0,
      this.control = Control.play});

  /// Parses the output of [toJson], missing values use the defaults of the
  /// constructor.
  GlobalAnimation.fromJson(Map map) {
    control = parseCustomAnimationControl(map["control"]) ?? Control.play;
    beginShift = (map['beginShift'] as num?)?.toDouble() ?? 0.0;
    endShift = (map['endShift'] as num?)?.toDouble() ?? 0.0;
    sequences = ((map["sequences"] as Map?) ?? {}).map((key, value) {
      return MapEntry(key as String, MultiAnimationSequence.fromJson(value));
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
    for (final MultiAnimationSequence sequence in sequences.values) {
      for (final double time in sequence.getAllTimeStamps()) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      }
    }
    timeStamps.sort();
    return timeStamps;
  }

  void rescaleTime(Duration maxDuration) {
    for (final MultiAnimationSequence sequence in sequences.values) {
      sequence.rescaleTime(maxDuration);
    }
  }
}

/// The progress of a scroll animation, clamped to between 0 and 1.
class ContinuousAnimationProgressNotifier extends ValueNotifier<double> {
  ContinuousAnimationProgressNotifier(super.value);

  @override
  set value(double newValue) {
    super.value = newValue.clamp(0.0, 1.0);
  }
}
