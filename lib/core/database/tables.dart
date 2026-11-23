import 'package:drift/drift.dart';

/// Mekânlar Drift Tablosu
class PlacesTable extends Table {
  @override
  String get tableName => 'places';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get categoryKey => text()();
  TextColumn get status => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get addressLabel => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get rating => integer().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get visitedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Mekân Fotoğrafları Drift Tablosu (Cascade Delete)
class PlacePhotosTable extends Table {
  @override
  String get tableName => 'place_photos';

  TextColumn get id => text()();
  TextColumn get placeId => text().references(PlacesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get caption => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Uygulama Tercihleri Tablosu
class AppPreferencesTable extends Table {
  @override
  String get tableName => 'app_preferences';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
