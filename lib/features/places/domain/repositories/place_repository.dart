import '../entities/place.dart';
import '../entities/place_photo.dart';
import '../entities/place_status.dart';

class PlaceFilter {
  final String? searchQuery;
  final String? categoryKey;
  final PlaceStatus? status;
  final bool? isFavoriteOnly;

  const PlaceFilter({
    this.searchQuery,
    this.categoryKey,
    this.status,
    this.isFavoriteOnly,
  });

  PlaceFilter copyWith({
    String? searchQuery,
    String? categoryKey,
    PlaceStatus? status,
    bool? isFavoriteOnly,
  }) {
    return PlaceFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryKey: categoryKey ?? this.categoryKey,
      status: status ?? this.status,
      isFavoriteOnly: isFavoriteOnly ?? this.isFavoriteOnly,
    );
  }
}

abstract class PlaceRepository {
  Stream<List<Place>> watchPlaces({PlaceFilter? filter});
  Future<List<Place>> getPlaces({PlaceFilter? filter});
  Future<Place?> getPlaceById(String id);
  Future<void> savePlace(Place place);
  Future<void> deletePlace(String id);
  Future<void> toggleFavorite(String id);
  Future<void> updateStatus(String id, PlaceStatus newStatus);

  // Fotoğraf işlemleri
  Stream<List<PlacePhoto>> watchPhotosForPlace(String placeId);
  Future<List<PlacePhoto>> getPhotosForPlace(String placeId);
  Future<void> addPhoto(PlacePhoto photo);
  Future<void> deletePhoto(String photoId);
}
