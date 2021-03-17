import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:responsive_styled_widget/styled_widget.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tuple/tuple.dart';

import 'custom_visibility_detector/visibility_detector.dart';
import 'explicit_animations/animation_provider.dart';
import 'explicit_animations/animation_sequence.dart';
import 'explicit_animations/global_animation.dart';

class ParentScroll extends InheritedWidget {
  static of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentScroll>();

  final ScrollController controller;
  final Axis direction;

  ParentScroll({
    Key? key,
    required Widget child,
    required this.controller,
    required this.direction,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(ParentScroll oldWidget) {
    return this.controller != oldWidget.controller ||
        this.direction != oldWidget.direction;
  }
}

class ExplicitAnimatedStyledContainer extends StyledWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final VisibilityChangedCallback? onVisible;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final String? id;
  final Map<AnimationTrigger, MultiAnimationSequence> localAnimations;
  final Map<AnimationTrigger, String> globalAnimationIds;

  ExplicitAnimatedStyledContainer({
    Key? key,
    dynamic style,
    required this.child,
    this.id,
    this.onMouseEnter,
    this.onMouseExit,
    this.onTap,
    this.onVisible,
    this.localAnimations = const {},
    this.globalAnimationIds = const {},
  }) : super(
          key: key,
          style: style,
        );

  @override
  _ExplicitAnimatedStyledContainerState createState() =>
      _ExplicitAnimatedStyledContainerState();
}

class _ExplicitAnimatedStyledContainerState
    extends StyledWidgetState<ExplicitAnimatedStyledContainer> {
  bool onlyLocal = true;

  bool visibilityDetected = false;

  double beginOffset = 0.0;
  double currentOffset = 0.0;
  double endOffset = 1.0;
  double currentScrollOffset = 0.0;

  @override
  void initState() {
    onlyLocal = widget.id == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      prepareStyle();
      parentMaxWidth = constraints.maxWidth == double.infinity
          ? screenSize.width
          : constraints.maxWidth;
      parentMaxHeight = constraints.maxHeight == double.infinity
          ? screenSize.height
          : constraints.maxHeight;
      prepareProperties();

      return ChangeNotifierProvider<LocalAnimationNotifier>(
        create: (_) => LocalAnimationNotifier(),
        builder: (BuildContext context, Widget? child) {
          return VisibilityDetector(
              key: UniqueKey(),
              onVisibilityChanged: (VisibilityInfo visibilityInfo) {
                triggerScrollAnimation(context, visibilityInfo);
                triggerVisibilityChangeAnimation(context, visibilityInfo);
                if (widget.onVisible != null) {
                  widget.onVisible!(visibilityInfo);
                }
              },
              child: GestureDetector(
                onTap: () {
                  triggerTapAnimation(context);
                  if (widget.onTap != null) {
                    widget.onTap!();
                  }
                },
                child: buildGlobalContinuousAnimationWidget(
                    child: buildLocalContinuousAnimationWidget(
                        child: buildGlobalAnimationWidget(
                            child: buildLocalAnimationWidget(
                                child: buildStyledContainerWithMouseEvent(
                                    context))))),
              ));
        },
        child: widget.child,
      );
    });
  }

  Widget buildStyledContainerWithMouseEvent(BuildContext context) {
    return buildStyledContainer(
        child: widget.child,
        onMouseEnter: (PointerEnterEvent event) {
          triggerMouseEnterAnimation(context);
          if (widget.onMouseEnter != null) {
            widget.onMouseEnter!(event);
          }
        },
        onMouseExit: (PointerExitEvent event) {
          triggerMouseExitAnimation(context);
          if (widget.onMouseExit != null) {
            widget.onMouseExit!(event);
          }
        });
  }

  void triggerTapAnimation(BuildContext context) {
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.tap)) {
      String animationId = widget.globalAnimationIds[AnimationTrigger.tap]!;
      CustomAnimationControl? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.tap]!,
              control ?? CustomAnimationControl.PLAY);
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.tap)) {
      Provider.of<LocalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(widget.localAnimations[AnimationTrigger.tap]!,
              widget.localAnimations[AnimationTrigger.tap]!.control);
    }
  }

  void triggerMouseEnterAnimation(BuildContext context) {
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.mouseEnter)) {
      String animationId =
          widget.globalAnimationIds[AnimationTrigger.mouseEnter]!;
      CustomAnimationControl? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.mouseEnter]!,
              control ?? CustomAnimationControl.PLAY);
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.mouseEnter)) {
      Provider.of<LocalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.localAnimations[AnimationTrigger.mouseEnter]!,
              widget.localAnimations[AnimationTrigger.mouseEnter]!.control);
    }
  }

  void triggerMouseExitAnimation(BuildContext context) {
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.mouseExit)) {
      String animationId =
          widget.globalAnimationIds[AnimationTrigger.mouseExit]!;
      CustomAnimationControl? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.mouseExit]!,
              control ?? CustomAnimationControl.PLAY);
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.mouseExit)) {
      Provider.of<LocalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.localAnimations[AnimationTrigger.mouseExit]!,
              widget.localAnimations[AnimationTrigger.mouseExit]!.control);
    }
  }

  void triggerVisibilityChangeAnimation(
      BuildContext context, VisibilityInfo visibilityInfo) {
    if (mounted) {
      if (widget.globalAnimationIds.containsKey(AnimationTrigger.visible)) {
        String animationId =
            widget.globalAnimationIds[AnimationTrigger.visible]!;
        CustomAnimationControl? control =
            Provider.of<GlobalAnimationNotifier>(context, listen: false)
                .animationPool[animationId]
                ?.control;

        Provider.of<GlobalAnimationNotifier>(context, listen: false)
            .updateAnimationStatus(
                widget.globalAnimationIds[AnimationTrigger.visible]!,
                control ?? CustomAnimationControl.PLAY);
      }
      if (widget.localAnimations.containsKey(AnimationTrigger.visible)) {
        Provider.of<LocalAnimationNotifier>(context, listen: false)
            .updateAnimationStatus(
                widget.localAnimations[AnimationTrigger.visible]!,
                widget.localAnimations[AnimationTrigger.visible]!.control);
      }
    }
  }

  void triggerScrollAnimation(
      BuildContext context, VisibilityInfo visibilityInfo) {
    if (!mounted || ParentScroll.of(context) == null) return;
    String globalScrollAnimationName = "";
    void Function() globalScrollProgressCallBack = () {};
    void Function() localScrollProgressCallBack = () {};
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
      globalScrollAnimationName =
          widget.globalAnimationIds[AnimationTrigger.scroll]!;
      globalScrollProgressCallBack = () {
        if (mounted) {
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationProgressNotifiers[globalScrollAnimationName]
              ?.value = (endOffset -
                  (currentOffset -
                      ParentScroll.of(context).controller.offset +
                      currentScrollOffset)) /
              (endOffset - beginOffset);
        }
      };
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.scroll)) {
      localScrollProgressCallBack = () {
        if (mounted) {
          Provider.of<LocalAnimationNotifier>(context, listen: false)
              .animationProgressNotifier
              ?.value = (endOffset -
                  (currentOffset -
                      ParentScroll.of(context).controller.offset +
                      currentScrollOffset)) /
              (endOffset - beginOffset);
        }
      };
    }

    if (mounted) {
      if (!visibilityDetected) {
        double beginShift = 0.0, endShift = 0.0;
        if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
          String animationId =
              widget.globalAnimationIds[AnimationTrigger.scroll]!;
          beginShift =
              Provider.of<GlobalAnimationNotifier>(context, listen: false)
                      .animationPool[animationId]
                      ?.beginShift ??
                  0.0;
          endShift =
              Provider.of<GlobalAnimationNotifier>(context, listen: false)
                      .animationPool[animationId]
                      ?.endShift ??
                  0.0;
        }
        if (widget.localAnimations.containsKey(AnimationTrigger.scroll)) {
          beginShift =
              widget.localAnimations[AnimationTrigger.scroll]?.beginShift ??
                  0.0;
          endShift =
              widget.localAnimations[AnimationTrigger.scroll]?.endShift ?? 0.0;
        }

        if (ParentScroll.of(context).direction == Axis.vertical) {
          setState(() {
            beginOffset = 0.0 + beginShift * visibilityInfo.widgetBounds.height;
            endOffset = MediaQuery.of(context).size.height +
                endShift * visibilityInfo.widgetBounds.height;
            currentOffset = visibilityInfo.widgetBounds.top;
            currentScrollOffset = ParentScroll.of(context).controller.offset;
          });
        } else {
          setState(() {
            beginOffset = 0.0 + beginShift * visibilityInfo.widgetBounds.width;
            endOffset = MediaQuery.of(context).size.width +
                endShift * visibilityInfo.widgetBounds.width;

            currentOffset = visibilityInfo.widgetBounds.left;
            currentScrollOffset = ParentScroll.of(context).controller.offset;
          });
        }

        if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
                  .animationProgressNotifiers[globalScrollAnimationName] =
              ContinuousAnimationProgressNotifier(
                  (endOffset - currentOffset) / (endOffset - beginOffset));
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .updateContinuousAnimationStatus(globalScrollAnimationName, true);
          (ParentScroll.of(context).controller)
              ?.addListener(globalScrollProgressCallBack);
        }
        if (widget.localAnimations.containsKey(AnimationTrigger.scroll)) {
          Provider.of<LocalAnimationNotifier>(context, listen: false)
                  .animationProgressNotifier =
              ContinuousAnimationProgressNotifier(
                  (endOffset - currentOffset) / (endOffset - beginOffset));
          Provider.of<LocalAnimationNotifier>(context, listen: false)
              .updateContinuousAnimationStatus(
                  widget.localAnimations[AnimationTrigger.scroll], true);
          (ParentScroll.of(context).controller)
              ?.addListener(localScrollProgressCallBack);
        }
        setState(() {
          visibilityDetected = true;
        });
      }
    } else {
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .animationProgressNotifiers
          .remove(globalScrollAnimationName);
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateContinuousAnimationStatus(
              widget.globalAnimationIds[globalScrollAnimationName]!, false);
      (ParentScroll.of(context).controller)
          ?.removeListener(globalScrollProgressCallBack);

      Provider.of<LocalAnimationNotifier>(context, listen: false)
          .animationProgressNotifier = null;
      Provider.of<LocalAnimationNotifier>(context, listen: false)
          .updateContinuousAnimationStatus(null, false);
      (ParentScroll.of(context).controller)
          ?.removeListener(localScrollProgressCallBack);
      setState(() {
        visibilityDetected = false;
      });
    }
  }

  MultiTween<AnimationProperty> getMultiTweenFromAnimationSequences(
      MultiAnimationSequence sequences) {
    return sequences.getAnimationTween(
        initialValues: {
          AnimationProperty.opacity: opacity,
          AnimationProperty.alignment: alignment,
          AnimationProperty.width: width,
          AnimationProperty.height: height,
          AnimationProperty.margin: margin,
          AnimationProperty.padding: padding,
          AnimationProperty.backgroundDecoration: backgroundDecoration,
          AnimationProperty.shadows: shadows,
          AnimationProperty.insetShadows: insetShadows,
          AnimationProperty.shapeBorder: shapeBorder,
          AnimationProperty.transform: transform,
          AnimationProperty.transformAlignment: transformAlignment,
          AnimationProperty.childAlignment: childAlignment,
          AnimationProperty.textStyle: textStyle,
        },
        constraintSize: Size(parentMaxWidth, parentMaxHeight),
        screenSize: MediaQuery.of(context).size,
        parentFontSize: DefaultTextStyle.of(context).style.fontSize ?? 14.0);
  }

  Widget buildGlobalAnimationWidget({required Widget child}) {
    if (!onlyLocal) {
      return Selector<GlobalAnimationNotifier,
              Tuple2<CustomAnimationControl?, MultiAnimationSequence?>>(
          selector: (_, notifier) => Tuple2(
              notifier.currentAnimationsControl[widget.id],
              notifier.currentAnimations[widget.id]),
          child: child,
          builder: (context, tuple, child) {
            CustomAnimationControl? control = tuple.item1;
            MultiAnimationSequence? sequences = tuple.item2;
            if (control == null || sequences == null) {
              return child!;
            }

            var multiTween = getMultiTweenFromAnimationSequences(sequences);

            return buildCustomAnimation(
                multiTween: multiTween, control: control, child: child!);
          });
    } else {
      return child;
    }
  }

  Widget buildLocalAnimationWidget({required Widget child}) {
    return Selector<LocalAnimationNotifier,
            Tuple2<CustomAnimationControl?, MultiAnimationSequence?>>(
        selector: (_, notifier) =>
            Tuple2(notifier.currentAnimationControl, notifier.currentAnimation),
        child: child,
        builder: (context, tuple, child) {
          CustomAnimationControl? control = tuple.item1;
          MultiAnimationSequence? sequences = tuple.item2;
          if (control == null || sequences == null) {
            return child!;
          }

          var multiTween = getMultiTweenFromAnimationSequences(sequences);

          return buildCustomAnimation(
              multiTween: multiTween, control: control, child: child!);
        });
  }

  Widget buildGlobalContinuousAnimationWidget({required Widget child}) {
    if (!onlyLocal) {
      return Selector<GlobalAnimationNotifier, MultiAnimationSequence?>(
          selector: (_, notifier) =>
              notifier.currentContinuousAnimations[widget.id],
          child: child,
          builder: (context, sequences, child) {
            if (sequences == null) {
              return child!;
            }

            MultiTween<AnimationProperty> multiTween =
                getMultiTweenFromAnimationSequences(sequences);

            return buildCustomContinuousAnimation(
                isGlobal: true, multiTween: multiTween, child: child!);
          });
    } else {
      return child;
    }
  }

  Widget buildLocalContinuousAnimationWidget({required Widget child}) {
    return Selector<LocalAnimationNotifier, MultiAnimationSequence?>(
        selector: (_, notifier) => notifier.currentContinuousAnimation,
        child: child,
        builder: (context, sequences, child) {
          if (sequences == null) {
            return child!;
          }

          MultiTween<AnimationProperty> multiTween =
              getMultiTweenFromAnimationSequences(sequences);

          return buildCustomContinuousAnimation(
              isGlobal: false, multiTween: multiTween, child: child!);
        });
  }

  Widget buildCustomAnimation(
      { //required Duration delay,
      var multiTween,
      required CustomAnimationControl control,
      required Widget child}) {
    return CustomAnimation<MultiTweenValues<AnimationProperty>>(
      key: UniqueKey(),
      control: control, // <
      duration: multiTween.duration, // -- bind state variable to parameter
      tween: multiTween,
      builder: animatedWidgetBuilder,
      child: child,
    );
  }

  //TODO: currently only use scrollcontrollers
  Widget buildCustomContinuousAnimation(
      {required MultiTween<AnimationProperty> multiTween,
      required bool isGlobal,
      required Widget child}) {
    return Builder(builder: (BuildContext context) {
      ContinuousAnimationProgressNotifier progressNotifier;
      if (isGlobal) {
        String? currentContinuousAnimationName =
            Provider.of<GlobalAnimationNotifier>(context, listen: false)
                .currentContinuousAnimationNames[widget.id];

        progressNotifier =
            Provider.of<GlobalAnimationNotifier>(context, listen: false)
                .animationProgressNotifiers[currentContinuousAnimationName]!;
      } else {
        progressNotifier =
            Provider.of<LocalAnimationNotifier>(context, listen: false)
                .animationProgressNotifier!;
      }

      return AnimatedBuilder(
        animation: progressNotifier,
        child: child,
        builder: (BuildContext context, Widget? child) {
          MultiTweenValues<AnimationProperty> values =
              multiTween.transform(progressNotifier.value.clamp(0.0, 1.0));
          return animatedWidgetBuilder(context, child!, values);
        },
      );
    });
  }

  Widget animatedWidgetBuilder(BuildContext context, Widget? child,
      MultiTweenValues<AnimationProperty> values) {
    opacity = values.getOrElse(AnimationProperty.opacity, opacity);
    alignment = values.getOrElse(AnimationProperty.alignment, alignment);
    width = values.getOrElse(AnimationProperty.width, width);
    height = values.getOrElse(AnimationProperty.height, height);
    margin = values.getOrElse(AnimationProperty.margin, margin);
    padding = values.getOrElse(AnimationProperty.padding, padding);
    backgroundDecoration = values.getOrElse(
        AnimationProperty.backgroundDecoration, backgroundDecoration);
    shadows = values.getOrElse(AnimationProperty.shadows, shadows);
    insetShadows =
        values.getOrElse(AnimationProperty.insetShadows, insetShadows);
    shapeBorder = values.getOrElse(AnimationProperty.shapeBorder, shapeBorder);

    transform = values.getOrElse(AnimationProperty.transform, transform);
    transformAlignment = values.getOrElse(
        AnimationProperty.transformAlignment, transformAlignment);
    childAlignment =
        values.getOrElse(AnimationProperty.childAlignment, childAlignment);
    textStyle = values.getOrElse(AnimationProperty.textStyle, textStyle);

    return buildStyledContainerWithMouseEvent(context);
  }
}
