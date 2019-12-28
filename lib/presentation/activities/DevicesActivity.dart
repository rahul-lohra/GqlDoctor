import 'dart:math';

import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/presentation/routes/Router.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceActivityVM.dart';
import 'package:flutter/material.dart';

class DevicesActivity extends StatefulWidget {
  @override
  _DevicesActivityState createState() => _DevicesActivityState();
}

class _DevicesActivityState extends State<DevicesActivity> {
  List<Devices> deviceList = new List();
  DeviceActivityVM devicesActivityVM = new DeviceActivityVM();
  Widget resultDeviceWidget = Container();

  void showDevices(Result resultDevices) {
    setState(() {
      if(resultDevices is Success) {
          resultDeviceWidget = getDevicesWidget(resultDevices.data);
      }else if (resultDevices is Fail){
        resultDeviceWidget = getExceptionWidget(resultDevices);
      }
    });
  }

  Widget getDevicesWidget(List<Devices> devices){
    deviceList.clear();
    deviceList.addAll(devices);
    return Expanded(
      child: ListView.builder(
        itemCount: deviceList.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Container(
            child: GestureDetector(child: Text(deviceList[index].name), onTap: (){
              Router.routeToDeviceDetail(context);
            },),
          );
        },
      ),
    );
  }

  Widget getExceptionWidget(Fail fail){
    return Text("${fail.e}");
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
          resultDeviceWidget
        ],
      ),
    );
  }
}
