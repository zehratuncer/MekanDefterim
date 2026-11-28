import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';

class WishlistCard extends StatelessWidget {
  final Place place;
  final VoidCallback onTap;
  final VoidCallback onMarkVisited;

  const WishlistCard({
    super.key,
    required this.place,
    required this.onTap,
    required this.onMarkVisited,
  });

  @override
  Widget build(BuildContext context) {
    final category = PlaceCategory.fromKey(place.categoryKey);
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: colors.cardBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol Kategori İkon Kutusu
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Icon(
                      category.icon,
                      color: colors.accent,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Orta Bilgiler
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
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
                        ),
                        if (place.note != null && place.note!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            '“${place.note}”',
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: colors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // Gezildi Olarak İşaretle Butonu
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: colors.surfaceVariant,
                  foregroundColor: colors.visitedText,
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onMarkVisited,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text(
                  'Gezildi olarak işaretle',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
