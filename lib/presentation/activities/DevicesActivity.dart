import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/data/moor_database.dart';
import 'package:example_flutter/domain/usecases/GetAdbUseCase.dart';
import 'package:example_flutter/domain/usecases/GetDefaultConfigUseCase.dart';
import 'package:example_flutter/domain/usecases/GetDevicesUseCase.dart';
import 'package:example_flutter/domain/repositories/LocalRepository.dart';
import 'package:example_flutter/presentation/HexColor.dart';
import 'package:example_flutter/presentation/activities/DeviceDetailActivity.dart';
import 'package:example_flutter/presentation/data/DeviceDetailData.dart';
import 'package:example_flutter/presentation/routes/Router.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceActivityVM.dart';
import 'package:flutter/material.dart';
import 'package:moor/moor.dart' as moor;
import 'package:provider/provider.dart';

class DevicesActivity extends StatefulWidget {
  @override
  _DevicesActivityState createState() => _DevicesActivityState();
}

class _DevicesActivityState extends State<DevicesActivity> {
  final List<Devices> deviceList = new List();
  DeviceActivityVM devicesActivityVM;
  Widget resultDeviceWidget = Container();
  RaisedButton btnNext;
  int selectedEmulator = 0;
  bool cbPackageValue = false;
  bool cbDbValue = false;
  String adbPath;

  final packageController = TextEditingController();
  final dbController = TextEditingController();
  final adbTextController = TextEditingController();

  @override
  void initState() {
    final packageDao = Provider.of<PackageTableDao>(context, listen: false);
    final mobileDbDao = Provider.of<MobileDbTableDao>(context, listen: false);
    var defaultConfigUseCase =
        GetDefaultConfigUseCase(LocalRepository(packageDao, mobileDbDao));
    devicesActivityVM =
        DeviceActivityVM(GetDevicesUseCase(), defaultConfigUseCase, GetAdbUseCase());

    btnNext = getButtonNext();
    packageController.addListener(toggleButtonNext);
    dbController.addListener(toggleButtonNext);
    adbTextController.addListener(toggleButtonNext);

    devicesActivityVM.getConnectedDevices(showDevices);
    devicesActivityVM.getDefaultPackageName(showDefaultPackageName);
    devicesActivityVM.getDefaultDbName(showDefaultDbName);
    adbPath = devicesActivityVM.getAdbPath();
    adbTextController.text =  adbPath;
  }

  void toggleButtonNext() {
    if (btnNext.enabled) {
      if (!allDataIsReadyForOnNext()) {
        setState(() {
          btnNext = getButtonNext();
        });
      }
    } else {
      if (allDataIsReadyForOnNext()) {
        setState(() {
          btnNext = getButtonNext();
        });
      }
    }
  }

  @override
  void dispose() {
    packageController.dispose();
    dbController.dispose();
    super.dispose();
  }

  void onRadioButtonClick(int value) {
    setState(() {
      selectedEmulator = value;
      resultDeviceWidget = getDevicesWidget();
      toggleButtonNext();
    });
  }

  void showDefaultPackageName(Result packageNameResult) {
    setState(() {
      if (packageNameResult is Success &&
          (packageNameResult.data as String).isNotEmpty) {
        packageController.text = packageNameResult.data;
        cbPackageValue = true;
      }
    });
  }

  void showDefaultDbName(Result packageNameResult) {
    setState(() {
      if (packageNameResult is Success &&
          (packageNameResult.data as String).isNotEmpty) {
        dbController.text = packageNameResult.data;
        cbDbValue = true;
      }
    });
  }

  void showDevices(Result resultDevices) {
    setState(() {
      deviceList.clear();
      if (resultDevices is Success) {
        deviceList.addAll(resultDevices.data);
        resultDeviceWidget = getDevicesWidget();
      } else if (resultDevices is Fail) {
        resultDeviceWidget = getExceptionWidget(resultDevices);
      }
      btnNext = getButtonNext();
    });
  }

  onNextButtonClick() {
    saveSettings();
    String deviceName = deviceList[selectedEmulator].name.split("\t")[0];
    openDetailActivity(deviceName, packageController.text, dbController.text);
  }

  saveSettings() {
    devicesActivityVM.createOrUpdatePackage(
        packageController.text, cbPackageValue, dbController.text, cbDbValue);
  }

  readValuesFromDatabase(PackageTableDao dao) async {
    List<PackageTableData> list = await dao.getEnabledPackage();
    list.forEach((t) => print("data =  ${t.name}"));
  }

  void openDetailActivity(
      String deviceName, String packageName, String databaseName) {
    DeviceDetailData deviceDetailData =
        DeviceDetailData(packageName, databaseName, deviceName, adbTextController.text);
    DeviceDetailActivity activity = DeviceDetailActivity(deviceDetailData: deviceDetailData);
    Router.routeTo(
        context,
        activity,
        deviceName,
    );
  }

  bool allDataIsReadyForOnNext() {
    bool textFieldsAreNotEmpty =
        packageController.text.isNotEmpty && dbController.text.isNotEmpty;
    bool emulatorIsSelected = selectedEmulator < deviceList.length && deviceList.length > 0;
    return textFieldsAreNotEmpty && emulatorIsSelected;
  }

  Widget getDevicesWidget() {
    return Expanded(
      child: ListView.builder(
        itemCount: deviceList.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Container(
            child: GestureDetector(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Radio(
                      groupValue: selectedEmulator,
                      value: index,
                      onChanged: (value) {
                        onRadioButtonClick(value);
                      },
                    ),
                    Text(deviceList[index].name)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getExceptionWidget(Fail fail) {
    return Text("${fail.e}");
  }

  RaisedButton getButtonNext() {
    return RaisedButton(
      onPressed: allDataIsReadyForOnNext() ? () => onNextButtonClick() : null,
      child: const Text('Next', style: TextStyle(fontSize: 20)),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Padding(
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
                            controller: packageController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor("#e0e0e0"))),
                                border: OutlineInputBorder(),
                                hintText: 'Enter a package'),
                          ),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Checkbox(
                        value: cbPackageValue,
                        onChanged: (value) {
                          setState(() {
                            cbPackageValue = value;
                          });
                        },
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
                            controller: dbController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor("#e0e0e0"))),
                                border: OutlineInputBorder(),
                                hintText: 'Enter database name'),
                          ),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Checkbox(
                        value: cbDbValue,
                        onChanged: (value) {
                          setState(() {
                            cbDbValue = value;
                          });
                        },
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          "Use this database by default",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    ]),
                    Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(16, 0, 40, 0),
                        child: Text(
                          "Adb path",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: TextField(
                            controller: adbTextController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor("#e0e0e0"))),
                                border: OutlineInputBorder(),
                                hintText: 'Enter adb path'),
                          ),
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
                          Container(
                            margin: EdgeInsets.fromLTRB(
                              400,
                              0,
                              0,
                              0,
                            ),
                            child: RaisedButton(
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                "Refresh",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () {
//                                devicesActivityVM
//                                    .getConnectedDevices(showDevices);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    resultDeviceWidget
                  ],
                ),
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(20),
              child: btnNext,
            ),
          )
        ],
      ),
    );
  }
}
