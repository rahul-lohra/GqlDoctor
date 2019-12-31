import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/data/Result.dart';

import '../../domain/GetDevicesUseCase.dart';

class DeviceActivityVM {
  GetDevicesUseCase useCase;

  DeviceActivityVM() {
    this.useCase = new GetDevicesUseCase();
  }

  Future<void>  getConnectedDevices(Function function) async {
    Result resultDevices;
    try{
      List<Devices> devices =  await useCase.getConnectedDevices();
      resultDevices = Success(devices);
    }catch(err){
      resultDevices = Fail(err);

      //todo Rahul Remove later
      List<Devices> devices = new List();
      devices.add(Devices("Emulator 5554 -1"));
      devices.add(Devices("Emulator 5554 -2"));
      devices.add(Devices("Emulator 5554 -3"));
      devices.add(Devices("Emulator 5554 -4"));
      devices.add(Devices("Emulator 5554 -5"));
      resultDevices = Success(devices);
    }
    function(resultDevices);

  }
}
