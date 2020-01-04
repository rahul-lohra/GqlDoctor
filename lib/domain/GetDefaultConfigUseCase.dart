import 'package:example_flutter/data/moor_database.dart';
import 'package:example_flutter/domain/LocalRepository.dart';
import 'package:flutter/material.dart';

class GetDefaultConfigUseCase {
  final LocalRepository localRepository;

  GetDefaultConfigUseCase(this.localRepository);

  Future<String> getDefaultPackageName() async {
    List<PackageTableData> list = await localRepository.getDefaultPackage();
    if (list.isEmpty) {
      return "";
    } else {
      return list[0].name;
    }
  }

  Future<String> getDefaultDbName() async {
    List<MobileDbTableData> list = await localRepository.getDefaultDb();
    if (list.isEmpty) {
      return "";
    } else {
      return list[0].name;
    }
  }

  void createOrUpdatePackage(String packageName, bool isEnabled) {
    localRepository.createOrUpdatePackage(packageName, isEnabled);
  }

  void createOrUpdateMobileDb(String databaseName, bool isEnabled) {
    localRepository.createOrUpdateMobileDb(databaseName, isEnabled);
  }
}
