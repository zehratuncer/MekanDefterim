import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import '../../../../app/providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_delete_dialog.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekân detayı'),
      ),
      body: placeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(
          child: Text('Mekân bulunamadı: $err', style: const TextStyle(color: AppColors.error)),
        ),
        data: (place) {
          if (place == null) {
            return const Center(
              child: Text('Mekân kaydı silinmiş veya bulunamadı.', style: TextStyle(color: AppColors.textMuted)),
            );
          }

          final category = PlaceCategory.fromKey(place.categoryKey);
          final isVisited = place.status == PlaceStatus.visited;
          final photos = ref.watch(placePhotosStreamProvider(placeId)).asData?.value ?? const <PlacePhoto>[];

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
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface.withAlpha(200),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              place.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: place.isFavorite ? AppColors.accent : Colors.white,
                            ),
                            onPressed: () async {
                              await ref.read(placeRepositoryProvider).toggleFavorite(place.id);
                              ref.invalidate(placeDetailProvider(placeId));
                            },
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
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).brightness == Brightness.light
                              ? AppColors.background
                              : AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    if (!isVisited)
                      IconButton(
                        icon: Icon(
                          place.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: place.isFavorite
                              ? AppColors.accent
                              : (Theme.of(context).brightness == Brightness.light
                                  ? AppColors.background
                                  : Colors.white),
                        ),
                        onPressed: () async {
                          await ref.read(placeRepositoryProvider).toggleFavorite(place.id);
                          ref.invalidate(placeDetailProvider(placeId));
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      place.addressLabel ?? 'İstanbul',
                      style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Rozetler (Kategori, Gezildi/İstek, Puan)
                Row(
                  children: [
                    _Badge(label: category.label),
                    const SizedBox(width: 8),
                    _Badge(
                      label: isVisited ? '✓ Gezildi' : 'İstek',
                      color: isVisited ? AppColors.visitedBadge : AppColors.wishlistBadge,
                      textColor: isVisited ? AppColors.visitedText : AppColors.wishlistText,
                    ),
                    if (place.rating != null) ...[
                      const SizedBox(width: 8),
                      _Badge(
                        label: '★ ${place.rating!.toDouble().toStringAsFixed(1)}',
                        color: AppColors.surfaceVariant,
                        textColor: AppColors.starRating,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 24),
                // Kendime Not Alanı
                if (place.note != null && place.note!.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'KENDİME NOT',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              DateFormat('d MMMM yyyy', 'tr_TR').format(place.createdAt),
                              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          place.note!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                // Haritada Gör Önizleme Kartı
                GestureDetector(
                  onTap: () => context.go(
                    '/places?lat=${place.latitude}&lng=${place.longitude}',
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: IgnorePointer(
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: LatLng(place.latitude, place.longitude),
                                initialZoom: 15.5,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.none,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                                  subdomains: const ['a', 'b', 'c', 'd'],
                                  userAgentPackageName: 'com.zehratuncer.mekandefterim',
                                  keepBuffer: 2,
                                  maxNativeZoom: 19,
                                  tileDisplay: const TileDisplay.fadeIn(
                                    duration: Duration(milliseconds: 150),
                                  ),
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(place.latitude, place.longitude),
                                      width: 40,
                                      height: 40,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: isVisited ? AppColors.primary : AppColors.wishlistBadge,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2.5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(90),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          isVisited ? Icons.check_rounded : category.icon,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              const Icon(Icons.map_rounded, color: AppColors.accent, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Haritada gör',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      place.addressLabel ?? 'İstanbul',
                                      style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Alt Butonlar (Düzenle & Sil)
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/places/${place.id}/edit', extra: place),
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        label: const Text('Düzenle'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AppDeleteDialog(
                              onConfirm: () async {
                                await ref.read(placeRepositoryProvider).deletePlace(placeId);
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.textPrimary,
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
    if (widget.photos.isEmpty) {
      return Container(
        width: double.infinity,
        height: 220,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.fallbackIcon, size: 48, color: AppColors.accent),
              const SizedBox(height: 8),
              const Text(
                'Fotoğraf eklenmedi',
                style: TextStyle(color: AppColors.textMuted, fontSize: 13),
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
            borderRadius: BorderRadius.circular(24),
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
                    color: AppColors.surfaceVariant,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, size: 40, color: AppColors.textMuted),
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
                borderRadius: BorderRadius.circular(12),
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
