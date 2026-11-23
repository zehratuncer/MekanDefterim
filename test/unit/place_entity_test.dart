import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/features/places/domain/entities/place.dart';
import 'package:mekandefterim/features/places/domain/entities/place_status.dart';

void main() {
  group('Place Entity Validations', () {
    test('geçerli verilerle Place sorunsuz oluşur', () {
      final place = Place(
        id: 'place-1',
        name: 'Montag Coffee',
        categoryKey: 'cafe',
        status: PlaceStatus.visited,
        latitude: 40.9876,
        longitude: 29.0234,
        rating: 5,
      );

      expect(place.name, 'Montag Coffee');
      expect(place.rating, 5);
      expect(place.status, PlaceStatus.visited);
    });

    test('boş isim verildiğinde PlaceValidationException fırlatır', () {
      expect(
        () => Place(
          id: 'place-2',
          name: '   ',
          categoryKey: 'cafe',
          status: PlaceStatus.visited,
          latitude: 40.0,
          longitude: 29.0,
        ),
        throwsA(isA<PlaceValidationException>()),
      );
    });

    test('hatalı enlem veya boylamda PlaceValidationException fırlatır', () {
      expect(
        () => Place(
          id: 'place-3',
          name: 'Kadıköy',
          categoryKey: 'cafe',
          status: PlaceStatus.visited,
          latitude: 95.0, // Geçersiz enlem > 90
          longitude: 29.0,
        ),
        throwsA(isA<PlaceValidationException>()),
      );

      expect(
        () => Place(
          id: 'place-4',
          name: 'Kadıköy',
          categoryKey: 'cafe',
          status: PlaceStatus.visited,
          latitude: 40.0,
          longitude: 190.0, // Geçersiz boylam > 180
        ),
        throwsA(isA<PlaceValidationException>()),
      );
    });

    test('hatalı puan verildiğinde PlaceValidationException fırlatır', () {
      expect(
        () => Place(
          id: 'place-5',
          name: 'Kadıköy',
          categoryKey: 'cafe',
          status: PlaceStatus.visited,
          latitude: 40.0,
          longitude: 29.0,
          rating: 6, // > 5
        ),
        throwsA(isA<PlaceValidationException>()),
      );
    });

    test('planned (Gitmek istiyorum) durumunda puan verilirse hata fırlatır', () {
      expect(
        () => Place(
          id: 'place-6',
          name: 'Müze Gazhane',
          categoryKey: 'culture',
          status: PlaceStatus.planned,
          latitude: 40.0,
          longitude: 29.0,
          rating: 4, // planned için puan olamaz
        ),
        throwsA(isA<PlaceValidationException>()),
      );
    });
  });
}
