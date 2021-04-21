import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class LongAnimatedButtonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval =
        Duration(milliseconds: 1);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Long Animated Button"),
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
  @override
  Widget build(BuildContext context) {
    return ExplicitAnimatedStyledContainer(
      style: Style(
          alignment: Alignment.center,
          width: 300.toPXLength,
          height: 300.toPXLength,
          childAlignment: Alignment.center,
          backgroundDecoration: BoxDecoration(
            color: Colors.amber,
          ),
          textStyle: DynamicTextStyle(
              color: Colors.black, fontSize: 120.toPercentLength),
          shapeBorder: RectangleShapeBorder()),
      localAnimations: {
        AnimationTrigger.tap: RainbowLinearGradientAnimation(
                duration: Duration(seconds: 30))
            .getAnimationSequence()
              ..merge(WobbleAnimation(
                repeats: 3,
                translation: 2.toVWLength,
                angle: 3.1415 / 6,
                alignment: Alignment.center,
                delay: Duration(seconds: 0),
                duration: Duration(seconds: 6),
              ).getAnimationSequence())
              ..merge(FlashAnimation(
                repeats: 1,
                delay: Duration(seconds: 1),
                duration: Duration(seconds: 4),
              ).getAnimationSequence())
              ..merge(MultiAnimationSequence(sequences: {
                AnimationProperty.shadows: AnimationSequence()
                  ..add(duration: Duration(seconds: 6), value: [
                    ShapeShadow(
                        gradient: LinearGradient(
                            colors: [Colors.redAccent, Colors.blueAccent]),
                        offset: Offset(20, 20),
                        blurRadius: 50)
                  ])
                  ..add(duration: Duration(seconds: 6), value: [
                    ShapeShadow(
                        gradient: LinearGradient(
                            colors: [Colors.greenAccent, Colors.blueAccent]),
                        offset: Offset(-20, -20),
                        blurRadius: 1)
                  ])
                  ..add(duration: Duration(seconds: 8), value: [
                    ShapeShadow(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.redAccent, Colors.blueAccent]),
                        offset: Offset(20, 20),
                        spreadRadius: 30,
                        blurRadius: 60),
                    ShapeShadow(
                        gradient: LinearGradient(
                            colors: [Colors.greenAccent, Colors.amberAccent]),
                        offset: Offset(-10, -10),
                        spreadRadius: 10,
                        blurRadius: 20)
                  ]),
                AnimationProperty.textStyle: AnimationSequence()
                  ..add(
                      delay: Duration(seconds: 10),
                      value: DynamicTextStyle(
                          color: Colors.indigo, fontSize: 300.toPercentLength))
                  ..add(
                      delay: Duration(seconds: 5),
                      duration: Duration(seconds: 10),
                      value: DynamicTextStyle(
                          color: Colors.amber, fontSize: 200.toPercentLength))
                  ..add(
                      duration: Duration(seconds: 10),
                      value: DynamicTextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 400.toPercentLength)),
                AnimationProperty.width: AnimationSequence()
                  ..add(duration: Duration(seconds: 5), value: 200.toPXLength)
                  ..add(duration: Duration(seconds: 5), value: 50.toVMINLength)
                  ..add(
                      duration: Duration(seconds: 10), value: 70.toVMINLength),
                AnimationProperty.height: AnimationSequence()
                  ..add(duration: Duration(seconds: 5), value: 200.toPXLength)
                  ..add(duration: Duration(seconds: 5), value: 50.toVMINLength)
                  ..add(
                      duration: Duration(seconds: 10), value: 70.toVMINLength),
                AnimationProperty.shapeBorder: AnimationSequence()
                  ..add(
                      value: RectangleShapeBorder(
                          borderRadius: DynamicBorderRadius.all(
                              DynamicRadius.circular(50.toPercentLength))))
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "Rectangle",
                            "borderRadius": {
                              "topLeft": {"x": "25%", "y": "25%"},
                              "topRight": {"x": "25%", "y": "25%"},
                              "bottomLeft": {"x": "25%", "y": "25%"},
                              "bottomRight": {"x": "25%", "y": "25%"}
                            },
                            "cornerStyles": {
                              "topLeft": "cutout",
                              "bottomLeft": "cutout",
                              "topRight": "cutout",
                              "bottomRight": "cutout"
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "Path",
                            "path": {
                              "size": {"width": 400, "height": 400},
                              "nodes": [
                                {
                                  "pos": {"dx": 400, "dy": 0},
                                  "prev": {"dx": 360, "dy": 0}
                                },
                                {
                                  "pos": {"dx": 400, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 0},
                                  "next": {"dx": 40, "dy": 0}
                                },
                                {
                                  "pos": {"dx": 100, "dy": 40},
                                  "prev": {"dx": 60, "dy": 40},
                                  "next": {"dx": 140, "dy": 40}
                                },
                                {
                                  "pos": {"dx": 200, "dy": 0},
                                  "prev": {"dx": 160, "dy": 0},
                                  "next": {"dx": 240, "dy": 0}
                                },
                                {
                                  "pos": {"dx": 300, "dy": 40},
                                  "prev": {"dx": 260, "dy": 40},
                                  "next": {"dx": 340, "dy": 40}
                                }
                              ]
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "Path",
                            "path": {
                              "size": {"width": 400, "height": 400},
                              "nodes": [
                                {
                                  "pos": {"dx": 400, "dy": 40},
                                  "prev": {"dx": 360, "dy": 40}
                                },
                                {
                                  "pos": {"dx": 400, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 40},
                                  "next": {"dx": 40, "dy": 40}
                                },
                                {
                                  "pos": {"dx": 100, "dy": 0},
                                  "prev": {"dx": 60, "dy": 0},
                                  "next": {"dx": 140, "dy": 0}
                                },
                                {
                                  "pos": {"dx": 200, "dy": 40},
                                  "prev": {"dx": 160, "dy": 40},
                                  "next": {"dx": 240, "dy": 40}
                                },
                                {
                                  "pos": {"dx": 300, "dy": 0},
                                  "prev": {"dx": 260, "dy": 0},
                                  "next": {"dx": 340, "dy": 0}
                                }
                              ]
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "Path",
                            "path": {
                              "size": {"width": 400, "height": 400},
                              "nodes": [
                                {
                                  "pos": {
                                    "dx": 266.6666666666667,
                                    "dy": 33.333333333333336
                                  },
                                  "prev": {"dx": 233.333, "dy": 33.333},
                                  "next": {"dx": 300, "dy": 33.333}
                                },
                                {
                                  "pos": {"dx": 333.33333333333337, "dy": 0},
                                  "prev": {"dx": 300, "dy": 0},
                                  "next": {"dx": 366.667, "dy": 0}
                                },
                                {
                                  "pos": {"dx": 400, "dy": 33.333333333333336},
                                  "prev": {"dx": 366.667, "dy": 33.333}
                                },
                                {
                                  "pos": {"dx": 400, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 400}
                                },
                                {
                                  "pos": {"dx": 0, "dy": 33.333333333333336},
                                  "next": {"dx": 33.333, "dy": 33.333}
                                },
                                {
                                  "pos": {"dx": 66.66666666666667, "dy": 0},
                                  "prev": {"dx": 33.333, "dy": 0},
                                  "next": {"dx": 100, "dy": 0}
                                },
                                {
                                  "pos": {
                                    "dx": 133.33333333333334,
                                    "dy": 33.333333333333336
                                  },
                                  "prev": {"dx": 100, "dy": 33.333},
                                  "next": {"dx": 166.667, "dy": 33.333}
                                },
                                {
                                  "pos": {"dx": 200, "dy": 0},
                                  "prev": {"dx": 166.667, "dy": 0},
                                  "next": {"dx": 233.333, "dy": 0}
                                }
                              ]
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "RoundedRectangle",
                            "borderRadius": {
                              "topLeft": {"x": "50%", "y": "50%"},
                              "topRight": {"x": "50%", "y": "50%"},
                              "bottomLeft": {"x": "50%", "y": "50%"},
                              "bottomRight": {"x": "0px", "y": "0px"}
                            },
                            "borders": {
                              "top": {
                                "color": "ff3f51b5",
                                "width": 10,
                                "style": "solid"
                              },
                              "bottom": {
                                "color": "ffe91e63",
                                "width": 20,
                                "style": "solid"
                              },
                              "left": {
                                "color": "ff8bc34a",
                                "width": 5,
                                "style": "solid"
                              },
                              "right": {
                                "color": "ffffc107",
                                "width": 20,
                                "style": "solid"
                              }
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 5),
                      value: parseMorphableShapeBorder({
                            "type": "RoundedRectangle",
                            "borderRadius": {
                              "topLeft": {"x": "0%", "y": "0%"},
                              "topRight": {"x": "50%", "y": "50%"},
                              "bottomLeft": {"x": "50%", "y": "50%"},
                              "bottomRight": {"x": "0px", "y": "0px"}
                            },
                            "borders": {
                              "top": {
                                "color": "ff2196f3",
                                "width": 50,
                                "style": "solid"
                              },
                              "bottom": {
                                "color": "ffe91e63",
                                "width": 0,
                                "style": "solid"
                              },
                              "left": {
                                "color": "ff8bc34a",
                                "width": 50,
                                "style": "solid"
                              },
                              "right": {
                                "color": "ffffc107",
                                "width": 0,
                                "style": "solid"
                              }
                            }
                          }) ??
                          RectangleShapeBorder())
                  ..add(
                      duration: Duration(seconds: 4),
                      value: RectangleShapeBorder(
                          borderRadius: DynamicBorderRadius.all(
                              DynamicRadius.circular(50.toPercentLength))))
              }))
      },
      child: Text("Tap"),
    );
  }
}
