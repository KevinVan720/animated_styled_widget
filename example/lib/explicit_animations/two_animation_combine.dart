import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simple_animations/simple_animations.dart';

class TwoAnimationCombinePage extends StatefulWidget {
  @override
  _TwoAnimationCombinePageState createState() =>
      _TwoAnimationCombinePageState();
}

class _TwoAnimationCombinePageState extends State<TwoAnimationCombinePage> {
  late String animationName1;
  late String animationName2;
  late bool isMerge;
  late List<bool> isSelected;
  late CustomAnimationControl control;

  @override
  void initState() {
    animationName1 = "Rainbow";
    animationName2 = "Wobble";
    control = CustomAnimationControl.MIRROR;
    isMerge = true;
    isSelected = [isMerge, !isMerge];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
      MultiAnimationSequence sequence =
          presetAllAnimations[animationName1]!.getAnimationSequence();
      if (isMerge) {
        sequence
            .merge(presetAllAnimations[animationName2]!.getAnimationSequence());
      } else {
        sequence.extend(
            presetAllAnimations[animationName2]!.getAnimationSequence());
      }
      sequence.control = control;

      return MaterialApp(
          home: Scaffold(
              appBar: AppBar(
                title: Text("Two Animation Combined"),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              endDrawer: buildEndDrawer(),
              body: Stack(
                children: [
                  Center(
                    child: buildChild(sequence),
                  )
                ],
              )));
    });
  }

  Widget buildChild(MultiAnimationSequence sequence) {
    return ExplicitAnimatedStyledContainer(
      style: Style(
          alignment: Alignment.center,
          childAlignment: Alignment.center,
          backgroundDecoration: BoxDecoration(color: Colors.redAccent),
          width: 50.toPercentLength,
          height: 50.toPercentLength,
          textStyle: DynamicTextStyle(fontSize: 300.toPercentLength)),
      localAnimations: {AnimationTrigger.visible: sequence},
      child: Text("Hello"),
    );
  }

  Widget buildEndDrawer() {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 6, top: 6),
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Controls",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text("First Animation"),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                iconSize: 18,
                isDense: true,
                value: animationName1,
                onChanged: (String? newValue) {
                  setState(() {
                    animationName1 = newValue ?? "Wobble";
                  });
                },
                items: presetAllAnimations.keys.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e.toString(),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Second Animation"),
              SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                iconSize: 18,
                isDense: true,
                value: animationName2,
                onChanged: (String? newValue) {
                  setState(() {
                    animationName2 = newValue ?? "Wobble";
                  });
                },
                items: presetAllAnimations.keys.map((e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e.toString(),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Control"),
              SizedBox(
                height: 20,
              ),
              DropdownButton<CustomAnimationControl>(
                iconSize: 18,
                isDense: true,
                value: control,
                onChanged: (CustomAnimationControl? newValue) {
                  setState(() {
                    control = newValue ?? CustomAnimationControl.MIRROR;
                  });
                },
                items: CustomAnimationControl.values.map((e) {
                  return DropdownMenuItem<CustomAnimationControl>(
                    value: e,
                    child: Text(
                      e.toJson(),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              ToggleButtons(
                children: [
                  Container(
                    width: 100,
                    alignment: Alignment.center,
                    child: Text(
                      "MERGE",
                      style: TextStyle(letterSpacing: 2),
                    ),
                  ),
                  Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        "EXTEND",
                        style: TextStyle(letterSpacing: 2),
                      ))
                ],
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    isSelected[index] = !isSelected[index];
                    if (index == 0) {
                      isSelected[1] = !isSelected[index];
                    } else {
                      isSelected[0] = !isSelected[index];
                    }
                    isMerge = isSelected[0];
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
