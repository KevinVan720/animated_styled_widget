import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

enum SimpleValue {
  one,
  two,
  three,
}

class StyledPopupMenuButtonPage extends StatefulWidget {
  StyledPopupMenuButtonPage({this.title = "Styled Navigation Bar"});

  final String title;

  @override
  _StyledPopupMenuButtonPageState createState() =>
      _StyledPopupMenuButtonPageState();
}

class _StyledPopupMenuButtonPageState extends State<StyledPopupMenuButtonPage> {
  late Style buttonStyle;
  late Style itemStyle;
  late Style itemSelectedStyle;

  late SimpleValue _simpleValue;

  void showAndSetMenuSelection(BuildContext context, SimpleValue value) {
    setState(() {
      _simpleValue = value;
    });
    print(_simpleValue);
  }

  String simpleValueToString(BuildContext context, SimpleValue value) => {
        SimpleValue.one: "one",
        SimpleValue.two: "two",
        SimpleValue.three: "three",
      }[value]!;

  @override
  void initState() {
    super.initState();

    _simpleValue = SimpleValue.two;

    buttonStyle = Style(
        //alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Colors.blueAccent,
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(10.toPXLength)),
        ),
        textStyle: DynamicTextStyle(
          color: Colors.grey,
          fontSize: 20.toPXLength,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    itemStyle = Style(
        width: 50.toVWLength,
        height: 50.toPXLength,
        backgroundDecoration:
            BoxDecoration(color: Colors.redAccent.withOpacity(0.3)),
        //alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10),
        textStyle: DynamicTextStyle(
          letterSpacing: 0.1.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 18.toPXLength),
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);
    itemSelectedStyle = itemStyle.copyWith(
        backgroundDecoration: BoxDecoration(color: Colors.green));
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
          alignment: Alignment.center,
          color: Colors.white,
          child: Column(
            children: [_popupButton1Builder],
          )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget get _popupButton1Builder {
    return StyledPopupMenuButton<SimpleValue>(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      style: buttonStyle,
      menuStyle: Style(
          width: 50.toVWLength,
          //height: 100.toVHLength,
          backgroundDecoration: BoxDecoration(color: Colors.amberAccent),
          shapeBorder: RectangleShapeBorder(
              borderRadius: DynamicBorderRadius.all(
                  DynamicRadius.circular(20.toPXLength)))),
      initialValue: _simpleValue,
      onSelected: (value) => showAndSetMenuSelection(context, value),
      child: Text("hello"),
      itemBuilder: (context) => <PopupMenuEntry<SimpleValue>>[
        StyledPopupMenuItem<SimpleValue>(
          style: itemStyle,
          selectedStyle: itemSelectedStyle,
          value: SimpleValue.one,
          child: Text(simpleValueToString(
            context,
            SimpleValue.one,
          )),
        ),
        const PopupMenuDivider(
          height: 2,
        ),
        StyledPopupMenuItem<SimpleValue>(
          style: itemStyle,
          selectedStyle: itemSelectedStyle,
          value: SimpleValue.two,
          child: Text(simpleValueToString(
            context,
            SimpleValue.two,
          )),
        ),
        const PopupMenuDivider(
          height: 2,
        ),
        StyledPopupMenuItem<SimpleValue>(
          style: itemStyle,
          selectedStyle: itemSelectedStyle,
          value: SimpleValue.three,
          child: Text(simpleValueToString(
            context,
            SimpleValue.three,
          )),
        ),
      ],
    );
  }
}
