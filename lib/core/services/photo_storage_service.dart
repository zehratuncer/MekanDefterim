import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class PhotoStorageException implements Exception {
  final String message;
  const PhotoStorageException(this.message);

  @override
  String toString() => 'PhotoStorageException: $message';
}

abstract class PhotoStorageService {
  static const int maxPhotosPerPlace = 5;

  Future<String?> pickImage({required ImageSource source});

  Future<String> persistPhoto({
    required String sourcePath,
    required String placeId,
    required String photoId,
  });

  Future<void> deletePhotoFile(String filePath);

  Future<void> deletePlaceDirectory(String placeId);
}

class LocalPhotoStorageService implements PhotoStorageService {
  final ImagePicker _picker;
  final Future<Directory> Function()? baseDirProvider;

  LocalPhotoStorageService({
    ImagePicker? picker,
    this.baseDirProvider,
  }) : _picker = picker ?? ImagePicker();

  Future<Directory> _getPhotosRootDir() async {
    final baseDir = baseDirProvider != null
        ? await baseDirProvider!()
        : await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(baseDir.path, 'place_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }
    return photosDir;
  }

  @override
  Future<String?> pickImage({required ImageSource source}) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 82,
    );
    return picked?.path;
  }

  @override
  Future<String> persistPhoto({
    required String sourcePath,
    required String placeId,
    required String photoId,
  }) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw const PhotoStorageException('Seçilen fotoğraf dosyası bulunamadı.');
    }

    final rootDir = await _getPhotosRootDir();
    final placeDir = Directory(p.join(rootDir.path, placeId));
    if (!await placeDir.exists()) {
      await placeDir.create(recursive: true);
    }

    final ext = p.extension(sourcePath).isNotEmpty ? p.extension(sourcePath) : '.jpg';
    final targetPath = p.join(placeDir.path, '$photoId$ext');

    if (p.equals(sourceFile.path, targetPath)) {
      return targetPath;
    }

    final copied = await sourceFile.copy(targetPath);
    return copied.path;
  }

  @override
  Future<void> deletePhotoFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Dosya sisteminde yoksa veya silinemezse akışı bozmaz
    }
  }

  @override
  Future<void> deletePlaceDirectory(String placeId) async {
    try {
      final rootDir = await _getPhotosRootDir();
      final placeDir = Directory(p.join(rootDir.path, placeId));
      if (await placeDir.exists()) {
        await placeDir.delete(recursive: true);
      }
    } catch (_) {
      // Klasör temizliği başarısız olursa akışı bozmaz
    }
  }
}

final photoStorageServiceProvider = Provider<PhotoStorageService>((ref) {
  return LocalPhotoStorageService();
});
