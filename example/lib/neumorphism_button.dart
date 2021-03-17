import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class NeumorphismPage extends StatefulWidget {
  NeumorphismPage({this.title = "Neumorphism Button"});

  final String title;

  @override
  _NeumorphismPageState createState() => _NeumorphismPageState();
}

class _NeumorphismPageState extends State<NeumorphismPage> {
  bool toggleStyle = true;

  late Style outBeginStyle;
  late Style outEndStyle;
  late Style beginStyle;
  late Style endStyle;

  @override
  void initState() {
    super.initState();

    outBeginStyle = Style(
        width: 440.toPXLength,
        height: 440.toPXLength,
        padding: DynamicEdgeInsets.symmetric(vertical: 20.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(64.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 30.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Color(0xFFFDFDFD),
              offset: DynamicOffset(-15.toPXLength, -15.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Colors.grey.shade500,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
        ],
        insetShadows: [
          DynamicShapeShadow(
              blurRadius: 30.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Colors.grey.shade500,
              offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 30.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Colors.grey.shade50,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
        ],
        mouseCursor: SystemMouseCursors.click);

    outEndStyle = outBeginStyle.copyWith(
      insetShadows: [
        DynamicShapeShadow(
            blurRadius: 30.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Colors.grey.shade200,
            offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
        DynamicShapeShadow(
            blurRadius: 30.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Colors.grey.shade50,
            offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
      ],
    );

    beginStyle = Style(
        width: Dimension.min(80.toVWLength, 400.toPXLength),
        height: 400.toPXLength,
        padding: DynamicEdgeInsets.symmetric(vertical: 20.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade50, Colors.grey.shade200])),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        insetShadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Colors.grey.shade400,
              offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Color(0xFFFEFEFE),
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
          fontWeight: FontWeight.w900,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    endStyle = beginStyle.copyWith(
      backgroundDecoration: BoxDecoration(
        color: Color(0xFFE0E0E0),
      ),
      insetShadows: [
        DynamicShapeShadow(
            blurRadius: 30.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Color(0xFFFFFFFF),
            offset: DynamicOffset(-30.toPXLength, -30.toPXLength)),
        DynamicShapeShadow(
            blurRadius: 30.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Color(0xFFBEBEBE),
            offset: DynamicOffset(30.toPXLength, 30.toPXLength)),
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
          child: Container(
        color: Color(0xFFE0E0E0),
        alignment: Alignment.center,
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
            duration: Duration(milliseconds: 100),
            style: toggleStyle ? outBeginStyle : outEndStyle,
            child: AnimatedStyledContainer(
                duration: Duration(milliseconds: 100),
                style: toggleStyle ? beginStyle : endStyle,
                child: Container()),
          ),
        ),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
