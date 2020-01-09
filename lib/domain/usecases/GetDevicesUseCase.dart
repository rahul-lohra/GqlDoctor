import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/domain/repositories/DevicesRepository.dart';

class GetDevicesUseCase {
  DevicesRepository repository;

  GetDevicesUseCase() {
    repository = new DevicesRepository();
  }

  Future<List<Devices>> getConnectedDevices() async{
    ProcessResult pr = await repository.getConnectedDevices();
    return processResultToDevices(pr);
  }

  List<Devices> processResultToDevices(ProcessResult result) {
    dynamic resultText = result.stdout;
    if (resultText is String) {
      List<String> list = resultText.trim().split(new RegExp("\n"));
      if (list == null || list.isEmpty || list.length == 1) {
        throw NoDevicesException();
      } else {
        List<Devices> devices = new List();
         list.sublist(1, list.length).forEach((it) => {devices.add(Devices(utf8.decode(it.codeUnits)))});
         return devices;
      }
    } else {
      throw UnableToReadFromShellException();
    }
  }
}

class NoDevicesException extends BaseException {
  NoDevicesException({String message}) : super(message);

}
class UnableToReadFromShellException extends BaseException {
  UnableToReadFromShellException({String message}) : super(message);
}
class BaseException implements Exception {
  final String message;
  BaseException(this.message);

  String toString() => "$runtimeType: $message";
}
