import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class StyledSliderPage extends StatefulWidget {
  StyledSliderPage({this.title = "Styled Buttons"});

  final String title;

  @override
  _StyledSliderPageState createState() => _StyledSliderPageState();
}

class _StyledSliderPageState extends State<StyledSliderPage> {
  late Style neumorphicStyle;
  late Style neumorphicBackgroundStyle;

  double _value = 0.5;

  @override
  void initState() {
    super.initState();

    neumorphicStyle = Style(
        width: 40.toPXLength,
        height: 40.toPXLength,
        childAlignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              color: Colors.grey.shade400,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
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
        transform: SmoothMatrix4()..scale(1),
        mouseCursor: SystemMouseCursors.click);

    neumorphicBackgroundStyle = Style(
        width: 100.toPXLength,
        //aspectRatio: 0.1,
        height: 20.toPXLength,
        alignment: Alignment.center,
        margin: DynamicEdgeInsets.symmetric(
            horizontal: 10.toPXLength, vertical: 0.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Colors.grey,
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              color: Colors.grey.shade400,
              offset: DynamicOffset(20.toPXLength, 20.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
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
            StyledSlider(
              value: _value,
              onChanged: (double value) {
                setState(() {
                  _value = value;
                });
              },
              duration: Duration(milliseconds: 200),
              thumbStyle: neumorphicStyle,
              trackStyle: neumorphicBackgroundStyle,
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
