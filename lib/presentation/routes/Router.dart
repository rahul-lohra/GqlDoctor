import 'package:example_flutter/presentation/activities/DeviceDetailActivity.dart';
import 'package:flutter/material.dart';

class Router {
  static void routeTo(BuildContext context, Widget destinationWidget) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => Activity(destinationWidget: destinationWidget,)));
  }
}

class Activity extends StatelessWidget {
  final Widget destinationWidget;

  const Activity({Key key, @required this.destinationWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello"),
      ),
      body:destinationWidget
    );
  }
}

