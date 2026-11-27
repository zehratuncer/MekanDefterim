import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_status.dart';

class PlaceCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final category = PlaceCategory.fromKey(place.categoryKey);
    final isVisited = place.status == PlaceStatus.visited;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol Görsel / Harita Pin Önizleme Kutusu
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isVisited ? AppColors.primary : AppColors.wishlistBadge,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isVisited ? Icons.check_rounded : category.icon,
                        color: Colors.white,
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
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${category.label} · ${place.addressLabel ?? 'İstanbul'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (place.rating != null) ...[
                            const Icon(Icons.star_rounded, size: 16, color: AppColors.starRating),
                            const SizedBox(width: 4),
                            Text(
                              place.rating!.toDouble().toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (isVisited) ...[
                            const Icon(Icons.check_rounded, size: 14, color: AppColors.visitedText),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place.visitedAt != null
                                    ? 'Gezildi · ${DateFormat('d MMM', 'tr_TR').format(place.visitedAt!)}'
                                    : 'Gezildi',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.visitedText,
                                ),
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.bookmark_border_rounded, size: 14, color: AppColors.wishlistText),
                            const SizedBox(width: 4),
                            const Expanded(
                              child: Text(
                                'Gitmek istiyorum',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.wishlistText,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                // Sağ Favori Butonu
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    place.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: place.isFavorite ? AppColors.accent : AppColors.textMuted,
                    size: 22,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
