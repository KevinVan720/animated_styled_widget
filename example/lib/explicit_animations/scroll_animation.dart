import 'dart:math';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:provider/provider.dart';

class ScrollAnimationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval =
        Duration(milliseconds: 1);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Scroll Animations"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: MyHomePage()));
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ScrollController scrollController;
  late ScrollController scrollController2;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController2 = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dimension = MediaQuery.of(context).size.longestSide / 3;
    List<Widget> children = [
      Container(
        height: dimension,
        color: Colors.greenAccent,
        child: Center(child: Text("Scroll vertically")),
      ),
      Container(
        height: dimension,
        color: Colors.blueAccent,
      ),
      ExplicitAnimatedStyledContainer(
        style: Style(
            height: dimension.toPXLength,
            childAlignment: Alignment.center,
            backgroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.lightBlueAccent]))),
        localAnimations: {
          AnimationTrigger.scroll:
              SlideInAnimation(direction: AxisDirection.right)
                  .getAnimationSequence()
                ..beginShift = 1
        },
        child: Text("Fly in from right"),
      ),
      Container(
          color: Colors.amber,
          height: dimension,
          child: ParentScroll(
              controller: scrollController2,
              direction: Axis.horizontal,
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: scrollController2,
                physics: AlwaysScrollableScrollPhysics(),
                children: [
                  Container(
                    width: dimension,
                    color: Colors.redAccent,
                    child: Center(child: Text("Scroll horizontally")),
                  ),
                  Container(
                    width: dimension,
                    color: Colors.greenAccent,
                  ),
                  ExplicitAnimatedStyledContainer(
                    style: Style(
                        width: dimension.toPXLength,
                        childAlignment: Alignment.center,
                        backgroundDecoration:
                            BoxDecoration(color: Colors.deepOrangeAccent)),
                    localAnimations: {
                      AnimationTrigger.scroll:
                          ZoomInAnimation(curve: Curves.bounceOut)
                              .getAnimationSequence()
                            ..merge(FadeInAnimation(curve: Curves.bounceOut)
                                .getAnimationSequence())
                            ..endShift = -1.0
                    },
                    child: Text("Zoom and fade in"),
                  ),
                  Container(
                    width: dimension,
                    color: Colors.deepPurpleAccent,
                  ),
                  ExplicitAnimatedStyledContainer(
                    style: Style(
                        alignment: Alignment.center,
                        width: dimension.toPXLength,
                        childAlignment: Alignment.center,
                        height: (dimension / 2).toPXLength,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        backgroundDecoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.cyanAccent,
                          Colors.purpleAccent
                        ]))),
                    localAnimations: {
                      AnimationTrigger.scroll: MultiAnimationSequence(
                          beginShift: 0.0,
                          endShift: 0.0,
                          sequences: {
                            AnimationProperty.transform:
                                AnimationSequence<SmoothMatrix4>()
                                  ..add(
                                    duration: Duration(milliseconds: 100),
                                    value: SmoothMatrix4()..rotateZ(pi),
                                  )
                          }),
                    },
                    child: Text("Rotate"),
                  ),
                  Container(
                      width: dimension,
                      alignment: Alignment.center,
                      color: Colors.indigo),
                  Container(
                    width: dimension,
                    color: Colors.red,
                  ),
                  ExplicitAnimatedStyledContainer(
                    style: Style(
                      width: dimension.toPXLength,
                      childAlignment: Alignment.center,
                    ),
                    localAnimations: {
                      AnimationTrigger.scroll:
                          RainbowAnimation().getAnimationSequence()
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        ContinuousAnimationProgressNotifier? progressNotifier =
                            Provider.of<LocalAnimationNotifier>(context,
                                    listen: false)
                                .animationProgressNotifier;
                        return progressNotifier != null
                            ? AnimatedBuilder(
                                animation: progressNotifier,
                                builder: (BuildContext context, Widget? child) {
                                  return Text("Progress: " +
                                      (progressNotifier.value * 100)
                                          .roundWithPrecision(2)
                                          .toString() +
                                      "%");
                                })
                            : Container();
                      },
                    ),
                  ),
                  Container(
                    width: dimension,
                    color: Colors.amber,
                  ),
                  ExplicitAnimatedStyledContainer(
                    style: Style(
                        width: dimension.toPXLength,
                        childAlignment: Alignment.center,
                        backgroundDecoration:
                            BoxDecoration(color: Colors.deepPurpleAccent)),
                    localAnimations: {
                      AnimationTrigger.scroll:
                          MultiAnimationSequence(sequences: {
                        AnimationProperty.shapeBorder: AnimationSequence()
                          ..add(
                              value: RectangleShapeBorder(
                                  borderRadius: DynamicBorderRadius.all(
                                      DynamicRadius.circular(
                                          50.toPercentLength))))
                      })
                    },
                    child: Text("Shape morph"),
                  ),
                  Container(
                    width: dimension,
                    color: Colors.greenAccent,
                  ),
                  Container(
                    width: dimension,
                    color: Colors.yellowAccent,
                  ),
                  Container(width: dimension, color: Colors.deepOrangeAccent),
                ],
              ))),
      Container(
        height: dimension,
        color: Colors.greenAccent,
      ),
      Container(
        height: dimension,
        color: Colors.lightBlueAccent,
      )
    ];
    return ParentScroll(
      controller: scrollController,
      direction: Axis.vertical,
      child: ListView(
        controller: scrollController,
        children: children,
      ),
    );
  }
}
