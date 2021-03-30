import 'package:dimension/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:morphable_shape/morphable_shape.dart';
import 'package:responsive_styled_widget/styled_widget.dart';

class NeumorphismTwoPage extends StatefulWidget {
  NeumorphismTwoPage({this.title = "Neumorphism Two Button"});

  final String title;

  @override
  _NeumorphismTwoPageState createState() => _NeumorphismTwoPageState();
}

class _NeumorphismTwoPageState extends State<NeumorphismTwoPage> {
  bool toggleBig = true;
  bool toggleLittle = true;

  ///0 means down and 1 means up
  /// 01 means big button is down and little button is up
  late Style bigStyle;
  late Style bigStyle00;
  late Style bigStyle01;
  late Style bigStyle10;
  late Style bigStyle11;

  late Style littleStyle;
  late Style littleStyle00;
  late Style littleStyle01;
  late Style littleStyle10;
  late Style littleStyle11;

  @override
  void initState() {
    super.initState();

    var downInsetShadows = [
      ShapeShadow(
          blurRadius: 10,
          spreadRadius: 1,
          color: Color(0xFFFFFFFF),
          offset: Offset(-10, -10)),
      ShapeShadow(
          blurRadius: 20,
          spreadRadius: 1,
          color: Color(0xFFBEBEBE),
          offset: Offset(20, 20)),
    ];

    bigStyle = Style(
        width: Dimension.min(80.toVWLength, 400.toPXLength),
        height: 400.toPXLength,
        padding: EdgeInsets.symmetric(vertical: 20),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: parseShape({
                  "type": "PathShape",
                  "border": {"color": "ff000000", "width": 0, "style": "none"},
                  "path": {
                    "size": {"width": 400, "height": 400},
                    "nodes": [
                      {
                        "pos": {"dx": 40, "dy": 0},
                        "prev": {"dx": 20, "dy": 0},
                        "next": {"dx": 60, "dy": 0}
                      },
                      {
                        "pos": {"dx": 360, "dy": 0},
                        "prev": {"dx": 340, "dy": 0},
                        "next": {"dx": 380, "dy": 0}
                      },
                      {
                        "pos": {"dx": 400, "dy": 40},
                        "prev": {"dx": 400, "dy": 20},
                        "next": {"dx": 400, "dy": 60}
                      },
                      {
                        "pos": {"dx": 400, "dy": 140},
                        "prev": {"dx": 400, "dy": 120},
                        "next": {"dx": 400, "dy": 160}
                      },
                      {
                        "pos": {"dx": 360, "dy": 180},
                        "prev": {"dx": 380, "dy": 180},
                        "next": {"dx": 340, "dy": 180}
                      },
                      {
                        "pos": {"dx": 240, "dy": 180},
                        "prev": {"dx": 270, "dy": 180},
                        "next": {"dx": 210, "dy": 180}
                      },
                      {
                        "pos": {"dx": 180, "dy": 240},
                        "prev": {"dx": 180, "dy": 210},
                        "next": {"dx": 180, "dy": 270}
                      },
                      {
                        "pos": {"dx": 180, "dy": 360},
                        "prev": {"dx": 180, "dy": 340},
                        "next": {"dx": 180, "dy": 380}
                      },
                      {
                        "pos": {"dx": 140, "dy": 400},
                        "prev": {"dx": 160, "dy": 400},
                        "next": {"dx": 120, "dy": 400}
                      },
                      {
                        "pos": {"dx": 40, "dy": 400},
                        "prev": {"dx": 60, "dy": 400},
                        "next": {"dx": 20, "dy": 400}
                      },
                      {
                        "pos": {"dx": 0, "dy": 360},
                        "prev": {"dx": 0, "dy": 380},
                        "next": {"dx": 0, "dy": 340}
                      },
                      {
                        "pos": {"dx": 0, "dy": 40},
                        "prev": {"dx": 0, "dy": 60},
                        "next": {"dx": 0, "dy": 20}
                      }
                    ]
                  }
                }) ??
                RectangleShape()),
        mouseCursor: SystemMouseCursors.click);

    bigStyle00 = bigStyle.copyWith(
      insetShadows: downInsetShadows,
    );

    bigStyle01 = bigStyle00;

    bigStyle10 = bigStyle.copyWith(
      shadows: [
        ShapeShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Color(0xFFFFFFFF),
            offset: Offset(-10, -10)),
        ShapeShadow(
            blurRadius: 20,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
            offset: Offset(20, 20)),
      ],
    );

    bigStyle11 = bigStyle10;

    littleStyle = Style(
        width: 200.toPXLength,
        height: 200.toPXLength,
        padding: EdgeInsets.symmetric(vertical: 20),
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        shapeBorder: MorphableShapeBorder(
            shape: RectangleShape(
          //cornerStyles: RectangleCornerStyles.all(CornerStyle.cutout),
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(50.toPXLength)),
        )),
        mouseCursor: SystemMouseCursors.click);

    littleStyle00 = littleStyle.copyWith(
      insetShadows: downInsetShadows,
    );

    littleStyle01 = littleStyle.copyWith(
      shadows: [
        ShapeShadow(
            blurRadius: 10,
            spreadRadius: 1,
            color: Color(0xFFFFFFFF),
            offset: Offset(-5, -5)),
        ShapeShadow(
            blurRadius: 20,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
            offset: Offset(20, 20)),
      ],
    );
    littleStyle10 = littleStyle00;
    littleStyle11 = littleStyle.copyWith(
      shadows: [
        ShapeShadow(
            blurRadius: 20,
            spreadRadius: 1,
            color: Color(0xFFBEBEBE),
            offset: Offset(20, 20)),
      ],
    );
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
          child: Container(
              color: Color(0xFFE0E0E0),
              alignment: Alignment.center,
              child: Container(
                width: 400,
                height: 400,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        setState(() {
                          toggleBig = false;
                        });
                      },
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          toggleBig = true;
                        });
                      },
                      child: StyledContainer(
                          //duration: Duration(milliseconds: 100),
                          style: toggleBig
                              ? toggleLittle
                                  ? bigStyle11
                                  : bigStyle10
                              : toggleLittle
                                  ? bigStyle01
                                  : bigStyle00,
                          child: Container()),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTapDown: (TapDownDetails details) {
                            setState(() {
                              toggleLittle = false;
                            });
                          },
                          onTapUp: (TapUpDetails details) {
                            setState(() {
                              toggleLittle = true;
                            });
                          },
                          child: StyledContainer(
                              //duration: Duration(milliseconds: 100),
                              style: toggleLittle
                                  ? toggleBig
                                      ? littleStyle11
                                      : littleStyle01
                                  : toggleBig
                                      ? littleStyle10
                                      : littleStyle00,
                              child: Container()),
                        ))
                  ],
                ),
              ))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
