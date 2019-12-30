import 'package:flutter/material.dart';

abstract class BaseStfullActivity extends StatefulWidget {}

abstract class BaseState<T extends BaseStfullActivity> extends State<T>{
  Widget getHome();

  @override
  Widget build(BuildContext context) {

  }
}
