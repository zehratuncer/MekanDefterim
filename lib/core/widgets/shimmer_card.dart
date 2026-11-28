import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';

/// Veri yüklenirken `PlaceCard` / `WishlistCard` geometrisinde parlayan iskelet kart.
///
/// Açık ve koyu temaya uyumludur; "Animasyonları azalt" açıkken sabit iskelet gösterir.
class ShimmerCard extends StatelessWidget {
  final EdgeInsetsGeometry margin;

  const ShimmerCard({
    super.key,
    this.margin = const EdgeInsets.only(bottom: 14),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final reducedMotion = AppMotion.isReducedMotion(context);

    final skeletonBody = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: AppRadius.borderSm,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Container(
                height: 16,
                width: 150,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 12,
                width: 110,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                height: 12,
                width: 80,
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: colors.cardBorder),
      ),
      child: reducedMotion
          ? skeletonBody
          : Shimmer.fromColors(
              baseColor: colors.surfaceVariant,
              highlightColor: Color.lerp(colors.surfaceVariant, colors.textPrimary, 0.14)!,
              period: const Duration(milliseconds: 1300),
              child: skeletonBody,
            ),
    );
  }
}

/// Çoklu yükleme iskeleti listesi.
class ShimmerCardList extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;

  const ShimmerCardList({
    super.key,
    this.itemCount = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (_, _) => const ShimmerCard(),
    );
  }
}
