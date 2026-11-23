import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/providers.dart';
import '../../domain/entities/place.dart';
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
    this.isSubmitting = false,
    this.errorMessage,
  });

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

  Future<bool> savePlace() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Lütfen bir mekân adı girin.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, errorMessage: null);

    try {
      final repository = ref.read(placeRepositoryProvider);
      final place = Place(
        id: state.id ?? const Uuid().v4(),
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
