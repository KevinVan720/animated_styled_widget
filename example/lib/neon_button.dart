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
        width: Dimension.max(50.toVWLength, 400.toPXLength),
        padding: DynamicEdgeInsets.symmetric(vertical: 20.toPXLength),
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
          DynamicShapeShadow(
              blurRadius: 25.toPXLength,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: 300.toPercentLength,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            DynamicShadow(
                blurRadius: 5.toPXLength,
                color: Colors.white,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
            DynamicShadow(
                blurRadius: 20.toPXLength,
                color: Colors.white,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
            DynamicShadow(
                blurRadius: 1.toPXLength,
                color: Colors.white70,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength))
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
          DynamicShapeShadow(
              blurRadius: 40.toPXLength,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
        ],
        textAlign: TextAlign.center,
        textStyle: DynamicTextStyle(
          letterSpacing: 1.0.toVWLength,
          fontSize: 300.toPercentLength,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            DynamicShadow(
                blurRadius: 10.toPXLength,
                color: Colors.white,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
            DynamicShadow(
                blurRadius: 25.toPXLength,
                color: Colors.white,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
            DynamicShadow(
                blurRadius: 2.toPXLength,
                color: Colors.white70,
                offset: DynamicOffset(0.toPXLength, 0.toPXLength))
          ],
        ));

    //printWrapped(json.encode(beginStyle.toJson()));
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
