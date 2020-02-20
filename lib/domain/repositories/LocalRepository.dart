import 'package:example_flutter/data/moor_database.dart';
import 'package:moor/moor.dart' as moor;

class LocalRepository {
  final PackageTableDao packageTableDao;
  final MobileDbTableDao mobileDbTableDao;

  LocalRepository(this.packageTableDao, this.mobileDbTableDao);

  Future<List<PackageTableData>> getDefaultPackage() {
    return packageTableDao.getEnabledPackage();
  }
  Future<List<MobileDbTableData>> getDefaultDb() {
    return mobileDbTableDao.getEnabledDb();
  }

  void createOrUpdatePackage(String packageName, bool isEnabled) {
    if(packageName.isNotEmpty){
      packageTableDao.insertOrUpdateRecord(PackageTableCompanion(
          name: moor.Value(packageName), isEnabled: moor.Value(isEnabled)));
    }
  }

  void createOrUpdateMobileDb(String dbName, bool isEnabled) {
    if(dbName.isNotEmpty){
      mobileDbTableDao.insertOrUpdateRecord(MobileDbTableCompanion(
          name: moor.Value(dbName), isEnabled: moor.Value(isEnabled)));
    }
  }
}
