import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
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

/// The values used by [MultiAnimationSequence.getAnimationTween] for the
/// properties that are missing in its initial values.
Map<AnimationProperty, dynamic> animationPropertyDefaultInitMap = {
  AnimationProperty.opacity: 1.0,
  AnimationProperty.alignment: Alignment.center,
  AnimationProperty.width: null,
  AnimationProperty.height: null,
  AnimationProperty.margin: EdgeInsets.zero,
  AnimationProperty.padding: EdgeInsets.zero,
  AnimationProperty.backgroundDecoration: const BoxDecoration(),
  AnimationProperty.foregroundDecoration: const BoxDecoration(),
  AnimationProperty.shadows: <ShapeShadow>[],
  AnimationProperty.insetShadows: <ShapeShadow>[],
  AnimationProperty.shapeBorder: const RectangleShapeBorder(),
  AnimationProperty.transform: Matrix4.identity(),
  AnimationProperty.transformAlignment: Alignment.center,
  AnimationProperty.childAlignment: Alignment.center,
  AnimationProperty.textStyle: const TextStyle(),
};

typedef _ShapeShadowList = List<ShapeShadow>;
typedef _ShadowList = List<Shadow>;

/// The duration used for steps without a duration, so that the animation
/// never has to be evaluated in the middle of a step without a length.
const Duration _kMinStepDuration = Duration(microseconds: 1);

/// A step of an [AnimationSequence]: wait for [delay], then animate to
/// [value] in [duration] using [curve].
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

  /// Parses the output of [toJson]. A missing duration is one second, a
  /// missing delay zero and a missing curve [Curves.linear].
  AnimationData.fromJson(Map<String, dynamic> map) {
    value = parse(map["value"]);
    duration =
        Duration(milliseconds: (map["duration"] as num?)?.round() ?? 1000);
    delay = Duration(milliseconds: (map["delay"] as num?)?.round() ?? 0);
    curve = parseCurve(map["curve"]) ?? Curves.linear;
  }

  AnimationData<T> _copy() {
    return AnimationData<T>(
        duration: duration, delay: delay, curve: curve, value: value);
  }

  static bool _isShadowList(Type type) =>
      type == _ShapeShadowList || type == _ShadowList;

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
    if (_isShadowList(T)) {
      return (value as List)
          .map((e) => e is ShapeShadow
              ? e.toJson()
              : ShapeShadow(
                      color: (e as Shadow).color,
                      offset: e.offset,
                      blurRadius: e.blurRadius)
                  .toJson())
          .toList();
    }
    return null;
  }

  dynamic parse(dynamic value) {
    if (T == double) {
      return (value as num?)?.toDouble();
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
    if (_isShadowList(T)) {
      return (value as List?)
              ?.map((e) => parseShapeShadow(e))
              .whereType<ShapeShadow>()
              .toList() ??
          <ShapeShadow>[];
    }
    return null;
  }
}

/// The steps of the animation of one [AnimationProperty], played one after
/// another.
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
    data = (map["data"] as List?)
            ?.map((e) => AnimationData<T>.fromJson(e))
            .toList() ??
        [];
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
      for (final AnimationData<T> element in data) {
        if ((element.value as double) > max) {
          max = element.value as double;
        }
      }
    }
    return max;
  }

  double getMinValue({double initialValue = double.infinity}) {
    double min = initialValue;
    if (T == double) {
      for (final AnimationData<T> element in data) {
        if ((element.value as double) < min) {
          min = element.value as double;
        }
      }
    }
    return min;
  }

  /// The begin and end times of the steps in milliseconds, sorted.
  List<double> getAllTimeStamps() {
    double time = 0.0;
    List<double> timeStamps = [time];
    for (final AnimationData<T> step in data) {
      time += step.delay.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
      time += step.duration.inMilliseconds;
      if (!timeStamps.contains(time)) {
        timeStamps.add(time);
      }
    }
    timeStamps.sort();
    return timeStamps;
  }

  AnimationSequence<T> _emptyCopy() => AnimationSequence<T>();
}

/// The animations of several [AnimationProperty]s, played at the same time.
class MultiAnimationSequence {
  late Map<AnimationProperty, AnimationSequence> sequences = {};
  Control control = Control.play;
  double beginShift = 0.0;
  double endShift = 0.0;

  MultiAnimationSequence(
      {required this.sequences,
      this.beginShift = 0.0,
      this.endShift = 0.0,
      this.control = Control.play});

