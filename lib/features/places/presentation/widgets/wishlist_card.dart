import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pressable_scale.dart';
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

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14),
      radius: AppRadius.md,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PressableScale(
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
                    borderRadius: AppRadius.borderSm,
                    border: Border.all(color: colors.cardBorder),
                  ),
                  child: Icon(
                    category.icon,
                    color: colors.accent,
                    size: 26,
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
          // Gezildi Olarak İşaretle Butonu (≥ 48dp dokunma alanı + tik haptic)
          PressableScale.button(
            hapticFeedback: AppHaptics.check,
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: colors.visitedBadge,
                  foregroundColor: colors.visitedText,
                  side: const BorderSide(color: AppColors.primary),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.borderSm,
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
          ),
        ],
      ),
    );
  }
}
