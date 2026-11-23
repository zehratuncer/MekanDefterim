import 'place_status.dart';

class PlaceValidationException implements Exception {
  final String message;
  const PlaceValidationException(this.message);

  @override
  String toString() => 'PlaceValidationException: $message';
}

/// Mekân Domain Entity nesnesi.
class Place {
  final String id;
  final String name;
  final String categoryKey;
  final PlaceStatus status;
  final double latitude;
  final double longitude;
  final String? addressLabel;
  final String? note;
  final int? rating;
  final bool isFavorite;
  final DateTime? visitedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Place({
    required this.id,
    required this.name,
    required this.categoryKey,
    required this.status,
    required this.latitude,
    required this.longitude,
    this.addressLabel,
    this.note,
    this.rating,
    this.isFavorite = false,
    this.visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now() {
    validate();
  }

  void validate() {
    if (name.trim().isEmpty) {
      throw const PlaceValidationException('Mekân adı boş olamaz.');
    }
    if (latitude < -90.0 || latitude > 90.0) {
      throw const PlaceValidationException('Geçersiz enlem değeri (-90 ile 90 arasında olmalıdır).');
    }
    if (longitude < -180.0 || longitude > 180.0) {
      throw const PlaceValidationException('Geçersiz boylam değeri (-180 ile 180 arasında olmalıdır).');
    }
    if (rating != null && (rating! < 1 || rating! > 5)) {
      throw const PlaceValidationException('Puan 1 ile 5 arasında olmalıdır.');
    }
    if (status == PlaceStatus.planned && rating != null) {
      throw const PlaceValidationException('Yalnızca ziyaret edilmiş (Gezildi) mekânlara puan verilebilir.');
    }
  }

  Place copyWith({
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
    DateTime? visitedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryKey: categoryKey ?? this.categoryKey,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      addressLabel: addressLabel ?? this.addressLabel,
      note: note ?? this.note,
      rating: status == PlaceStatus.planned ? null : (rating ?? this.rating),
      isFavorite: isFavorite ?? this.isFavorite,
      visitedAt: status == PlaceStatus.planned ? null : (visitedAt ?? this.visitedAt),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
