// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PackageTableData extends DataClass
    implements Insertable<PackageTableData> {
  final int id;
  final String name;
  final DateTime createdDate;
  final bool isEnabled;
  PackageTableData(
      {@required this.id,
      @required this.name,
      this.createdDate,
      @required this.isEnabled});
  factory PackageTableData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return PackageTableData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      createdDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_date']),
      isEnabled: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_enabled']),
    );
  }
  factory PackageTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return PackageTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson(
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  @override
  PackageTableCompanion createCompanion(bool nullToAbsent) {
    return PackageTableCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      createdDate: createdDate == null && nullToAbsent
          ? const Value.absent()
          : Value(createdDate),
      isEnabled: isEnabled == null && nullToAbsent
          ? const Value.absent()
          : Value(isEnabled),
    );
  }

  PackageTableData copyWith(
          {int id, String name, DateTime createdDate, bool isEnabled}) =>
      PackageTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        createdDate: createdDate ?? this.createdDate,
        isEnabled: isEnabled ?? this.isEnabled,
      );
  @override
  String toString() {
    return (StringBuffer('PackageTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdDate: $createdDate, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(id.hashCode,
      $mrjc(name.hashCode, $mrjc(createdDate.hashCode, isEnabled.hashCode))));
  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      (other is PackageTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdDate == this.createdDate &&
          other.isEnabled == this.isEnabled);
}

class PackageTableCompanion extends UpdateCompanion<PackageTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdDate;
  final Value<bool> isEnabled;
  const PackageTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
  });
  PackageTableCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.createdDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
  }) : name = Value(name);
  PackageTableCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<DateTime> createdDate,
      Value<bool> isEnabled}) {
    return PackageTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class $PackageTableTable extends PackageTable
    with TableInfo<$PackageTableTable, PackageTableData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PackageTableTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  GeneratedIntColumn _id;
  @override
  GeneratedIntColumn get id => _id ??= _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn('id', $tableName, false,
        hasAutoIncrement: true, declaredAsPrimaryKey: true);
  }

  final VerificationMeta _nameMeta = const VerificationMeta('name');
  GeneratedTextColumn _name;
  @override
  GeneratedTextColumn get name => _name ??= _constructName();
  GeneratedTextColumn _constructName() {
    return GeneratedTextColumn('name', $tableName, false, minTextLength: 1);
  }

  final VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  GeneratedDateTimeColumn _createdDate;
  @override
  GeneratedDateTimeColumn get createdDate =>
      _createdDate ??= _constructCreatedDate();
  GeneratedDateTimeColumn _constructCreatedDate() {
    return GeneratedDateTimeColumn(
      'created_date',
      $tableName,
      true,
    );
  }

  final VerificationMeta _isEnabledMeta = const VerificationMeta('isEnabled');
  GeneratedBoolColumn _isEnabled;
  @override
  GeneratedBoolColumn get isEnabled => _isEnabled ??= _constructIsEnabled();
  GeneratedBoolColumn _constructIsEnabled() {
    return GeneratedBoolColumn('is_enabled', $tableName, false,
        defaultValue: Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [id, name, createdDate, isEnabled];
  @override
  $PackageTableTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'package_table';
  @override
  final String actualTableName = 'package_table';
  @override
  VerificationContext validateIntegrity(PackageTableCompanion d,
      {bool isInserting = false}) {
    final context = VerificationContext();
    if (d.id.present) {
      context.handle(_idMeta, id.isAcceptableValue(d.id.value, _idMeta));
    } else if (id.isRequired && isInserting) {
      context.missing(_idMeta);
    }
    if (d.name.present) {
      context.handle(
          _nameMeta, name.isAcceptableValue(d.name.value, _nameMeta));
    } else if (name.isRequired && isInserting) {
      context.missing(_nameMeta);
    }
    if (d.createdDate.present) {
      context.handle(_createdDateMeta,
          createdDate.isAcceptableValue(d.createdDate.value, _createdDateMeta));
    } else if (createdDate.isRequired && isInserting) {
      context.missing(_createdDateMeta);
    }
    if (d.isEnabled.present) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableValue(d.isEnabled.value, _isEnabledMeta));
    } else if (isEnabled.isRequired && isInserting) {
      context.missing(_isEnabledMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PackageTableData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PackageTableData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(PackageTableCompanion d) {
    final map = <String, Variable>{};
    if (d.id.present) {
      map['id'] = Variable<int, IntType>(d.id.value);
    }
    if (d.name.present) {
      map['name'] = Variable<String, StringType>(d.name.value);
    }
    if (d.createdDate.present) {
      map['created_date'] =
          Variable<DateTime, DateTimeType>(d.createdDate.value);
    }
    if (d.isEnabled.present) {
      map['is_enabled'] = Variable<bool, BoolType>(d.isEnabled.value);
    }
    return map;
  }

  @override
  $PackageTableTable createAlias(String alias) {
    return $PackageTableTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PackageTableTable _packageTable;
  $PackageTableTable get packageTable =>
      _packageTable ??= $PackageTableTable(this);
  PackageTableDao _packageTableDao;
  PackageTableDao get packageTableDao =>
      _packageTableDao ??= PackageTableDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [packageTable];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PackageTableDaoMixin on DatabaseAccessor<AppDatabase> {
  $PackageTableTable get packageTable => db.packageTable;
}
