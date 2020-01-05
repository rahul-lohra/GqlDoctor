import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/GetPackagesUseCase.dart';

class DeviceDetailVM {
  GetPackagesUseCase useCase;
  Process emulatorProcess;
  Process sqlProcess;
  Function processCallback;

  DeviceDetailVM(GetPackagesUseCase getPackagesUseCase, Function processCallback) {
    this.useCase = getPackagesUseCase;
    this.processCallback = processCallback;
  }

  Future<void> getDatabases(String packageName) async {
    Future<ProcessResult> result = Process.run('adb', ['devices']);
    ProcessResult pr = await result;
    print(pr.stdout);
    return result;
  }

  void createConnection(String deviceName, String packageName, String databaseName, Function function){
    Result result;
    try{
    connectEmulator(deviceName);
    gotoPackage(packageName);
    listFiles();
    connectDatabase(databaseName);
    String message = "Connection to database Successfull";
    result = Success(message);
    }catch(err){
      result = Fail(err);
    }
    function(result);
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
      processCallback(Success(data));
    });

    emulatorProcess.stderr.transform(utf8.decoder).listen((data) {
      print("------ERROR-----");
      print(data);
      processCallback(Fail(Exception(data)));
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
    }else {
      killOldProcess();
      throw Exception("Emulator Process is null in finding package");
    }
  }

  listFiles() async {
    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("ls");
    }else {
      killOldProcess();
      throw Exception("Emulator Process is null in listing files");
    }
  }

  connectDatabase(String databaseName) async {
    if (emulatorProcess != null) {
      // emulatorProcess.stdin.writeln("app_gqlLibs/sqlite3 'databases/gqlDb'");
      String databasePath = 'databases/$databaseName';
      String sqlite3Path = 'app_gqlLibs/sqlite3';
      emulatorProcess.stdin.writeln("$sqlite3Path $databasePath");
    }else {
      killOldProcess();
      throw Exception("Emulator Process is null Connecting db");
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
