import 'dart:ui';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class NeonButtonPage extends StatefulWidget {
  NeonButtonPage({this.title = "Neon Button"});

  final String title;

  @override
  _NeonButtonPageState createState() => _NeonButtonPageState();
}

class _NeonButtonPageState extends State<NeonButtonPage> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Style endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
        //width: Dimension.min(80.toVWLength, 400.toPXLength),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 20),
        backgroundDecoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1557409239-720ef57b99d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80"))),
        shapeBorder: RoundedRectangleShapeBorder(
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(15.toPXLength)),
            borderSides: RectangleBorderSides.only(
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
                right:
                    DynamicBorderSide(color: Colors.purpleAccent, width: 28))),
        shadows: [
          ShapeShadow(
              blurRadius: 25,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: Offset(0, 0)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            Shadow(blurRadius: 5, color: Colors.white, offset: Offset(0, 0)),
            Shadow(blurRadius: 20, color: Colors.white, offset: Offset(0, 0)),
            Shadow(blurRadius: 1, color: Colors.white70, offset: Offset(0, 0))
          ],
        ),
        textAlign: TextAlign.center,
        shaderGradient: LinearGradient(colors: [
          Colors.cyan,
          Colors.amberAccent,
          Colors.amberAccent,
          Colors.cyan,
        ]),
        mouseCursor: SystemMouseCursors.click);

    endStyle = Style(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      margin: EdgeInsets.symmetric(vertical: 20),
      backgroundDecoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1647369098673-94c0590a15a7?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=802&q=80"))),
      textStyle: DynamicTextStyle(
        letterSpacing: 0.8.toVWLength,
        fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
        fontWeight: FontWeight.w900,
        color: Colors.white,
        shadows: [
          Shadow(blurRadius: 5, color: Colors.white, offset: Offset(0, 0)),
          Shadow(blurRadius: 20, color: Colors.white, offset: Offset(0, 0)),
          Shadow(blurRadius: 1, color: Colors.white70, offset: Offset(0, 0))
        ],
      ),
    );

    /*printWrapped(
        parsePossibleStyleMap(json.decode(json.encode(beginStyle.toJson())))
            .toJson()
            .toString());*/
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
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              setState(() {
                toggleStyle = false;
              });
            },
            onTapUp: (TapUpDetails details) {
              setState(() {
                toggleStyle = true;
              });
            },
            child: AnimatedStyledContainer(
                duration: Duration(milliseconds: 10000),
                style: toggleStyle ? beginStyle : endStyle,
                child: Text("TAP ME")),
          )
        ],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
