import 'dart:math';

import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class ListViewPage extends StatefulWidget {
  ListViewPage({this.title = "Transform"});

  final String title;

  @override
  _ListViewPageState createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Map<ScreenScope, Style> endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
      alignment: Alignment.center,
      //width: 50.toVWLength,
      height: 120.toPXLength,
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
          opacity: 0.8),
      typicalTabletScreenScope: Style(
        alignment: Alignment.center,
        width: 200.toPXLength,
        height: 200.toPXLength,
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        shape: PolygonShape(sides: 8),
        transform: SmoothMatrix4()..rotateZ(pi),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 0.1.toPXLength,
              color: Colors.grey.shade700,
              offset: DynamicOffset((-20).toPXLength, (-20).toPXLength))
        ],
      ),
    };
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
        child: ListView(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500,
                maxHeight: 500,
              ),
              child: AnimatedStyledContainer(
                duration: Duration(seconds: 3),
                style: toggleStyle ? beginStyle : endStyle,
                child: Container(),
              ),
            )
          ],
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