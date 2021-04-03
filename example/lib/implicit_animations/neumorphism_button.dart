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
        padding: EdgeInsets.symmetric(vertical: 20),
        childAlignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(64.toPXLength)),
        ),
        shadows: [
          ShapeShadow(
              blurRadius: 30,
              spreadRadius: 1,
              color: Color(0xFFFDFDFD),
              offset: Offset(-15, -15)),
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: 1,
              color: Colors.grey.shade500,
              offset: Offset(20, 20)),
        ],
        insetShadows: [
          ShapeShadow(
              blurRadius: 30,
              spreadRadius: 1,
              color: Colors.grey.shade500,
              offset: Offset(-20, -20)),
          ShapeShadow(
              blurRadius: 30,
              spreadRadius: 1,
              color: Colors.grey.shade50,
              offset: Offset(20, 20)),
        ],
        mouseCursor: SystemMouseCursors.click);

    outEndStyle = outBeginStyle.copyWith(
      insetShadows: [
        ShapeShadow(
            blurRadius: 30,
            spreadRadius: 1,
            color: Colors.grey.shade200,
            offset: Offset(-20, -20)),
        ShapeShadow(
            blurRadius: 30,
            spreadRadius: 1,
            color: Colors.grey.shade50,
            offset: Offset(20, 20)),
      ],
    );

    beginStyle = Style(
        width: 400.toPXLength,
        height: 400.toPXLength,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.grey.shade50, Colors.grey.shade200])),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        insetShadows: [
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Colors.grey.shade400,
              offset: Offset(-20, -20)),
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Color(0xFFFEFEFE),
              offset: Offset(20, 20)),
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
        ShapeShadow(
            blurRadius: 30,
            spreadRadius: 1,
            color: Color(0xFFFFFFFF),
            offset: Offset(-30, -30)),
        ShapeShadow(
            blurRadius: 30,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
            offset: Offset(30, 30)),
      ],
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
