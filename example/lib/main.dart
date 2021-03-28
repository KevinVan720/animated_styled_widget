import 'package:example/button_transform_1.dart';
import 'package:example/button_transform_2.dart';
import 'package:example/glassmorphism_button.dart';
import 'package:example/neon_button.dart';
import 'package:example/neumorphism_button.dart';
import 'package:example/neumorphsim_button_explicit.dart';
import 'package:example/progress_indicator_explicit.dart';
import 'package:example/styled_buttons.dart';
import 'package:example/styled_checkbox.dart';
import 'package:example/styled_slider.dart';
import 'package:example/styled_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'button_transform_3.dart';
import 'long_animated_button.dart';
import 'neon_button_explicit.dart';
import 'neumorphism_two_button.dart';
import 'scroll_animation.dart';
import 'staggerd_animations.dart';
import 'styled_radios.dart';
import 'styled_toggle_buttons.dart';
import 'two_animation_combine.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Responsive Styled Widget',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Responsive Styled Widget"),
      ),
      body: Center(
          child: Container(
              width: 240,
              child: ListView(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Implicit Animations",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NeonButtonPage()));
                      },
                      child: Text("Neon Button")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NeumorphismPage()));
                      },
                      child: Text("Neumorphism Button")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NeumorphismTwoPage()));
                      },
                      child: Text("Neumorphism Two Button")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GlassmorphismButtonPage()));
                      },
                      child: Text("Glassmorphism Button")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StyledButtonsPage()));
                      },
                      child: Text("Physical Styled Buttons")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StyledToggleButtonsPage()));
                      },
                      child: Text("Styled Toggle Buttons")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StyledRadiosPage()));
                      },
                      child: Text("Styled Radios")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StyledCheckboxesPage()));
                      },
                      child: Text("Styled Checkboxes")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StyledSwitchPage()));
                      },
                      child: Text("Styled Switches")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StyledSliderPage()));
                      },
                      child: Text("Styled Slider")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ButtonTransform1Page()));
                      },
                      child: Text("Button Transform 1")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ButtonTransform2Page()));
                      },
                      child: Text("Button Transform 2")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ButtonTransform3Page()));
                      },
                      child: Text("Button Transform 3")),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Explicit Animations",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProgressIndicatorExplicitPage()));
                      },
                      child: Text("Progress Container")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TwoAnimationCombinePage()));
                      },
                      child: Text("Two Animation Combine")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NeonButtonExplicitPage()));
                      },
                      child: Center(
                          child: Text(
                        "Explicitly Animated Neon Button",
                        textAlign: TextAlign.center,
                      ))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NeumorphismButtonExplicitPage()));
                      },
                      child: Center(
                          child: Text(
                        "Explicitly Animated Neumorphsim Button",
                        textAlign: TextAlign.center,
                      ))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LongAnimatedButtonPage()));
                      },
                      child: Center(
                          child: Text(
                        "Long Animated Button",
                        textAlign: TextAlign.center,
                      ))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScrollAnimationPage()));
                      },
                      child: Center(
                          child: Text(
                        "Scroll Animations",
                        textAlign: TextAlign.center,
                      ))),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StaggeredAnimationsPage()));
                      },
                      child: Center(
                          child: Text(
                        "Staggered Animations",
                        textAlign: TextAlign.center,
                      ))),
                ],
              ))),
    );
  }
}
