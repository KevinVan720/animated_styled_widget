import 'dart:ui';

import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

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
                        color: Colors.purpleAccent, width: 28)))),
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
        mouseCursor: SystemMouseCursors.click);

    endStyle = beginStyle.copyWith(
      shapeBorder: MorphableShapeBorder(
          shape: (beginStyle.shapeBorder?.shape as RoundedRectangleShape)
              .copyWith(
                  borders: RectangleBorders.only(
                      top: DynamicBorderSide(
                          gradient: LinearGradient(colors: [
                            Colors.cyanAccent.shade100,
                            Colors.purpleAccent.shade100
                          ]),
                          width: 20),
                      bottom: DynamicBorderSide(
                          gradient: LinearGradient(
                              colors: [Colors.cyan, Colors.purple]),
                          width: 20),
                      left: DynamicBorderSide(
                          color: Colors.cyanAccent.shade200, width: 20),
                      right: DynamicBorderSide(
                          color: Colors.purpleAccent, width: 20)))),
      shadows: [
        ShapeShadow(
            blurRadius: 40,
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent]),
            offset: Offset(0, 0)),
      ],
      textAlign: TextAlign.center,
      textStyle: DynamicTextStyle(
        letterSpacing: 1.0.toVWLength,
        fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
        fontWeight: FontWeight.w900,
        color: Colors.white,
        shadows: [
          Shadow(blurRadius: 10, color: Colors.white, offset: Offset(0, 0)),
          Shadow(blurRadius: 25, color: Colors.white, offset: Offset(0, 0)),
          Shadow(blurRadius: 2, color: Colors.white70, offset: Offset(0, 0))
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
                duration: Duration(milliseconds: 100),
                style: toggleStyle ? beginStyle : endStyle,
                child: Text("TAP ME")),
          )
        ],
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
