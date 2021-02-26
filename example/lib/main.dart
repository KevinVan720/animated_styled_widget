import 'package:example/neon_button.dart';
import 'package:example/transform.dart';
import 'package:example/stack.dart';
import 'package:example/listview.dart';
import 'package:example/column.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        home: HomePage()
        //home: Center(child: Text("Hello")),
        );
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
              width: 160,
              child: ListView(
                children: [
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
                                builder: (context) => TransformPage()));
                      },
                      child: Text("Transform")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StackPage()));
                      },
                      child: Text("Stack")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListViewPage()));
                      },
                      child: Text("List View")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ColumnPage()));
                      },
                      child: Text("Column")),
                ],
              ))),
    );
  }
}
