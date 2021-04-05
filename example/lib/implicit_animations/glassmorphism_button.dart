import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/responsive_styled_widget.dart';

class GlassmorphismButtonPage extends StatefulWidget {
  GlassmorphismButtonPage({this.title = "Glassmorphism Button"});

  final String title;

  @override
  _GlassmorphismButtonPageState createState() =>
      _GlassmorphismButtonPageState();
}

class _GlassmorphismButtonPageState extends State<GlassmorphismButtonPage> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Style endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
        width: 400.toPXLength,
        height: 400.toPXLength,
        padding: EdgeInsets.symmetric(vertical: 30),
        childAlignment: Alignment.center,
        shapeBorder: RectangleShapeBorder(
            border: DynamicBorderSide(
                width: 3,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0, 0.2],
                    colors: [Colors.white70, Colors.white.withOpacity(0.05)])),
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(20.toPXLength))),
        backgroundDecoration: BoxDecoration(color: Colors.white38),
        backdropFilter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        mouseCursor: SystemMouseCursors.click);

    endStyle = beginStyle.copyWith(
      width: 396.toPXLength,
      height: 396.toPXLength,
      shapeBorder: RectangleShapeBorder(
          border: DynamicBorderSide(
              width: 1,
              begin: 50.toPercentLength,
              end: 60.toPercentLength,
              gradient: LinearGradient(colors: [
                Colors.white.withOpacity(0.01),
                Colors.white.withOpacity(0.01)
              ])),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(20.toPXLength))),
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
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1604776159603-cacfe8f4b46f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1334&q=80")),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red,
                    Colors.amber,
                    Colors.deepOrange,
                    Colors.green
                  ])),
          child: Center(
            child: GestureDetector(
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
                duration: Duration(milliseconds: 200),
                style: toggleStyle ? beginStyle : endStyle,
                child: Text("TAP ME"),
              ),
            ),
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
