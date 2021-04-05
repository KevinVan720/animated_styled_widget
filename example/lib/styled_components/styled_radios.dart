import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class StyledRadiosPage extends StatefulWidget {
  StyledRadiosPage({this.title = "Styled Radios"});

  final String title;

  @override
  _StyledRadiosPageState createState() => _StyledRadiosPageState();
}

class _StyledRadiosPageState extends State<StyledRadiosPage> {
  late Style neumorphicStyle;
  late Style neumorphicOutStyle;

  late Style keyboardStyle;

  int _value = 0;

  @override
  void initState() {
    super.initState();

    neumorphicOutStyle = Style(
      width: 30.toPXLength,
      height: 30.toPXLength,
      alignment: Alignment.center,
      margin: EdgeInsets.all(20),
      backgroundDecoration: BoxDecoration(
        color: Color(0xFFE0E0E0),
      ),
      shapeBorder: RectangleShapeBorder(
        borderRadius:
            DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
      ),
      shadows: [],
      insetShadows: [
        ShapeShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Color(0xFFFFFFFF),
            offset: Offset(-10, -10)),
        ShapeShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
            offset: Offset(10, 10)),
      ],
      mouseCursor: SystemMouseCursors.click,
    );

    neumorphicStyle = Style(
        opacity: 0,
        width: 20.toPXLength,
        height: 20.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        insetShadows: [
          ShapeShadow(
              blurRadius: 3,
              spreadRadius: 1,
              color: Colors.blueAccent.shade100,
              offset: Offset(1, 1)),
        ],
        mouseCursor: SystemMouseCursors.click);

    keyboardStyle = Style(
        width: 60.toPXLength,
        height: 46.toPXLength,
        alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        backgroundDecoration: BoxDecoration(color: Colors.tealAccent.shade100),
        shapeBorder: RectangleShapeBorder(
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(20.toPXLength)),
            border: DynamicBorderSide(width: 1, color: Colors.teal)),
        shadows: [
          ShapeShadow(
              blurRadius: 10,
              spreadRadius: 1,
              color: Colors.grey.shade700,
              offset: Offset(0, 14)),
          ShapeShadow(blurRadius: 0, color: Colors.teal, offset: Offset(0, 15)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: -1,
              color: Colors.tealAccent.shade400,
              offset: Offset(0, 14)),
        ],
        transform: SmoothMatrix4()..translate(0.toPXLength, -15.toPXLength),
        textStyle: DynamicTextStyle(
            letterSpacing: 5.toPXLength,
            fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
            color: Colors.teal,
            fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);
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
        color: Color(0xFFE0E0E0),
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int i = 1; i <= 5; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StyledRadio(
                          value: i,
                          groupValue: _value,
                          onChanged: (int? value) {
                            setState(() {
                              _value = value ?? 0;
                            });
                          },
                          duration: Duration(milliseconds: 1000),
                          style: neumorphicOutStyle,
                          selectedStyle: neumorphicOutStyle,
                          builder: (BuildContext context,
                              StyledComponentState state) {
                            return AnimatedStyledContainer(
                                style: state == StyledComponentState.selected
                                    ? neumorphicStyle.copyWith(opacity: 1)
                                    : state == StyledComponentState.hovered
                                        ? neumorphicStyle.copyWith(opacity: 0.2)
                                        : neumorphicStyle,
                                duration: Duration(milliseconds: 1000),
                                child: Container());
                          },
                        ),
                        Text(
                          'Radio $i',
                        )
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  for (int i = 1; i <= 5; i++)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StyledRadio(
                          value: i,
                          groupValue: _value,
                          onChanged: (int? value) {
                            setState(() {
                              _value = value ?? 0;
                            });
                          },
                          duration: Duration(milliseconds: 500),
                          style: keyboardStyle,
                          selectedStyle: keyboardStyle.copyWith(
                            shadows: [
                              ShapeShadow(
                                  blurRadius: 3,
                                  spreadRadius: 1,
                                  color: Colors.grey.shade700,
                                  offset: Offset(0, 3)),
                              ShapeShadow(
                                  blurRadius: 0,
                                  color: Colors.teal,
                                  offset: Offset(0, 2)),
                              ShapeShadow(
                                  blurRadius: 0,
                                  spreadRadius: -1,
                                  color: Colors.tealAccent.shade400,
                                  offset: Offset(0, 1)),
                            ],
                            transform: SmoothMatrix4()
                              ..translate(0.toPXLength, -2.toPXLength),
                          ),
                          hoveredStyle: keyboardStyle.copyWith(
                            shadows: [
                              ShapeShadow(
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  color: Colors.grey.shade700,
                                  offset: Offset(0, 10)),
                              ShapeShadow(
                                  blurRadius: 0,
                                  color: Colors.teal,
                                  offset: Offset(0, 11)),
                              ShapeShadow(
                                  blurRadius: 0,
                                  spreadRadius: -1,
                                  color: Colors.tealAccent.shade400,
                                  offset: Offset(0, 10)),
                            ],
                            transform: SmoothMatrix4()
                              ..translate(0.toPXLength, -11.toPXLength),
                          ),
                          builder: (context, state) {
                            Widget child;
                            switch (state) {
                              case StyledComponentState.selected:
                                child = Icon(
                                  Icons.check,
                                  key: UniqueKey(),
                                );
                                break;
                              default:
                                child = Container(key: UniqueKey());
                                break;
                            }
                            return AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: child,
                            );
                          },
                        ),
                        Text(
                          'Radio $i',
                        )
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
