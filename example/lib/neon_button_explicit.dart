import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class NeonButtonExplicitPage extends StatelessWidget {
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
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Text("Hover mouse over the button"),
        ),
        Expanded(
          child: ExplicitAnimatedStyledContainer(
            style: Style(
                alignment: Alignment.center,
                childAlignment: Alignment.center,
                width: Dimension.min(80.toVWLength, 400.toPXLength),
                height: 120.toPXLength,
                padding: DynamicEdgeInsets.all(1.toPercentLength),
                margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
                backgroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.cyanAccent, Colors.purpleAccent])),
                shapeBorder: MorphableShapeBorder(
                  shape: RoundedRectangleShape(
                      borderRadius: DynamicBorderRadius.all(
                          DynamicRadius.circular(15.toPXLength)),
                      borders: RectangleBorders.only(
                          top: DynamicBorderSide(
                              gradient: LinearGradient(colors: [
                                Colors.cyanAccent.shade100,
                                Colors.purpleAccent.shade100
                              ]),
                              width: 12),
                          bottom: DynamicBorderSide(
                              gradient: LinearGradient(
                                  colors: [Colors.cyan, Colors.purple]),
                              width: 28),
                          left: DynamicBorderSide(
                              color: Colors.cyanAccent.shade200, width: 12),
                          right: DynamicBorderSide(
                              color: Colors.purpleAccent, width: 28))),
                ),
                textStyle: DynamicTextStyle(
                    letterSpacing: 10.toPXLength,
                    fontSize: 300.toPercentLength,
                    color: Colors.black45,
                    fontWeight: FontWeight.bold),
                mouseCursor: SystemMouseCursors.click),
            localAnimations: {
              AnimationTrigger.mouseEnter: MultiAnimationSequence(sequences: {
                AnimationProperty.width: AnimationSequence()
                  ..add(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                      value: 440.toPXLength),
                AnimationProperty.backgroundDecoration:
                    AnimationSequence<BoxDecoration>()
                      ..add(
                        duration: Duration(milliseconds: 150),
                        value: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Colors.cyanAccent,
                          Colors.amberAccent,
                          Colors.purpleAccent
                        ])),
                      ),
                AnimationProperty.shapeBorder:
                    AnimationSequence<MorphableShapeBorder>()
                      ..add(
                          duration: Duration(milliseconds: 200),
                          value: MorphableShapeBorder(
                            shape: RoundedRectangleShape(
                                borderRadius: DynamicBorderRadius.all(
                                    DynamicRadius.circular(15.toPXLength)),
                                borders: RectangleBorders.only(
                                    top: DynamicBorderSide(
                                        gradient: LinearGradient(colors: [
                                          Colors.cyanAccent.shade100,
                                          Colors.amberAccent.shade100,
                                          Colors.purpleAccent.shade100
                                        ]),
                                        width: 20),
                                    bottom: DynamicBorderSide(
                                        gradient: LinearGradient(colors: [
                                          Colors.cyan,
                                          Colors.amber,
                                          Colors.purple
                                        ]),
                                        width: 20),
                                    left: DynamicBorderSide(
                                        color: Colors.cyanAccent.shade200,
                                        width: 20),
                                    right: DynamicBorderSide(
                                        color: Colors.purpleAccent,
                                        width: 20))),
                          )),
              }),
              AnimationTrigger.mouseExit: MultiAnimationSequence(sequences: {
                AnimationProperty.width: AnimationSequence()
                  ..add(
                      duration: Duration(milliseconds: 1500),
                      curve: Curves.elasticIn,
                      value: Dimension.min(80.toVWLength, 400.toPXLength)),
                AnimationProperty
                    .backgroundDecoration: AnimationSequence<BoxDecoration>()
                  ..add(
                    duration: Duration(milliseconds: 1500),
                    value: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.cyanAccent, Colors.purpleAccent])),
                  ),
                AnimationProperty
                    .shapeBorder: AnimationSequence<MorphableShapeBorder>()
                  ..add(
                      duration: Duration(milliseconds: 1550),
                      value: MorphableShapeBorder(
                        shape: RoundedRectangleShape(
                            borderRadius: DynamicBorderRadius.all(
                                DynamicRadius.circular(15.toPXLength)),
                            borders: RectangleBorders.only(
                                top: DynamicBorderSide(
                                    gradient: LinearGradient(colors: [
                                      Colors.cyanAccent.shade100,
                                      Colors.purpleAccent.shade100
                                    ]),
                                    width: 12),
                                bottom: DynamicBorderSide(
                                    gradient: LinearGradient(
                                        colors: [Colors.cyan, Colors.purple]),
                                    width: 28),
                                left: DynamicBorderSide(
                                    color: Colors.cyanAccent.shade200,
                                    width: 12),
                                right: DynamicBorderSide(
                                    color: Colors.purpleAccent, width: 28))),
                      )),
              }),
            },
            child: Text("HELLO"),
          ),
        ),
      ],
    );
  }
}
