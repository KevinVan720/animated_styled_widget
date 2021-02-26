import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_styled_widget/styled_widget.dart';
import 'package:dimension/dimension.dart';
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
      //alignment: Alignment.center,
        width: 50.toVWLength,
        //height: 120.toPXLength,
        margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent])),
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
                right:
                DynamicBorderSide(color: Colors.purpleAccent, width: 28))),
        shadows: [
          DynamicBoxShadow(
              blurRadius: 15.toPXLength,
              color: Colors.cyanAccent,
              offset:
              DynamicOffset((-2).toPXLength, (0).toPXLength)),
          DynamicBoxShadow(
              blurRadius: 15.toPXLength,
              color: Colors.deepPurpleAccent,
              offset: DynamicOffset(2.toPXLength, 0.toPXLength)),
        ],
        opacity: 1,
        textStyle: DynamicTextStyle(
          letterSpacing: 2.toVWLength,
          fontSize: 6.toVWLength,
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
        shape: (beginStyle.shape as RoundedRectangleShape).copyWith(
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
                right: DynamicBorderSide(color: Colors.purpleAccent, width: 20))),
        shadows: [
          DynamicBoxShadow(
              blurRadius: 20.toPXLength,
              color: Colors.cyanAccent,
              offset:
              DynamicOffset((-2).toPXLength, (0).toPXLength)),
          DynamicBoxShadow(
              blurRadius: 20.toPXLength,
              color: Colors.deepPurpleAccent,
              offset: DynamicOffset(2.toPXLength, 0.toPXLength)),
        ],
        textAlign: TextAlign.center,
        textStyle: DynamicTextStyle(
          letterSpacing: 2.2.toVWLength,
          fontSize: 6.toVWLength,
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
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    /*
    Map<ScreenScope, Style> endStyle = {
      typicalTabletScreenScope: Style(
          alignment: Alignment.center,
          width: 200.toPXLength,
          height: 140.toPXLength,
          margin: DynamicEdgeInsets.symmetric(vertical: 10.toPXLength),
          backgroundDecoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.red, Colors.red])),
          shape: PolygonShape(sides: 12, cornerRadius: 50.toPXLength),
          shadows: [
            DynamicBoxShadow(
                blurRadius: 10.toPXLength,
                color: Colors.grey,
                offset: DynamicOffset(10.toPXLength, 10.toPXLength))
          ],
          translationX: 0,
          translationY: 0,
          textStyle: DynamicTextStyle(
              fontSize: 3.toVWLength, color: Colors.blueAccent)),
      typicalDesktopScreenScope: Style(
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
            borderRadius: DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
              border: DynamicBorderSide(
                  width: 10.toPercentLength,
                  color: Color.fromARGB(255, 246, 167, 186))),
          translationX: 50,
          translationY: -150,
          rotationX: 20,
          //rotationY: 20,
          childAlignment: Alignment.center,
          opacity: 0.8,
          textStyle: DynamicTextStyle(
              letterSpacing: 5,
              fontSize: 4.toVWLength,
              fontWeight: FontWeight.bold,
              color: Colors.tealAccent.shade700))
    };

     */

    //debugPrint(json.encode(beginStyle.toJson()));

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
                    //duration: Duration(milliseconds: 10),
                    child: Text("Hello World")),
              )
            ],
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}