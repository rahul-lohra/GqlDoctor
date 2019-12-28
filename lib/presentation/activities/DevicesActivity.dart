import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceActivityVM.dart';
import 'package:flutter/material.dart';

class DevicesActivity extends StatefulWidget {
  @override
  _DevicesActivityState createState() => _DevicesActivityState();
}

class _DevicesActivityState extends State<DevicesActivity> {
  List<Devices> deviceList = new List();
  DeviceActivityVM devicesActivityVM = new DeviceActivityVM();

  void showDevices(List<Devices> devices) {
    setState(() {
      deviceList.clear();
      deviceList.addAll(devices);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Connected Devices"),
          FlatButton(
            child: Text("Refresh"),
            onPressed: () {
              devicesActivityVM.getConnectedDevices(showDevices);
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: deviceList.length,
              itemBuilder: (BuildContext ctx, int index) {
                return new Container(
                  child: Text(deviceList[index].name),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
