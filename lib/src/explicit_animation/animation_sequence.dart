import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:simple_animations/simple_animations.dart';

extension Typing<T> on List<T> {
  /// Provide access to the generic type at runtime.
  Type get genericType => T;
}

enum AnimationTrigger {
  mouseEnter,
  mouseExit,
  tap,
  visible,
  scroll,
}

enum AnimationProperty {
  opacity,

  alignment,

  width,
  height,

  margin,
  padding,

  backgroundDecoration,
  foregroundDecoration,
  shadows,
  insetShadows,
  shapeBorder,

  transform,
  transformAlignment,

  childAlignment,
  textStyle,
}

const Map<AnimationProperty, Type> animationPropertyTypeMap = {
  AnimationProperty.opacity: double,
  AnimationProperty.alignment: Alignment,
  AnimationProperty.width: Dimension,
  AnimationProperty.height: Dimension,
  AnimationProperty.margin: EdgeInsets,
  AnimationProperty.padding: EdgeInsets,
  AnimationProperty.backgroundDecoration: BoxDecoration,
  AnimationProperty.foregroundDecoration: BoxDecoration,
  AnimationProperty.shadows: List,
  AnimationProperty.insetShadows: List,
  AnimationProperty.shapeBorder: MorphableShapeBorder,
  AnimationProperty.transform: SmoothMatrix4,
  AnimationProperty.transformAlignment: Alignment,
  AnimationProperty.childAlignment: Alignment,
  AnimationProperty.textStyle: DynamicTextStyle,
};

Map<AnimationProperty, dynamic> animationPropertyDefaultInitMap = {
  AnimationProperty.opacity: 1.0,
  AnimationProperty.alignment: Alignment.center,
  AnimationProperty.width: 100.0,
  AnimationProperty.height: 100.0,
  AnimationProperty.margin: EdgeInsets.zero,
  AnimationProperty.padding: EdgeInsets.zero,
  AnimationProperty.backgroundDecoration: BoxDecoration(),
  AnimationProperty.foregroundDecoration: BoxDecoration(),
  AnimationProperty.shadows: <ShapeShadow>[],
  AnimationProperty.insetShadows: <ShapeShadow>[],
  AnimationProperty.shapeBorder: RectangleShapeBorder(),
  AnimationProperty.transform: Matrix4.identity(),
  AnimationProperty.transformAlignment: Alignment.center,
  AnimationProperty.childAlignment: Alignment.center,
  AnimationProperty.textStyle: TextStyle(),
};

class AnimationData<T> {
  late Duration duration;
  late Duration delay;
  late Curve curve;
  late T value;

  AnimationData(
      {this.duration = const Duration(seconds: 1),
      this.delay = const Duration(seconds: 0),
      this.curve = Curves.linear,
      required this.value});

  AnimationData.fromJson(Map<String, dynamic> map) {
    value = parse(map["value"]);
    duration = Duration(milliseconds: map["duration"]);
    delay = Duration(milliseconds: map["delay"]);
    curve = parseCurve(map["curve"]) ?? Curves.linear;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["duration"] = duration.inMilliseconds;
    rst["delay"] = delay.inMilliseconds;
    rst["curve"] = curve.toJson();
    rst["value"] = convert(value);
    return rst;
  }

  dynamic convert(dynamic value) {
    if (T == double) {
      return value;
    }
    if (T == Dimension) {
      return (value as Dimension).toJson();
    }
    if (T == Color) {
      return (value as Color).toJson();
    }
    if (T == Gradient) {
      return (value as Gradient).toJson();
    }
    if (T == BoxDecoration) {
      return (value as BoxDecoration).toJson();
    }
    if (T == EdgeInsets) {
      return (value as EdgeInsets).toJson();
    }
    if (T == Alignment) {
      return (value as Alignment).toJson();
    }
    if (T == MorphableShapeBorder) {
      return (value as MorphableShapeBorder).toJson();
    }
    if (T == SmoothMatrix4) {
      return (value as SmoothMatrix4).toJson();
    }
    if (T == DynamicTextStyle) {
      return (value as DynamicTextStyle).toJson();
    }
    if (T == List) {
      if ((T as List).genericType == ShapeShadow) {
        return (value as List<ShapeShadow>).map((e) => e.toJson()).toList();
      }
    }
  }

  dynamic parse(dynamic value) {
    if (T == double) {
      return value;
    }
    if (T == Dimension) {
      return parseDimension(value);
    }
    if (T == Color) {
      return parseColor(value);
    }
    if (T == Gradient) {
      return parseGradient(value);
    }
    if (T == Alignment) {
      return parseAlignment(value);
    }
    if (T == EdgeInsets) {
      return parseEdgeInsets(value);
    }
    if (T == BoxDecoration) {
      return parseBoxDecoration(value);
    }

    if (T == MorphableShapeBorder) {
      return parseMorphableShapeBorder(value);
    }
    if (T == SmoothMatrix4) {
      return parseSmoothMatrix4(value);
    }
    if (T == DynamicTextStyle) {
      return parseDynamicTextStyle(value);
    }
    if (T == List) {
      if ((T as List).genericType == ShapeShadow) {
        return (value as List).map((e) => parseShapeShadow(e)).toList();
      }
    }
  }
}

