import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'moor_database.g.dart';

class PackageTable extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();
  DateTimeColumn get createdDate => dateTime().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [PackageTable], daos: [PackageTableDao])
class AppDatabase extends _$AppDatabase{
  AppDatabase():super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
//    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File('db.sqlite');
    return VmDatabase(file);
  });
}

@UseDao(tables: [PackageTable])
class PackageTableDao extends DatabaseAccessor<AppDatabase> with _$PackageTableDaoMixin {
  PackageTableDao(AppDatabase db) : super(db);

  Future<List<PackageTableData>> getEnabledPackage() {
    return (select(packageTable)..where((t) => t.isEnabled.equals(true))..limit(1)).get();
  }
  Future<int> insertOrUpdatePackage(PackageTableCompanion package) {
    int count = _isPackagePresent(package.name.value);
    if(count == 0) {
      return into(packageTable).insert(package);
    }else{
      return update(packageTable).write(package);
    }
  }

  _isPackagePresent(String packageNameName) async {
    return await (select(packageTable)..where((t) => t.name.equals(packageNameName))..limit(1)).get();
  }

}