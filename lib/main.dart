import 'dart:io';

import 'package:example_flutter/data/moor_database.dart';
import 'package:example_flutter/presentation/activities/DevicesActivity.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

void main() {
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  debugPaintSizeEnabled = false;

  AppDatabase appDatabase = AppDatabase();
  var packageDao = Provider<PackageTableDao>(create: (_) => appDatabase.packageTableDao);
  var mobileDbDao = Provider<MobileDbTableDao>(create: (_) => appDatabase.mobileDbTableDao);

  runApp(MultiProvider(
    providers: [packageDao,mobileDbDao],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: getDevices(),
    );
  }

  Widget getDevices() {
    return DevicesActivity();
  }
}
