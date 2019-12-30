import 'dart:io';

import 'package:example_flutter/domain/DevicesRepository.dart';

class GetPackagesUseCase {
  DevicesRepository repository;

  GetPackagesUseCase() {
    repository = new DevicesRepository();
  }

  Future<ProcessResult> getPackages() async {
    return repository.getPackagesWhereLibraryIsInstalled();
  }
}
