import 'package:example_flutter/data/moor_database.dart';
import 'package:moor/moor.dart' as moor;

class LocalRepository {
  final PackageTableDao dao;

  LocalRepository(this.dao);

  Future<List<PackageTableData>> getDefaultPackage() {
    return dao.getEnabledPackage();
  }

  void createOrUpdatePackage(String packageName, bool isEnabled) {
    if(packageName.isNotEmpty){
      dao.insertOrUpdatePackage(PackageTableCompanion(
          name: moor.Value(packageName), isEnabled: moor.Value(isEnabled)));
    }
  }
}
