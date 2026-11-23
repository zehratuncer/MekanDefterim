import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/core/database/app_database.dart';
import 'package:mekandefterim/features/places/data/datasources/place_local_data_source.dart';
import 'package:mekandefterim/features/places/data/repositories/place_repository_impl.dart';
import 'package:mekandefterim/features/places/domain/entities/place.dart';
import 'package:mekandefterim/features/places/domain/entities/place_photo.dart';
import 'package:mekandefterim/features/places/domain/entities/place_status.dart';
import 'package:mekandefterim/features/places/domain/repositories/place_repository.dart';

void main() {
  late AppDatabase db;
  late PlaceLocalDataSource dataSource;
  late PlaceRepository repository;

  setUp(() {
    // In-Memory SQLite ile izole test veritabanı
    db = AppDatabase(NativeDatabase.memory());
    dataSource = PlaceLocalDataSource(db);
    repository = PlaceRepositoryImpl(dataSource);
  });

  tearDown(() async {
    await db.close();
  });

  group('PlaceRepository & SQLite CRUD Testleri', () {
    final testPlace = Place(
      id: 'p-1',
      name: 'Montag Coffee',
      categoryKey: 'cafe',
      status: PlaceStatus.visited,
      latitude: 40.9876,
      longitude: 29.0234,
      addressLabel: 'Caferağa, Kadıköy',
      note: 'Kahvesi harika.',
      rating: 5,
      isFavorite: true,
    );

    test('Mekân kaydetme ve id ile getirme', () async {
      await repository.savePlace(testPlace);

      final retrieved = await repository.getPlaceById('p-1');
      expect(retrieved, isNotNull);
      expect(retrieved!.name, 'Montag Coffee');
      expect(retrieved.categoryKey, 'cafe');
      expect(retrieved.status, PlaceStatus.visited);
      expect(retrieved.isFavorite, isTrue);
      expect(retrieved.rating, 5);
    });

    test('Mekân güncelleme', () async {
      await repository.savePlace(testPlace);

      final updatedPlace = testPlace.copyWith(
        name: 'Montag Coffee Moda',
        rating: 4,
      );
      await repository.savePlace(updatedPlace);

      final result = await repository.getPlaceById('p-1');
      expect(result!.name, 'Montag Coffee Moda');
      expect(result.rating, 4);
    });

    test('Favori durumu değiştirme (toggleFavorite)', () async {
      await repository.savePlace(testPlace);
      expect(testPlace.isFavorite, isTrue);

      await repository.toggleFavorite('p-1');
      var result = await repository.getPlaceById('p-1');
      expect(result!.isFavorite, isFalse);

      await repository.toggleFavorite('p-1');
      result = await repository.getPlaceById('p-1');
      expect(result!.isFavorite, isTrue);
    });

    test('Durum güncelleme (planned -> visited)', () async {
      final plannedPlace = Place(
        id: 'p-2',
        name: 'Müze Gazhane',
        categoryKey: 'culture',
        status: PlaceStatus.planned,
        latitude: 40.999,
        longitude: 29.045,
      );
      await repository.savePlace(plannedPlace);

      await repository.updateStatus('p-2', PlaceStatus.visited);
      final result = await repository.getPlaceById('p-2');
      expect(result!.status, PlaceStatus.visited);
      expect(result.visitedAt, isNotNull);
    });

    test('Mekân silme ve ilişkili fotoğrafların CASCADE silinmesi', () async {
      await repository.savePlace(testPlace);

      final photo = PlacePhoto(
        id: 'photo-1',
        placeId: 'p-1',
        filePath: '/mock/path/photo1.jpg',
      );
      await repository.addPhoto(photo);

      var photos = await repository.getPhotosForPlace('p-1');
      expect(photos.length, 1);

      // Mekânı sil
      await repository.deletePlace('p-1');

      // Mekân silindi mi?
      final placeResult = await repository.getPlaceById('p-1');
      expect(placeResult, isNull);

      // Cascade ile fotoğraf da DB'den silindi mi?
      photos = await repository.getPhotosForPlace('p-1');
      expect(photos, isEmpty);
    });

    test('Arama ve Filtreleme testleri', () async {
      final p1 = Place(
        id: '1',
        name: 'Montag Coffee',
        categoryKey: 'cafe',
        status: PlaceStatus.visited,
        latitude: 40.98,
        longitude: 29.02,
        isFavorite: true,
      );
      final p2 = Place(
        id: '2',
        name: 'Moda Sahili',
        categoryKey: 'seaside',
        status: PlaceStatus.visited,
        latitude: 40.98,
        longitude: 29.03,
        isFavorite: false,
      );
      final p3 = Place(
        id: '3',
        name: 'Müze Gazhane',
        categoryKey: 'culture',
        status: PlaceStatus.planned,
        latitude: 40.99,
        longitude: 29.04,
        isFavorite: false,
      );

      await repository.savePlace(p1);
      await repository.savePlace(p2);
      await repository.savePlace(p3);

      // Arama filtresi
      var list = await repository.getPlaces(filter: const PlaceFilter(searchQuery: 'Moda'));
      expect(list.length, 1);
      expect(list.first.name, 'Moda Sahili');

      // Kategori filtresi
      list = await repository.getPlaces(filter: const PlaceFilter(categoryKey: 'cafe'));
      expect(list.length, 1);
      expect(list.first.name, 'Montag Coffee');

      // Durum filtresi (planned)
      list = await repository.getPlaces(filter: const PlaceFilter(status: PlaceStatus.planned));
      expect(list.length, 1);
      expect(list.first.name, 'Müze Gazhane');

      // Favori filtresi
      list = await repository.getPlaces(filter: const PlaceFilter(isFavoriteOnly: true));
      expect(list.length, 1);
      expect(list.first.name, 'Montag Coffee');
    });
  });
}
