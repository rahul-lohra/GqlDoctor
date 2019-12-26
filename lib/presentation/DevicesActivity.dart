import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/domain/DeviceActivityVM.dart';
import 'package:flutter/material.dart';

class DevicesActivity extends StatefulWidget {
  @override
  _DevicesActivityState createState() => _DevicesActivityState();
}

class _DevicesActivityState extends State<DevicesActivity> {
  List<Devices> deviceList = new List();
  DeviceActivityVM devicesActivityVM = new DeviceActivityVM();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text("Connected Devices"),
          FlatButton(child: Text("Refresh"),onPressed: (){
            devicesActivityVM.getConnectedDevices();
          },),
          Expanded(
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (BuildContext ctx, int index) {
                return new Container(
                  child: Text("Hello"),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
