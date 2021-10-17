import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class StaggeredAnimationsPage extends StatelessWidget {
  var animationPool = {
    "animation":
        GlobalAnimation(control: CustomAnimationControl.mirror, sequences: {
      "Container1": SlideOutAnimation(
              curve: Curves.bounceIn,
              duration: Duration(seconds: 2),
              distance: 200.toPXLength)
          .getAnimationSequence()
        ..merge(MultiAnimationSequence(sequences: {
          AnimationProperty.shapeBorder: AnimationSequence()
            ..add(
                curve: Curves.bounceIn,
                duration: Duration(seconds: 2),
                value: RectangleShapeBorder(
                    borderRadius: DynamicBorderRadius.all(
                        DynamicRadius.circular(50.toPercentLength)))),
          AnimationProperty.backgroundDecoration: AnimationSequence()
            ..add(
                curve: Curves.bounceIn,
                duration: Duration(seconds: 2),
                value: BoxDecoration(
                    gradient: RadialGradient(stops: [
                  0.3,
                  0.6,
                  0.9
                ], colors: [
                  Colors.white,
                  Colors.redAccent.shade100,
                  Colors.red,
                ])))
        })),
      "Container2": MultiAnimationSequence(sequences: {
        AnimationProperty.transform: AnimationSequence()
          ..add(
              curve: Curves.bounceIn,
              delay: Duration(seconds: 1),
              duration: Duration(seconds: 2),
              value: SmoothMatrix4()
                ..translate(0.toPXLength, -200.toPXLength)
                ..rotateZ(3.1415)),
        AnimationProperty.shapeBorder: AnimationSequence()
          ..add(
              curve: Curves.bounceIn,
              delay: Duration(seconds: 1),
              duration: Duration(seconds: 2),
              value: PolygonShapeBorder(sides: 8))
      }),
      "Container3": SlideOutAnimation(
              curve: Curves.bounceIn,
              delay: Duration(seconds: 2),
              duration: Duration(seconds: 2),
              distance: 200.toPXLength)
          .getAnimationSequence()
        ..merge(ElevateAnimation(
          beginElevation: 0,
          endElevation: 24,
          curve: Curves.bounceIn,
          delay: Duration(seconds: 2),
          duration: Duration(seconds: 2),
        ).getAnimationSequence())
        ..merge(MultiAnimationSequence(sequences: {
          AnimationProperty.shapeBorder: AnimationSequence()
            ..add(
                curve: Curves.bounceIn,
                delay: Duration(seconds: 2),
                duration: Duration(seconds: 2),
                value: StarShapeBorder(corners: 8)),
        })),
      "Container4": MultiAnimationSequence(sequences: {
        AnimationProperty.transform: AnimationSequence()
          ..add(
              delay: Duration(seconds: 3),
              duration: Duration(seconds: 2),
              value: SmoothMatrix4()..scale(1.2)),
        AnimationProperty.shapeBorder: AnimationSequence()
          ..add(
              delay: Duration(seconds: 3),
              duration: Duration(seconds: 2),
              value: CircleShapeBorder(
                  border: DynamicBorderSide(
                      width: 10,
                      color: Colors.red,
                      begin: 0.toPercentLength,
                      end: 0.toPercentLength,
                      shift: 100.toPercentLength)))
      })
    })
  };

  @override
  Widget build(BuildContext context) {
    /*printWrapped(animationPool["animation"]?.toJson()?.toString() ?? "");*/

    VisibilityDetectorController.instance.updateInterval =
        Duration(milliseconds: 1);
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Staggered Animations"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: MultiProvider(providers: [
                ChangeNotifierProvider<GlobalAnimationNotifier>(
                    create: (_) =>
                        GlobalAnimationNotifier(animationPool: animationPool)),
              ], child: MyHomePage())));
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isRunning = false;

  @override
  Widget build(BuildContext context) {
    Dimension containerSize = 20.toVMINLength;
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ExplicitAnimatedStyledContainer(
                id: "Container1",
                style: Style(
                  width: containerSize,
                  height: containerSize,
                  backgroundDecoration: BoxDecoration(
                      gradient: RadialGradient(
                          center: Alignment(0.8, -0.8),
                          stops: [
                        0.1,
                        0.2,
                        0.3
                      ],
                          colors: [
                        Colors.white,
                        Colors.redAccent,
                        Colors.red
                      ])),
                ),
                child: Container(),
              ),
              ExplicitAnimatedStyledContainer(
                id: "Container2",
                style: Style(
                  width: containerSize,
                  height: containerSize,
                  backgroundDecoration:
                      BoxDecoration(color: Colors.amberAccent),
                ),
                child: Container(),
              ),
              ExplicitAnimatedStyledContainer(
                id: "Container3",
                style: Style(
                  width: containerSize,
                  height: containerSize,
                  backgroundDecoration: BoxDecoration(color: Colors.blueAccent),
                ),
                child: Container(),
              ),
              ExplicitAnimatedStyledContainer(
                id: "Container4",
                style: Style(
                    width: containerSize,
                    height: containerSize,
                    backgroundDecoration:
                        BoxDecoration(color: Colors.greenAccent),
                    shapeBorder: CircleShapeBorder(
                        border: DynamicBorderSide(
                      width: 10,
                      color: Colors.blue,
                      begin: 0.toPercentLength,
                      end: 100.toPercentLength,
                    ))),
                child: Container(),
              )
            ],
          ),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: ExplicitAnimatedStyledContainer(
              id: "FAB",
              onTap: () {
                setState(() {
                  isRunning = !isRunning;
                });
                if (isRunning) {
                  Provider.of<GlobalAnimationNotifier>(context, listen: false)
                      .updateAnimationStatus(
                          "animation", CustomAnimationControl.mirror);
                } else {
                  Provider.of<GlobalAnimationNotifier>(context, listen: false)
                      .updateAnimationStatus(
                          "animation", CustomAnimationControl.stop);
                }
              },
              style: Style(
                  width: 60.toPXLength,
                  height: 60.toPXLength,
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  backgroundDecoration: BoxDecoration(color: Colors.amber),
                  shapeBorder: RoundedRectangleShapeBorder(
                      borderRadius: DynamicBorderRadius.all(
                          DynamicRadius.circular(49.9.toPercentLength))),
                  shadows: preDefinedShapeShadow[6]),
              globalAnimationIds: {AnimationTrigger.tap: "animation"},
              child: !isRunning ? Icon(Icons.play_arrow) : Icon(Icons.pause),
            ))
      ],
    );
  }
}
