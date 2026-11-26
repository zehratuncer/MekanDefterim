import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/core/services/photo_storage_service.dart';
import 'package:mekandefterim/features/places/presentation/controllers/place_form_controller.dart';
import 'package:path/path.dart' as p;

void main() {
  group('LocalPhotoStorageService', () {
    late Directory tempBaseDir;
    late LocalPhotoStorageService service;

    setUp(() async {
      tempBaseDir = await Directory.systemTemp.createTemp('mekan_defterim_photo_test_');
      service = LocalPhotoStorageService(baseDirProvider: () async => tempBaseDir);
    });

    tearDown(() async {
      if (await tempBaseDir.exists()) {
        await tempBaseDir.delete(recursive: true);
      }
    });

    test('persistPhoto copies image into app-private place_photos directory', () async {
      final sourceFile = File(p.join(tempBaseDir.path, 'picked.jpg'));
      await sourceFile.writeAsBytes([1, 2, 3, 4, 5]);

      final persistedPath = await service.persistPhoto(
        sourcePath: sourceFile.path,
        placeId: 'place-1',
        photoId: 'photo-1',
      );

      expect(File(persistedPath).existsSync(), isTrue);
      expect(persistedPath, contains('place_photos'));
      expect(persistedPath, contains('place-1'));
      expect(persistedPath, endsWith('photo-1.jpg'));
    });

    test('deletePhotoFile and deletePlaceDirectory clean up files safely', () async {
      final sourceFile = File(p.join(tempBaseDir.path, 'picked2.png'));
      await sourceFile.writeAsBytes([9, 8, 7]);

      final persistedPath = await service.persistPhoto(
        sourcePath: sourceFile.path,
        placeId: 'place-2',
        photoId: 'photo-2',
      );

      expect(File(persistedPath).existsSync(), isTrue);

      await service.deletePhotoFile(persistedPath);
      expect(File(persistedPath).existsSync(), isFalse);

      await service.deletePlaceDirectory('place-2');
      expect(Directory(p.join(tempBaseDir.path, 'place_photos', 'place-2')).existsSync(), isFalse);
    });
  });

  group('PlaceFormNotifier photo rules', () {
    test('enforces maximum of 5 photos per place', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(placeFormNotifierProvider(null).notifier);

      for (var i = 0; i < 5; i++) {
        final err = notifier.addPhotoFromPath('/tmp/photo_$i.jpg');
        expect(err, isNull);
      }

      final state = container.read(placeFormNotifierProvider(null));
      expect(state.photos.length, 5);
      expect(state.canAddMorePhotos, isFalse);

      final overflowErr = notifier.addPhotoFromPath('/tmp/photo_6.jpg');
      expect(overflowErr, isNotNull);
      expect(container.read(placeFormNotifierProvider(null)).photos.length, 5);
    });
  });
}
