import 'dart:async';

import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/usecases/GetPackagesUseCase.dart';
import 'package:example_flutter/presentation/HexColor.dart';
import 'package:example_flutter/presentation/data/ButtonData.dart';
import 'package:example_flutter/presentation/data/DeviceDetailAction.dart';
import 'package:example_flutter/presentation/data/DeviceDetailData.dart';
import 'package:example_flutter/presentation/routes/Router.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceDetailVM.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeviceDetailActivity extends StatefulWidget {
  final DeviceDetailData deviceDetailData;

  const DeviceDetailActivity({Key key, this.deviceDetailData})
      : super(key: key);

  @override
  _DeviceDetailActivityState createState() =>
      _DeviceDetailActivityState(deviceDetailData);
}

class _DeviceDetailActivityState extends State<DeviceDetailActivity> {
  final DeviceDetailData deviceDetailData;
  DeviceDetailVM detailVM;
  Widget historyWidgetList;
  List<String> outputResultList = List();

  final outputController = ScrollController();
  final tableNameController = TextEditingController();
  final dbNameController = TextEditingController();

  _DeviceDetailActivityState(this.deviceDetailData);

  @override
  void initState() {
    historyWidgetList = Container();
    detailVM = DeviceDetailVM(GetPackagesUseCase(), processCallback, deviceDetailData.adbPath);
    detailVM.createConnection(
        deviceDetailData.deviceName,
        deviceDetailData.packageName,
        deviceDetailData.databaseName,
        connectionCallback);
  }

  handleBackPress() {
    detailVM.killOldProcess();
  }

  void processCallback(Result result) {
    setState(() {
      if (result is Success) {
        outputResultList.add(result.data);
      } else if (result is Fail) {
        outputResultList.add(result.e.toString());
      }
    });
  }

  void connectionCallback(Result result) {
    setState(() {
      if (result is Success) {
        outputResultList.add(result.data);
      } else if (result is Fail) {
        outputResultList.add(result.e.toString());
      }
    });
  }

  void handleUpdateTableName(DeviceDetailAction action, BuildContext ctx) {
    switch (action) {
      case DeviceDetailAction.POP_BACK:
        Router.popBackStack(ctx);
        break;
      default:
        {
          detailVM.performDatabaseOperations(action, tableNameController.text);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    var activityState = Activity.of(context);
    activityState.backPressService.onBackPress = handleBackPress;

    Timer(
        Duration(milliseconds: 1000),
        () =>
            outputController.jumpTo(outputController.position.maxScrollExtent));

    double tableNameFieldWidth = 150;
    return Container(
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Container(
              width: tableNameFieldWidth,
              margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
              child: Text(
                "Database name (N/A)",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: dbNameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter databse name'),
                ),
              ),
            )
          ]),
          Row(children: <Widget>[
            Container(
              width: tableNameFieldWidth,
              margin: EdgeInsets.fromLTRB(16, 18, 0, 0),
              child: Text(
                "Table name",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  controller: tableNameController,
                  decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter table name'),
                ),
              ),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: RaisedButton(
                    onPressed: null,
                    child: const Text('Update', style: TextStyle(fontSize: 20)),
                    color: Colors.blue,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Color(0xffe0e0e0),
          ),
          Row(
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Text("Column name", style: TextStyle(fontSize: 18)),
                ),
                flex: 1,
                fit: FlexFit.tight,
              ),
              Flexible(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                      child: Text("Values", style: TextStyle(fontSize: 18)),
                    )),
                flex: 1,
                fit: FlexFit.tight,
              ),
            ],
          ),
          getListView(1),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            alignment: Alignment.centerLeft,
            child: Text(
              "Output",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 100,
            width: double.infinity,
            child: ListView.builder(
                controller: outputController,
                itemCount: outputResultList.length,
                itemBuilder: (BuildContext ctx, int pos) {
                  return Text(outputResultList[pos]);
                }),
            color: HexColor("#e5e5e5"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: getCtaButtonList(),
          )
        ],
      ),
    );
  }

  List<Widget> getCtaButtonList() {
    List<ButtonData> list = List();
    list.add(ButtonData("Create", DeviceDetailAction.CREATE));
    list.add(ButtonData("Read", DeviceDetailAction.READ));
    list.add(ButtonData("Update", DeviceDetailAction.UPDATE));
    list.add(ButtonData("Delete", DeviceDetailAction.DELETE));
    list.add(ButtonData("Back", DeviceDetailAction.POP_BACK));

    List<Widget> buttonList = List();
    list.forEach((it) {
      buttonList.add(getCtaButton(it));
    });
    return buttonList;
  }

  Widget getCtaButton(ButtonData buttonData) {
    return RaisedButton(
      onPressed: () => handleUpdateTableName(buttonData.action, context),
      child: Text(buttonData.text, style: TextStyle(fontSize: 20)),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 5,
    );
  }

  Widget getListView(int count) {
    return Expanded(
      child: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext ctx, int index) {
            return Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Column name',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Value',
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
