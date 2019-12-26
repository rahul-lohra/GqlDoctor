import 'GetDevicesUseCase.dart';

class DeviceActivityVM {
  GetDevicesUseCase useCase;

  DeviceActivityVM(){
    this.useCase = new GetDevicesUseCase();
  }

  void getConnectedDevices() {
    useCase.getConnectedDevices();
  }
}
