import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/usecases/GetPackagesUseCase.dart';
import 'package:example_flutter/domain/usecases/GetPrettyJsonUseCase.dart';
import 'package:example_flutter/presentation/data/DeviceDetailAction.dart';
import 'package:example_flutter/presentation/data/EmulatorProcessCallback.dart';
import 'package:example_flutter/presentation/data/TableData.dart';

class DeviceDetailVM {
  GetPackagesUseCase useCase;
  Process emulatorProcess;
  Process sqlProcess;
  Function processCallback;
  String adbPath;
  GetPrettyJsonUseCase getPrettyJsonUseCase;
  EmulatorProcessCallback emulatorProcessCallback;

  DeviceDetailVM(GetPackagesUseCase getPackagesUseCase,
      Function processCallback, String adbPath) {
    this.useCase = getPackagesUseCase;
    this.processCallback = processCallback;
    this.adbPath = adbPath;

    this.getPrettyJsonUseCase = GetPrettyJsonUseCase();
  }

  Future<void> getDatabases(String packageName) async {
    Future<ProcessResult> result = Process.run(adbPath, ['devices']);
    ProcessResult pr = await result;
    print(pr.stdout);
    return result;
  }

  Future<void> createConnection(String deviceName, String packageName,
      String databaseName, Function function) async {
    Result result;
    try {
      await connectEmulator(deviceName);
      await gotoPackage(packageName);
      await listFiles();
      await connectDatabase(databaseName);
      String message = "Connection to database Successfull";
      result = Success(message);
    } catch (err) {
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

      if (emulatorProcessCallback != null) {
        emulatorProcessCallback.success(data);
      }
    });

    emulatorProcess.stderr.transform(utf8.decoder).listen((data) {
      print("------ERROR-----");
      print(data);
      processCallback(Fail(Exception(data)));

      if (emulatorProcessCallback != null) {
        emulatorProcessCallback.fail();
      }
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
    } else {
      killOldProcess();
      throw Exception("Emulator Process is null in finding package");
    }
  }

  listFiles() async {
    if (emulatorProcess != null) {
      emulatorProcess.stdin.writeln("ls");
    } else {
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
    } else {
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

  void performDatabaseOperations(DeviceDetailAction action, String tableName, TableData tableData) {
    if (tableData == null) {
      return;
    }

    if (emulatorProcess == null) {
      processCallback(Fail(Exception("Cannor perform CRUD operations")));
      return;
    }

    if (tableName.isEmpty) {
      processCallback(Fail(Exception("Please enter table name")));
      return;
    }

    switch (action) {
      case DeviceDetailAction.READ:
        {
          emulatorProcess.stdin.writeln(getAndroidSqlExp("select * from $tableName"));
        }
        break;
      case DeviceDetailAction.CREATE:
        {
          int length = tableData.columnEditor.length;

          var colNamesList =
          tableData.columnEditor.map((it) => it.text.toString()).toList();
          var valuesList =
          tableData.valueEditor.map((it) => it.text.toString()).toList();
          String columnNameExpression = getColExpressions(colNamesList);
          String valuesExpression = getColExpressions(valuesList);

          String createExp =
              "INSERT INTO $tableName $columnNameExpression VALUES $valuesExpression";
          //todo Rahul valuesExpression needs special care
          // As all string values must in encoded within within single quotes like - 'some value'
          //throw exception when column name is not present
          emulatorProcess.stdin.writeln(getAndroidSqlExp(createExp));
        }
        break;
      default:
    }
  }

  void readTableSchema(String tableName, Function callback) {
    emulatorProcessCallback = EmulatorProcessCallback();
    emulatorProcessCallback.success = (String schemaString) {
      //CREATE TABLE `RestResponse` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `response` TEXT, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `enabled` INTEGER NOT NULL, `url` TEXT NOT NULL, `httpMethod` TEXT NOT NULL);
      List<String> list = schemaString.split(',');
      Map<String, String> colNameDataType = HashMap();
      if (list.length > 1) {
        list.skip(1).forEach((f) =>
        {
          colNameDataType[f.split(' ')[1]] = f.split(' ')[2]
        });
      }

      //list[0] = CREATE TABLE `RestResponse` (`id` INTEGER PRIMARY KEY AUTOINCREMENT
      List<String> items = list[0].split('(')[1].split(' ');
      colNameDataType[items[0]] = items[1];

      callback(colNameDataType);
    };
    emulatorProcessCallback.fail = () {

    };
    emulatorProcess.stdin.writeln(".schema $tableName");
  }

  String getColExpressions(List<String> text) {
    StringBuffer sb = new StringBuffer();
    sb.write("(");
    for (int i = 0; i < text.length; ++i) {
      sb.write(text);
      if (i != text.length - 1) {
        sb.write(",");
      }
    }
    sb.write(")");
    return sb.toString();
  }

  String getValueExpressions(List<String> text) {
    StringBuffer sb = new StringBuffer();
    sb.write("(");
    for (int i = 0; i < text.length; ++i) {
      sb.write(text);
      if (i != text.length - 1) {
        sb.write(",");
      }
    }
    sb.write(")");
    return sb.toString();
  }

  String getPrettyJson(String json) {
    try {
      return getPrettyJsonUseCase.getPrettyJson(json);
    } catch (e) {
      processCallback(Fail(Exception("Pretty Json exception")));
      processCallback(Fail(e));
    }
    return json;
  }

  String getAndroidSqlExp(String expression) {
    return expression + ";";
  }
}
