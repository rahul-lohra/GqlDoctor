import 'dart:convert';
import 'dart:io';

import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/domain/DevicesRepository.dart';

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
      List<String> list = resultText.split(new RegExp("\n"));
      if (list == null || list.isEmpty || list.length == 1) {
        throw NoDevicesException;
      } else {
        List<Devices> devices = new List();
         list.sublist(1, list.length).forEach((it) => {devices.add(Devices(utf8.decode(it.codeUnits)))});
         return devices;
      }
    } else {
      throw UnableToReadFromShellException;
    }
  }
}

mixin NoDevicesException implements Exception {}
mixin UnableToReadFromShellException implements Exception {}
