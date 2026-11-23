class PlacePhotoValidationException implements Exception {
  final String message;
  const PlacePhotoValidationException(this.message);

  @override
  String toString() => 'PlacePhotoValidationException: $message';
}

/// Mekâna ait fotoğraf kaydı Entity nesnesi.
class PlacePhoto {
  final String id;
  final String placeId;
  final String filePath;
  final String? thumbnailPath;
  final String? caption;
  final int sortOrder;
  final DateTime createdAt;

  PlacePhoto({
    required this.id,
    required this.placeId,
    required this.filePath,
    this.thumbnailPath,
    this.caption,
    this.sortOrder = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now() {
    if (id.trim().isEmpty) {
      throw const PlacePhotoValidationException('Fotoğraf kimliği (id) boş olamaz.');
    }
    if (placeId.trim().isEmpty) {
      throw const PlacePhotoValidationException('İlişkili mekân kimliği (placeId) boş olamaz.');
    }
    if (filePath.trim().isEmpty) {
      throw const PlacePhotoValidationException('Dosya yolu (filePath) boş olamaz.');
    }
  }

  PlacePhoto copyWith({
    String? id,
    String? placeId,
    String? filePath,
    String? thumbnailPath,
    String? caption,
    int? sortOrder,
    DateTime? createdAt,
  }) {
    return PlacePhoto(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      filePath: filePath ?? this.filePath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      caption: caption ?? this.caption,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
