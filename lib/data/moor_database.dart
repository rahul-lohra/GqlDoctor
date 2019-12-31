import 'package:moor/moor.dart';

part 'moor_database.g.dart';

class PackageName extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1)();
  DateTimeColumn get createdDate => dateTime().nullable()();
  BoolColumn get isEnabled => boolean().withDefault(Constant(false))();
}

@UseMoor(tables: [PackageName], daos: [PackageNameDao])
class AppDatabase extends _$AppDatabase{
  AppDatabase(QueryExecutor e):super(e);

  @override
  int get schemaVersion => 1;
}

@UseDao(tables: [PackageName])
class PackageNameDao extends DatabaseAccessor<AppDatabase> with _$PackageNameDaoMixin {
  PackageNameDao(AppDatabase db) : super(db);
}