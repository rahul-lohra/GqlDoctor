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
    }
    function(resultDevices);

  }
}
