import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_photo.dart';
import '../../domain/entities/place_status.dart';
import '../../domain/repositories/place_repository.dart';

class PlaceLocalDataSource {
  final AppDatabase db;

  PlaceLocalDataSource(this.db);

  Stream<List<Place>> watchPlaces({PlaceFilter? filter}) {
    final query = db.select(db.placesTable);

    if (filter != null) {
      if (filter.status != null) {
        query.where((tbl) => tbl.status.equals(filter.status!.value));
      }
      if (filter.categoryKey != null && filter.categoryKey!.isNotEmpty) {
        query.where((tbl) => tbl.categoryKey.equals(filter.categoryKey!));
      }
      if (filter.isFavoriteOnly == true) {
        query.where((tbl) => tbl.isFavorite.equals(true));
      }
      if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
        final queryStr = '%${filter.searchQuery!.trim()}%';
        query.where((tbl) => tbl.name.like(queryStr));
      }
    }

    query.orderBy([
      (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
    ]);

    return query.watch().map((rows) => rows.map(_mapToEntity).toList());
  }

  Future<List<Place>> getPlaces({PlaceFilter? filter}) {
    final query = db.select(db.placesTable);

    if (filter != null) {
      if (filter.status != null) {
        query.where((tbl) => tbl.status.equals(filter.status!.value));
      }
      if (filter.categoryKey != null && filter.categoryKey!.isNotEmpty) {
        query.where((tbl) => tbl.categoryKey.equals(filter.categoryKey!));
      }
      if (filter.isFavoriteOnly == true) {
        query.where((tbl) => tbl.isFavorite.equals(true));
      }
      if (filter.searchQuery != null && filter.searchQuery!.trim().isNotEmpty) {
        final queryStr = '%${filter.searchQuery!.trim()}%';
        query.where((tbl) => tbl.name.like(queryStr));
      }
    }

    query.orderBy([
      (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc),
    ]);

    return query.get().then((rows) => rows.map(_mapToEntity).toList());
  }

  Future<Place?> getPlaceById(String id) async {
    final row = await (db.select(db.placesTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    return row == null ? null : _mapToEntity(row);
  }

  Future<void> savePlace(Place place) async {
    final companion = PlacesTableCompanion(
      id: Value(place.id),
      name: Value(place.name),
      categoryKey: Value(place.categoryKey),
      status: Value(place.status.value),
      latitude: Value(place.latitude),
      longitude: Value(place.longitude),
      addressLabel: Value(place.addressLabel),
      note: Value(place.note),
      rating: Value(place.rating),
      isFavorite: Value(place.isFavorite),
      visitedAt: Value(place.visitedAt),
      createdAt: Value(place.createdAt),
      updatedAt: Value(DateTime.now()),
    );

    await db.into(db.placesTable).insertOnConflictUpdate(companion);
  }

  Future<List<String>> getPhotoPathsForPlace(String placeId) async {
    final photos = await (db.select(db.placePhotosTable)..where((tbl) => tbl.placeId.equals(placeId))).get();
    return photos.map((p) => p.filePath).toList();
  }

  Future<void> deletePlace(String id) async {
    await (db.delete(db.placesTable)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<void> toggleFavorite(String id) async {
    final place = await getPlaceById(id);
    if (place != null) {
      await (db.update(db.placesTable)..where((tbl) => tbl.id.equals(id))).write(
        PlacesTableCompanion(
          isFavorite: Value(!place.isFavorite),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<void> updateStatus(String id, PlaceStatus newStatus) async {
    final companion = PlacesTableCompanion(
      status: Value(newStatus.value),
      rating: newStatus == PlaceStatus.planned ? const Value(null) : const Value.absent(),
      visitedAt: newStatus == PlaceStatus.visited ? Value(DateTime.now()) : const Value(null),
      updatedAt: Value(DateTime.now()),
    );

    await (db.update(db.placesTable)..where((tbl) => tbl.id.equals(id))).write(companion);
  }

  // Fotoğraflar
  Stream<List<PlacePhoto>> watchPhotosForPlace(String placeId) {
    return (db.select(db.placePhotosTable)
          ..where((tbl) => tbl.placeId.equals(placeId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)]))
        .watch()
        .map((rows) => rows.map(_mapPhotoToEntity).toList());
  }

  Future<List<PlacePhoto>> getPhotosForPlace(String placeId) async {
    final rows = await (db.select(db.placePhotosTable)
          ..where((tbl) => tbl.placeId.equals(placeId))
          ..orderBy([(tbl) => OrderingTerm(expression: tbl.sortOrder)]))
        .get();
    return rows.map(_mapPhotoToEntity).toList();
  }

  Future<void> addPhoto(PlacePhoto photo) async {
    await db.into(db.placePhotosTable).insertOnConflictUpdate(
          PlacePhotosTableCompanion(
            id: Value(photo.id),
            placeId: Value(photo.placeId),
            filePath: Value(photo.filePath),
            thumbnailPath: Value(photo.thumbnailPath),
            caption: Value(photo.caption),
            sortOrder: Value(photo.sortOrder),
            createdAt: Value(photo.createdAt),
          ),
        );
  }

  Future<String?> deletePhoto(String photoId) async {
    final photo = await (db.select(db.placePhotosTable)..where((tbl) => tbl.id.equals(photoId))).getSingleOrNull();
    if (photo != null) {
      await (db.delete(db.placePhotosTable)..where((tbl) => tbl.id.equals(photoId))).go();
      return photo.filePath;
    }
    return null;
  }

  Place _mapToEntity(PlacesTableData row) {
    return Place(
      id: row.id,
      name: row.name,
      categoryKey: row.categoryKey,
      status: PlaceStatus.fromString(row.status),
      latitude: row.latitude,
      longitude: row.longitude,
      addressLabel: row.addressLabel,
      note: row.note,
      rating: row.rating,
      isFavorite: row.isFavorite,
      visitedAt: row.visitedAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  PlacePhoto _mapPhotoToEntity(PlacePhotosTableData row) {
    return PlacePhoto(
      id: row.id,
      placeId: row.placeId,
      filePath: row.filePath,
      thumbnailPath: row.thumbnailPath,
      caption: row.caption,
      sortOrder: row.sortOrder,
      createdAt: row.createdAt,
    );
  }
}
