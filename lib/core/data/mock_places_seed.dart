import '../../features/places/domain/entities/place.dart';
import '../../features/places/domain/entities/place_category.dart';
import '../../features/places/domain/entities/place_status.dart';
import '../../features/places/domain/repositories/place_repository.dart';

/// Uygulamayı test etmek için kullanılan örnek (mock) mekânlar.
class MockPlacesSeed {
  static final List<Place> places = [
    Place(
      id: 'mock-place-1',
      name: 'Walter\'s Coffee Roastery',
      categoryKey: PlaceCategory.cafe.key,
      status: PlaceStatus.visited,
      latitude: 40.9854,
      longitude: 29.0267,
      addressLabel: 'Moda, Kadıköy',
      note: 'V60 filtre kahvesi ve geniş çalışma masaları çok keyifli. Sabah erken saatlerde sakin oluyor.',
      rating: 5,
      isFavorite: true,
      visitedAt: DateTime(2026, 11, 18),
      createdAt: DateTime(2026, 11, 18),
    ),
    Place(
      id: 'mock-place-2',
      name: 'Karaköy Lokantası',
      categoryKey: PlaceCategory.restaurant.key,
      status: PlaceStatus.visited,
      latitude: 41.0226,
      longitude: 28.9766,
      addressLabel: 'Karaköy, Beyoğlu',
      note: 'Akşam yemeği için önceden rezervasyon şart. Mezeleri ve turkuaz çinili atmosferi harika.',
      rating: 5,
      isFavorite: true,
      visitedAt: DateTime(2026, 11, 10),
      createdAt: DateTime(2026, 11, 10),
    ),
    Place(
      id: 'mock-place-3',
      name: 'Nail Kitabevi',
      categoryKey: PlaceCategory.bookstore.key,
      status: PlaceStatus.visited,
      latitude: 41.0355,
      longitude: 29.0298,
      addressLabel: 'Kuzguncuk, Üsküdar',
      note: 'Üst katta kahve eşliğinde kitap okumak için mükemmel bir köşe.',
      rating: 4,
      isFavorite: false,
      visitedAt: DateTime(2026, 10, 29),
      createdAt: DateTime(2026, 10, 29),
    ),
    Place(
      id: 'mock-place-4',
      name: 'Emirgan Korusu',
      categoryKey: PlaceCategory.nature.key,
      status: PlaceStatus.planned,
      latitude: 41.1086,
      longitude: 29.0528,
      addressLabel: 'Emirgan, Sarıyer',
      note: 'Hafta sonu sabah yürüyüşü ve Sarı Köşk\'te kahvaltı için gitmek istiyorum.',
      isFavorite: true,
      createdAt: DateTime(2026, 11, 22),
    ),
    Place(
      id: 'mock-place-5',
      name: 'İstanbul Modern',
      categoryKey: PlaceCategory.culture.key,
      status: PlaceStatus.visited,
      latitude: 41.0258,
      longitude: 28.9830,
      addressLabel: 'Galataport, Beyoğlu',
      note: 'Yeni binasının teras manzarası ve kalıcı koleksiyon sergisi mutlaka görülmeli.',
      rating: 5,
      isFavorite: false,
      visitedAt: DateTime(2026, 11, 4),
      createdAt: DateTime(2026, 11, 4),
    ),
    Place(
      id: 'mock-place-6',
      name: 'Bebek Sahili',
      categoryKey: PlaceCategory.seaside.key,
      status: PlaceStatus.planned,
      latitude: 41.0766,
      longitude: 29.0434,
      addressLabel: 'Bebek, Beşiktaş',
      note: 'Gün batımında sahil yürüyüşü ve kahve molası.',
      isFavorite: false,
      createdAt: DateTime(2026, 11, 24),
    ),
    Place(
      id: 'mock-place-7',
      name: 'Balat Antikacılar Sokağı',
      categoryKey: PlaceCategory.shopping.key,
      status: PlaceStatus.planned,
      latitude: 41.0315,
      longitude: 28.9488,
      addressLabel: 'Balat, Fatih',
      note: 'Hafta sonu mezatlarına uğrayıp plak ve vintage objelere bakmak istiyorum.',
      isFavorite: false,
      createdAt: DateTime(2026, 11, 25),
    ),
    Place(
      id: 'mock-place-8',
      name: 'Moda İskelesi',
      categoryKey: PlaceCategory.seaside.key,
      status: PlaceStatus.visited,
      latitude: 40.9794,
      longitude: 29.0251,
      addressLabel: 'Moda, Kadıköy',
      note: 'Üst kattaki kütüphane alanı deniz manzarasıyla çalışmak için harika.',
      rating: 4,
      isFavorite: true,
      visitedAt: DateTime(2026, 11, 20),
      createdAt: DateTime(2026, 11, 20),
    ),
  ];

  static Future<void> seed(PlaceRepository repository) async {
    for (final place in places) {
      await repository.savePlace(place);
    }
  }

  static Future<void> clear(PlaceRepository repository) async {
    for (final place in places) {
      await repository.deletePlace(place.id);
    }
  }
}
