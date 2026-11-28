import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/shimmer_card.dart';
import '../../../../core/widgets/staggered_list.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_status.dart';
import '../controllers/places_list_controller.dart';
import '../widgets/place_card.dart';

class PlacesListPage extends ConsumerStatefulWidget {
  const PlacesListPage({super.key});

  @override
  ConsumerState<PlacesListPage> createState() => _PlacesListPageState();
}

class _PlacesListPageState extends ConsumerState<PlacesListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summary = ref.watch(placesSummaryProvider);
    final filter = ref.watch(placeFilterStateProvider);
    final placesAsync = ref.watch(filteredPlacesStreamProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Koleksiyon'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alt Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
            child: Text(
              'Keşfettiğin her yer, tek defterde.',
              style: AppTypography.serif(
                color: colors.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Sayaç Alanı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              '${summary.total} mekân · ${summary.visited} gezildi · ${summary.planned} yeni rota',
              style: TextStyle(
                fontSize: 13,
                color: colors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {});
                ref.read(placeFilterStateProvider.notifier).update(
                      filter.copyWith(
                        searchQuery: val.trim().isEmpty ? null : val.trim(),
                      ),
                    );
              },
              decoration: InputDecoration(
                hintText: 'Moda, kafe, sahil...',
                prefixIcon: Icon(Icons.search_rounded, color: colors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 20,
                          color: colors.textMuted,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          ref.read(placeFilterStateProvider.notifier).update(
                                filter.copyWith(searchQuery: null),
                              );
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Filtre Çipleri
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                AppChip(
                  label: 'Tümü',
                  isSelected: filter.categoryKey == null &&
                      filter.status == null &&
                      filter.isFavoriteOnly != true,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).clear();
                  },
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: '✓ Gezildi',
                  isSelected: filter.status == PlaceStatus.visited,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(
                            status: filter.status == PlaceStatus.visited
                                ? null
                                : PlaceStatus.visited,
                            isFavoriteOnly: null,
                          ),
                        );
                  },
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'İstekler',
                  icon: filter.status == PlaceStatus.planned
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  isSelected: filter.status == PlaceStatus.planned,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(
                            status: filter.status == PlaceStatus.planned
                                ? null
                                : PlaceStatus.planned,
                            isFavoriteOnly: null,
                          ),
                        );
                  },
                ),
                const SizedBox(width: 8),
                AppChip(
                  label: 'Favoriler',
                  icon: Icons.favorite_rounded,
                  isSelected: filter.isFavoriteOnly == true,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(
                            isFavoriteOnly:
                                filter.isFavoriteOnly == true ? null : true,
                            status: null,
                          ),
                        );
                  },
                ),
                const SizedBox(width: 8),
                // Kategoriler
                ...PlaceCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: AppChip(
                      label: cat.label,
                      isSelected: filter.categoryKey == cat.key,
                      onTap: () {
                        ref.read(placeFilterStateProvider.notifier).update(
                              filter.copyWith(
                                categoryKey: filter.categoryKey == cat.key
                                    ? null
                                    : cat.key,
                              ),
                            );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Liste Alanı
          Expanded(
            child: placesAsync.when(
              loading: () => const ShimmerCardList(),
              error: (err, stack) => Center(
                child: Text(
                  'Kayıtlar yüklenemedi: $err',
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
              data: (places) {
                if (places.isEmpty) {
                  final isFiltered = filter.categoryKey != null ||
                      filter.status != null ||
                      filter.isFavoriteOnly == true ||
                      (filter.searchQuery != null &&
                          filter.searchQuery!.isNotEmpty);

                  return AppEmptyState(
                    icon: isFiltered
                        ? Icons.search_off_rounded
                        : Icons.bookmark_border_rounded,
                    title: isFiltered
                        ? 'Eşleşen mekân bulunamadı'
                        : 'Henüz bir mekân eklemedin',
                    subtitle: isFiltered
                        ? 'Filtreleri sıfırlayarak tüm kayıtlarını görebilirsin.'
                        : 'Gezdiğin veya keşfetmek istediğin ilk noktayı ekleyerek kendi defterini oluştur.',
                    actionLabel:
                        isFiltered ? 'Filtreleri Temizle' : 'İlk mekânını ekle',
                    onAction: () {
                      if (isFiltered) {
                        _searchController.clear();
                        setState(() {});
                        ref.read(placeFilterStateProvider.notifier).clear();
                      } else {
                        context.push('/places/new');
                      }
                    },
                  );
                }

                return StaggeredList(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return PlaceCard(
                      place: place,
                      onTap: () => context.push('/places/${place.id}'),
                      onFavoriteTap: () {
                        ref
                            .read(placeRepositoryProvider)
                            .toggleFavorite(place.id);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
