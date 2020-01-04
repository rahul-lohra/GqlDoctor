import 'package:flutter/material.dart';

class Router {
  static void routeTo(BuildContext context, Widget destinationWidget, String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Activity(destinationWidget: destinationWidget,title: title,)));
  }
}

class Activity extends StatelessWidget {
  final Widget destinationWidget;
  final String title;

  const Activity({Key key, @required this.destinationWidget , @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body:destinationWidget
    );
  }
}

