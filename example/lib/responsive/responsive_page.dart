import 'dart:ui';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_property/responsive_property.dart';

class ResponsivePage extends StatefulWidget {
  ResponsivePage({this.title = "Responsive"});

  final String title;

  @override
  _ResponsivePageState createState() => _ResponsivePageState();
}

class _ResponsivePageState extends State<ResponsivePage> {
  late Style bigStyle;
  late Style mediumStyle;
  late Style littleStyle;

  @override
  void initState() {
    super.initState();

    bigStyle = Style(
        width: Dimension.min(80.toVWLength, 400.toPXLength),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.symmetric(vertical: 20),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent])),
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
                right:
                    DynamicBorderSide(color: Colors.purpleAccent, width: 28))),
        shadows: [
          ShapeShadow(
              blurRadius: 25,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: Offset(0, 0)),
        ],
        mouseCursor: SystemMouseCursors.click);

    mediumStyle = bigStyle.copyWith(
      shapeBorder: (bigStyle.shapeBorder as RoundedRectangleShapeBorder)
          .copyWith(
              borders: RectangleBorders.only(
                  top: DynamicBorderSide(
                      gradient: LinearGradient(colors: [
                        Colors.cyanAccent.shade100,
                        Colors.purpleAccent.shade100
                      ]),
                      width: 20),
                  bottom: DynamicBorderSide(
                      gradient:
                          LinearGradient(colors: [Colors.cyan, Colors.purple]),
                      width: 20),
                  left: DynamicBorderSide(
                      color: Colors.cyanAccent.shade200, width: 20),
                  right: DynamicBorderSide(
                      color: Colors.purpleAccent, width: 20))),
      shadows: [
        ShapeShadow(
            blurRadius: 40,
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent]),
            offset: Offset(0, 0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print(Responsive({
      ScreenScope(minWidth: 0, maxWidth: 500): 3,
      ScreenScope(minWidth: 500, maxWidth: 1000): 4,
      ScreenScope(minWidth: 1000, maxWidth: 2000): 6,
    }).toJson());
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
          child: Responsive({
                ScreenScope(minWidth: 0, maxWidth: 700): ListView(
                  children: List.generate(
                      30,
                      (index) => AnimatedStyledContainer(
                          duration: Duration(milliseconds: 100),
                          style: mediumStyle,
                          child: Text("TAP ME"))),
                ),
                ScreenScope(minWidth: 700, maxWidth: 1200): GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: List.generate(
                      30,
                      (index) => AnimatedStyledContainer(
                          duration: Duration(milliseconds: 100),
                          style: mediumStyle,
                          child: Text("TAP ME"))),
                ),
                ScreenScope(minWidth: 1200, maxWidth: 3000): GridView.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 6,
                  children: List.generate(
                      30,
                      (index) => AnimatedStyledContainer(
                          duration: Duration(milliseconds: 100),
                          style: bigStyle,
                          child: Text("TAP ME"))),
                ),
              }).resolve(context) ??
              Container()),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
