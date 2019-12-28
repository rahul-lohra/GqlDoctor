import 'package:example_flutter/data/Devices.dart';

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

class Result{

}
class Success<T> extends Result{
  T data;
  Success(T data){this.data = data;}
}
class Fail extends Result{
  Exception e;
  Fail(Exception e){this.e = e;}
}
class Loading extends Result{}

class LiveData<T,E>{
  T data;
  E error;

  success(T data){
    this.data = data;
    this.error = null;
  }

  fail(E error){
    this.data = null;
    this.error = error;
  }
}
