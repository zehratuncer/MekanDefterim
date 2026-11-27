import '../entities/place.dart';
import '../entities/place_photo.dart';
import '../entities/place_status.dart';

const _unset = Object();

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
    Object? searchQuery = _unset,
    Object? categoryKey = _unset,
    Object? status = _unset,
    Object? isFavoriteOnly = _unset,
  }) {
    return PlaceFilter(
      searchQuery: identical(searchQuery, _unset) ? this.searchQuery : searchQuery as String?,
      categoryKey: identical(categoryKey, _unset) ? this.categoryKey : categoryKey as String?,
      status: identical(status, _unset) ? this.status : status as PlaceStatus?,
      isFavoriteOnly: identical(isFavoriteOnly, _unset) ? this.isFavoriteOnly : isFavoriteOnly as bool?,
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
