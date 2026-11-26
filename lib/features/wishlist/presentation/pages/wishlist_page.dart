import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_empty_state.dart';
import 'package:mekandefterim/features/places/domain/entities/place_status.dart';
import 'package:mekandefterim/features/places/presentation/controllers/places_list_controller.dart';
import 'package:mekandefterim/features/places/presentation/widgets/wishlist_card.dart';

class WishlistPage extends ConsumerWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistAsync = ref.watch(wishlistPlacesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('İstek Listem'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık ve Sayaç Alanı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bir sonraki durağın?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                wishlistAsync.maybeWhen(
                  data: (places) => Text(
                    '${places.length} mekân, keşfedilmeyi bekliyor.',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                  orElse: () => const Text(
                    '0 mekân, keşfedilmeyi bekliyor.',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Liste Alanı
          Expanded(
            child: wishlistAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
              error: (err, stack) => Center(
                child: Text('Kayıtlar yüklenemedi: $err', style: const TextStyle(color: AppColors.error)),
              ),
              data: (places) {
                if (places.isEmpty) {
                  return AppEmptyState(
                    icon: Icons.favorite_border_rounded,
                    title: 'İstek listen henüz boş',
                    subtitle: 'Gitmek istediğin yerleri kaydet, vakti geldiğinde ziyaret edip gezildi olarak işaretle.',
                    actionLabel: 'Yeni İstek Ekle',
                    onAction: () => context.push('/places/new'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: places.length,
                  itemBuilder: (context, index) {
                    final place = places[index];
                    return WishlistCard(
                      place: place,
                      onTap: () => context.push('/places/${place.id}'),
                      onMarkVisited: () async {
                        await ref.read(placeRepositoryProvider).updateStatus(place.id, PlaceStatus.visited);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: AppColors.surface,
                              content: Text(
                                '${place.name} gezildi olarak işaretlendi!',
                                style: const TextStyle(color: AppColors.visitedText),
                              ),
                            ),
                          );
                        }
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
