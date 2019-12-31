import 'package:example_flutter/domain/GetPackagesUseCase.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceDetailVM.dart';
import 'package:flutter/material.dart';

class DeviceDetailActivity extends StatefulWidget {
  final String deviceName;

  const DeviceDetailActivity({Key key, this.deviceName}) : super(key: key);

  @override
  _DeviceDetailActivityState createState() =>
      _DeviceDetailActivityState(deviceName);
}

class _DeviceDetailActivityState extends State<DeviceDetailActivity> {
  DeviceDetailVM detailVM = new DeviceDetailVM(new GetPackagesUseCase());
  final String deviceName;

  Widget historyWidgetList = Container();

  _DeviceDetailActivityState(this.deviceName);

  void showPackages(Set<String> packageList) {
    setState(() {
      setHistoryWidget(packageList.toList(growable: false));
    });
  }

  void setHistoryWidget(List<String> packageList) {
    historyWidgetList = Expanded(
      child: ListView.builder(
        itemCount: packageList.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Container(
            child: GestureDetector(
              child: Text(packageList[index]),
              onTap: () {
                detailVM.connectEmulator(deviceName);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    detailVM.getPackagesWhereLibraryIsInstalled(showPackages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Enter a package'),
          ),
          Text("Recent Searches"),
          GestureDetector(
            child: Text(
              "Coonect Emulator",
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {
              detailVM.connectEmulator(deviceName);
            },
          ),
          GestureDetector(
            child: Text("Goto package", style: TextStyle(fontSize: 18)),
            onTap: () {
              detailVM.gotoPackage("com.rahullohra.gqldeveloperapp");
            },
          ),
          GestureDetector(
            child: Text("List files", style: TextStyle(fontSize: 18)),
            onTap: () {
              detailVM.listFiles();
            },
          ),
          GestureDetector(
            child: Text("Connect database", style: TextStyle(fontSize: 18)),
            onTap: () {
              detailVM.connectDatabase();
            },
          ),
          GestureDetector(
            child: Text("Show all tables", style: TextStyle(fontSize: 18)),
            onTap: () {
              detailVM.showAllTables();
            },
          ),
          historyWidgetList
        ],
      ),
    );
  }
}