  /// Parses the output of [toJson], missing values use the defaults of the
  /// constructor.
  MultiAnimationSequence.fromJson(Map map) {
    control = parseCustomAnimationControl(map["control"]) ?? Control.play;
    beginShift = (map['beginShift'] as num?)?.toDouble() ?? 0.0;
    endShift = (map['endShift'] as num?)?.toDouble() ?? 0.0;
    sequences = ((map["sequences"] as Map?) ?? {}).map((key, value) {
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

  /// Adds the sequences of [secondSequence] after the end of the sequences of
  /// this animation, so that they play after this animation.
  ///
  /// [secondSequence] is not modified.
  void extend(MultiAnimationSequence secondSequence) {
    double currentMaxTime = 0;
    sequences.forEach((key, value) {
      double maxTime = value.getAllTimeStamps().last;
      if (maxTime > currentMaxTime) {
        currentMaxTime = maxTime;
      }
    });

    secondSequence.sequences.forEach((key, value) {
      if (value.data.isEmpty) return;
      final AnimationSequence sequence =
          sequences.putIfAbsent(key, () => value._emptyCopy());
      final double lastTime = sequence.getAllTimeStamps().last;
      for (int i = 0; i < value.data.length; i++) {
        final AnimationData step = value.data[i]._copy();
        if (i == 0) {
          step.delay +=
              Duration(milliseconds: (currentMaxTime - lastTime).round());
        }
        sequence.data.add(step);
      }
    });
  }

  /// The tween of the animation, starting from [initialValues] (or
  /// [animationPropertyDefaultInitMap] for missing values).
  ///
  /// The steps of each sequence are played one after another, properties
  /// without a sequence keep their initial value. Does not modify the
  /// sequences.
  MovieTween getAnimationTween(
      {required Map<AnimationProperty, dynamic> initialValues,
      required double parentFontSize,
      required Size screenSize}) {
    MovieTween multiTween = MovieTween();
    MovieScene startScene = multiTween.scene(
        begin: Duration.zero, duration: const Duration(microseconds: 1));

    final Map<AnimationProperty, List<AnimationData>> propertySteps = {
      for (final MapEntry<AnimationProperty, AnimationSequence> entry
          in sequences.entries)
        entry.key: entry.value.data,
      for (final AnimationProperty property in animationPropertyTypeMap.keys)
        if (!sequences.containsKey(property)) property: const [],
    };

    propertySteps.forEach((property, data) {
      dynamic begin, end;
      begin =
          initialValues[property] ?? animationPropertyDefaultInitMap[property];
      final List<AnimationData> animations = data.isNotEmpty
          ? data
          : [AnimationData(value: begin, duration: Duration.zero)];
      MovieScene scene = startScene;
      for (final AnimationData animation in animations) {
        Animatable tween;
        switch (property) {
          case AnimationProperty.opacity:
            end = animation.value;
            tween = Tween(begin: begin, end: end);
            break;
          case AnimationProperty.alignment:
          case AnimationProperty.transformAlignment:
          case AnimationProperty.childAlignment:
            end = animation.value;

            tween = AlignmentTween(begin: begin, end: end);
            break;
          case AnimationProperty.width:
          case AnimationProperty.height:
            end = (animation.value as Dimension?);

            tween = DimensionTween(begin: begin, end: end);
            break;
          case AnimationProperty.margin:
          case AnimationProperty.padding:
            end = (animation.value as EdgeInsets?);

            tween = EdgeInsetsTween(begin: begin, end: end);
            break;
          case AnimationProperty.backgroundDecoration:
          case AnimationProperty.foregroundDecoration:
            end = animation.value;

            tween = DecorationTween(begin: begin, end: end);
            break;
          case AnimationProperty.shadows:
          case AnimationProperty.insetShadows:
            end = (animation.value as List).cast<ShapeShadow>();

            tween = ListShapeShadowTween(begin: begin, end: end);
            break;
          case AnimationProperty.shapeBorder:
            end = animation.value;

            tween = MorphableShapeBorderTween(begin: begin, end: end);
            break;
          case AnimationProperty.transform:
            if (animation.value is SmoothMatrix4) {
              end = (animation.value as SmoothMatrix4)
                  .toMatrix4(screenSize: screenSize);
            } else {
              end = animation.value;
            }

            tween = Matrix4Tween(begin: begin, end: end);
            break;
          case AnimationProperty.textStyle:
            if (animation.value is DynamicTextStyle) {
              end = (animation.value as DynamicTextStyle).toTextStyle(
                  parentFontSize: parentFontSize, screenSize: screenSize);
            } else {
              end = animation.value;
            }
            // TextStyles can only be interpolated if both inherit or not.
            if (begin is TextStyle &&
                end is TextStyle &&
                begin.inherit != end.inherit) {
              end = end.copyWith(inherit: begin.inherit);
            }

            tween = TextStyleTween(begin: begin, end: end);
            break;
        }
        // A step without duration and delay at the start is applied
        // immediately, also in the first frame of the animation.
        if (identical(animation, animations.first) &&
            animation.duration <= Duration.zero &&
            animation.delay <= Duration.zero) {
          tween = ConstantTween(end);
        }
        scene = scene.thenTween(property, tween,
            duration: animation.duration > Duration.zero
                ? animation.duration
                : _kMinStepDuration,
            delay: animation.delay,
            curve: animation.curve);
        begin = end;
      }
    });
    return multiTween;
  }

  /// The begin and end times of the steps of all sequences in milliseconds,
  /// sorted.
  List<double> getAllTimeStamps() {
    List<double> timeStamps = [];
    for (final AnimationSequence sequence in sequences.values) {
      for (final double time in sequence.getAllTimeStamps()) {
        if (!timeStamps.contains(time)) {
          timeStamps.add(time);
        }
      }
    }
    timeStamps.sort();
    return timeStamps;
  }

  /// Delays the start of every sequence by [delay].
  void addDelay(Duration delay) {
    for (final AnimationSequence sequence in sequences.values) {
      if (sequence.data.isNotEmpty) sequence.data.first.delay += delay;
    }
  }

  /// Scales the durations and delays so that the animation takes
  /// [maxDuration]. An animation without duration is not changed.
  void rescaleTime(Duration maxDuration) {
    final List<double> timeStamps = getAllTimeStamps();
    if (timeStamps.isEmpty || timeStamps.last <= 0) return;
    double currentMaxTime = timeStamps.last;
    sequences.forEach((property, sequence) {
      for (final AnimationData data in sequence.data) {
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
      }
    });
  }
}
