import 'package:example_flutter/presentation/activities/DeviceDetailActivity.dart';
import 'package:flutter/material.dart';

class Router {
  static void routeToDeviceDetail(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DeviceDetailActivity()));
  }
}
