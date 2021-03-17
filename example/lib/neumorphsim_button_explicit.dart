import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class NeumorphismButtonExplicitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VisibilityDetectorController.instance.updateInterval =
        Duration(milliseconds: 1);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Explicit Animated Button"),
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
    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text("Hover mouse over the button"),
          ),
          Expanded(
            child: ExplicitAnimatedStyledContainer(
              style: Style(
                  width: 400.toPXLength,
                  height: 400.toPXLength,
                  padding: DynamicEdgeInsets.symmetric(vertical: 20.toPXLength),
                  backgroundDecoration:
                      BoxDecoration(color: Colors.grey.shade100),
                  shapeBorder: MorphableShapeBorder(
                      shape: RectangleShape(
                    borderRadius: DynamicBorderRadius.all(
                        DynamicRadius.circular(150.toPXLength)),
                  )),
                  shadows: [
                    DynamicShapeShadow(
                        blurRadius: 20.toPXLength,
                        spreadRadius: -5.toPXLength,
                        color: Colors.grey.shade400,
                        offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
                    DynamicShapeShadow(
                        blurRadius: 20.toPXLength,
                        spreadRadius: -5.toPXLength,
                        color: Color(0xFFFEFEFE),
                        offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
                  ],
                  textStyle: DynamicTextStyle(
                    letterSpacing: 0.8.toVWLength,
                    fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
                    fontWeight: FontWeight.w900,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  childAlignment: Alignment(-0.01, -0.01),
                  mouseCursor: SystemMouseCursors.click),
              localAnimations: {
                AnimationTrigger.mouseEnter: MultiAnimationSequence(sequences: {
                  AnimationProperty.shadows:
                      AnimationSequence<List<DynamicShapeShadow>>()
                        ..add(
                          duration: Duration(milliseconds: 150),
                          value: [],
                        ),
                  AnimationProperty.insetShadows:
                      AnimationSequence<List<DynamicShapeShadow>>()
                        ..add(
                          duration: Duration(milliseconds: 150),
                          value: [
                            DynamicShapeShadow(
                                blurRadius: 20.toPXLength,
                                spreadRadius: -5.toPXLength,
                                color: Colors.grey.shade400,
                                offset: DynamicOffset(
                                    20.toPXLength, 20.toPXLength)),
                            DynamicShapeShadow(
                                blurRadius: 20.toPXLength,
                                spreadRadius: -5.toPXLength,
                                color: Color(0xFFFEFEFE),
                                offset: DynamicOffset(
                                    -20.toPXLength, -20.toPXLength)),
                          ],
                        ),
                  AnimationProperty.shapeBorder:
                      AnimationSequence<MorphableShapeBorder>(animationData: [])
                        ..add(
                            duration: Duration(milliseconds: 200),
                            value: MorphableShapeBorder(
                              shape: RoundedRectangleShape(
                                borderRadius: DynamicBorderRadius.all(
                                    DynamicRadius.circular(50.toPercentLength)),
                              ),
                            )),
                  AnimationProperty.childAlignment: AnimationSequence()
                    ..add(
                        duration: Duration(milliseconds: 200),
                        value: Alignment(0.01, 0.01))
                }),
                AnimationTrigger.mouseExit: MultiAnimationSequence(sequences: {
                  AnimationProperty.insetShadows:
                      AnimationSequence<List<DynamicShapeShadow>>()
                        ..add(
                          duration: Duration(milliseconds: 500),
                          value: [],
                        ),
                  AnimationProperty
                      .shadows: AnimationSequence<List<DynamicShapeShadow>>()
                    ..add(
                      duration: Duration(milliseconds: 500),
                      value: [
                        DynamicShapeShadow(
                            blurRadius: 20.toPXLength,
                            spreadRadius: -5.toPXLength,
                            color: Colors.grey.shade400,
                            offset:
                                DynamicOffset(20.toPXLength, 20.toPXLength)),
                        DynamicShapeShadow(
                            blurRadius: 20.toPXLength,
                            spreadRadius: -5.toPXLength,
                            color: Color(0xFFFEFEFE),
                            offset:
                                DynamicOffset(-20.toPXLength, -20.toPXLength)),
                      ],
                    ),
                  AnimationProperty.shapeBorder:
                      AnimationSequence<MorphableShapeBorder>(animationData: [])
                        ..add(
                            duration: Duration(milliseconds: 500),
                            value: MorphableShapeBorder(
                              shape: RoundedRectangleShape(
                                borderRadius: DynamicBorderRadius.all(
                                    DynamicRadius.circular(150.toPXLength)),
                              ),
                            )),
                  AnimationProperty.childAlignment: AnimationSequence()
                    ..add(
                        duration: Duration(milliseconds: 500),
                        value: Alignment(-0.01, -0.01))
                }),
              },
              child: Text("HELLO"),
            ),
          ),
        ],
      ),
    );
  }
}
