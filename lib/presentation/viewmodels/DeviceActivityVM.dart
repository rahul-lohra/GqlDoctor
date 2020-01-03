import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/GetDefaultConfigUseCase.dart';

import '../../domain/GetDevicesUseCase.dart';

class DeviceActivityVM {
  final GetDevicesUseCase useCase;
  final GetDefaultConfigUseCase getDefaultConfigUseCase;

  DeviceActivityVM(this.useCase, this.getDefaultConfigUseCase);

  Future<void> getDefaultPackageName(Function function)async {
    Result defaultPackageName;
    try{
      String name = await getDefaultConfigUseCase.getDefaultPackageName();
      defaultPackageName = Success(name);
    }catch(err){
      defaultPackageName = Fail(err);
    }
    function(defaultPackageName);
  }

  void createOrUpdatePackage(String packageName, bool isEnabled){
    try{
      getDefaultConfigUseCase.createOrUpdatePackage(packageName, isEnabled);
    }catch(err){
      //do nothing
    }
  }

  Future<void>  getConnectedDevices(Function function) async {
    Result resultDevices;
    try{
      List<Devices> devices =  await useCase.getConnectedDevices();
      resultDevices = Success(devices);
    }catch(err){
      resultDevices = Fail(err);

      //todo Rahul Remove later
//      List<Devices> devices = new List();
//      devices.add(Devices("Emulator 5554 -1"));
//      devices.add(Devices("Emulator 5554 -2"));
//      resultDevices = Success(devices);
    }
    function(resultDevices);

  }
}
