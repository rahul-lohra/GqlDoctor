import 'package:flutter/material.dart';

abstract class BaseStlessActivity extends StatelessWidget {
  Widget getHome();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // See https://github.com/flutter/flutter/wiki/Desktop-shells#fonts
        fontFamily: 'Roboto',
      ),
      home: getHome()
    );
  }
}
