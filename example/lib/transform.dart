import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_styled_widget/styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:morphable_shape/morphable_shape.dart';

void printWrapped(String text) {
  final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

class TransformPage extends StatefulWidget {
  TransformPage({this.title = "Transform"});

  final String title;

  @override
  _TransformPageState createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Map<ScreenScope, Style> endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
      alignment: Alignment.center,
      width: Dimension.min(50.toVWLength, 400.toPXLength),
      height: 120.toPXLength,
      padding: DynamicEdgeInsets.all(1.toPercentLength),
      margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
      backgroundDecoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])),
      shape: RoundedRectangleShape(
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
      transform: SmoothMatrix4()..scale(1.2),
    );

    endStyle = {
      ScreenScope(): Style(
          alignment: Alignment.center,
          width: 200.toPXLength,
          height: 140.toPXLength,
          margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
          backgroundDecoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 210, 243, 224),
                Color.fromARGB(255, 210, 243, 224),
              ])),
          shape: RectangleShape(
              borderRadius: DynamicBorderRadius.all(
                  DynamicRadius.circular(50.toPXLength)),
              border: DynamicBorderSide(
                  width: 10, color: Color.fromARGB(255, 246, 167, 186))),
          childAlignment: Alignment.center,
        transform: SmoothMatrix4()..translate(-50.0.toVWLength-50.toPercentLength),),
    };

    printWrapped(json.encode(beginStyle.toJson()));
    printWrapped(json.encode(endStyle.toJson()));
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
          duration: Duration(seconds: 3),
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
