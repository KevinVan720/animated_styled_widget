import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:length_unit/length_unit.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:morphable_shape/morphable_shape.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      //home: Center(child: Text("Hello")),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title = "Home"});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Style beginStyle = Style(
      alignment: Alignment.center,
      width: 300.toPXLength,
      height: 20.toVHLength,
      margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
      backgroundDecoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red, Colors.amber])),
      borderColor: Colors.green,
      borderThickness: 5,
      shape: ArcShape(),
      shadows: [
        DynamicBoxShadow(
            blurRadius: 2.toPXLength,
            color: Colors.grey,
            offset: DynamicOffset(2.toPXLength, 2.toPXLength))
      ],
      translationX: -50,
      translationY: 50,
      childAlignment: Alignment.centerLeft,
      opacity: 0.8,
      textStyle: DynamicTextStyle(fontSize: 2.toVWLength, color: Colors.black));

  Map<ScreenScope, Style> endStyle = {
    typicalTabletScreenScope: Style(
        alignment: Alignment.center,
        width: 300.toPXLength,
        height: 300.toPXLength,
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.red])),
        borderColor: Colors.blueAccent,
        borderThickness: 1,
        shape: PolygonShape(sides: 12, cornerRadius: 50.toPXLength),
        shadows: [
          DynamicBoxShadow(
              blurRadius: 10.toPXLength,
              color: Colors.grey,
              offset: DynamicOffset(10.toPXLength, 10.toPXLength))
        ],
        translationX: 0,
        translationY: 0,
        textStyle:
            DynamicTextStyle(fontSize: 3.toVWLength, color: Colors.blueAccent)),
    typicalDesktopScreenScope: Style(
        alignment: Alignment.center,
        width: 300.toPXLength,
        height: 300.toPXLength,
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.amber,
          Colors.red,
        ])),
        borderColor: Colors.redAccent,
        borderThickness: 10,
        shape: PolygonShape(sides: 6, cornerRadius: 20.toPXLength),
        shadows: [
          DynamicBoxShadow(
              blurRadius: 10.toPXLength,
              color: Colors.grey,
              offset: DynamicOffset(10.toPXLength, 10.toPXLength))
        ],
        translationX: 50,
        translationY: -100,
        childAlignment: Alignment.centerLeft,
        opacity: 0.8,
        textStyle: DynamicTextStyle(
            fontSize: 3.toVWLength,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent))
  };

  bool toggleStyle = true;

  @override
  Widget build(BuildContext context) {
    //debugPrint(json.encode(beginStyle.toJson()));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedStyledContainer(
            style: toggleStyle ? beginStyle : endStyle,
            duration: Duration(seconds: 1),
            child: Text("Hello")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.toggle_off),
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
