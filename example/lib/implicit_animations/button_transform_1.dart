import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class ButtonTransform1Page extends StatefulWidget {
  ButtonTransform1Page({this.title = "Button Transform 1"});

  final String title;

  @override
  _ButtonTransform1PageState createState() => _ButtonTransform1PageState();
}

class _ButtonTransform1PageState extends State<ButtonTransform1Page> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Style endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
      alignment: Alignment.center,
      childAlignment: Alignment.center,
      width: Dimension.min(50.toVWLength, 400.toPXLength),
      height: 120.toPXLength,
      backgroundDecoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])),
      shapeBorder: RoundedRectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(15.toPXLength)),
          borders: RectangleBorders.only(
              top: DynamicBorderSide(
                  gradient: LinearGradient(colors: [
                    Colors.cyanAccent.shade100,
                    Colors.purpleAccent.shade100
                  ]),
                  width: 12),
              bottom: DynamicBorderSide(
                  gradient:
                      LinearGradient(colors: [Colors.cyan, Colors.purple]),
                  width: 28),
              left: DynamicBorderSide(
                  color: Colors.cyanAccent.shade200, width: 12),
              right: DynamicBorderSide(color: Colors.purpleAccent, width: 28))),
      shadows: [ShapeShadow(offset: Offset(0, 0), blurRadius: 0)],
      transform: SmoothMatrix4()..scale(1.2),
    );

    endStyle = Style(
      width: 200.toPXLength,
      height: 140.toPXLength,
      alignment: Alignment.center,
      childAlignment: Alignment.center,
      backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 210, 243, 224),
        Colors.tealAccent,
      ])),
      shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
          border: DynamicBorderSide(
              width: 10,
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 246, 167, 186),
                Colors.pinkAccent.shade200
              ]))),
      transform: SmoothMatrix4()..translate(-50.toPXLength),
      shadows: [
        ShapeShadow(
            offset: Offset(10, 10),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 246, 167, 186),
              Colors.pinkAccent.shade200
            ]),
            blurRadius: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: AnimatedStyledContainer(
          curve: Curves.elasticInOut,
          duration: Duration(seconds: 1),
          style: toggleStyle ? beginStyle : endStyle,
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            toggleStyle = !toggleStyle;
          });
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
