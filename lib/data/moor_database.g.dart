// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class PackageNameData extends DataClass implements Insertable<PackageNameData> {
  final int id;
  final String name;
  final DateTime createdDate;
  final bool isEnabled;
  PackageNameData(
      {@required this.id,
      @required this.name,
      this.createdDate,
      @required this.isEnabled});
  factory PackageNameData.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String prefix}) {
    final effectivePrefix = prefix ?? '';
    final intType = db.typeSystem.forDartType<int>();
    final stringType = db.typeSystem.forDartType<String>();
    final dateTimeType = db.typeSystem.forDartType<DateTime>();
    final boolType = db.typeSystem.forDartType<bool>();
    return PackageNameData(
      id: intType.mapFromDatabaseResponse(data['${effectivePrefix}id']),
      name: stringType.mapFromDatabaseResponse(data['${effectivePrefix}name']),
      createdDate: dateTimeType
          .mapFromDatabaseResponse(data['${effectivePrefix}created_date']),
      isEnabled: boolType
          .mapFromDatabaseResponse(data['${effectivePrefix}is_enabled']),
    );
  }
  factory PackageNameData.fromJson(Map<String, dynamic> json,
      {ValueSerializer serializer = const ValueSerializer.defaults()}) {
    return PackageNameData(
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
  PackageNameCompanion createCompanion(bool nullToAbsent) {
    return PackageNameCompanion(
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

  PackageNameData copyWith(
          {int id, String name, DateTime createdDate, bool isEnabled}) =>
      PackageNameData(
        id: id ?? this.id,
        name: name ?? this.name,
        createdDate: createdDate ?? this.createdDate,
        isEnabled: isEnabled ?? this.isEnabled,
      );
  @override
  String toString() {
    return (StringBuffer('PackageNameData(')
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
      (other is PackageNameData &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdDate == this.createdDate &&
          other.isEnabled == this.isEnabled);
}

class PackageNameCompanion extends UpdateCompanion<PackageNameData> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdDate;
  final Value<bool> isEnabled;
  const PackageNameCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
  });
  PackageNameCompanion.insert({
    this.id = const Value.absent(),
    @required String name,
    this.createdDate = const Value.absent(),
    this.isEnabled = const Value.absent(),
  }) : name = Value(name);
  PackageNameCompanion copyWith(
      {Value<int> id,
      Value<String> name,
      Value<DateTime> createdDate,
      Value<bool> isEnabled}) {
    return PackageNameCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class $PackageNameTable extends PackageName
    with TableInfo<$PackageNameTable, PackageNameData> {
  final GeneratedDatabase _db;
  final String _alias;
  $PackageNameTable(this._db, [this._alias]);
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
  $PackageNameTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'package_name';
  @override
  final String actualTableName = 'package_name';
  @override
  VerificationContext validateIntegrity(PackageNameCompanion d,
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
  PackageNameData map(Map<String, dynamic> data, {String tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : null;
    return PackageNameData.fromData(data, _db, prefix: effectivePrefix);
  }

  @override
  Map<String, Variable> entityToSql(PackageNameCompanion d) {
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
  $PackageNameTable createAlias(String alias) {
    return $PackageNameTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  $PackageNameTable _packageName;
  $PackageNameTable get packageName => _packageName ??= $PackageNameTable(this);
  PackageNameDao _packageNameDao;
  PackageNameDao get packageNameDao =>
      _packageNameDao ??= PackageNameDao(this as AppDatabase);
  @override
  List<TableInfo> get allTables => [packageName];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$PackageNameDaoMixin on DatabaseAccessor<AppDatabase> {
  $PackageNameTable get packageName => db.packageName;
}
