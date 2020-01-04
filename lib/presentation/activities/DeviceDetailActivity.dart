import 'package:example_flutter/domain/GetPackagesUseCase.dart';
import 'package:example_flutter/presentation/HexColor.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceDetailVM.dart';
import 'package:flutter/cupertino.dart';
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

  void handleUpdateTableName() {}

  @override
  void initState() {
    detailVM.getPackagesWhereLibraryIsInstalled(showPackages);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
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
                      border: InputBorder.none, hintText: 'Enter databse name'),
                ),
              ),
            )
          ]),
          Row(children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Text(
                "Table name",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Enter table name'),
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
                    onPressed: handleUpdateTableName,
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
          getListView(3),
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
            child: Text(""),
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
    List<String> list = List();
    list.add("Create");
    list.add("Read");
    list.add("Update");
    list.add("Delete");

    List<Widget> buttonList = List();
    list.forEach((it) {
      buttonList.add(getCtaButton(it));
    });
    return buttonList;
  }

  Widget getCtaButton(String name) {
    return RaisedButton(
      onPressed: handleUpdateTableName,
      child: Text(name, style: TextStyle(fontSize: 20)),
      color: Colors.blue,
      textColor: Colors.white,
      elevation: 5,
    );
  }

  Widget getOldWidgets() {
    return Column(
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
              border: InputBorder.none, hintText: 'Enter a package'),
        ),
        historyWidgetList,
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
      ],
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
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter column name',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 10, 0),
                    child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter value',
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
