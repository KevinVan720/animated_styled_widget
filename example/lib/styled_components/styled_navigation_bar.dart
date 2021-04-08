import 'package:animated_styled_widget/animated_styled_widget.dart';
import 'package:dimension/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:morphable_shape/morphable_shape.dart';

class StyledNavigationBarPage extends StatefulWidget {
  StyledNavigationBarPage({this.title = "Styled Navigation Bar"});

  final String title;

  @override
  _StyledNavigationBarPageState createState() =>
      _StyledNavigationBarPageState();
}

class _StyledNavigationBarPageState extends State<StyledNavigationBarPage> {
  late Style googleStyle;
  late Style defaultStyle;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: School',
      style: optionStyle,
    ),
    Text(
      'Index 4: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    googleStyle = Style(
        alignment: Alignment.center,
        backgroundDecoration: BoxDecoration(
          color: Color(0xFFE0E0E0),
        ),
        padding: EdgeInsets.all(10),
        shapeBorder: RectangleShapeBorder(
          borderRadius:
              DynamicBorderRadius.all(DynamicRadius.circular(30.toPXLength)),
        ),
        textStyle: DynamicTextStyle(
          color: Colors.grey,
        ),
        textAlign: TextAlign.center,
        mouseCursor: SystemMouseCursors.click);

    defaultStyle = Style(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        textStyle: DynamicTextStyle(
          letterSpacing: 0.1.toVWLength,
          fontSize: Dimension.min(300.toPercentLength, 18.toPXLength),
          fontWeight: FontWeight.w500,
          color: Colors.black,
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
      body: Center(child: _navigationBarBuilder),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget get _navigationBarBuilder {
    List<IconData> icons = [
      Icons.ac_unit,
      Icons.call,
      Icons.cake,
      Icons.add,
      Icons.remove,
    ];

    return Column(
      children: [
        Expanded(
            child: Center(child: _widgetOptions.elementAt(_selectedIndex))),
        StyledContainer(
          style: Style(
              height: 60.toPXLength,
              padding: EdgeInsets.symmetric(vertical: 2),
              backgroundDecoration: BoxDecoration(color: Colors.green)),
          child: StyledNavigationBar.builder(
            duration: Duration(milliseconds: 300),
            itemCount: 5,
            itemBuilder:
                (BuildContext context, StyledComponentState state, int index) {
              Widget child;
              child = FittedBox(
                fit: BoxFit.fitHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      icons[index],
                      color: state == StyledComponentState.selected
                          ? Colors.red
                          : Colors.black,
                    ),
                    Text("Selected"),
                    AnimatedStyledContainer(
                        duration: Duration(milliseconds: 300),
                        style: state == StyledComponentState.selected
                            ? Style(
                                width: 100.toPXLength,
                                height: 4.toPXLength,
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.redAccent),
                                transform: SmoothMatrix4()
                                  ..translate(0.toPXLength, 5.toPXLength))
                            : Style(
                                width: 100.toPXLength,
                                height: 4.toPXLength,
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.redAccent),
                                transform: SmoothMatrix4()
                                  ..translate(0.toPXLength, 20.toPXLength)),
                        child: Container())
                  ],
                ),
              );
              return child;
            },
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            style: defaultStyle.copyWith(
                backgroundDecoration:
                    BoxDecoration(color: Color(0xFFE0E0E0).withOpacity(0.01))),
            selectedStyle: defaultStyle.copyWith(
              textStyle: DynamicTextStyle(
                letterSpacing: 0.1.toVWLength,
                fontSize: 18.toPXLength,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
            hoveredStyle: defaultStyle,
          ),
        ),
        StyledContainer(
          style: Style(
              height: 60.toPXLength,
              padding: EdgeInsets.symmetric(vertical: 2),
              backgroundDecoration: BoxDecoration(color: Colors.blueAccent)),
          child: StyledNavigationBar.builder(
            duration: Duration(milliseconds: 300),
            itemCount: 5,
            itemBuilder:
                (BuildContext context, StyledComponentState state, int index) {
              Widget child;
              child = FittedBox(
                fit: BoxFit.fitHeight,
                child: Column(
                  children: [
                    Icon(
                      icons[index],
                      color: state == StyledComponentState.selected
                          ? Colors.red
                          : Colors.black,
                    ),
                    Text("Selected")
                  ],
                ),
              );
              return child;
            },
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            style: defaultStyle.copyWith(
                backgroundDecoration:
                    BoxDecoration(color: Color(0xFFE0E0E0).withOpacity(0.01))),
            selectedStyle: defaultStyle.copyWith(
              transform: SmoothMatrix4()..scale(1.2),
              textStyle: DynamicTextStyle(
                letterSpacing: 0.1.toVWLength,
                fontSize: 18.toPXLength,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
            hoveredStyle: defaultStyle,
          ),
        ),
        StyledContainer(
          style: Style(
              height: 60.toPXLength,
              padding: EdgeInsets.symmetric(vertical: 5),
              backgroundDecoration: BoxDecoration(color: Colors.amberAccent)),
          child: StyledNavigationBar.builder(
            duration: Duration(milliseconds: 300),
            itemCount: 5,
            itemBuilder:
                (BuildContext context, StyledComponentState state, int index) {
              Widget child;
              child = FittedBox(
                fit: BoxFit.fitHeight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Icon(
                        icons[index],
                        color: DefaultTextStyle.of(context).style.color,
                      ),
                    ),
                    Container(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 300),
                        opacity: state == StyledComponentState.selected ? 1 : 0,
                        child: AnimatedAlign(
                          duration: Duration(milliseconds: 300),
                          alignment: Alignment.centerRight,
                          widthFactor:
                              state == StyledComponentState.selected ? 1 : 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Option",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
              return child;
            },
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            style: googleStyle.copyWith(
                // width: 30.toPXLength,
                backgroundDecoration:
                    BoxDecoration(color: Color(0xFFE0E0E0).withOpacity(0.01))),
            selectedStyle: googleStyle.copyWith(
                textStyle: DynamicTextStyle(
                    color: Colors.grey,
                    fontSize: 18.toPXLength,
                    fontWeight: FontWeight.w600)),
            hoveredStyle: googleStyle,
          ),
        ),
      ],
    );
  }
}
