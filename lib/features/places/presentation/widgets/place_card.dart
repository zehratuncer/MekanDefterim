import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_photo.dart';
import '../../domain/entities/place_status.dart';
import '../controllers/places_list_controller.dart';

class PlaceCard extends ConsumerWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const PlaceCard({
    super.key,
    required this.place,
    required this.onTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = PlaceCategory.fromKey(place.categoryKey);
    final isVisited = place.status == PlaceStatus.visited;
    final colors = context.colors;
    final photos = isVisited
        ? (ref.watch(placePhotosStreamProvider(place.id)).asData?.value ??
            const <PlacePhoto>[])
        : const <PlacePhoto>[];
    final firstPhotoFile = photos.isNotEmpty ? File(photos.first.filePath) : null;
    final hasValidPhoto = firstPhotoFile != null && firstPhotoFile.existsSync();

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      radius: AppRadius.md,
      padding: const EdgeInsets.fromLTRB(14, 14, 8, 14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol Görsel / Fotoğraf Önizleme Kutusu
          Container(
            width: 76,
            height: 76,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: colors.cardBorder),
            ),
            child: hasValidPhoto
                ? Image.file(
                    firstPhotoFile,
                    width: 76,
                    height: 76,
                    fit: BoxFit.cover,
                  )
                : Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isVisited ? AppColors.primary : colors.wishlistBadge,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isVisited ? Icons.check_rounded : category.icon,
                        color: isVisited ? Colors.white : colors.wishlistText,
                        size: 20,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          // Orta Bilgi Alanı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  place.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${category.label} · ${place.addressLabel ?? 'İstanbul'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (place.rating != null) ...[
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.starRating,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        place.rating!.toDouble().toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (isVisited) ...[
                      Icon(Icons.check_rounded, size: 14, color: colors.visitedText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          place.visitedAt != null
                              ? 'Gezildi · ${DateFormat('d MMM', 'tr_TR').format(place.visitedAt!)}'
                              : 'Gezildi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.visitedText,
                          ),
                        ),
                      ),
                    ] else ...[
                      Icon(
                        Icons.bookmark_border_rounded,
                        size: 14,
                        color: colors.wishlistText,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Gitmek istiyorum',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.wishlistText,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Sağ Favori Butonu (≥ 48dp erişilebilir dokunma alanı + kalp haptic)
          PressableScale(
            onTap: onFavoriteTap,
            hapticFeedback: AppHaptics.favorite,
            child: SizedBox(
              width: 48,
              height: 48,
              child: Center(
                child: Icon(
                  place.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: place.isFavorite ? colors.accent : colors.textMuted,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
