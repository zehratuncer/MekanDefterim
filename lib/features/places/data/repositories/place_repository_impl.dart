import 'dart:io';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_photo.dart';
import '../../domain/entities/place_status.dart';
import '../../domain/repositories/place_repository.dart';
import '../datasources/place_local_data_source.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  final PlaceLocalDataSource dataSource;

  PlaceRepositoryImpl(this.dataSource);

  @override
  Stream<List<Place>> watchPlaces({PlaceFilter? filter}) {
    return dataSource.watchPlaces(filter: filter);
  }

  @override
  Future<List<Place>> getPlaces({PlaceFilter? filter}) {
    return dataSource.getPlaces(filter: filter);
  }

  @override
  Future<Place?> getPlaceById(String id) {
    return dataSource.getPlaceById(id);
  }

  @override
  Future<void> savePlace(Place place) {
    return dataSource.savePlace(place);
  }

  @override
  Future<void> deletePlace(String id) async {
    // 1. Önce ilişkili fotoğrafların yerel dosya yollarını topla
    final filePaths = await dataSource.getPhotoPathsForPlace(id);

    // 2. Veritabanından mekânı sil (foreign key ON DELETE CASCADE ile fotoğraflar da DB'den silinir)
    await dataSource.deletePlace(id);

    // 3. Dosya sistemindeki fotoğrafları güvenli temizle
    for (final path in filePaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Dosya silinemezse bile DB silme işlemi bozulmaz
      }
    }
  }

  @override
  Future<void> toggleFavorite(String id) {
    return dataSource.toggleFavorite(id);
  }

  @override
  Future<void> updateStatus(String id, PlaceStatus newStatus) {
    return dataSource.updateStatus(id, newStatus);
  }

  @override
  Stream<List<PlacePhoto>> watchPhotosForPlace(String placeId) {
    return dataSource.watchPhotosForPlace(placeId);
  }

  @override
  Future<List<PlacePhoto>> getPhotosForPlace(String placeId) {
    return dataSource.getPhotosForPlace(placeId);
  }

  @override
  Future<void> addPhoto(PlacePhoto photo) {
    return dataSource.addPhoto(photo);
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    final filePath = await dataSource.deletePhoto(photoId);
    if (filePath != null) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {}
    }
  }
}
