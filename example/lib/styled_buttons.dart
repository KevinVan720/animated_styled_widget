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
  late Style neumorphicStyle;
  late Style neonStyle;
  late Style comicStyle;
  late Style skeumorphismStyle;
  late Style keyboardStyle;
  late Style macKeyboardStyle;

  @override
  void initState() {
    super.initState();

    neumorphicStyle = Style(
        width: 200.toPXLength,
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.symmetric(
            vertical: 20.toPXLength, horizontal: 10.toPXLength),
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
        mouseCursor: SystemMouseCursors.click);

    neonStyle = Style(
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.all(20.toPXLength),
        backgroundDecoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.cyanAccent, Colors.purpleAccent])),
        shapeBorder: MorphableShapeBorder(
            shape: RoundedRectangleShape(
                borderRadius: DynamicBorderRadius.all(
                    DynamicRadius.circular(15.toPXLength)),
                borders: RectangleBorders.only(
                    top: DynamicBorderSide(
                        gradient: LinearGradient(colors: [
                          Colors.cyanAccent.shade100,
                          Colors.purpleAccent.shade100
                        ]),
                        width: 11),
                    bottom: DynamicBorderSide(
                        gradient: LinearGradient(
                            colors: [Colors.cyan, Colors.purple]),
                        width: 29),
                    left: DynamicBorderSide(
                        color: Colors.cyanAccent.shade200, width: 11),
                    right: DynamicBorderSide(
                        color: Colors.purpleAccent, width: 29)))),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 25.toPXLength,
              gradient: LinearGradient(
                  colors: [Colors.cyanAccent, Colors.purpleAccent]),
              offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
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

    comicStyle = Style(
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.all(20.toPXLength),
        backgroundDecoration: BoxDecoration(color: Colors.amberAccent),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              color: Colors.black87,
              offset: DynamicOffset(10.toPXLength, 10.toPXLength)),
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

    skeumorphismStyle = Style(
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.symmetric(
            vertical: 20.toPXLength, horizontal: 40.toPXLength),
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
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
                borderRadius: DynamicBorderRadius.all(
                    DynamicRadius.circular(50.toPXLength)),
                border: DynamicBorderSide(
                  color: Color(0xFF8F9092),
                  width: 1,
                  //begin: (50*pi).toPXLength
                ))),
        shadows: [
          DynamicShapeShadow(
            offset: DynamicOffset(0.toPXLength, -6.toPXLength),
            blurRadius: 4.toPXLength,
            color: Color(0xFFFEFEFE),
          ),
          DynamicShapeShadow(
            offset: DynamicOffset(0.toPXLength, -4.toPXLength),
            blurRadius: 4.toPXLength,
            color: Color(0xFFCECFD1),
          ),
          DynamicShapeShadow(
            offset: DynamicOffset(0.toPXLength, 6.toPXLength),
            blurRadius: 8.toPXLength,
            color: Color(0xFFd6d7d9),
          ),
          DynamicShapeShadow(
            offset: DynamicOffset(0.toPXLength, 4.toPXLength),
            blurRadius: 3.toPXLength,
            spreadRadius: 1.toPXLength,
            color: Color(0xFFFCFCFC),
          ),
        ],
        insetShadows: [
          DynamicShapeShadow(
            offset: DynamicOffset(0.toPXLength, 0.toPXLength),
            blurRadius: 3.toPXLength,
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

    keyboardStyle = Style(
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.symmetric(
            vertical: 20.toPXLength, horizontal: 30.toPXLength),
        backgroundDecoration: BoxDecoration(color: Colors.tealAccent.shade100),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
                borderRadius: DynamicBorderRadius.all(
                    DynamicRadius.circular(20.toPXLength)),
                border: DynamicBorderSide(width: 1, color: Colors.teal))),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 10.toPXLength,
              spreadRadius: 1.toPXLength,
              color: Colors.grey.shade700,
              offset: DynamicOffset(0.toPXLength, 14.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              color: Colors.teal,
              offset: DynamicOffset(0.toPXLength, 15.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: -1.toPXLength,
              color: Colors.tealAccent.shade400,
              offset: DynamicOffset(0.toPXLength, 14.toPXLength)),
        ],
        transform: SmoothMatrix4()..translate(0.toPXLength, -15.toPXLength),
        textStyle: DynamicTextStyle(
            letterSpacing: 5.toPXLength,
            fontSize: Dimension.min(300.toPercentLength, 28.toPXLength),
            color: Colors.teal,
            fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    macKeyboardStyle = Style(
        width: 180.toPXLength,
        height: 180.toPXLength,
        alignment: Alignment.center,
        padding: DynamicEdgeInsets.all(10.toPXLength),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFF4F5F6),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(35.toPXLength)),
        )),
        shadows: [
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              color: Colors.grey.shade500,
              offset: DynamicOffset(10.toPXLength, 10.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 20.toPXLength,
              color: Color(0xFFFEFEFE),
              offset: DynamicOffset(-10.toPXLength, 15.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: 0.toPXLength,
              color: Color(0xFF444444),
              offset: DynamicOffset(-4.toPXLength, 14.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: 0.toPXLength,
              color: Color(0xFF444444),
              offset: DynamicOffset(4.toPXLength, 14.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: 0.toPXLength,
              color: Color(0xFF444444),
              offset: DynamicOffset(-4.toPXLength, 6.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: 0.toPXLength,
              color: Color(0xFF444444),
              offset: DynamicOffset(4.toPXLength, 6.toPXLength)),
          DynamicShapeShadow(
              blurRadius: 0.toPXLength,
              spreadRadius: 0.toPXLength,
              color: Color(0xFFDDDDDD),
              offset: DynamicOffset(0.toPXLength, 10.toPXLength)),
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
            StyledButton(
              duration: Duration(milliseconds: 200),
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
                /*return AnimatedCrossFade(
                  duration: Duration(milliseconds: 500),
                  firstChild: Text("TAP ME"),
                  secondChild: Text("TAPPED"),
                  crossFadeState: state == StyledComponentState.pressed
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                );*/
              },
              style: neumorphicStyle,
              pressedStyle: neumorphicStyle.copyWith(
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
              ),
              hoveredStyle: neumorphicStyle.copyWith(
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
              onPressed: () {
                print("Tapped!");
              },
            ),
            SizedBox(
              height: 50,
            ),
            StyledButton(
              child: Text("TAP ME"),
              style: neonStyle,
              pressedStyle: neonStyle.copyWith(
                  padding: DynamicEdgeInsets.all(23.toPXLength),
                  shapeBorder: MorphableShapeBorder(
                      shape: RoundedRectangleShape(
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
                              right:
                                  DynamicBorderSide(color: Colors.purpleAccent, width: 20))))),
              hoveredStyle: neonStyle.copyWith(
                  shapeBorder: MorphableShapeBorder(
                      shape: RoundedRectangleShape(
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
                              right:
                                  DynamicBorderSide(color: Colors.purpleAccent, width: 27))))),
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
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      color: Colors.black87,
                      offset: DynamicOffset(0.toPXLength, 0.toPXLength)),
                ],
                transform: SmoothMatrix4()
                  ..translate(0.toPXLength, 0.toPXLength),
              ),
              hoveredStyle: comicStyle.copyWith(
                shadows: [
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      color: Colors.black87,
                      offset: DynamicOffset(5.toPXLength, 5.toPXLength)),
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
                  DynamicShapeShadow(
                    offset: DynamicOffset(0.toPXLength, 0.toPXLength),
                    blurRadius: 10.toPXLength,
                    spreadRadius: 3.toPXLength,
                    color: Color(0xFFCECFD1),
                  ),
                  DynamicShapeShadow(
                    offset: DynamicOffset(0.toPXLength, 0.toPXLength),
                    blurRadius: 3.toPXLength,
                    spreadRadius: 1.toPXLength,
                    color: Color(0xFF888888),
                  )
                ],
              ),
              hoveredStyle: skeumorphismStyle.copyWith(
                insetShadows: [
                  DynamicShapeShadow(
                    offset: DynamicOffset(0.toPXLength, 0.toPXLength),
                    blurRadius: 3.toPXLength,
                    spreadRadius: 3.toPXLength,
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
                  DynamicShapeShadow(
                      blurRadius: 3.toPXLength,
                      spreadRadius: 1.toPXLength,
                      color: Colors.grey.shade700,
                      offset: DynamicOffset(0.toPXLength, 3.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      color: Colors.teal,
                      offset: DynamicOffset(0.toPXLength, 2.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: -1.toPXLength,
                      color: Colors.tealAccent.shade400,
                      offset: DynamicOffset(0.toPXLength, 1.toPXLength)),
                ],
                transform: SmoothMatrix4()
                  ..translate(0.toPXLength, -2.toPXLength),
              ),
              hoveredStyle: keyboardStyle.copyWith(
                shadows: [
                  DynamicShapeShadow(
                      blurRadius: 10.toPXLength,
                      spreadRadius: 1.toPXLength,
                      color: Colors.grey.shade700,
                      offset: DynamicOffset(0.toPXLength, 10.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      color: Colors.teal,
                      offset: DynamicOffset(0.toPXLength, 11.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: -1.toPXLength,
                      color: Colors.tealAccent.shade400,
                      offset: DynamicOffset(0.toPXLength, 10.toPXLength)),
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
                  DynamicShapeShadow(
                      blurRadius: 5.toPXLength,
                      color: Colors.grey.shade500,
                      offset: DynamicOffset(2.toPXLength, 2.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 5.toPXLength,
                      color: Color(0xFFFEFEFE),
                      offset: DynamicOffset(-2.toPXLength, 2.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: 0.toPXLength,
                      color: Color(0xFF444444),
                      offset: DynamicOffset(-4.toPXLength, 4.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: 0.toPXLength,
                      color: Color(0xFF444444),
                      offset: DynamicOffset(4.toPXLength, 4.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: 0.toPXLength,
                      color: Color(0xFF444444),
                      offset: DynamicOffset(-4.toPXLength, -4.toPXLength)),
                  DynamicShapeShadow(
                      blurRadius: 0.toPXLength,
                      spreadRadius: 0.toPXLength,
                      color: Color(0xFF444444),
                      offset: DynamicOffset(4.toPXLength, -4.toPXLength))
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
