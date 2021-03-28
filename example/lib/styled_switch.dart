import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_components/styled_switch.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

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

  late Style rotateThumbStyle;
  late Style rotateTrackStyle;

  bool _selected = true;

  @override
  void initState() {
    super.initState();

    neumorphicThumbStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: DynamicEdgeInsets.symmetric(
            vertical: 10.toPXLength, horizontal: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Colors.grey.shade400,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Color(0xFFFEFEFE),
              offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.2.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 26.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        transform: SmoothMatrix4()..scale(1.5),
        mouseCursor: SystemMouseCursors.click);

    neumorphicTrackStyle = Style(
        width: 220.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Colors.grey.shade400,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              spreadRadius: -5.toPXLength,
              color: Color(0xFFFEFEFE),
              offset: DynamicOffset(-20.toPXLength, -20.toPXLength)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.2.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 26.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    iosThumbStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: DynamicEdgeInsets.symmetric(
            vertical: 10.toPXLength, horizontal: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        transform: SmoothMatrix4()..rotateZ(3.1415),
        mouseCursor: SystemMouseCursors.click);

    iosTrackStyle = Style(
        width: 240.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        shapeBorder: MorphableShapeBorder(
          shape: RectangleShape(
            //border: DynamicBorderSide(width: 6, color: Colors.grey.shade200),
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
          ),
        ),
        mouseCursor: SystemMouseCursors.click);

    rotateThumbStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        childAlignment: Alignment.center,
        margin: DynamicEdgeInsets.symmetric(
            vertical: 10.toPXLength, horizontal: 10.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        mouseCursor: SystemMouseCursors.click);

    rotateTrackStyle = Style(
        width: 250.toPXLength,
        height: 100.toPXLength,
        padding: DynamicEdgeInsets.all(20.toPXLength),
        margin: DynamicEdgeInsets.all(20.toPXLength),
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        shapeBorder: MorphableShapeBorder(
          shape: RectangleShape(
            //border: DynamicBorderSide(width: 6, color: Colors.grey.shade200),
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(60.toPXLength)),
          ),
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
            StyledSwitch(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              duration: Duration(milliseconds: 200),
              builder: childBuilder,
              thumbStyle: neumorphicThumbStyle,
              thumbSelectedStyle: neumorphicThumbStyle.copyWith(
                shadows: [
                  DynamicShapeShadow(
                      blurRadius: 20.toPXLength,
                      spreadRadius: -5.toPXLength,
                      color: Colors.grey.shade400,
                      offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
                ],
              ),
              thumbHoveredStyle: neumorphicThumbStyle.copyWith(
                shadows: [
                  DynamicShapeShadow(
                      blurRadius: 20.toPXLength,
                      spreadRadius: -2.toPXLength,
                      color: Colors.grey.shade400,
                      offset: DynamicOffset(10.toPXLength, 10.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 20.toPXLength,
                      spreadRadius: -2.toPXLength,
                      color: Color(0xFFFEFEFE),
                      offset: DynamicOffset(-10.toPXLength, -10.toPXLength)),
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
            StyledSwitch(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              duration: Duration(milliseconds: 200),
              builder: childBuilder,
              thumbStyle: iosThumbStyle,
              thumbSelectedStyle: iosThumbStyle.copyWith(
                transform: SmoothMatrix4(),
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
            StyledSwitch(
              value: _selected,
              onChanged: (bool value) {
                setState(() {
                  _selected = value;
                });
              },
              duration: Duration(milliseconds: 1000),
              builder: childBuilder,
              thumbStyle: rotateThumbStyle,
              thumbSelectedStyle:
                  rotateThumbStyle.copyWith(transform: SmoothMatrix4()),
              trackStyle: rotateTrackStyle,
              trackSelectedStyle: rotateTrackStyle.copyWith(
                width: 400.toPXLength,
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
