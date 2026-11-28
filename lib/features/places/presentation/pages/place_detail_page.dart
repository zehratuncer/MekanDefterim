import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_delete_dialog.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_photo.dart';
import '../../domain/entities/place_status.dart';
import '../controllers/places_list_controller.dart';

class PlaceDetailPage extends ConsumerWidget {
  final String placeId;

  const PlaceDetailPage({super.key, required this.placeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final placeAsync = ref.watch(placeDetailProvider(placeId));
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekân detayı'),
      ),
      body: placeAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Text(
            'Mekân bulunamadı: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (place) {
          if (place == null) {
            return Center(
              child: Text(
                'Mekân kaydı silinmiş veya bulunamadı.',
                style: TextStyle(color: colors.textMuted),
              ),
            );
          }

          final category = PlaceCategory.fromKey(place.categoryKey);
          final isVisited = place.status == PlaceStatus.visited;
          final photos =
              ref.watch(placePhotosStreamProvider(placeId)).asData?.value ??
                  const <PlacePhoto>[];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isVisited) ...[
                  // Fotoğraf Galerisi / Placeholder Alanı (yalnızca gezilen mekânlarda)
                  Stack(
                    children: [
                      _PhotoGalleryBanner(
                        photos: photos,
                        fallbackIcon: category.icon,
                      ),
                      // Sağ Üst Favori Butonu
                      Positioned(
                        top: 14,
                        right: 14,
                        child: PressableScale(
                          hapticFeedback: AppHaptics.favorite,
                          onTap: () async {
                            await ref
                                .read(placeRepositoryProvider)
                                .toggleFavorite(place.id);
                            ref.invalidate(placeDetailProvider(placeId));
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colors.surface.withValues(alpha: 0.88),
                              shape: BoxShape.circle,
                              border: Border.all(color: colors.cardBorder),
                            ),
                            child: Icon(
                              place.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: place.isFavorite
                                  ? colors.accent
                                  : colors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
                // Mekân Adı ve Semt
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        place.name,
                        style: AppTypography.serif(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                    if (!isVisited)
                      IconButton(
                        icon: Icon(
                          place.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: place.isFavorite
                              ? colors.accent
                              : colors.textPrimary,
                        ),
                        onPressed: () async {
                          AppHaptics.favorite();
                          await ref
                              .read(placeRepositoryProvider)
                              .toggleFavorite(place.id);
                          ref.invalidate(placeDetailProvider(placeId));
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: colors.accent,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        place.addressLabel ?? 'İstanbul',
                        style: TextStyle(color: colors.textMuted, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Rozetler (Kategori, Gezildi/İstek, Puan)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(label: category.label),
                    _Badge(
                      label: isVisited ? '✓ Gezildi' : 'İstek',
                      color: isVisited
                          ? colors.visitedBadge
                          : colors.wishlistBadge,
                      textColor:
                          isVisited ? colors.visitedText : colors.wishlistText,
                    ),
                    if (place.rating != null)
                      _Badge(
                        label: '★ ${place.rating!.toDouble().toStringAsFixed(1)}',
                        color: colors.surfaceVariant,
                        textColor: AppColors.starRating,
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                // Kendime Not Alanı
                if (place.note != null && place.note!.isNotEmpty) ...[
                  AppCard(
                    radius: AppRadius.md,
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'KENDİME NOT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: colors.accent,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              DateFormat('d MMMM yyyy', 'tr_TR')
                                  .format(place.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.textMuted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          place.note!,
                          style: TextStyle(
                            fontSize: 14,
                            color: colors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // Haritada Gör Önizleme Kartı
                AppCard(
                  radius: AppRadius.md,
                  onTap: () => context.go(
                    '/places?lat=${place.latitude}&lng=${place.longitude}',
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: IgnorePointer(
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter:
                                  LatLng(place.latitude, place.longitude),
                              initialZoom: 15.5,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none,
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.zehratuncer.mekandefterim',
                                keepBuffer: 2,
                                maxNativeZoom: 19,
                                tileDisplay: const TileDisplay.fadeIn(
                                  duration: Duration(milliseconds: 150),
                                ),
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point:
                                        LatLng(place.latitude, place.longitude),
                                    width: 40,
                                    height: 40,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isVisited
                                            ? AppColors.primary
                                            : AppColors.wishlistBadge,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2.5,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha(90),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isVisited
                                            ? Icons.check_rounded
                                            : category.icon,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.map_rounded,
                              color: colors.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Haritada gör',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: colors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    place.addressLabel ?? 'İstanbul',
                                    style: TextStyle(
                                      color: colors.textMuted,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Alt Butonlar (Düzenle & Sil)
                Row(
                  children: [
                    Expanded(
                      child: PressableScale.button(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push(
                            '/places/${place.id}/edit',
                            extra: place,
                          ),
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          label: const Text('Düzenle'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: AppRadius.borderSm,
                        border: Border.all(color: colors.cardBorder),
                      ),
                      child: IconButton(
                        tooltip: 'Mekânı sil',
                        icon: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AppDeleteDialog(
                              onConfirm: () async {
                                await ref
                                    .read(placeRepositoryProvider)
                                    .deletePlace(placeId);
                                if (context.mounted) {
                                  context.pop();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color? color;
  final Color? textColor;

  const _Badge({
    required this.label,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? colors.surfaceVariant,
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: colors.cardBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? colors.textPrimary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PhotoGalleryBanner extends StatefulWidget {
  final List<PlacePhoto> photos;
  final IconData fallbackIcon;

  const _PhotoGalleryBanner({
    required this.photos,
    required this.fallbackIcon,
  });

  @override
  State<_PhotoGalleryBanner> createState() => _PhotoGalleryBannerState();
}

class _PhotoGalleryBannerState extends State<_PhotoGalleryBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (widget.photos.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          gradient: colors.cardGradient,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: colors.cardBorder),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.fallbackIcon, size: 48, color: colors.accent),
              const SizedBox(height: 8),
              Text(
                'Fotoğraf eklenmedi',
                style: TextStyle(color: colors.textMuted, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: AppRadius.borderLg,
            child: PageView.builder(
              itemCount: widget.photos.length,
              onPageChanged: (idx) => setState(() => _currentIndex = idx),
              itemBuilder: (context, index) {
                final photo = widget.photos[index];
                return Image.file(
                  File(photo.filePath),
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  cacheWidth: 900,
                  errorBuilder: (_, _, _) => Container(
                    color: colors.surfaceVariant,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        size: 40,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 12,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(170),
                borderRadius: AppRadius.borderSm,
              ),
              child: Text(
                '${_currentIndex + 1} / ${widget.photos.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
