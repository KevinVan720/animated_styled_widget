import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class StyledSwitchPage extends StatefulWidget {
  StyledSwitchPage({this.title = "Styled Buttons"});

  final String title;

  @override
  _StyledSwitchPageState createState() => _StyledSwitchPageState();
}

class _StyledSwitchPageState extends State<StyledSwitchPage> {
  late Style neumorphicThumbStyle;
  late Style neumorphicTrackStyle;

  late Style iosThumbStyle;
  late Style iosTrackStyle;

  late Style morphThumbStyle;
  late Style morphTrackStyle;

  late Style morphVerticalThumbStyle;
  late Style morphVerticalTrackStyle;

  bool _selected = true;

  @override
  void initState() {
    super.initState();

    neumorphicThumbStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        shadows: [
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Colors.grey.shade400,
              offset: Offset(20, 20)),
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Color(0xFFFEFEFE),
              offset: Offset(-20, -20)),
        ],
        mouseCursor: SystemMouseCursors.click);

    neumorphicTrackStyle = Style(
        width: 240.toPXLength,
        height: 120.toPXLength,
        //alignment: Alignment.centerLeft,
        //margin: EdgeInsets.symmetric(horizontal: 10),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFDEDEDE),
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
        ),
        shadows: [
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Colors.grey.shade400,
              offset: Offset(20, 20)),
          ShapeShadow(
              blurRadius: 20,
              spreadRadius: -5,
              color: Color(0xFFFEFEFE),
              offset: Offset(-20, -20)),
        ],
        mouseCursor: SystemMouseCursors.click);

    iosThumbStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        //margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: RectangleShapeBorder(
          border: DynamicBorderSide(
              width: 10,
              color: Colors.amber,
              begin: 0.toPercentLength,
              end: 0.toPercentLength,
              strokeCap: StrokeCap.butt),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        transform: SmoothMatrix4()..rotateZ(3.1415),
        mouseCursor: SystemMouseCursors.click);

    iosTrackStyle = Style(
        width: 240.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          //border: DynamicBorderSide(width: 6, color: Colors.grey.shade200),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    morphThumbStyle = Style(
        width: 150.toPXLength,
        height: 150.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(75.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    morphTrackStyle = Style(
        width: 250.toPXLength,
        height: 80.toPXLength,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        //alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          //border: DynamicBorderSide(width: 6, color: Colors.grey.shade200),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    morphVerticalThumbStyle = Style(
        width: 150.toPXLength,
        height: 150.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(75.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    morphVerticalTrackStyle = Style(
        width: 80.toPXLength,
        height: 250.toPXLength,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          //border: DynamicBorderSide(width: 6, color: Colors.grey.shade200),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);
  }

  @override
  Widget build(BuildContext context) {
    var childBuilder = (context, state) {
      Widget child;
      switch (state) {
        case StyledComponentState.selected:
          child = Icon(
            Icons.check,
            key: UniqueKey(),
          );
          break;
        default:
          child = Icon(
            Icons.cancel_outlined,
            key: UniqueKey(),
          );
          break;
      }
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: child,
      );
    };

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
            StyledSwitch.builder(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              duration: Duration(milliseconds: 200),
              thumbChildBuilder: childBuilder,
              thumbStyle: neumorphicThumbStyle,
              thumbSelectedStyle: neumorphicThumbStyle.copyWith(
                  backgroundDecoration: BoxDecoration(color: Colors.black38),
                  shadows: [],
                  insetShadows: [
                    ShapeShadow(
                        blurRadius: 6,
                        spreadRadius: 0,
                        color: Colors.black54,
                        offset: Offset(3, 3)),
                    ShapeShadow(
                        blurRadius: 6,
                        spreadRadius: 0,
                        color: Colors.grey.shade300,
                        offset: Offset(-3, -3)),
                  ]),
              thumbHoveredStyle: neumorphicThumbStyle.copyWith(
                shadows: [
                  ShapeShadow(
                      blurRadius: 20,
                      spreadRadius: -2,
                      color: Colors.grey.shade400,
                      offset: Offset(10, 10)),
                  ShapeShadow(
                      blurRadius: 20,
                      spreadRadius: -2,
                      color: Color(0xFFFEFEFE),
                      offset: Offset(-10, -10)),
                ],
              ),
              trackStyle: neumorphicTrackStyle,
              trackSelectedStyle: neumorphicTrackStyle.copyWith(
                backgroundDecoration: BoxDecoration(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StyledSwitch.builder(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              duration: Duration(milliseconds: 1000),
              thumbChildBuilder: childBuilder,
              thumbStyle: iosThumbStyle,
              thumbSelectedStyle: iosThumbStyle.copyWith(
                transform: SmoothMatrix4(),
                shapeBorder: RectangleShapeBorder(
                  border: DynamicBorderSide(
                      width: 10,
                      color: Colors.amber,
                      begin: 0.toPercentLength,
                      end: 100.toPercentLength),
                  borderRadius: DynamicBorderRadius.all(
                      DynamicRadius.circular(50.toPXLength)),
                ),
              ),
              trackStyle: iosTrackStyle,
              trackSelectedStyle: iosTrackStyle.copyWith(
                backgroundDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StyledSwitch.builder(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              //duration: Duration(milliseconds: 1000),
              thumbChildBuilder: childBuilder,
              thumbStyle: morphThumbStyle,
              thumbSelectedStyle: morphThumbStyle.copyWith(
                transform: SmoothMatrix4(),
                shapeBorder: RectangleShapeBorder(
                  borderRadius: DynamicBorderRadius.all(
                      DynamicRadius.circular(25.toPXLength)),
                ),
              ),
              trackStyle: morphTrackStyle,
              trackSelectedStyle: morphTrackStyle.copyWith(
                backgroundDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StyledSwitch.builder(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              //duration: Duration(milliseconds: 1000),
              thumbChildBuilder: childBuilder,
              direction: Axis.vertical,
              thumbStyle: morphVerticalThumbStyle,
              thumbSelectedStyle: morphVerticalThumbStyle.copyWith(
                transform: SmoothMatrix4(),
                shapeBorder: RectangleShapeBorder(
                  borderRadius: DynamicBorderRadius.all(
                      DynamicRadius.circular(25.toPXLength)),
                ),
              ),
              trackStyle: morphVerticalTrackStyle,
              trackSelectedStyle: morphVerticalTrackStyle.copyWith(
                backgroundDecoration: BoxDecoration(
                  color: Colors.greenAccent,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