class AnimationSequence<T> {
  late List<AnimationData<T>> data = [];

  AnimationSequence({List<AnimationData<T>>? data}) {
    if (data != null) {
      this.data = data;
    } else {
      this.data = [];
    }
  }

  AnimationSequence.fromJson(Map map) {
    data =
        (map["data"] as List).map((e) => AnimationData<T>.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["data"] = data.map((e) => e.toJson()).toList();
    return rst;
  }

  void add(
      {Duration duration = const Duration(seconds: 1),
      Duration delay = const Duration(seconds: 0),
      Curve curve = Curves.linear,
      required T value}) {
    data.add(AnimationData<T>(
        duration: duration, delay: delay, curve: curve, value: value));
  }

  double getMaxValue({double initialValue = -double.infinity}) {
    double max = initialValue;
    if (T == double) {
      data.forEach((element) {
        if ((element.value as double) > max) {
          max = element.value as double;
        }
      });
    }
    return max;
  }

  double getMinValue({double initialValue = double.infinity}) {
    double min = initialValue;
    if (T == double) {
      data.forEach((element) {
        if ((element.value as double) < min) {
          min = element.value as double;
        }
      });
    }
    return min;
  }

  List<double> getAllTimeStamps() {
    double time = 0.0;
    List<double> timeStamps = [time];
    data.forEach((data) {
      time += data.delay.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
      time += data.duration.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
    });
    timeStamps.sort();
    return timeStamps;
  }
}

class MultiAnimationSequence {
  late Map<AnimationProperty, AnimationSequence> sequences = {};
  CustomAnimationControl control = CustomAnimationControl.PLAY;
  double beginShift = 0.0;
  double endShift = 0.0;

  MultiAnimationSequence(
      {required this.sequences,
      this.beginShift = 0.0,
      this.endShift = 0.0,
      this.control = CustomAnimationControl.PLAY});

  MultiAnimationSequence.fromJson(Map map) {
    control = parseCustomAnimationControl(map["control"]) ??
        CustomAnimationControl.PLAY;
    beginShift = map['beginShift'];
    endShift = map['endShift'];
    sequences = (map["sequences"] as Map).map((key, value) {
      AnimationProperty property = parseAnimationProperty(key);
      switch (property) {
        case AnimationProperty.opacity:
          return MapEntry(property, AnimationSequence<double>.fromJson(value));
        case AnimationProperty.alignment:
        case AnimationProperty.transformAlignment:
        case AnimationProperty.childAlignment:
          return MapEntry(
              property, AnimationSequence<Alignment>.fromJson(value));
        case AnimationProperty.width:
        case AnimationProperty.height:
          return MapEntry(
              property, AnimationSequence<Dimension>.fromJson(value));
        case AnimationProperty.margin:
        case AnimationProperty.padding:
          return MapEntry(
              property, AnimationSequence<EdgeInsets>.fromJson(value));
        case AnimationProperty.backgroundDecoration:
        case AnimationProperty.foregroundDecoration:
          return MapEntry(
              property, AnimationSequence<BoxDecoration>.fromJson(value));
        case AnimationProperty.shadows:
        case AnimationProperty.insetShadows:
          return MapEntry(
              property, AnimationSequence<List<ShapeShadow>>.fromJson(value));
        case AnimationProperty.shapeBorder:
          return MapEntry(property,
              AnimationSequence<MorphableShapeBorder>.fromJson(value));
        case AnimationProperty.transform:
          return MapEntry(
              property, AnimationSequence<SmoothMatrix4>.fromJson(value));
        case AnimationProperty.textStyle:
          return MapEntry(
              property, AnimationSequence<DynamicTextStyle>.fromJson(value));
      }
    });
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst['beginShift'] = beginShift;
    rst['endShift'] = endShift;
    rst["control"] = control.toJson();
    rst["sequences"] =
        sequences.map((key, value) => MapEntry(key.toJson(), value.toJson()));

    return rst;
  }

  void merge(MultiAnimationSequence secondSequence) {
    sequences.addAll(secondSequence.sequences);
  }

