import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_status.dart';
import '../../domain/repositories/place_repository.dart';

/// Koleksiyon sayacı modeli
class PlacesCountSummary {
  final int total;
  final int visited;
  final int planned;

  const PlacesCountSummary({
    this.total = 0,
    this.visited = 0,
    this.planned = 0,
  });
}

/// Tüm mekânların istatistik sayacını hesaplayan provider
final placesSummaryProvider = Provider<PlacesCountSummary>((ref) {
  final placesAsync = ref.watch(allPlacesStreamProvider);
  return placesAsync.maybeWhen(
    data: (places) {
      final visited = places.where((p) => p.status == PlaceStatus.visited).length;
      final planned = places.where((p) => p.status == PlaceStatus.planned).length;
      return PlacesCountSummary(
        total: places.length,
        visited: visited,
        planned: planned,
      );
    },
    orElse: () => const PlacesCountSummary(),
  );
});

/// Tüm mekânların canlı akışı (filtresiz)
final allPlacesStreamProvider = StreamProvider<List<Place>>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.watchPlaces();
});

class PlaceFilterNotifier extends Notifier<PlaceFilter> {
  @override
  PlaceFilter build() => const PlaceFilter();

  void update(PlaceFilter filter) => state = filter;
  void clear() => state = const PlaceFilter();
}

final placeFilterStateProvider = NotifierProvider<PlaceFilterNotifier, PlaceFilter>(() {
  return PlaceFilterNotifier();
});

/// Filtrelenmiş mekânlar canlı akışı
final filteredPlacesStreamProvider = StreamProvider<List<Place>>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  final filter = ref.watch(placeFilterStateProvider);
  return repository.watchPlaces(filter: filter);
});

/// Yalnızca İstek Listem (planned) canlı akışı
final wishlistPlacesStreamProvider = StreamProvider<List<Place>>((ref) {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.watchPlaces(filter: const PlaceFilter(status: PlaceStatus.planned));
});

/// Tekil mekân getirme provider'ı (Family)
final placeDetailProvider = FutureProvider.family<Place?, String>((ref, id) {
  final repository = ref.watch(placeRepositoryProvider);
  return repository.getPlaceById(id);
});

