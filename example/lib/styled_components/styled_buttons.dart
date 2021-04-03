import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class StyledButtonsPage extends StatefulWidget {
  StyledButtonsPage({this.title = "Styled Buttons"});

  final String title;

  @override
  _StyledButtonsPageState createState() => _StyledButtonsPageState();
}

class _StyledButtonsPageState extends State<StyledButtonsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Style neumorphicStyle = Style(
        width: 200.toPXLength,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
    Style neonStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent])),
        shapeBorder: RoundedRectangleShapeBorder(
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(15.toPXLength)),
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
    Style comicStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.all(20),
        backgroundDecoration: BoxDecoration(color: Colors.amberAccent),
        shadows: [
          ShapeShadow(
              blurRadius: 0, color: Colors.black87, offset: Offset(10, 10)),
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 0.8.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
        transform: SmoothMatrix4()..translate(-10.toPXLength, -10.toPXLength),
        mouseCursor: SystemMouseCursors.click);
    Style skeumorphismStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              Color(0xFFD8D9DB),
              Color(0xFFFFFFFF),
              Color(0xFFFDFDFD),
            ],
                stops: [
              0,
              0.8,
              1
            ])),
        shapeBorder: RectangleShapeBorder(
            borderRadius:
                DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
            border: DynamicBorderSide(
              color: Color(0xFF8F9092),
              width: 1,
              //begin: (50*pi).toPXLength
            )),
        shadows: [
          ShapeShadow(
            offset: Offset(0, -6),
            blurRadius: 4,
            color: Color(0xFFFEFEFE),
          ),
          ShapeShadow(
            offset: Offset(0, -4),
            blurRadius: 4,
            color: Color(0xFFCECFD1),
          ),
          ShapeShadow(
            offset: Offset(0, 6),
            blurRadius: 8,
            color: Color(0xFFd6d7d9),
          ),
          ShapeShadow(
            offset: Offset(0, 4),
            blurRadius: 3,
            spreadRadius: 1,
            color: Color(0xFFFCFCFC),
          ),
        ],
        insetShadows: [
          ShapeShadow(
            offset: Offset(0, 0),
            blurRadius: 3,
            color: Color(0xFFCECFD1),
          )
        ],
        textStyle: DynamicTextStyle(
          letterSpacing: 1.toPXLength,
          fontSize: Dimension.min(300.toPercentLength, 18.toPXLength),
          fontWeight: FontWeight.w500,
          color: Color(0xFF606060),
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);
    Style keyboardStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
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
    Style macKeyboardStyle = Style(
        width: 180.toPXLength,
        height: 180.toPXLength,
        alignment: Alignment.center,
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
        childAlignment: Alignment(0, 0.8),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

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
            StyledButton(
              duration: Duration(milliseconds: 200),
              style: neumorphicStyle,
              pressedStyle: neumorphicStyle.copyWith(
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
              hoveredStyle: neumorphicStyle.copyWith(
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
              onPressed: () {
                print("Tapped!");
              },
              builder: (context, state) {
                Widget child;
                switch (state) {
                  case StyledComponentState.pressed:
                    child = Text(
                      "TAPPED",
                      key: UniqueKey(),
                    );
                    break;
                  case StyledComponentState.hovered:
                    child = Text(
                      "HOVERED",
                      key: UniqueKey(),
                    );
                    break;
                  default:
                    child = Text(
                      "TAP ME",
                      key: UniqueKey(),
                    );
                    break;
                }
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: child,
                );
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("TAP ME"),
              style: neonStyle,
              pressedStyle: neonStyle.copyWith(
                  padding: EdgeInsets.all(23),
                  shapeBorder: RoundedRectangleShapeBorder(
                      borderRadius: DynamicBorderRadius.all(
                          DynamicRadius.circular(15.toPXLength)),
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
                          DynamicRadius.circular(15.toPXLength)),
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
              onPressed: () {
                print("Tapped!");
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("TAP ME"),
              style: comicStyle,
              pressedStyle: comicStyle.copyWith(
                shadows: [
                  ShapeShadow(
                      blurRadius: 0,
                      color: Colors.black87,
                      offset: Offset(0, 0)),
                ],
                transform: SmoothMatrix4()
                  ..translate(0.toPXLength, 0.toPXLength),
              ),
              hoveredStyle: comicStyle.copyWith(
                shadows: [
                  ShapeShadow(
                      blurRadius: 0,
                      color: Colors.black87,
                      offset: Offset(5, 5)),
                ],
                transform: SmoothMatrix4()
                  ..translate(-5.toPXLength, -5.toPXLength),
              ),
              duration: Duration(milliseconds: 50),
              onPressed: () {
                print("Tapped!");
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("TAP ME"),
              style: skeumorphismStyle,
              pressedStyle: skeumorphismStyle.copyWith(
                backgroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                      Color(0xFFD8D9DB),
                      //Color(0xFFFFFFFF),
                      Color(0xFFFDFDFD),
                    ],
                        stops: [
                      0,
                      //0.8,
                      1
                    ])),
                insetShadows: [
                  ShapeShadow(
                    offset: Offset(0, 0),
                    blurRadius: 10,
                    spreadRadius: 3,
                    color: Color(0xFFCECFD1),
                  ),
                  ShapeShadow(
                    offset: Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 1,
                    color: Color(0xFF888888),
                  )
                ],
              ),
              hoveredStyle: skeumorphismStyle.copyWith(
                insetShadows: [
                  ShapeShadow(
                    offset: Offset(0, 0),
                    blurRadius: 3,
                    spreadRadius: 3,
                    color: Color(0xFFCECFD1),
                  )
                ],
              ),
              onPressed: () {
                print("Tapped!");
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("TAP ME"),
              style: keyboardStyle,
              pressedStyle: keyboardStyle.copyWith(
                shadows: [
                  ShapeShadow(
                      blurRadius: 3,
                      spreadRadius: 1,
                      color: Colors.grey.shade700,
                      offset: Offset(0, 3)),
                  ShapeShadow(
                      blurRadius: 0, color: Colors.teal, offset: Offset(0, 2)),
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
                      blurRadius: 0, color: Colors.teal, offset: Offset(0, 11)),
                  ShapeShadow(
                      blurRadius: 0,
                      spreadRadius: -1,
                      color: Colors.tealAccent.shade400,
                      offset: Offset(0, 10)),
                ],
                transform: SmoothMatrix4()
                  ..translate(0.toPXLength, -11.toPXLength),
              ),
              curve: Curves.elasticOut,
              duration: Duration(milliseconds: 300),
              onPressed: () {
                print("Tapped!");
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("command"),
              style: macKeyboardStyle,
              pressedStyle: macKeyboardStyle.copyWith(
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
              onPressed: () {
                print("Tapped!");
              },
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
