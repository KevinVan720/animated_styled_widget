import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:tuple/tuple.dart';

/// Provides the scroll controller and direction of the scroll view that
/// drives the [AnimationTrigger.scroll] animations below it.
class ParentScroll extends InheritedWidget {
  /// The closest [ParentScroll] ancestor, or null.
  // The return type is dynamic for compatibility.
  static dynamic of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentScroll>();

  final ScrollController controller;
  final Axis direction;

  const ParentScroll({
    super.key,
    required super.child,
    required this.controller,
    required this.direction,
  });

  @override
  bool updateShouldNotify(ParentScroll oldWidget) {
    return controller != oldWidget.controller ||
        direction != oldWidget.direction;
  }
}

/// A styled container that plays explicit animations when it is tapped,
/// hovered, becomes visible or is scrolled.
///
/// [localAnimations] are played by this widget only, [globalAnimationIds]
/// are ids of the animations of a [GlobalAnimationNotifier] ancestor, which
/// animate all the widgets of the animation (identified by their [id]).
class ExplicitAnimatedStyledContainer extends StyledWidget {
  final Widget child;
  final GestureTapCallback? onTap;
  final VisibilityChangedCallback? onVisible;
  final PointerEnterEventListener? onMouseEnter;
  final PointerExitEventListener? onMouseExit;
  final Map<AnimationTrigger, MultiAnimationSequence> localAnimations;
  final Map<AnimationTrigger, String> globalAnimationIds;

  const ExplicitAnimatedStyledContainer({
    super.key,
    required super.style,
    required this.child,
    super.id,
    this.onMouseEnter,
    this.onMouseExit,
    this.onTap,
    this.onVisible,
    this.localAnimations = const {},
    this.globalAnimationIds = const {},
  });

  @override
  StyledWidgetState<ExplicitAnimatedStyledContainer> createState() =>
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

  /// The scroll controller that [_scrollListeners] were added to.
  ScrollController? _scrollController;
  final List<VoidCallback> _scrollListeners = [];

  /// Whether the mouse is inside the container. The mouse region is rebuilt
  /// when an animation starts, which reports the mouse entering again.
  bool _mouseInside = false;

  @override
  void initState() {
    onlyLocal = widget.id == null;
    super.initState();
  }

  @override
  void didUpdateWidget(ExplicitAnimatedStyledContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    onlyLocal = widget.id == null;
  }

  @override
  void dispose() {
    _removeScrollListeners();
    super.dispose();
  }

  void _removeScrollListeners() {
    for (final VoidCallback listener in _scrollListeners) {
      _scrollController?.removeListener(listener);
    }
    _scrollListeners.clear();
    _scrollController = null;
  }

  void _addScrollListener(ScrollController controller, VoidCallback listener) {
    if (_scrollController != controller) _removeScrollListeners();
    _scrollController = controller;
    _scrollListeners.add(listener);
    controller.addListener(listener);
  }

  ParentScroll? _parentScroll(BuildContext context) => ParentScroll.of(context);

  @override
  Widget build(BuildContext context) {
    resolveStyle();
    resolveProperties();

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
  }

  Widget buildStyledContainerWithMouseEvent(BuildContext context) {
    // An invisible container has no mouse region, so it can't report the
    // mouse leaving.
    if (!visible) _mouseInside = false;
    return buildStyledContainer(
        child: widget.child,
        onMouseEnter: (PointerEnterEvent event) {
          if (_mouseInside) return;
          _mouseInside = true;
          triggerMouseEnterAnimation(context);
          if (widget.onMouseEnter != null) {
            widget.onMouseEnter!(event);
          }
        },
        onMouseExit: (PointerExitEvent event) {
          _mouseInside = false;
          triggerMouseExitAnimation(context);
          if (widget.onMouseExit != null) {
            widget.onMouseExit!(event);
          }
        });
  }

