// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PlacesTableTable extends PlacesTable
    with TableInfo<$PlacesTableTable, PlacesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryKeyMeta = const VerificationMeta(
    'categoryKey',
  );
  @override
  late final GeneratedColumn<String> categoryKey = GeneratedColumn<String>(
    'category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressLabelMeta = const VerificationMeta(
    'addressLabel',
  );
  @override
  late final GeneratedColumn<String> addressLabel = GeneratedColumn<String>(
    'address_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _visitedAtMeta = const VerificationMeta(
    'visitedAt',
  );
  @override
  late final GeneratedColumn<DateTime> visitedAt = GeneratedColumn<DateTime>(
    'visited_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    categoryKey,
    status,
    latitude,
    longitude,
    addressLabel,
    note,
    rating,
    isFavorite,
    visitedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'places';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlacesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_key')) {
      context.handle(
        _categoryKeyMeta,
        categoryKey.isAcceptableOrUnknown(
          data['category_key']!,
          _categoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryKeyMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('address_label')) {
      context.handle(
        _addressLabelMeta,
        addressLabel.isAcceptableOrUnknown(
          data['address_label']!,
          _addressLabelMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('visited_at')) {
      context.handle(
        _visitedAtMeta,
        visitedAt.isAcceptableOrUnknown(data['visited_at']!, _visitedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlacesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlacesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_key'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      addressLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address_label'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      visitedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visited_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlacesTableTable createAlias(String alias) {
    return $PlacesTableTable(attachedDatabase, alias);
  }
}

class PlacesTableData extends DataClass implements Insertable<PlacesTableData> {
  final String id;
  final String name;
  final String categoryKey;
  final String status;
  final double latitude;
  final double longitude;
  final String? addressLabel;
  final String? note;
  final int? rating;
  final bool isFavorite;
  final DateTime? visitedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PlacesTableData({
    required this.id,
    required this.name,
    required this.categoryKey,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.addressLabel,
    this.note,
    this.rating,
    required this.isFavorite,
    this.visitedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category_key'] = Variable<String>(categoryKey);
    map['status'] = Variable<String>(status);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || addressLabel != null) {
      map['address_label'] = Variable<String>(addressLabel);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || visitedAt != null) {
      map['visited_at'] = Variable<DateTime>(visitedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlacesTableCompanion toCompanion(bool nullToAbsent) {
    return PlacesTableCompanion(
      id: Value(id),
      name: Value(name),
      categoryKey: Value(categoryKey),
      status: Value(status),
      latitude: Value(latitude),
      longitude: Value(longitude),
      addressLabel: addressLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(addressLabel),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isFavorite: Value(isFavorite),
      visitedAt: visitedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(visitedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlacesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlacesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryKey: serializer.fromJson<String>(json['categoryKey']),
      status: serializer.fromJson<String>(json['status']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      addressLabel: serializer.fromJson<String?>(json['addressLabel']),
      note: serializer.fromJson<String?>(json['note']),
      rating: serializer.fromJson<int?>(json['rating']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      visitedAt: serializer.fromJson<DateTime?>(json['visitedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'categoryKey': serializer.toJson<String>(categoryKey),
      'status': serializer.toJson<String>(status),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'addressLabel': serializer.toJson<String?>(addressLabel),
      'note': serializer.toJson<String?>(note),
      'rating': serializer.toJson<int?>(rating),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'visitedAt': serializer.toJson<DateTime?>(visitedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlacesTableData copyWith({
    String? id,
    String? name,
    String? categoryKey,
    String? status,
    double? latitude,
    double? longitude,
    Value<String?> addressLabel = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    bool? isFavorite,
    Value<DateTime?> visitedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PlacesTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    categoryKey: categoryKey ?? this.categoryKey,
    status: status ?? this.status,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    addressLabel: addressLabel.present ? addressLabel.value : this.addressLabel,
    note: note.present ? note.value : this.note,
    rating: rating.present ? rating.value : this.rating,
    isFavorite: isFavorite ?? this.isFavorite,
    visitedAt: visitedAt.present ? visitedAt.value : this.visitedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlacesTableData copyWithCompanion(PlacesTableCompanion data) {
    return PlacesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryKey: data.categoryKey.present
          ? data.categoryKey.value
          : this.categoryKey,
      status: data.status.present ? data.status.value : this.status,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      addressLabel: data.addressLabel.present
          ? data.addressLabel.value
          : this.addressLabel,
      note: data.note.present ? data.note.value : this.note,
      rating: data.rating.present ? data.rating.value : this.rating,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      visitedAt: data.visitedAt.present ? data.visitedAt.value : this.visitedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlacesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('status: $status, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('addressLabel: $addressLabel, ')
          ..write('note: $note, ')
          ..write('rating: $rating, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('visitedAt: $visitedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    categoryKey,
    status,
    latitude,
    longitude,
    addressLabel,
    note,
    rating,
    isFavorite,
    visitedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryKey == this.categoryKey &&
          other.status == this.status &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.addressLabel == this.addressLabel &&
          other.note == this.note &&
          other.rating == this.rating &&
          other.isFavorite == this.isFavorite &&
          other.visitedAt == this.visitedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlacesTableCompanion extends UpdateCompanion<PlacesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> categoryKey;
  final Value<String> status;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> addressLabel;
  final Value<String?> note;
  final Value<int?> rating;
  final Value<bool> isFavorite;
  final Value<DateTime?> visitedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlacesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryKey = const Value.absent(),
    this.status = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.addressLabel = const Value.absent(),
    this.note = const Value.absent(),
    this.rating = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.visitedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacesTableCompanion.insert({
    required String id,
    required String name,
    required String categoryKey,
    required String status,
    required double latitude,
    required double longitude,
    this.addressLabel = const Value.absent(),
    this.note = const Value.absent(),
    this.rating = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.visitedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       categoryKey = Value(categoryKey),
       status = Value(status),
       latitude = Value(latitude),
       longitude = Value(longitude),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PlacesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? categoryKey,
    Expression<String>? status,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? addressLabel,
    Expression<String>? note,
    Expression<int>? rating,
    Expression<bool>? isFavorite,
    Expression<DateTime>? visitedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryKey != null) 'category_key': categoryKey,
      if (status != null) 'status': status,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (addressLabel != null) 'address_label': addressLabel,
      if (note != null) 'note': note,
      if (rating != null) 'rating': rating,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (visitedAt != null) 'visited_at': visitedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? categoryKey,
    Value<String>? status,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? addressLabel,
    Value<String?>? note,
    Value<int?>? rating,
    Value<bool>? isFavorite,
    Value<DateTime?>? visitedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlacesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryKey: categoryKey ?? this.categoryKey,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressLabel: addressLabel ?? this.addressLabel,
      note: note ?? this.note,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      visitedAt: visitedAt ?? this.visitedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryKey.present) {
      map['category_key'] = Variable<String>(categoryKey.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (addressLabel.present) {
      map['address_label'] = Variable<String>(addressLabel.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (visitedAt.present) {
      map['visited_at'] = Variable<DateTime>(visitedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryKey: $categoryKey, ')
          ..write('status: $status, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('addressLabel: $addressLabel, ')
          ..write('note: $note, ')
          ..write('rating: $rating, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('visitedAt: $visitedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlacePhotosTableTable extends PlacePhotosTable
    with TableInfo<$PlacePhotosTableTable, PlacePhotosTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlacePhotosTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES places (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeId,
    filePath,
    thumbnailPath,
    caption,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'place_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlacePhotosTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlacePhotosTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlacePhotosTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlacePhotosTableTable createAlias(String alias) {
    return $PlacePhotosTableTable(attachedDatabase, alias);
  }
}

class PlacePhotosTableData extends DataClass
    implements Insertable<PlacePhotosTableData> {
  final String id;
  final String placeId;
  final String filePath;
  final String? thumbnailPath;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;
  const PlacePhotosTableData({
    required this.id,
    required this.placeId,
    required this.filePath,
    this.thumbnailPath,
    this.caption,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || caption != null) {
      map['caption'] = Variable<String>(caption);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlacePhotosTableCompanion toCompanion(bool nullToAbsent) {
    return PlacePhotosTableCompanion(
      id: Value(id),
      placeId: Value(placeId),
      filePath: Value(filePath),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      caption: caption == null && nullToAbsent
          ? const Value.absent()
          : Value(caption),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory PlacePhotosTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlacePhotosTableData(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      caption: serializer.fromJson<String?>(json['caption']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'filePath': serializer.toJson<String>(filePath),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'caption': serializer.toJson<String?>(caption),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlacePhotosTableData copyWith({
    String? id,
    String? placeId,
    String? filePath,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<String?> caption = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => PlacePhotosTableData(
    id: id ?? this.id,
    placeId: placeId ?? this.placeId,
    filePath: filePath ?? this.filePath,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    caption: caption.present ? caption.value : this.caption,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  PlacePhotosTableData copyWithCompanion(PlacePhotosTableCompanion data) {
    return PlacePhotosTableData(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      caption: data.caption.present ? data.caption.value : this.caption,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlacePhotosTableData(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    placeId,
    filePath,
    thumbnailPath,
    caption,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlacePhotosTableData &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.filePath == this.filePath &&
          other.thumbnailPath == this.thumbnailPath &&
          other.caption == this.caption &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class PlacePhotosTableCompanion extends UpdateCompanion<PlacePhotosTableData> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String> filePath;
  final Value<String?> thumbnailPath;
  final Value<String?> caption;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlacePhotosTableCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.caption = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlacePhotosTableCompanion.insert({
    required String id,
    required String placeId,
    required String filePath,
    this.thumbnailPath = const Value.absent(),
    this.caption = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       placeId = Value(placeId),
       filePath = Value(filePath),
       createdAt = Value(createdAt);
  static Insertable<PlacePhotosTableData> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? filePath,
    Expression<String>? thumbnailPath,
    Expression<String>? caption,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (filePath != null) 'file_path': filePath,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (caption != null) 'caption': caption,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlacePhotosTableCompanion copyWith({
    Value<String>? id,
    Value<String>? placeId,
    Value<String>? filePath,
    Value<String?>? thumbnailPath,
    Value<String?>? caption,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PlacePhotosTableCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      caption: caption ?? this.caption,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlacePhotosTableCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('filePath: $filePath, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('caption: $caption, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppPreferencesTableTable extends AppPreferencesTable
    with TableInfo<$AppPreferencesTableTable, AppPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppPreferencesTableData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppPreferencesTableTable createAlias(String alias) {
    return $AppPreferencesTableTable(attachedDatabase, alias);
  }
}

class AppPreferencesTableData extends DataClass
    implements Insertable<AppPreferencesTableData> {
  final String key;
  final String value;
  const AppPreferencesTableData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return AppPreferencesTableCompanion(key: Value(key), value: Value(value));
  }

  factory AppPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppPreferencesTableData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppPreferencesTableData copyWith({String? key, String? value}) =>
      AppPreferencesTableData(key: key ?? this.key, value: value ?? this.value);
  AppPreferencesTableData copyWithCompanion(AppPreferencesTableCompanion data) {
    return AppPreferencesTableData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppPreferencesTableData &&
          other.key == this.key &&
          other.value == this.value);
}

class AppPreferencesTableCompanion
    extends UpdateCompanion<AppPreferencesTableData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppPreferencesTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppPreferencesTableCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppPreferencesTableData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppPreferencesTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppPreferencesTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppPreferencesTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlacesTableTable placesTable = $PlacesTableTable(this);
  late final $PlacePhotosTableTable placePhotosTable = $PlacePhotosTableTable(
    this,
  );
  late final $AppPreferencesTableTable appPreferencesTable =
      $AppPreferencesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    placesTable,
    placePhotosTable,
    appPreferencesTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'places',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('place_photos', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PlacesTableTableCreateCompanionBuilder =
    PlacesTableCompanion Function({
      required String id,
      required String name,
      required String categoryKey,
      required String status,
      required double latitude,
      required double longitude,
      Value<String?> addressLabel,
      Value<String?> note,
      Value<int?> rating,
      Value<bool> isFavorite,
      Value<DateTime?> visitedAt,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlacesTableTableUpdateCompanionBuilder =
    PlacesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> categoryKey,
      Value<String> status,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> addressLabel,
      Value<String?> note,
      Value<int?> rating,
      Value<bool> isFavorite,
      Value<DateTime?> visitedAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$PlacesTableTableReferences
    extends BaseReferences<_$AppDatabase, $PlacesTableTable, PlacesTableData> {
  $$PlacesTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PlacePhotosTableTable, List<PlacePhotosTableData>>
  _placePhotosTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.placePhotosTable,
    aliasName: 'places__id__place_photos__place_id',
  );

  $$PlacePhotosTableTableProcessedTableManager get placePhotosTableRefs {
    final manager = $$PlacePhotosTableTableTableManager(
      $_db,
      $_db.placePhotosTable,
    ).filter((f) => f.placeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _placePhotosTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlacesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addressLabel => $composableBuilder(
    column: $table.addressLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visitedAt => $composableBuilder(
    column: $table.visitedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> placePhotosTableRefs(
    Expression<bool> Function($$PlacePhotosTableTableFilterComposer f) f,
  ) {
    final $$PlacePhotosTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.placePhotosTable,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacePhotosTableTableFilterComposer(
            $db: $db,
            $table: $db.placePhotosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addressLabel => $composableBuilder(
    column: $table.addressLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visitedAt => $composableBuilder(
    column: $table.visitedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlacesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacesTableTable> {
  $$PlacesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get categoryKey => $composableBuilder(
    column: $table.categoryKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get addressLabel => $composableBuilder(
    column: $table.addressLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get visitedAt =>
      $composableBuilder(column: $table.visitedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> placePhotosTableRefs<T extends Object>(
    Expression<T> Function($$PlacePhotosTableTableAnnotationComposer a) f,
  ) {
    final $$PlacePhotosTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.placePhotosTable,
      getReferencedColumn: (t) => t.placeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacePhotosTableTableAnnotationComposer(
            $db: $db,
            $table: $db.placePhotosTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlacesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacesTableTable,
          PlacesTableData,
          $$PlacesTableTableFilterComposer,
          $$PlacesTableTableOrderingComposer,
          $$PlacesTableTableAnnotationComposer,
          $$PlacesTableTableCreateCompanionBuilder,
          $$PlacesTableTableUpdateCompanionBuilder,
          (PlacesTableData, $$PlacesTableTableReferences),
          PlacesTableData,
          PrefetchHooks Function({bool placePhotosTableRefs})
        > {
  $$PlacesTableTableTableManager(_$AppDatabase db, $PlacesTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> categoryKey = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> addressLabel = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> visitedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacesTableCompanion(
                id: id,
                name: name,
                categoryKey: categoryKey,
                status: status,
                latitude: latitude,
                longitude: longitude,
                addressLabel: addressLabel,
                note: note,
                rating: rating,
                isFavorite: isFavorite,
                visitedAt: visitedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String categoryKey,
                required String status,
                required double latitude,
                required double longitude,
                Value<String?> addressLabel = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<DateTime?> visitedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlacesTableCompanion.insert(
                id: id,
                name: name,
                categoryKey: categoryKey,
                status: status,
                latitude: latitude,
                longitude: longitude,
                addressLabel: addressLabel,
                note: note,
                rating: rating,
                isFavorite: isFavorite,
                visitedAt: visitedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacesTableTable, PlacesTableData>(table),
                  $$PlacesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({placePhotosTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (placePhotosTableRefs) db.placePhotosTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (placePhotosTableRefs)
                    await $_getPrefetchedDataByColumns<
                      PlacesTableData,
                      $PlacesTableTable,
                      PlacePhotosTableData,
                      $PlacePhotosTableTable
                    >(
                      currentTable: table,
                      referencedTable: $$PlacesTableTableReferences
                          ._placePhotosTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlacesTableTableReferences(
                            db,
                            table,
                            p0,
                          ).placePhotosTableRefs,
                      currentColumn: 'id',
                      referencedColumn: 'place_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlacesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacesTableTable,
      PlacesTableData,
      $$PlacesTableTableFilterComposer,
      $$PlacesTableTableOrderingComposer,
      $$PlacesTableTableAnnotationComposer,
      $$PlacesTableTableCreateCompanionBuilder,
      $$PlacesTableTableUpdateCompanionBuilder,
      (PlacesTableData, $$PlacesTableTableReferences),
      PlacesTableData,
      PrefetchHooks Function({bool placePhotosTableRefs})
    >;
typedef $$PlacePhotosTableTableCreateCompanionBuilder =
    PlacePhotosTableCompanion Function({
      required String id,
      required String placeId,
      required String filePath,
      Value<String?> thumbnailPath,
      Value<String?> caption,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PlacePhotosTableTableUpdateCompanionBuilder =
    PlacePhotosTableCompanion Function({
      Value<String> id,
      Value<String> placeId,
      Value<String> filePath,
      Value<String?> thumbnailPath,
      Value<String?> caption,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PlacePhotosTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PlacePhotosTableTable,
          PlacePhotosTableData
        > {
  $$PlacePhotosTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlacesTableTable _placeIdTable(_$AppDatabase db) =>
      db.placesTable.createAlias('place_photos__place_id__places__id');

  $$PlacesTableTableProcessedTableManager get placeId {
    final $_column = $_itemColumn<String>('place_id')!;

    final manager = $$PlacesTableTableTableManager(
      $_db,
      $_db.placesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_placeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PlacePhotosTableTableFilterComposer
    extends Composer<_$AppDatabase, $PlacePhotosTableTable> {
  $$PlacePhotosTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlacesTableTableFilterComposer get placeId {
    final $$PlacesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableFilterComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlacePhotosTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PlacePhotosTableTable> {
  $$PlacePhotosTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlacesTableTableOrderingComposer get placeId {
    final $$PlacesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableOrderingComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlacePhotosTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlacePhotosTableTable> {
  $$PlacePhotosTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$PlacesTableTableAnnotationComposer get placeId {
    final $$PlacesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.placeId,
      referencedTable: $db.placesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlacesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.placesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlacePhotosTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlacePhotosTableTable,
          PlacePhotosTableData,
          $$PlacePhotosTableTableFilterComposer,
          $$PlacePhotosTableTableOrderingComposer,
          $$PlacePhotosTableTableAnnotationComposer,
          $$PlacePhotosTableTableCreateCompanionBuilder,
          $$PlacePhotosTableTableUpdateCompanionBuilder,
          (PlacePhotosTableData, $$PlacePhotosTableTableReferences),
          PlacePhotosTableData,
          PrefetchHooks Function({bool placeId})
        > {
  $$PlacePhotosTableTableTableManager(
    _$AppDatabase db,
    $PlacePhotosTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlacePhotosTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlacePhotosTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlacePhotosTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> placeId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlacePhotosTableCompanion(
                id: id,
                placeId: placeId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String placeId,
                required String filePath,
                Value<String?> thumbnailPath = const Value.absent(),
                Value<String?> caption = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PlacePhotosTableCompanion.insert(
                id: id,
                placeId: placeId,
                filePath: filePath,
                thumbnailPath: thumbnailPath,
                caption: caption,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlacePhotosTableTable, PlacePhotosTableData>(
                    table,
                  ),
                  $$PlacePhotosTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({placeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (placeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.placeId,
                                referencedTable:
                                    $$PlacePhotosTableTableReferences
                                        ._placeIdTable(db),
                                referencedColumn:
                                    $$PlacePhotosTableTableReferences
                                        ._placeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PlacePhotosTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlacePhotosTableTable,
      PlacePhotosTableData,
      $$PlacePhotosTableTableFilterComposer,
      $$PlacePhotosTableTableOrderingComposer,
      $$PlacePhotosTableTableAnnotationComposer,
      $$PlacePhotosTableTableCreateCompanionBuilder,
      $$PlacePhotosTableTableUpdateCompanionBuilder,
      (PlacePhotosTableData, $$PlacePhotosTableTableReferences),
      PlacePhotosTableData,
      PrefetchHooks Function({bool placeId})
    >;
typedef $$AppPreferencesTableTableCreateCompanionBuilder =
    AppPreferencesTableCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppPreferencesTableTableUpdateCompanionBuilder =
    AppPreferencesTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppPreferencesTableTable> {
  $$AppPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppPreferencesTableTable,
          AppPreferencesTableData,
          $$AppPreferencesTableTableFilterComposer,
          $$AppPreferencesTableTableOrderingComposer,
          $$AppPreferencesTableTableAnnotationComposer,
          $$AppPreferencesTableTableCreateCompanionBuilder,
          $$AppPreferencesTableTableUpdateCompanionBuilder,
          (
            AppPreferencesTableData,
            BaseReferences<
              _$AppDatabase,
              $AppPreferencesTableTable,
              AppPreferencesTableData
            >,
          ),
          AppPreferencesTableData,
          PrefetchHooks Function()
        > {
  $$AppPreferencesTableTableTableManager(
    _$AppDatabase db,
    $AppPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AppPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppPreferencesTableCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppPreferencesTableCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AppPreferencesTableTable,
                    AppPreferencesTableData
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppPreferencesTableTable,
                    AppPreferencesTableData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppPreferencesTableTable,
      AppPreferencesTableData,
      $$AppPreferencesTableTableFilterComposer,
      $$AppPreferencesTableTableOrderingComposer,
      $$AppPreferencesTableTableAnnotationComposer,
      $$AppPreferencesTableTableCreateCompanionBuilder,
      $$AppPreferencesTableTableUpdateCompanionBuilder,
      (
        AppPreferencesTableData,
        BaseReferences<
          _$AppDatabase,
          $AppPreferencesTableTable,
          AppPreferencesTableData
        >,
      ),
      AppPreferencesTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlacesTableTableTableManager get placesTable =>
      $$PlacesTableTableTableManager(_db, _db.placesTable);
  $$PlacePhotosTableTableTableManager get placePhotosTable =>
      $$PlacePhotosTableTableTableManager(_db, _db.placePhotosTable);
  $$AppPreferencesTableTableTableManager get appPreferencesTable =>
      $$AppPreferencesTableTableTableManager(_db, _db.appPreferencesTable);
}
