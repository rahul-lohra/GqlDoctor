import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/presentation/activities/DeviceDetailActivity.dart';
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

  @override
  void initState() {
    devicesActivityVM.getConnectedDevices(showDevices);
  }

  void showDevices(Result resultDevices) {
    setState(() {
      if (resultDevices is Success) {
        resultDeviceWidget = getDevicesWidget(resultDevices.data);
      } else if (resultDevices is Fail) {
        resultDeviceWidget = getExceptionWidget(resultDevices);
      }
    });
  }

  Widget getDevicesWidget(List<Devices> devices) {
    deviceList.clear();
    deviceList.addAll(devices);
    return Expanded(
      child: ListView.builder(
        itemCount: deviceList.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Container(
            child: GestureDetector(
              child: Text(deviceList[index].name),
              onTap: () {
                String deviceName = deviceList[index].name.split("\t")[0];
                Router.routeTo(
                    context,
                    DeviceDetailActivity(
                      deviceName: deviceName,
                    ));
              },
            ),
          );
        },
      ),
    );
  }

  Widget getExceptionWidget(Fail fail) {
    return Text("${fail.e}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    "Package name",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter a package'),
                    ),
                  ),
                )
              ]),
              Row(children: <Widget>[
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Use this package by default",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ]),
              Row(children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: Text(
                    "Database name",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter database name'),
                    ),
                  ),
                )
              ]),
              Row(children: <Widget>[
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Use this database by default",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              ]),
              Container(
                margin: EdgeInsets.fromLTRB(16, 20, 0, 0),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Connected Devices",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Container(margin:EdgeInsets.fromLTRB(400, 0,0,0,),child: FlatButton(
                      child: Text(
                        "Refresh",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        devicesActivityVM.getConnectedDevices(showDevices);
                      },
                    ),)
                  ],
                ),
              ),
              resultDeviceWidget
            ],
          ),
        ));
  }
}
