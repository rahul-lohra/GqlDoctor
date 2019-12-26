import 'package:example_flutter/domain/DevicesRepository.dart';

class GetDevicesUseCase {
  DevicesRepository repository;

  GetDevicesUseCase(){
    repository = new DevicesRepository();
  }

  getConnectedDevices(){
      repository.getConnectedDevices();
  }

}
