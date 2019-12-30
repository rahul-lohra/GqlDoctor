import 'package:example_flutter/domain/GetPackagesUseCase.dart';
import 'package:example_flutter/presentation/viewmodels/DeviceDetailVM.dart';
import 'package:flutter/material.dart';

class DeviceDetailActivity extends StatefulWidget {
  @override
  _DeviceDetailActivityState createState() => _DeviceDetailActivityState();
}

class _DeviceDetailActivityState extends State<DeviceDetailActivity> {
  DeviceDetailVM detailVM = new DeviceDetailVM(new GetPackagesUseCase());

  Widget historyWidgetList = Container();
  void showPackages(Set<String> packageList) {
    setState(() {
      setHistoryWidget(packageList.toList(growable: false));
    });
  }

  void setHistoryWidget(List<String> packageList){
    historyWidgetList =  Expanded(
      child: ListView.builder(
        itemCount: packageList.length,
        itemBuilder: (BuildContext ctx, int index) {
          return new Container(
            child: GestureDetector(child: Text(packageList[index]), onTap: (){
              detailVM.getDatabases(packageList[index]);
            },),
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
          historyWidgetList
        ],
      ),
    );
  }
}
