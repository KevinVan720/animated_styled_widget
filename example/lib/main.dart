import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'explicit_animations/long_animated_button.dart';
import 'explicit_animations/neon_button_explicit.dart';
import 'explicit_animations/neumorphsim_button_explicit.dart';
import 'explicit_animations/progress_indicator_explicit.dart';
import 'explicit_animations/scroll_animation.dart';
import 'explicit_animations/staggerd_animations.dart';
import 'explicit_animations/two_animation_combine.dart';
import 'implicit_animations/button_transform_1.dart';
import 'implicit_animations/button_transform_2.dart';
import 'implicit_animations/button_transform_3.dart';
import 'implicit_animations/glassmorphism_button.dart';
import 'implicit_animations/neon_button.dart';
import 'implicit_animations/neumorphism_button.dart';
import 'implicit_animations/neumorphism_two_button.dart';
import 'styled_components/styled_buttons.dart';
import 'styled_components/styled_checkboxes.dart';
import 'styled_components/styled_navigation_bar.dart';
import 'styled_components/styled_popup_menu.dart';
import 'styled_components/styled_radios.dart';
import 'styled_components/styled_slider.dart';
import 'styled_components/styled_switches.dart';
import 'styled_components/styled_toggle_buttons.dart';

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
              width: 300,
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
                        "Styled Components",
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
                                builder: (context) => StyledButtonsPage()));
                      },
                      child: Text("Styled Buttons")),
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
                      child: Text("Styled Sliders")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StyledPopupMenuButtonPage()));
                      },
                      child: Text("Styled Popup")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StyledNavigationBarPage()));
                      },
                      child: Text("Styled Navigation Bar")),
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
