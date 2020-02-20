import 'package:example_flutter/data/Devices.dart';
import 'package:example_flutter/data/Result.dart';
import 'package:example_flutter/domain/usecases/GetAdbUseCase.dart';
import 'package:example_flutter/domain/usecases/GetDefaultConfigUseCase.dart';

import '../../domain/usecases/GetDevicesUseCase.dart';

class DeviceActivityVM {
  final GetDevicesUseCase useCase;
  final GetDefaultConfigUseCase getDefaultConfigUseCase;
  final GetAdbUseCase getAdbUseCase;

  DeviceActivityVM(
      this.useCase, this.getDefaultConfigUseCase, this.getAdbUseCase);

  Future<void> getDefaultPackageName(Function function) async {
    Result defaultPackageName;
    try {
      String name = await getDefaultConfigUseCase.getDefaultPackageName();
      defaultPackageName = Success(name);
    } catch (err) {
      defaultPackageName = Fail(err);
    }
    function(defaultPackageName);
  }

  Future<void> getDefaultDbName(Function function) async {
    Result defaultDbName;
    try {
      String name = await getDefaultConfigUseCase.getDefaultDbName();
      defaultDbName = Success(name);
    } catch (err) {
      defaultDbName = Fail(err);
    }
    function(defaultDbName);
  }

  void createOrUpdatePackage(String packageName, bool isPackageEnabled,
      String dbName, bool isDbEnabled) {
    try {
      getDefaultConfigUseCase.createOrUpdatePackage(
          packageName, isPackageEnabled);
      getDefaultConfigUseCase.createOrUpdateMobileDb(dbName, isDbEnabled);
    } catch (err) {
      print(err);
    }
  }

  Future<void> getConnectedDevices(Function function) async {
    Result resultDevices;
    try {
      List<Devices> devices = await useCase.getConnectedDevices();
      resultDevices = Success(devices);
    } catch (err) {
      resultDevices = Fail(err);
    }
    function(resultDevices);
  }

  String getAdbPath() {
    return getAdbUseCase.getAdbPath();
  }
}
