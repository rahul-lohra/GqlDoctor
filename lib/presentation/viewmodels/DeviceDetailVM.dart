import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/domain/GetPackagesUseCase.dart';

class DeviceDetailVM {
  GetPackagesUseCase useCase;
  Process emulatorProcess;
  Process sqlProcess;

  DeviceDetailVM(GetPackagesUseCase getPackagesUseCase) {
    this.useCase = getPackagesUseCase;
  }

  Future<void> getPackagesWhereLibraryIsInstalled(Function function) async {
    Set<String> packageList = new Set();
    packageList.add("com.rahullohra.gqldeveloperapp");
    function(packageList);
  }

  Future<void> getDatabases(String packageName) async {
    Future<ProcessResult> result = Process.run('adb', ['devices']);
    ProcessResult pr = await result;
    print(pr.stdout);
    return result;
  }

  connectEmulator(String name) async {
    List<String> arguments = new List();
    arguments.add('-s');
    arguments.addAll(name.split(" "));
    arguments.add('shell');
    killOldProcess();
    Future<Process> pr = Process.start('adb', arguments);
    emulatorProcess = await pr;

    emulatorProcess.stdout.transform(utf8.decoder).listen((data) {
      print("------DATA-----");
      print(data);
    });

    emulatorProcess.stderr.transform(utf8.decoder).listen((data) {
      print("------ERROR-----");
      print(data);
    });

    print(emulatorProcess.stdout);
  }

  killOldProcess() {
    if (emulatorProcess != null) {
      emulatorProcess.kill();
    }
  }

  gotoPackage(String packageName) async {
    List<String> arguments = new List();
    arguments.add('run-as');
    arguments.add(packageName);

    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("run-as ${packageName}");
    }
  }

  listFiles() async {
    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("ls");
    }
  }

  connectDatabase() async {
    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("app_gqlLibs/sqlite3 'databases/gqlDb'");
    }
  }

  gotoSqlLibDir() async {
    List<String> arguments = new List();
    arguments.add('cd');
    arguments.add('app_gqlLibs');

    Future<ProcessResult> result = Process.run('', arguments);
    ProcessResult pr = await result;
    print(pr.stdout);
    return result;
  }

  showAllTables() async {
    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("Select * from Gql;");
    }
  }

  showTables(String dbName) {}
}