  void triggerTapAnimation(BuildContext context) {
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.tap)) {
      String animationId = widget.globalAnimationIds[AnimationTrigger.tap]!;
      Control? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.tap]!,
              control ?? Control.play);
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
      Control? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.mouseEnter]!,
              control ?? Control.play);
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
      Control? control =
          Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.control;
      Provider.of<GlobalAnimationNotifier>(context, listen: false)
          .updateAnimationStatus(
              widget.globalAnimationIds[AnimationTrigger.mouseExit]!,
              control ?? Control.play);
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
        Control? control =
            Provider.of<GlobalAnimationNotifier>(context, listen: false)
                .animationPool[animationId]
                ?.control;

        Provider.of<GlobalAnimationNotifier>(context, listen: false)
            .updateAnimationStatus(
                widget.globalAnimationIds[AnimationTrigger.visible]!,
                control ?? Control.play);
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
    final ParentScroll? parentScroll = mounted ? _parentScroll(context) : null;
    if (parentScroll == null || visibilityDetected) return;
    final ScrollController controller = parentScroll.controller;

    double progress() =>
        (endOffset -
            (currentOffset - controller.offset + currentScrollOffset)) /
        (endOffset - beginOffset);

    String globalScrollAnimationName = "";
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
      globalScrollAnimationName =
          widget.globalAnimationIds[AnimationTrigger.scroll]!;
    }

    double beginShift = 0.0, endShift = 0.0;
    if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
      String animationId = widget.globalAnimationIds[AnimationTrigger.scroll]!;
      beginShift = Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.beginShift ??
          0.0;
      endShift = Provider.of<GlobalAnimationNotifier>(context, listen: false)
              .animationPool[animationId]
              ?.endShift ??
          0.0;
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.scroll)) {
      beginShift =
          widget.localAnimations[AnimationTrigger.scroll]?.beginShift ?? 0.0;
      endShift =
          widget.localAnimations[AnimationTrigger.scroll]?.endShift ?? 0.0;
    }

    final Size screenSize = MediaQuery.sizeOf(context);
    if (parentScroll.direction == Axis.vertical) {
      setState(() {
        beginOffset = 0.0 + beginShift * visibilityInfo.widgetBounds.height;
        endOffset =
            screenSize.height + endShift * visibilityInfo.widgetBounds.height;
        currentOffset = visibilityInfo.widgetBounds.top;
        currentScrollOffset = controller.offset;
      });
    } else {
      setState(() {
        beginOffset = 0.0 + beginShift * visibilityInfo.widgetBounds.width;
        endOffset =
            screenSize.width + endShift * visibilityInfo.widgetBounds.width;

        currentOffset = visibilityInfo.widgetBounds.left;
        currentScrollOffset = controller.offset;
      });
    }

    if (widget.globalAnimationIds.containsKey(AnimationTrigger.scroll)) {
      final GlobalAnimationNotifier notifier =
          Provider.of<GlobalAnimationNotifier>(context, listen: false);
      notifier.animationProgressNotifiers[globalScrollAnimationName] =
          ContinuousAnimationProgressNotifier(
              (endOffset - currentOffset) / (endOffset - beginOffset));
      notifier.updateContinuousAnimationStatus(globalScrollAnimationName, true);
      _addScrollListener(controller, () {
        if (mounted) {
          notifier.animationProgressNotifiers[globalScrollAnimationName]
              ?.value = progress();
        }
      });
    }
    if (widget.localAnimations.containsKey(AnimationTrigger.scroll)) {
      final LocalAnimationNotifier notifier =
          Provider.of<LocalAnimationNotifier>(context, listen: false);
      notifier.animationProgressNotifier = ContinuousAnimationProgressNotifier(
          (endOffset - currentOffset) / (endOffset - beginOffset));
      notifier.updateContinuousAnimationStatus(
          widget.localAnimations[AnimationTrigger.scroll], true);
      _addScrollListener(controller, () {
        if (mounted) {
          notifier.animationProgressNotifier?.value = progress();
        }
      });
    }
    setState(() {
      visibilityDetected = true;
    });
  }

  MovieTween getMultiTweenFromAnimationSequences(
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
          AnimationProperty.foregroundDecoration: foregroundDecoration,
          AnimationProperty.shadows: shadows,
          AnimationProperty.insetShadows: insetShadows,
          AnimationProperty.shapeBorder: shapeBorder,
          AnimationProperty.transform: transform,
          AnimationProperty.transformAlignment: transformAlignment,
          AnimationProperty.childAlignment: childAlignment,
          AnimationProperty.textStyle: textStyle,
        },
        screenSize: MediaQuery.sizeOf(context),
        parentFontSize: DefaultTextStyle.of(context).style.fontSize ?? 14.0);
  }

  Widget buildGlobalAnimationWidget({required Widget child}) {
    if (!onlyLocal) {
      return Selector<GlobalAnimationNotifier,
              Tuple2<Control?, MultiAnimationSequence?>>(
          selector: (_, notifier) => Tuple2(
              notifier.currentAnimationsControl[widget.id],
              notifier.currentAnimations[widget.id]),
          child: child,
          builder: (context, tuple, child) {
            Control? control = tuple.item1;
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
            Tuple2<Control?, MultiAnimationSequence?>>(
        selector: (_, notifier) =>
            Tuple2(notifier.currentAnimationControl, notifier.currentAnimation),
        child: child,
        builder: (context, tuple, child) {
          Control? control = tuple.item1;
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

            MovieTween multiTween =
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

          MovieTween multiTween =
              getMultiTweenFromAnimationSequences(sequences);

          return buildCustomContinuousAnimation(
              isGlobal: false, multiTween: multiTween, child: child!);
        });
  }

  Widget buildCustomAnimation(
      {required MovieTween multiTween,
      required Control control,
      required Widget child}) {
    return CustomAnimationBuilder<Movie>(
      key: UniqueKey(),
      control: control,
      duration: multiTween.duration,
      tween: multiTween,
      builder: animatedWidgetBuilder,
      child: child,
    );
  }

  //TODO: currently only use scrollcontrollers
  Widget buildCustomContinuousAnimation(
      {required MovieTween multiTween,
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
          Movie values =
              multiTween.transform(progressNotifier.value.clamp(0.0, 1.0));
          return animatedWidgetBuilder(context, values, child!);
        },
      );
    });
  }

  Widget animatedWidgetBuilder(
      BuildContext context, Movie values, Widget? child) {
    opacity = values.get(AnimationProperty.opacity);
    alignment = values.get(AnimationProperty.alignment);
    width = values.get(AnimationProperty.width);
    height = values.get(AnimationProperty.height);
    margin = values.get(AnimationProperty.margin);
    padding = values.get(AnimationProperty.padding);
    backgroundDecoration = values.get(AnimationProperty.backgroundDecoration);
    foregroundDecoration = values.get(AnimationProperty.foregroundDecoration);
    shadows = values.get(AnimationProperty.shadows);
    insetShadows = values.get(AnimationProperty.insetShadows);
    shapeBorder = values.get(AnimationProperty.shapeBorder);

    transform = values.get(AnimationProperty.transform);
    transformAlignment = values.get(AnimationProperty.transformAlignment);
    childAlignment = values.get(AnimationProperty.childAlignment);
    textStyle = values.get(AnimationProperty.textStyle);

    return buildStyledContainerWithMouseEvent(context);
  }
}
