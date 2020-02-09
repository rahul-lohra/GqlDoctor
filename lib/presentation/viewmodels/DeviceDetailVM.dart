import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/usecases/ColumnNameUseCase.dart';
import 'package:example_flutter/domain/usecases/GetPackagesUseCase.dart';
import 'package:example_flutter/domain/usecases/GetPrettyJsonUseCase.dart';
import 'package:example_flutter/presentation/data/DeviceDetailAction.dart';
import 'package:example_flutter/presentation/data/EmulatorProcessCallback.dart';
import 'package:example_flutter/presentation/data/ListItemData.dart';
import 'package:example_flutter/presentation/data/TableData.dart';

class DeviceDetailVM {
  GetPackagesUseCase useCase;
  Process emulatorProcess;
  Process sqlProcess;
  Function processCallback;
  String adbPath;
  GetPrettyJsonUseCase getPrettyJsonUseCase;
  ColumnNameUseCase columnNameUseCase;
  EmulatorProcessCallback emulatorProcessCallback;

  DeviceDetailVM(GetPackagesUseCase getPackagesUseCase, ColumnNameUseCase columnNameUseCase, Function processCallback,
      String adbPath) {
    this.useCase = getPackagesUseCase;
    this.columnNameUseCase = columnNameUseCase;
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
      String databaseName, Function function, Function tableNameCallback) async {
    Result result;
    try {
      await connectEmulator(deviceName);
      await gotoPackage(packageName);
      await connectDatabase(databaseName);
      await listTables(tableNameCallback);
      String message = "Connection to database Successfull";
      result = Success(message);
    } catch (err) {
      result = Fail(err);
    }
    function(result);
  }

  Future<void> listTables(Function function) {
    if (emulatorProcess == null) {
      return null;
    }
    emulatorProcessCallback = EmulatorProcessCallback();
    emulatorProcessCallback.success = (String result) {
      List<String> tableNames = List();
      result.split(RegExp("[\\s]")).forEach((String item) {
        if(item == 'android_metadata'|| item == 'room_master_table'){
          //DO nothing
        } else if (item.length > 1) {
          tableNames.add(item);
        }
        return "";
      });
      function(tableNames);
      print("Success write");
    };
    emulatorProcessCallback.fail = () {
      print("fail write");
    };
    emulatorProcess.stdin.writeln(".tables");
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
          emulatorProcess.stdin.writeln(getAndroidSqlExp("show tables"));
        }
        break;
      case DeviceDetailAction.CREATE:
        {
          var colNamesList = tableData.listOfListItemData.map((it) => it.colNameController.text.toString()).toList();
          Map<String, int> timeMap = getCreatedAtAndUpdatedAt();
          String columnNameExpression = getColExpressions(colNamesList, timeMap);
          String valuesExpression = getValueExpressions(tableData.listOfListItemData, timeMap);

          String createExp = "INSERT INTO $tableName $columnNameExpression VALUES $valuesExpression";

          emulatorProcessCallback = EmulatorProcessCallback();
          emulatorProcessCallback.success = (String result) {
            print("Success write");
          };
          emulatorProcessCallback.fail = () {
            print("fail write");
          };
          emulatorProcess.stdin.writeln(getAndroidSqlExp(createExp));
        }
        break;
      default:
    }
  }

  Map<String, int> getCreatedAtAndUpdatedAt() {
    int currentTime = DateTime
        .now()
        .millisecondsSinceEpoch;
    Map<String, int> map = HashMap();
    map['createdAt'] = currentTime;
    map['updatedAt'] = currentTime;
    return map;
  }

  void readTableSchema(String tableName, Function callback) {
    emulatorProcessCallback = EmulatorProcessCallback();
    emulatorProcessCallback.success = (String schemaString) {
      //CREATE TABLE `RestResponse` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `response` TEXT, `createdAt` INTEGER NOT NULL, `updatedAt` INTEGER NOT NULL, `enabled` INTEGER NOT NULL, `url` TEXT NOT NULL, `httpMethod` TEXT NOT NULL);
      List<String> list = schemaString.split(',');
      Map<String, String> colNameDataType = HashMap();
      if (list.length > 1) {
        for (int i = 1; i < list.length; ++i) {
          String f = list[i];
          String key = f.split(' ')[1].replaceAll(RegExp('`'), '');
          String value = f.split(' ')[2];
          if (columnNameUseCase.getAllowedColumnNames().contains(key)) {
            colNameDataType[key] = value;
          }
        }
      }

      //list[0] = CREATE TABLE `RestResponse` (`id` INTEGER PRIMARY KEY AUTOINCREMENT
      List<String> items = list[0].split('(')[1].split(' ');
      String key = items[0].replaceAll(RegExp('`'), '');
      if (columnNameUseCase.getAllowedColumnNames().contains(key)) {
        colNameDataType[key] = items[1];
      }

      callback(colNameDataType);
    };

    emulatorProcessCallback.fail = () {

    };

    emulatorProcess.stdin.writeln(".schema $tableName");
  }

  String getColExpressions(List<String> textList, Map<String, int> timeMap) {
    StringBuffer sb = new StringBuffer();
    sb.write("(");
    for (int i = 0; i < textList.length; ++i) {
      sb.write(textList[i]);
      if (i != textList.length - 1) {
        sb.write(",");
      }
    }

    timeMap.forEach((key, value) {
      sb.write(",");
      sb.write(key);
    });

    sb.write(")");
    return sb.toString();
  }

  String getValueExpressions(List<ListItemData> listOfListItemData, Map<String, int> timeMap) {
    StringBuffer sb = new StringBuffer();
    sb.write("(");
    for (int i = 0; i < listOfListItemData.length; ++i) {
      String dataType = listOfListItemData[i].dataType;
      String text = listOfListItemData[i].colValueController.text;
      sb.write("'");
      sb.write(text);
      sb.write("'");

      if (i != listOfListItemData.length - 1) {
        sb.write(",");
      }
    }

    timeMap.forEach((key, value) {
      sb.write(",");
      sb.write("'");
      sb.write(value);
      sb.write("'");
    });
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
