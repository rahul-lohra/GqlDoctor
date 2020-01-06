import 'package:flutter/material.dart';

class Router {
  static void routeTo(
      BuildContext context, Widget destinationWidget, String title) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx) {
      return Activity(destinationWidget: destinationWidget, title: title);
    }));
  }
  static void popBackStack(BuildContext context){
    Navigator.pop(context);
  }
}

class HandleBackActivity extends InheritedWidget {
  final _ActivityState _activityState;
  HandleBackActivity(this._activityState, {@required Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  // static _ActivityState of(BuildContext context) {
  //   return context
  //       .dependOnInheritedWidgetOfExactType<HandleBackActivity>()
  //       ._activityState;
  // }
}

class BackPressService {
  Function onBackPress;
}

class Activity extends StatefulWidget {
  final Widget destinationWidget;
  final String title;
  final BackPressService backPressService = BackPressService();

  Activity({Key key, @required this.destinationWidget, @required this.title})
      : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();

  static _ActivityState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HandleBackActivity>()._activityState;
  }
}

class _ActivityState extends State<Activity> {
  BackPressService backPressService = BackPressService();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: hello,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: HandleBackActivity(this, child: widget.destinationWidget)),
    );
  }

  Future<bool> hello() {
    backPressService.onBackPress();
    return Future<bool>.value(true);
  }
}