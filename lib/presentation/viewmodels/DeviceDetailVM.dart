import 'dart:io';

import 'package:example_flutter/domain/GetPackagesUseCase.dart';

class DeviceDetailVM{
  GetPackagesUseCase useCase;

  DeviceDetailVM(GetPackagesUseCase getPackagesUseCase){
    this.useCase = getPackagesUseCase;
  }

  Future<void> getPackagesWhereLibraryIsInstalled(Function function) async {
    Set<String> packageList = new Set();
    packageList.add("com.rahullohra.gqldeveloperapp");
    function(packageList);
  }

  Future<void> getDatabases(String packageName) async{
    Future<ProcessResult> result =  Process.run('adb', ['devices']);
    ProcessResult pr = await result;
    print(pr.stdout);
    return result;
  }

  showTables(String dbName){}
}