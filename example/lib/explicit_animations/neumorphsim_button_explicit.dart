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
    return Center(
      child: Container(
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
                    alignment: Alignment.center,
                    width: 400.toPXLength,
                    height: 400.toPXLength,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    backgroundDecoration:
                        BoxDecoration(color: Colors.grey.shade100),
                    shapeBorder: MorphableShapeBorder(
                        shape: RectangleShape(
                      borderRadius: DynamicBorderRadius.all(
                          DynamicRadius.circular(150.toPXLength)),
                    )),
                    shadows: [
                      ShapeShadow(
                          blurRadius: 20,
                          spreadRadius: -5,
                          color: Colors.grey.shade400,
                          offset: Offset(20, 20)),
                      ShapeShadow(
                          blurRadius: 20,
                          spreadRadius: -5,
                          color: Color(0xFFFEFEFE),
                          offset: Offset(-20, -20)),
                    ],
                    textStyle: DynamicTextStyle(
                      letterSpacing: 0.8.toVWLength,
                      fontSize:
                          Dimension.min(300.toPercentLength, 28.toPXLength),
                      fontWeight: FontWeight.w900,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    childAlignment: Alignment(-0.01, -0.01),
                    mouseCursor: SystemMouseCursors.click),
                localAnimations: {
                  AnimationTrigger.mouseEnter:
                      MultiAnimationSequence(sequences: {
                    AnimationProperty.shadows:
                        AnimationSequence<List<ShapeShadow>>()
                          ..add(
                            duration: Duration(milliseconds: 150),
                            value: [],
                          ),
                    AnimationProperty.insetShadows:
                        AnimationSequence<List<ShapeShadow>>()
                          ..add(
                            duration: Duration(milliseconds: 150),
                            value: [
                              ShapeShadow(
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                  color: Colors.grey.shade400,
                                  offset: Offset(20, 20)),
                              ShapeShadow(
                                  blurRadius: 20,
                                  spreadRadius: -5,
                                  color: Color(0xFFFEFEFE),
                                  offset: Offset(-20, -20)),
                            ],
                          ),
                    AnimationProperty
                        .shapeBorder: AnimationSequence<MorphableShapeBorder>()
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
                  AnimationTrigger.mouseExit:
                      MultiAnimationSequence(sequences: {
                    AnimationProperty.insetShadows: AnimationSequence()
                      ..add(
                        duration: Duration(milliseconds: 500),
                        value: [],
                      ),
                    AnimationProperty.shadows: AnimationSequence()
                      ..add(
                        duration: Duration(milliseconds: 500),
                        value: [
                          ShapeShadow(
                              blurRadius: 20,
                              spreadRadius: -5,
                              color: Colors.grey.shade400,
                              offset: Offset(20, 20)),
                          ShapeShadow(
                              blurRadius: 20,
                              spreadRadius: -5,
                              color: Color(0xFFFEFEFE),
                              offset: Offset(-20, -20)),
                        ],
                      ),
                    AnimationProperty.shapeBorder:
                        AnimationSequence<MorphableShapeBorder>()
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
      ),
    );
  }
}
