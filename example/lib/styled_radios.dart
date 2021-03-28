import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class StyledRadiosPage extends StatefulWidget {
  StyledRadiosPage({this.title = "Styled Radios"});

  final String title;

  @override
  _StyledRadiosPageState createState() => _StyledRadiosPageState();
}

class _StyledRadiosPageState extends State<StyledRadiosPage> {
  late Style neumorphicStyle;
  late Style neumorphicOutStyle;

  int _value = 0;

  @override
  void initState() {
    super.initState();

    neumorphicOutStyle = Style(
      width: 30.toPXLength,
      height: 30.toPXLength,
      alignment: Alignment.center,
      padding: DynamicEdgeInsets.all(0.toPXLength),
      margin: DynamicEdgeInsets.all(20.toPXLength),
      backgroundDecoration: BoxDecoration(
        color: Color(0xFFE0E0E0),
      ),
      shapeBorder: MorphableShapeBorder(
          shape: RectangleShape(
        borderRadius:
            DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
      )),
      shadows: [],
      insetShadows: [
        DynamicShapeShadow(
            blurRadius: 10.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Color(0xFFFFFFFF),
            offset: DynamicOffset(-10.toPXLength, -10.toPXLength)),
        DynamicShapeShadow(
            blurRadius: 10.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Color(0xFFBEBEBE),
            offset: DynamicOffset(10.toPXLength, 10.toPXLength)),
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
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        insetShadows: [
          DynamicShapeShadow(
              blurRadius: 3.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Colors.blueAccent.shade100,
              offset: DynamicOffset(1.toPXLength, 1.toPXLength)),
        ],
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
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
