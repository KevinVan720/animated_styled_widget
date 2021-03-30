import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class ButtonTransform3Page extends StatefulWidget {
  ButtonTransform3Page({this.title = "Button Transform 3"});

  final String title;

  @override
  _ButtonTransform3PageState createState() => _ButtonTransform3PageState();
}

class _ButtonTransform3PageState extends State<ButtonTransform3Page> {
  bool toggleStyle = true;

  late Style beginStyle;
  late Style endStyle;

  @override
  void initState() {
    super.initState();

    beginStyle = Style(
      width: 80.toVMINLength,
      height: 80.toVMINLength,
      backgroundDecoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])),
      shapeBorder: MorphableShapeBorder(
          shape: RectangleShape(
              cornerStyles: RectangleCornerStyles.all(CornerStyle.cutout),
              borderRadius: DynamicBorderRadius.all(
                  DynamicRadius.circular(100.toPercentLength)))),
    );

    endStyle = beginStyle.copyWith(
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
                border: DynamicBorderSide(width: 12, color: Colors.teal),
                borderRadius: DynamicBorderRadius.all(
                    DynamicRadius.circular(0.toPXLength)))),
        shadows: preDefinedShapeShadow[12]);
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
        child: AnimatedStyledContainer(
          curve: Curves.easeInOut,
          duration: Duration(seconds: 3),
          style: toggleStyle ? beginStyle : endStyle,
          child: Container(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            toggleStyle = !toggleStyle;
          });
        },
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
