import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'moor_database.g.dart';

class PackageTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();

  DateTimeColumn get createdDate => dateTime().nullable()();

  BoolColumn get isEnabled => boolean().withDefault(Constant(false))();
}

class MobileDbTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().withLength(min: 1)();

  BoolColumn get isEnabled => boolean().withDefault(Constant(false))();
}

@UseMoor(
    tables: [PackageTable, MobileDbTable],
    daos: [PackageTableDao, MobileDbTableDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = File('database/db.sqlite');
    if(!file.existsSync()){
      file.createSync(recursive: true);
    }
    return VmDatabase(file);
  });
}

@UseDao(tables: [PackageTable])
class PackageTableDao extends DatabaseAccessor<AppDatabase>
    with _$PackageTableDaoMixin {
  PackageTableDao(AppDatabase db) : super(db);

  Future<List<PackageTableData>> getEnabledPackage() {
    return (select(packageTable)
          ..where((t) => t.isEnabled.equals(true))
          ..limit(1))
        .get();
  }

  Future<int> insertOrUpdateRecord(PackageTableCompanion package) async {
    if (package.isEnabled.value) {
      update(packageTable)
        ..where((it) => it.isEnabled.equals(true))
        ..write(PackageTableCompanion(isEnabled: Value(false)));
    }
    List<PackageTableData> list = await _isPackagePresent(package.name.value);
    if (list.length == 0) {
      return into(packageTable).insert(package);
    } else {
      return update(packageTable).write(package);
    }
  }

  Future<List<PackageTableData>> _isPackagePresent(String packageNameName) {
    return (select(packageTable)
          ..where((t) => t.name.equals(packageNameName))
          ..limit(1))
        .get();
  }
}

@UseDao(tables: [MobileDbTable])
class MobileDbTableDao extends DatabaseAccessor<AppDatabase>
    with _$MobileDbTableDaoMixin {
  MobileDbTableDao(AppDatabase db) : super(db);

  Future<List<MobileDbTableData>> getEnabledDb() {
    return (select(mobileDbTable)
          ..where((t) => t.isEnabled.equals(true))
          ..limit(1))
        .get();
  }

  Future<int> insertOrUpdateRecord(MobileDbTableCompanion data) async {
    if (data.isEnabled.value) {
      update(mobileDbTable)
        ..where((it) => it.isEnabled.equals(true))
        ..write(MobileDbTableCompanion(isEnabled: Value(false)));
    }

    List<MobileDbTableData> list = await _isRecordPresent(data.name.value);
    if (list.length == 0) {
      return into(mobileDbTable).insert(data);
    } else {
      return update(mobileDbTable).write(data);
    }
  }

  Future<List<MobileDbTableData>> _isRecordPresent(String data) {
    return (select(mobileDbTable)
          ..where((t) => t.name.equals(data))
          ..limit(1))
        .get();
  }
}
