import 'dart:async';

import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/data/TableMode.dart';
import 'package:example_flutter/data/TableModeListItem.dart';
import 'package:example_flutter/domain/usecases/ColumnNameUseCase.dart';
import 'package:example_flutter/domain/usecases/GetPackagesUseCase.dart';
import 'package:example_flutter/presentation/HexColor.dart';
import 'package:example_flutter/presentation/data/ButtonData.dart';
import 'package:example_flutter/presentation/data/DeviceDetailAction.dart';
import 'package:example_flutter/presentation/data/DeviceDetailData.dart';
import 'package:example_flutter/presentation/data/TableData.dart';
import 'package:example_flutter/presentation/data/UpdateTableData.dart';
import 'package:example_flutter/presentation/routes/Router.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceDetailVM.dart';
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
  Widget dropDownTableNameWidget;
  List<String> outputResultList = List();
  List<String> tableNames = List();
  List<TableModeListItem> tableModeList = List();
  TableModeListItem selectedTableModeItem;

  final outputController = ScrollController();
  final dbNameController = TextEditingController();
  TableData tableData;
  UpdateTableData updateTableData;
  String selectedTableName = "";

  _DeviceDetailActivityState(this.deviceDetailData);

  @override
  void initState() {
    tableModeList.add(TableModeListItem("Add record", TableMode.CREATE));
    tableModeList.add(TableModeListItem("Update record", TableMode.UPDATE));

    selectedTableModeItem = tableModeList[0];

    historyWidgetList = Container();
    dropDownTableNameWidget = Container();
    detailVM = DeviceDetailVM(
        GetPackagesUseCase(), ColumnNameUseCase(), processCallback, deviceDetailData.adbPath);
    detailVM.createConnection(
        deviceDetailData.deviceName,
        deviceDetailData.packageName,
        deviceDetailData.databaseName,
        connectionCallback, (List<String> tableNames) {
      setState(() {
        this.tableNames = tableNames;
      });
    });
  }

  Widget dropDownTableName(List<String> tableNames) {
    if (tableNames.length == 0) {
      return Container();
    }

    if (selectedTableName == "") {
      selectedTableName = tableNames[0];
    }
    return Container(
      child: DropdownButton<String>(items: tableNames.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
        value: selectedTableName,
        onChanged: (String value) {
          setState(() {
            selectedTableName = value;
          });
        },),
    );
  }

  handleBackPress() {
    detailVM.killOldProcess();
  }

  void updateHeight(double height) {
    setState(() {});
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

  void updateTableName() {
    detailVM.readTableSchema(selectedTableName, ((Map<String, String> columnDataTypes) {
      setState(() {
//        List<String> formattedColumns = columnDataTypes.keys.toList();
        tableData = TableData(columnDataTypes);

        if (selectedTableModeItem.tableMode == TableMode.UPDATE) {
          updateTableData = UpdateTableData(columnDataTypes);
        }
      });
    }));
  }

  void handleBottomCta(DeviceDetailAction action, BuildContext ctx) {
    switch (action) {
      case DeviceDetailAction.POP_BACK:
        Router.popBackStack(ctx);
        break;
      case DeviceDetailAction.PRETTY_JSON:
        {
          String prettyJson =
          detailVM.getPrettyJson(getResponseEditingController().text);
          setState(() {
            getResponseEditingController().text = prettyJson;
          });
        }
        break;
      default:
        {
          detailVM.performDatabaseOperations(action, selectedTableName, tableData);
        }
    }
  }

  TextEditingController getResponseEditingController() {
    int index = 0;
    for (int i = 0; i < tableData.listOfListItemData.length; ++i) {
      String value = tableData.listOfListItemData[i].colNameController.text;
      if (value == 'response') {
        index = i;
        break;
      }
    }
    return tableData.listOfListItemData[index].colValueController;
  }

  Widget getTableModeWidget() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
      child: DropdownButton<TableModeListItem>(
        onChanged: (TableModeListItem value) {
          setState(() {
            selectedTableModeItem = value;
          });
        },
        value: selectedTableModeItem,
        items: tableModeList
            .map<DropdownMenuItem<TableModeListItem>>((TableModeListItem value) {
          return DropdownMenuItem<TableModeListItem>(
            value: value,
            child: Text(value.title),
          );
        }).toList()
        ,),
    );
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
              margin: EdgeInsets.fromLTRB(16, 18, 0, 0),
              child: Text("Select Table name", style: TextStyle(fontSize: 18),),
            ),
            Container(child: dropDownTableName(tableNames), margin: EdgeInsets.fromLTRB(20, 4, 0, 0),),
            Padding(
              padding: const EdgeInsets.fromLTRB(500, 18, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text("Select either mode", style: TextStyle(fontSize: 18)),
                  getTableModeWidget(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(200, 10, 10, 10),
                      child: RaisedButton(
                        onPressed: () => {updateTableName()},
                        child: const Text('Get Columns', style: TextStyle(fontSize: 20)),
                        color: Colors.blue,
                        textColor: Colors.white,
                        elevation: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),

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
//          getUpdateWidgetContainer(2, ),
          getListView(updateTableData),
         getListView(tableData),
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

  Widget getEnterDbName(double tableNameFieldWidth) {
    return Row(children: <Widget>[
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
                border: UnderlineInputBorder(), hintText: 'Enter databse name'),
          ),
        ),
      )
    ]);
  }

  List<Widget> getCtaButtonList() {
    List<ButtonData> list = List();
    list.add(ButtonData("Pretty Json", DeviceDetailAction.PRETTY_JSON));
    list.add(ButtonData("Create", DeviceDetailAction.CREATE));
    list.add(ButtonData("Read", DeviceDetailAction.READ));
//    list.add(ButtonData("Update", DeviceDetailAction.UPDATE));
//    list.add(ButtonData("Delete", DeviceDetailAction.DELETE));
    list.add(ButtonData("Back", DeviceDetailAction.POP_BACK));

    List<Widget> buttonList = List();
    list.forEach((it) {
      buttonList.add(getCtaButton(it));
    });
    return buttonList;
  }

  Widget getCtaButton(ButtonData buttonData) {
    return RaisedButton(
      onPressed: () => handleBottomCta(buttonData.action, context),
      child: Text(buttonData.text, style: TextStyle(fontSize: 20)),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 5,
    );
  }

  Widget getListView(TableData tableData) {
    if (tableData == null || tableData.fieldCount == 0) return Container();
    if (tableData is UpdateTableData) {
      return Expanded(child: getListViewForTable(tableData),);
    } else
      return Expanded(
        child: Scrollbar(
          child: getListViewForTable(tableData),
        ),
      );
  }

  Widget getListViewForTable(TableData tableData) {
    return ListView.builder(
        itemCount: tableData.fieldCount,
        itemBuilder: (BuildContext ctx, int index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                width: 300,
                height: 50,
                child: TextField(
                  controller: tableData.listOfListItemData[index].colNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: HexColor("#e0e0e0"))),
                    border: OutlineInputBorder(),
                    hintText: 'Column name',
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(border: Border(
                      top: BorderSide(width: 1.0, color: HexColor("#5BC3DA")),
                      left: BorderSide(width: 1.0, color: HexColor("#5BC3DA")),
                      right: BorderSide(width: 1.0, color: HexColor("#5BC3DA")),
                      bottom: BorderSide(width: 1.0, color: HexColor("#5BC3DA"))
                  ),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: HexColor("#F6F4E8"),),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  height: getHeightOfColumnValue(tableData.listOfListItemData[index].colNameController.text),
                  margin: EdgeInsets.fromLTRB(0, 8, 10, 0),
                  child: Stack(
                    children: <Widget>[
                      TextField(
                        controller: tableData.listOfListItemData[index].colValueController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter value"),
                        maxLines: null,
                      ),
//                          getDraggableWidget()
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }


  double getHeightOfColumnValue(String columnName) {
    if (columnName == 'response') {
      return 500;
    }
    return 50;
  }

  Widget getDraggableWidget() {
    return Listener(
      child: Container(
        color: Colors.red,
        width: 40,
        height: 40,
      ),
      onPointerDown: (details) {},
      onPointerUp: (details) {},
      onPointerMove: (details) {},
    );
  }
}
