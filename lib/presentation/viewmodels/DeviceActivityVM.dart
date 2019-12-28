import 'dart:io';

import 'package:example_flutter/data/Devices.dart';

import '../../domain/GetDevicesUseCase.dart';

class DeviceActivityVM {
  GetDevicesUseCase useCase;

  DeviceActivityVM() {
    this.useCase = new GetDevicesUseCase();
  }

  Future<void>  getConnectedDevices(Function function) async {
    List<Devices> devices =  await useCase.getConnectedDevices();
    function(devices);
  }
}
