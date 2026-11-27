import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import 'package:mekandefterim/features/places/domain/entities/place_category.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '𝐊𝐨𝐥𝐞𝐤𝐬𝐢𝐲𝐨𝐧',
          style: TextStyle(fontSize: 26),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alt Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Text(
              'Keşfettiğin her yer, tek defterde.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Sayaç Alanı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Text(
              '${summary.total} mekân · ${summary.visited} gezildi · ${summary.planned} yeni rota',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
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
                ref.read(placeFilterStateProvider.notifier).update(
                      filter.copyWith(searchQuery: val.trim().isEmpty ? null : val.trim()),
                    );
              },
              decoration: InputDecoration(
                hintText: 'Moda, kafe, sahil...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 20, color: AppColors.textMuted),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(placeFilterStateProvider.notifier).update(
                                filter.copyWith(searchQuery: null),
                              );
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Filtre Çipleri
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Tümü',
                  isSelected: filter.categoryKey == null && filter.status == null && filter.isFavoriteOnly != true,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).clear();
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: '✓ Gezildi',
                  isSelected: filter.status == PlaceStatus.visited,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(status: filter.status == PlaceStatus.visited ? null : PlaceStatus.visited),
                        );
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'İstekler',
                  icon: filter.status == PlaceStatus.planned
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  isSelected: filter.status == PlaceStatus.planned,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(status: filter.status == PlaceStatus.planned ? null : PlaceStatus.planned),
                        );
                  },
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Favoriler',
                  icon: Icons.favorite_rounded,
                  isSelected: filter.isFavoriteOnly == true,
                  onTap: () {
                    ref.read(placeFilterStateProvider.notifier).update(
                          filter.copyWith(isFavoriteOnly: filter.isFavoriteOnly == true ? null : true),
                        );
                  },
                ),
                const SizedBox(width: 8),
                // Kategoriler
                ...PlaceCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: cat.label,
                      isSelected: filter.categoryKey == cat.key,
                      onTap: () {
                        ref.read(placeFilterStateProvider.notifier).update(
                              filter.copyWith(categoryKey: filter.categoryKey == cat.key ? null : cat.key),
                            );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Liste Alanı
          Expanded(
            child: placesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, stack) => Center(
                child: Text('Kayıtlar yüklenemedi: $err', style: const TextStyle(color: AppColors.error)),
              ),
              data: (places) {
                if (places.isEmpty) {
                  final isFiltered = filter.categoryKey != null ||
                      filter.status != null ||
                      filter.isFavoriteOnly == true ||
                      (filter.searchQuery != null && filter.searchQuery!.isNotEmpty);

                  return AppEmptyState(
                    icon: isFiltered ? Icons.search_off_rounded : Icons.bookmark_border_rounded,
                    title: isFiltered ? 'Eşleşen mekân bulunamadı' : 'Henüz bir mekân eklemedin',
                    subtitle: isFiltered
                        ? 'Filtreleri sıfırlayarak tüm kayıtlarını görebilirsin.'
                        : 'Gezdiğin veya keşfetmek istediğin ilk noktayı ekleyerek kendi defterini oluştur.',
                    actionLabel: isFiltered ? 'Filtreleri Temizle' : 'İlk mekânını ekle',
                    onAction: () {
                      if (isFiltered) {
                        _searchController.clear();
                        ref.read(placeFilterStateProvider.notifier).clear();
                      } else {
                        context.push('/places/new');
                      }
                    },
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return PlaceCard(
                      place: place,
                      onTap: () => context.push('/places/${place.id}'),
                      onFavoriteTap: () {
                        ref.read(placeRepositoryProvider).toggleFavorite(place.id);
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

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.white : AppColors.accent),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
