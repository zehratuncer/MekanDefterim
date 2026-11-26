import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/providers.dart';
import '../../../../core/services/photo_storage_service.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_photo.dart';
import '../../domain/entities/place_status.dart';

class PlaceFormState {
  final String? id;
  final String name;
  final String categoryKey;
  final PlaceStatus status;
  final double latitude;
  final double longitude;
  final String? addressLabel;
  final String? note;
  final int? rating;
  final bool isFavorite;
  final List<PlacePhoto> photos;
  final List<String> removedPhotoIds;
  final Set<String> existingPhotoIds;
  final bool isSubmitting;
  final String? errorMessage;

  const PlaceFormState({
    this.id,
    this.name = '',
    this.categoryKey = 'cafe',
    this.status = PlaceStatus.visited,
    this.latitude = 40.9876,
    this.longitude = 29.0234,
    this.addressLabel = 'Caferağa, Kadıköy - İstanbul',
    this.note,
    this.rating = 5,
    this.isFavorite = false,
    this.photos = const [],
    this.removedPhotoIds = const [],
    this.existingPhotoIds = const {},
    this.isSubmitting = false,
    this.errorMessage,
  });

  bool get canAddMorePhotos => photos.length < PhotoStorageService.maxPhotosPerPlace;

  PlaceFormState copyWith({
    String? id,
    String? name,
    String? categoryKey,
    PlaceStatus? status,
    double? latitude,
    double? longitude,
    String? addressLabel,
    String? note,
    int? rating,
    bool? isFavorite,
    List<PlacePhoto>? photos,
    List<String>? removedPhotoIds,
    Set<String>? existingPhotoIds,
    bool? isSubmitting,
    String? errorMessage,
    bool clearRating = false,
  }) {
    return PlaceFormState(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryKey: categoryKey ?? this.categoryKey,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressLabel: addressLabel ?? this.addressLabel,
      note: note ?? this.note,
      rating: clearRating ? null : (rating ?? this.rating),
      isFavorite: isFavorite ?? this.isFavorite,
      photos: photos ?? this.photos,
      removedPhotoIds: removedPhotoIds ?? this.removedPhotoIds,
      existingPhotoIds: existingPhotoIds ?? this.existingPhotoIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }
}

class PlaceFormNotifier extends Notifier<PlaceFormState> {
  final Place? initialPlace;

  PlaceFormNotifier([this.initialPlace]);

  @override
  PlaceFormState build() {
    return initialPlace != null
        ? PlaceFormState(
            id: initialPlace!.id,
            name: initialPlace!.name,
            categoryKey: initialPlace!.categoryKey,
            status: initialPlace!.status,
            latitude: initialPlace!.latitude,
            longitude: initialPlace!.longitude,
            addressLabel: initialPlace!.addressLabel,
            note: initialPlace!.note,
            rating: initialPlace!.rating,
            isFavorite: initialPlace!.isFavorite,
          )
        : const PlaceFormState();
  }

  Future<void> loadInitialPhotos() async {
    if (initialPlace == null) return;
    final repository = ref.read(placeRepositoryProvider);
    final existing = await repository.getPhotosForPlace(initialPlace!.id);
    state = state.copyWith(
      photos: existing,
      existingPhotoIds: existing.map((e) => e.id).toSet(),
    );
  }

  void setName(String name) {
    state = state.copyWith(name: name, errorMessage: null);
  }

  void setCategory(String categoryKey) {
    state = state.copyWith(categoryKey: categoryKey);
  }

  void setStatus(PlaceStatus status) {
    if (status == PlaceStatus.planned) {
      state = state.copyWith(status: status, clearRating: true);
    } else {
      state = state.copyWith(status: status, rating: state.rating ?? 5);
    }
  }

  void setRating(int rating) {
    if (state.status == PlaceStatus.visited) {
      state = state.copyWith(rating: rating);
    }
  }

  void setNote(String note) {
    state = state.copyWith(note: note);
  }

  void setLocation({required double latitude, required double longitude, String? addressLabel}) {
    state = state.copyWith(
      latitude: latitude,
      longitude: longitude,
      addressLabel: addressLabel ?? state.addressLabel,
    );
  }

  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
  }

  String? addPhotoFromPath(String sourcePath) {
    if (!state.canAddMorePhotos) {
      return 'Bir mekâna en fazla ${PhotoStorageService.maxPhotosPerPlace} fotoğraf eklenebilir.';
    }
    final tempId = const Uuid().v4();
    final draftPhoto = PlacePhoto(
      id: tempId,
      placeId: state.id ?? 'draft',
      filePath: sourcePath,
      sortOrder: state.photos.length,
    );
    state = state.copyWith(photos: [...state.photos, draftPhoto]);
    return null;
  }

  void removePhoto(String photoId) {
    final updated = state.photos.where((p) => p.id != photoId).toList();
    final updatedRemoved = state.existingPhotoIds.contains(photoId)
        ? [...state.removedPhotoIds, photoId]
        : state.removedPhotoIds;
    state = state.copyWith(
      photos: updated,
      removedPhotoIds: updatedRemoved,
    );
  }

  Future<bool> savePlace() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Lütfen bir mekân adı girin.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final repository = ref.read(placeRepositoryProvider);
      final photoStorage = ref.read(photoStorageServiceProvider);
      final placeId = state.id ?? const Uuid().v4();

      final place = Place(
        id: placeId,
        name: state.name.trim(),
        categoryKey: state.categoryKey,
        status: state.status,
        latitude: state.latitude,
        longitude: state.longitude,
        addressLabel: state.addressLabel,
        note: state.note?.trim().isEmpty == true ? null : state.note?.trim(),
        rating: state.status == PlaceStatus.visited ? state.rating : null,
        isFavorite: state.isFavorite,
        visitedAt: state.status == PlaceStatus.visited ? DateTime.now() : null,
      );

      await repository.savePlace(place);

      // Kaldırılan mevcut fotoğrafları DB ve diskten temizle
      for (final removedId in state.removedPhotoIds) {
        await repository.deletePhoto(removedId);
      }

      // Yeni eklenen fotoğrafları uygulama dizinine kopyala ve DB'ye kaydet
      for (var i = 0; i < state.photos.length; i++) {
        final photo = state.photos[i];
        if (state.existingPhotoIds.contains(photo.id)) continue;

        final persistedPath = await photoStorage.persistPhoto(
          sourcePath: photo.filePath,
          placeId: placeId,
          photoId: photo.id,
        );

        await repository.addPhoto(
          PlacePhoto(
            id: photo.id,
            placeId: placeId,
            filePath: persistedPath,
            thumbnailPath: persistedPath,
            sortOrder: i,
          ),
        );
      }

      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, errorMessage: 'Mekân kaydedilemedi: $e');
      return false;
    }
  }
}

final placeFormNotifierProvider =
    NotifierProvider.autoDispose.family<PlaceFormNotifier, PlaceFormState, Place?>(
  PlaceFormNotifier.new,
);