  void extend(MultiAnimationSequence secondSequence) {
    double currentMaxTime = 0;
    sequences.forEach((key, value) {
      double maxTime = value.getAllTimeStamps().last;
      if (maxTime > currentMaxTime) {
        currentMaxTime = maxTime;
      }
    });

    secondSequence.sequences.forEach((key, value) {
      if (!sequences.containsKey(key)) {
        switch (key) {
          case AnimationProperty.opacity:
            sequences[key] = AnimationSequence<double>();
            break;
          case AnimationProperty.alignment:
          case AnimationProperty.transformAlignment:
          case AnimationProperty.childAlignment:
            sequences[key] = AnimationSequence<Alignment>();
            break;
          case AnimationProperty.width:
          case AnimationProperty.height:
            sequences[key] = AnimationSequence<Dimension>();
            break;
          case AnimationProperty.margin:
          case AnimationProperty.padding:
            sequences[key] = AnimationSequence<EdgeInsets>();
            break;
          case AnimationProperty.backgroundDecoration:
          case AnimationProperty.foregroundDecoration:
            sequences[key] = AnimationSequence<BoxDecoration>();
            break;
          case AnimationProperty.shadows:
          case AnimationProperty.insetShadows:
            sequences[key] = AnimationSequence<List<ShapeShadow>>();
            break;
          case AnimationProperty.shapeBorder:
            sequences[key] = AnimationSequence<MorphableShapeBorder>();
            break;
          case AnimationProperty.transform:
            sequences[key] = AnimationSequence<SmoothMatrix4>();
            break;
          case AnimationProperty.textStyle:
            sequences[key] = AnimationSequence<DynamicTextStyle>();
            break;
        }
      }

      double lastTime = (sequences[key]?.getAllTimeStamps().last) ?? 0.0;
      value.data[0].delay +=
          Duration(milliseconds: (currentMaxTime - lastTime).round());
      sequences[key]?.data.addAll(value.data);
    });
  }

  MultiTween<AnimationProperty> getAnimationTween(
      {required Map<AnimationProperty, dynamic> initialValues,
      required double parentFontSize,
      required Size screenSize}) {
    MultiTween<AnimationProperty> multiTween = MultiTween<AnimationProperty>();
    sequences.forEach((property, animationSequence) {
      var animations = animationSequence.data;
      dynamic begin, end;
      begin =
          initialValues[property] ?? animationPropertyDefaultInitMap[property];
      for (int index = 0; index < animations.length; index++) {
        Tween delayTween;
        Tween tween;
        switch (property) {
          case AnimationProperty.opacity:
            end = animations[index].value;
            delayTween = Tween(begin: begin, end: begin);
            tween = Tween(begin: begin, end: end);
            break;
          case AnimationProperty.alignment:
          case AnimationProperty.transformAlignment:
          case AnimationProperty.childAlignment:
            end = animations[index].value;
            delayTween = AlignmentTween(begin: begin, end: begin);
            tween = AlignmentTween(begin: begin, end: end);
            break;
          case AnimationProperty.width:
          case AnimationProperty.height:
            end = (animations[index].value as Dimension);
            delayTween = DimensionTween(begin: begin, end: begin);
            tween = DimensionTween(begin: begin, end: end);
            break;
          case AnimationProperty.margin:
          case AnimationProperty.padding:
            end = (animations[index].value as EdgeInsets);
            delayTween = EdgeInsetsTween(begin: begin, end: begin);
            tween = EdgeInsetsTween(begin: begin, end: end);
            break;
          case AnimationProperty.backgroundDecoration:
          case AnimationProperty.foregroundDecoration:
            end = animations[index].value;
            delayTween = DecorationTween(begin: begin, end: begin);
            tween = DecorationTween(begin: begin, end: end);
            break;
          case AnimationProperty.shadows:
          case AnimationProperty.insetShadows:
            end = (animations[index].value as List).cast<ShapeShadow>();
            delayTween = ListShapeShadowTween(begin: begin, end: begin);
            tween = ListShapeShadowTween(begin: begin, end: end);
            break;
          case AnimationProperty.shapeBorder:
            end = animations[index].value;
            delayTween = MorphableShapeBorderTween(begin: begin, end: begin);
            tween = MorphableShapeBorderTween(begin: begin, end: end);
            break;
          case AnimationProperty.transform:
            end = animations[index].value.toMatrix4(screenSize: screenSize);
            delayTween = Matrix4Tween(begin: begin, end: begin);
            tween = Matrix4Tween(begin: begin, end: end);
            break;
          case AnimationProperty.textStyle:
            end = (animations[index].value as DynamicTextStyle).toTextStyle(
                parentFontSize: parentFontSize, screenSize: screenSize);
            delayTween = TextStyleTween(begin: begin, end: begin);
            tween = TextStyleTween(begin: begin, end: end);
            break;
        }
        if (animations[index].delay.inMilliseconds > 0) {
          multiTween.add(property, delayTween, animations[index].delay);
        }
        multiTween.add(property, tween, animations[index].duration,
            animations[index].curve);
        begin = end;
      }
    });
    return multiTween;
  }

  List<double> getAllTimeStamps() {
    List<double> timeStamps = [];
    sequences.forEach((property, sequence) {
      sequence.getAllTimeStamps().forEach((time) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      });
    });
    timeStamps.sort();
    return timeStamps;
  }

  void addDelay(Duration delay) {
    sequences.forEach((property, sequence) {
      sequence.data.first.delay += delay;
    });
  }

  void rescaleTime(Duration maxDuration) {
    double currentMaxTime = getAllTimeStamps().last;
    sequences.forEach((property, sequence) {
      sequence.data.forEach((data) {
        data.delay = Duration(
            milliseconds: (data.delay.inMilliseconds /
                    currentMaxTime *
                    maxDuration.inMilliseconds)
                .round());
        data.duration = Duration(
            milliseconds: (data.duration.inMilliseconds /
                    currentMaxTime *
                    maxDuration.inMilliseconds)
                .round());
      });
    });
  }
}
