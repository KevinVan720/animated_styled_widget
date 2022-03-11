import 'dart:ui';

import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class StyledSliderPage extends StatefulWidget {
  StyledSliderPage({this.title = "Styled Buttons"});

  final String title;

  @override
  _StyledSliderPageState createState() => _StyledSliderPageState();
}

class _StyledSliderPageState extends State<StyledSliderPage> {
  late Style simpleThumbStyle;
  late Style simpleTrackStyle;

  late Style simple2ThumbStyle;
  late Style simple2TrackStyle;
  late Style simple2ActiveTrackStyle;

  late Style thumbStyle;
  late Style trackStyle;
  late Style activeTrackStyle;
  late Style toolTipStyle;

  late Style thumbVerticalStyle;
  late Style trackVerticalStyle;
  late Style toolTipVerticalStyle;

  late Style iosThumbVerticalStyle;
  late Style iosTrackVerticalStyle;
  late Style iosActiveTrackVerticalStyle;

  late Style neumorphicThumbStyle;
  late Style neumorphicTrackStyle;
  late Style neumorphicActiveTrackStyle;

  double _value = 0.5;

  @override
  void initState() {
    super.initState();

    simpleThumbStyle = Style(
        width: 30.toPXLength,
        height: 30.toPXLength,
        backgroundDecoration: BoxDecoration(
          color: Colors.amberAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    simpleTrackStyle = Style(
        width: 60.toPercentLength,
        height: 4.toPXLength,
        backgroundDecoration: BoxDecoration(
          color: Colors.black87,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(2.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    simple2ThumbStyle = Style(
        width: 50.toPXLength,
        height: 50.toPXLength,
        backgroundDecoration: BoxDecoration(
          color: Colors.amberAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius: DynamicBorderRadius.all(
              DynamicRadius.circular(100.toPercentLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    simple2TrackStyle = Style(
        width: 60.toPercentLength,
        height: 60.toPXLength,
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.deepPurple, Colors.black87])),
        shapeBorder: StarShapeBorder(corners: 4, insetRadius: 10.toPXLength),
        mouseCursor: SystemMouseCursors.click);

    simple2ActiveTrackStyle = Style(
        width: 60.toPercentLength,
        height: 2.toPXLength,
        backgroundDecoration: BoxDecoration(
          color: Colors.white,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(2.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    thumbStyle = Style(
        width: 60.toPXLength,
        height: 60.toPXLength,
        childAlignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.amberAccent,
        ),
        shapeBorder:
            StarShapeBorder(corners: 5, cornerRadius: 10.toPercentLength),
        shadows: [
          ShapeShadow(blurRadius: 6, color: Colors.grey, offset: Offset(2, 2)),
        ],
        transform: SmoothMatrix4()..scale(1),
        mouseCursor: SystemMouseCursors.click);

    toolTipStyle = Style(
        width: 70.toPXLength,
        height: 50.toPXLength,
        padding: EdgeInsets.all(4),
        alignment: Alignment.center,
        childAlignment: Alignment(0, -0.5),
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        shapeBorder: BubbleShapeBorder(),
        shadows: [],
        textStyle: DynamicTextStyle(
          fontSize: (16.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        transform: SmoothMatrix4()..translate(0.toPXLength, -80.toPXLength),
        mouseCursor: SystemMouseCursors.click);

    trackStyle = Style(
        width: 70.toPercentLength,
        height: 20.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.grey,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    activeTrackStyle = Style(
        height: 30.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent.shade400,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    thumbVerticalStyle = Style(
        width: 20.toPXLength,
        height: 20.toPXLength,
        childAlignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        shadows: [
          ShapeShadow(
              blurRadius: 10,
              color: Colors.grey.shade400,
              offset: Offset(2, 2)),
        ],
        transform: SmoothMatrix4()..scale(1),
        mouseCursor: SystemMouseCursors.click);

    trackVerticalStyle = Style(
        width: 10.toPXLength,
        height: 200.toPXLength,
        margin: EdgeInsets.symmetric(horizontal: 100),
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.grey,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        ),
        textStyle: DynamicTextStyle(
          letterSpacing: 0.2.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 26.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    toolTipVerticalStyle = Style(
        width: 90.toPXLength,
        height: 40.toPXLength,
        padding: EdgeInsets.all(4),
        alignment: Alignment.center,
        childAlignment: Alignment(0.5, 0.0),
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        shapeBorder: BubbleShapeBorder(
            side: ShapeSide.left, arrowHeadPosition: 25.toPercentLength),
        shadows: [],
        textStyle: DynamicTextStyle(
          fontSize: (16.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        transform: SmoothMatrix4()..translate(70.toPXLength, 10.toPXLength),
        mouseCursor: SystemMouseCursors.click);

    iosThumbVerticalStyle = Style(
        width: 100.toPXLength,
        height: 20.toPXLength,
        childAlignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.transparent,
        ),
        mouseCursor: SystemMouseCursors.click);

    iosTrackVerticalStyle = Style(
        width: 100.toPXLength,
        height: 200.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.black54,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(25.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);
    iosActiveTrackVerticalStyle = Style(
        width: 100.toPXLength,
        height: 100.toPXLength,
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blue,
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(25.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);

    neumorphicTrackStyle = Style(
      width: 88.toPercentLength,
      height: 20.toPXLength,
      backgroundDecoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
      ),
      shapeBorder: RectangleShapeBorder(
        borderRadius:
            DynamicBorderRadius.all(DynamicRadius.circular(10.toPXLength)),
      ),
      insetShadows: [
        ShapeShadow(
            blurRadius: 6,
            spreadRadius: -3,
            color: Colors.grey.shade400,
            offset: const Offset(6, 6)),
        const ShapeShadow(
            blurRadius: 6,
            spreadRadius: -3,
            color: Color(0xFFFEFEFE),
            offset: Offset(-6, -6)),
      ],
    );

    neumorphicActiveTrackStyle = Style(
      height: 20.toPXLength,
      backgroundDecoration: const BoxDecoration(
        color: Color(0xFFA0A0A0),
      ),
      shapeBorder: RectangleShapeBorder(
        borderRadius:
            DynamicBorderRadius.all(DynamicRadius.circular(10.toPXLength)),
      ),
      shadows: [
        ShapeShadow(
            blurRadius: 6,
            spreadRadius: -3,
            color: Colors.grey.shade400,
            offset: const Offset(-6, -6)),
        const ShapeShadow(
            blurRadius: 6,
            spreadRadius: -3,
            color: Color(0xFFFEFEFE),
            offset: Offset(6, 6)),
      ],
    );

    neumorphicThumbStyle = Style(
        shapeBorder: CircleShapeBorder(),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFA0A0A0),
        ),
        width: 20.toPXLength,
        height: 20.toPXLength);
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
        decoration: BoxDecoration(color: Colors.grey.shade100),
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Center(
              child: StyledSlider(
                value: _value,
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                },
                thumbStyle: simpleThumbStyle,
                trackStyle: simpleTrackStyle,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: StyledSlider(
                value: _value,
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                },
                thumbStyle: simple2ThumbStyle,
                trackStyle: simple2TrackStyle,
                activeTrackStyle: simple2ActiveTrackStyle,
                thumbChild: Icon(Icons.code),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: StyledSlider(
                value: _value,
                onChanged: (double value) {
                  setState(() {
                    _value = value;
                  });
                },
                thumbStyle: neumorphicThumbStyle,
                trackStyle: neumorphicTrackStyle,
                activeTrackStyle: neumorphicActiveTrackStyle,
                isTrackContained: true,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                height: 150,
                child: StyledSlider(
                  //divisions: 25,
                  label: (_value * 100).roundWithPrecision(0).toString() + "%",
                  value: _value,
                  onChanged: (double value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  duration: Duration(milliseconds: 200),
                  thumbStyle: thumbStyle,
                  thumbPressedStyle: thumbStyle.copyWith(
                      width: 100.toPXLength, height: 100.toPXLength),
                  trackStyle: trackStyle,
                  activeTrackStyle: activeTrackStyle,
                  toolTipStyle: toolTipStyle,
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            StyledSlider(
              divisions: 5,
              label: (_value * 100).roundWithPrecision(0).toString() + "%",
              value: _value,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
              },
              duration: Duration(milliseconds: 200),
              thumbStyle: thumbVerticalStyle,
              thumbPressedStyle: thumbVerticalStyle.copyWith(
                  width: 30.toPXLength, height: 30.toPXLength),
              trackStyle: trackVerticalStyle,
              toolTipStyle: toolTipVerticalStyle,
              direction: Axis.vertical,
            ),
            SizedBox(
              height: 50,
            ),
            StyledSlider(
              //divisions: 25,
              value: _value,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
              },
              duration: Duration(milliseconds: 200),
              thumbStyle: iosThumbVerticalStyle,
              trackStyle: iosTrackVerticalStyle,
              activeTrackStyle: iosActiveTrackVerticalStyle,
              direction: Axis.vertical,
            ),
            SizedBox(
              height: 50,
            ),
            Center(child: Text(_value.toString())),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
