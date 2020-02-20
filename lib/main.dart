import 'dart:io';

import 'package:example_flutter/data/moor_database.dart';
import 'package:example_flutter/presentation/activities/AboutActivity.dart';
import 'package:example_flutter/presentation/activities/DevicesActivity.dart';
import 'package:example_flutter/presentation/menu/MainPopupMenu.dart';
import 'package:example_flutter/presentation/routes/Router.dart';
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

  try {
    runApp(MultiProvider(
      providers: [packageDao, mobileDbDao],
      child: MyApp(),
    ));
  } catch (error) {
    File file = File("error.txt");
    if (file.existsSync()) {
      file.createSync(recursive: true);
    }
    file.writeAsStringSync(error);
  }
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

List<MainPopupMenu> getMenu() {
  List<MainPopupMenu> menuItems = List();
  menuItems.add(MainPopupMenu("About"));
  return menuItems;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[PopupMenuButton<MainPopupMenu>(
          elevation: 3.2,
          initialValue: getMenu()[0],
          onSelected: (MainPopupMenu menu){
            openAboutActivity();
          },
          itemBuilder: (BuildContext context) {
            return getMenu()
                .map((MainPopupMenu menu) {
              return PopupMenuItem<MainPopupMenu>(value: menu, child: Text(menu.title),);
            }).toList();
          },
        )
        ],
      ),
      body: getDevices(),
    );
  }

  void openAboutActivity(){
    Router.routeTo(context, AboutActivity(), "About");
  }

  Widget getDevices() {
    return DevicesActivity();
  }
}
