import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';

class StyledToggleButtonsPage extends StatefulWidget {
  StyledToggleButtonsPage({this.title = "Styled Toggle Buttons"});

  final String title;

  @override
  _StyledToggleButtonsPageState createState() =>
      _StyledToggleButtonsPageState();
}

class _StyledToggleButtonsPageState extends State<StyledToggleButtonsPage> {
  late Style neumorphicStyle;
  late Style neonStyle;
  late Style macKeyboardStyle;
  late Style materialStyle;

  List<bool> isSelected = [false, false, false];

  @override
  void initState() {
    super.initState();

    neumorphicStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.symmetric(horizontal: 10),
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
        textStyle: DynamicTextStyle(
          letterSpacing: 0.2.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 26.toPXLength),
          fontWeight: FontWeight.w700,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    neonStyle = Style(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.all(20),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent])),
        shapeBorder: RoundedRectangleShapeBorder(
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(10.toPXLength)),
            borders: RectangleBorders.only(
                top: DynamicBorderSide(
                    gradient: LinearGradient(colors: [
                      Colors.cyanAccent.shade100,
                      Colors.purpleAccent.shade100
                    ]),
                    width: 11),
                bottom: DynamicBorderSide(
                    gradient:
                        LinearGradient(colors: [Colors.cyan, Colors.purple]),
                    width: 29),
                left: DynamicBorderSide(
                    color: Colors.cyanAccent.shade200, width: 11),
                right:
                    DynamicBorderSide(color: Colors.purpleAccent, width: 29))),
        shadows: [
          ShapeShadow(
              blurRadius: 25,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: Offset(0, 0)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
        shaderGradient:
            LinearGradient(colors: [Colors.purpleAccent, Colors.cyanAccent]),
        mouseCursor: SystemMouseCursors.click);

    macKeyboardStyle = Style(
        width: 120.toPXLength,
        height: 100.toPXLength,
        //alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(10),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFF4F5F6),
        ),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(35.toPXLength)),
        ),
        shadows: [
          ShapeShadow(
              blurRadius: 20,
              color: Colors.grey.shade500,
              offset: Offset(10, 10)),
          ShapeShadow(
              blurRadius: 20,
              color: Color(0xFFFEFEFE),
              offset: Offset(-10, 15)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Color(0xFF444444),
              offset: Offset(-4, 14)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Color(0xFF444444),
              offset: Offset(4, 14)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Color(0xFF444444),
              offset: Offset(-4, 6)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Color(0xFF444444),
              offset: Offset(4, 6)),
          ShapeShadow(
              blurRadius: 0,
              spreadRadius: 0,
              color: Color(0xFFDDDDDD),
              offset: Offset(0, 10)),
        ],
        transform: SmoothMatrix4()..translate(0.toPXLength, -10.toPXLength),
        textStyle: DynamicTextStyle(
          fontSize: 28.toPXLength,
          fontWeight: FontWeight.w400,
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    materialStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: RectangleShapeBorder(
          border: DynamicBorderSide(width: 0, color: Colors.grey.shade500),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(0.toPXLength)),
        ),
        mouseCursor: SystemMouseCursors.click);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [
      Icon(Icons.ac_unit),
      Icon(Icons.call),
      Icon(Icons.cake),
    ];
    var childrenBuilder =
        (BuildContext context, StyledComponentState state, int index) {
      Widget child;
      if (state == StyledComponentState.selected) {
        child = Icon(
          Icons.check,
          color: Colors.green,
          key: UniqueKey(),
        );
      } else {
        child = icons[index];
      }
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
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
            Center(
              child: StyledToggleButtons(
                builder: childrenBuilder,
                onPressed: (int index) {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                  });
                },
                isSelected: isSelected,
                style: neumorphicStyle,
                selectedStyle: neumorphicStyle.copyWith(
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
                ),
                hoveredStyle: neumorphicStyle.copyWith(shadows: [
                  ShapeShadow(
                      blurRadius: 20,
                      spreadRadius: -2,
                      color: Colors.grey.shade400,
                      offset: Offset(10, 10)),
                  ShapeShadow(
                      blurRadius: 20,
                      spreadRadius: -2,
                      color: Color(0xFFFEFEFE),
                      offset: Offset(-10, -10))
                ]),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: StyledToggleButtons(
                children: icons,
                onPressed: (int index) {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                  });
                },
                isSelected: isSelected,
                style: neonStyle,
                selectedStyle: neonStyle.copyWith(
                    padding: EdgeInsets.all(23),
                    shapeBorder: RoundedRectangleShapeBorder(
                        borderRadius: DynamicBorderRadius.all(
                            DynamicRadius.circular(10.toPXLength)),
                        borders: RectangleBorders.only(
                            top: DynamicBorderSide(
                                gradient: LinearGradient(colors: [
                                  Colors.cyanAccent.shade100,
                                  Colors.purpleAccent.shade100
                                ]),
                                width: 14),
                            bottom: DynamicBorderSide(
                                gradient: LinearGradient(
                                    colors: [Colors.cyan, Colors.purple]),
                                width: 20),
                            left: DynamicBorderSide(
                                color: Colors.cyanAccent.shade200, width: 14),
                            right: DynamicBorderSide(
                                color: Colors.purpleAccent, width: 20)))),
                hoveredStyle: neonStyle.copyWith(
                    shapeBorder: RoundedRectangleShapeBorder(
                        borderRadius: DynamicBorderRadius.all(
                            DynamicRadius.circular(10.toPXLength)),
                        borders: RectangleBorders.only(
                            top: DynamicBorderSide(
                                gradient: LinearGradient(colors: [
                                  Colors.cyanAccent.shade100,
                                  Colors.purpleAccent.shade100
                                ]),
                                width: 13),
                            bottom: DynamicBorderSide(
                                gradient: LinearGradient(
                                    colors: [Colors.cyan, Colors.purple]),
                                width: 27),
                            left: DynamicBorderSide(
                                color: Colors.cyanAccent.shade200, width: 13),
                            right: DynamicBorderSide(
                                color: Colors.purpleAccent, width: 27)))),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              alignment: Alignment.center,
              child: StyledToggleButtons(
                builder: childrenBuilder,
                onPressed: (int index) {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                  });
                },
                isSelected: isSelected,
                style: macKeyboardStyle,
                selectedStyle: macKeyboardStyle.copyWith(
                  shadows: [
                    ShapeShadow(
                        blurRadius: 5,
                        color: Colors.grey.shade500,
                        offset: Offset(2, 2)),
                    ShapeShadow(
                        blurRadius: 5,
                        color: Color(0xFFFEFEFE),
                        offset: Offset(-2, 2)),
                    ShapeShadow(
                        blurRadius: 0,
                        spreadRadius: 0,
                        color: Color(0xFF444444),
                        offset: Offset(-4, 4)),
                    ShapeShadow(
                        blurRadius: 0,
                        spreadRadius: 0,
                        color: Color(0xFF444444),
                        offset: Offset(4, 4)),
                    ShapeShadow(
                        blurRadius: 0,
                        spreadRadius: 0,
                        color: Color(0xFF444444),
                        offset: Offset(-4, -4)),
                    ShapeShadow(
                        blurRadius: 0,
                        spreadRadius: 0,
                        color: Color(0xFF444444),
                        offset: Offset(4, -4))
                  ],
                  transform: SmoothMatrix4(),
                ),
                hoveredStyle: macKeyboardStyle,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 200),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: StyledToggleButtons(
                direction: Axis.vertical,
                children: icons,
                onPressed: (int index) {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                  });
                },
                isSelected: isSelected,
                style: materialStyle,
                selectedStyle: materialStyle.copyWith(
                    backgroundDecoration: BoxDecoration(
                        color: Colors.deepPurpleAccent.withOpacity(0.3))),
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
