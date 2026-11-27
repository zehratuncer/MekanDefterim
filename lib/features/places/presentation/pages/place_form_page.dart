import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/services/photo_storage_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_status.dart';
import '../controllers/place_form_controller.dart';
import 'location_picker_page.dart';

class PlaceFormPage extends ConsumerStatefulWidget {
  final Place? initialPlace;
  final PickedLocation? initialLocation;

  const PlaceFormPage({super.key, this.initialPlace, this.initialLocation});

  @override
  ConsumerState<PlaceFormPage> createState() => _PlaceFormPageState();
}

class _PlaceFormPageState extends ConsumerState<PlaceFormPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.initialPlace?.name ?? widget.initialLocation?.name ?? '',
    );
    _noteController = TextEditingController(text: widget.initialPlace?.note ?? '');

    if (widget.initialLocation != null && widget.initialPlace == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final notifier = ref.read(placeFormNotifierProvider(widget.initialPlace).notifier);
        if (widget.initialLocation!.name != null && widget.initialLocation!.name!.isNotEmpty) {
          notifier.setName(widget.initialLocation!.name!);
        }
        notifier.setLocation(
          latitude: widget.initialLocation!.latitude,
          longitude: widget.initialLocation!.longitude,
          addressLabel: widget.initialLocation!.addressLabel,
        );
      });
    } else if (widget.initialPlace != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(placeFormNotifierProvider(widget.initialPlace).notifier).loadInitialPhotos();
      });
    }
  }

  Future<void> _showPhotoSourceSheet(PlaceFormNotifier notifier) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.accent),
                title: const Text('Galeriden seç', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.accent),
                title: const Text('Kamera ile çek', style: TextStyle(color: AppColors.textPrimary)),
                onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null || !mounted) return;

    final path = await ref.read(photoStorageServiceProvider).pickImage(source: source);
    if (path == null || !mounted) return;

    final error = notifier.addPhotoFromPath(path);
    if (error != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Text(error, style: const TextStyle(color: AppColors.textPrimary)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(placeFormNotifierProvider(widget.initialPlace));
    final notifier = ref.read(placeFormNotifierProvider(widget.initialPlace).notifier);

    final isEdit = widget.initialPlace != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Mekânı Düzenle' : 'Yeni Mekân'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Konum Kutusu
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formState.addressLabel ?? 'İstanbul',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Konum seçildi',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await context.push<PickedLocation>(
                        '/places/pick-location',
                        extra: PickedLocation(
                          latitude: formState.latitude,
                          longitude: formState.longitude,
                          addressLabel: formState.addressLabel ?? 'İstanbul',
                        ),
                      );
                      if (picked != null && mounted) {
                        notifier.setLocation(
                          latitude: picked.latitude,
                          longitude: picked.longitude,
                          addressLabel: picked.addressLabel,
                        );
                      }
                    },
                    child: const Text('Değiştir', style: TextStyle(color: AppColors.accent)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Mekân Adı
            const Text(
              'Mekân adı',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              onChanged: notifier.setName,
              decoration: InputDecoration(
                hintText: 'Örn: Montag Coffee',
                errorText: formState.errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            // Kategori
            const Text(
              'Kategori',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: formState.categoryKey,
                  isExpanded: true,
                  dropdownColor: AppColors.surface,
                  items: PlaceCategory.values.map((cat) {
                    return DropdownMenuItem(
                      value: cat.key,
                      child: Row(
                        children: [
                          Icon(cat.icon, size: 20, color: AppColors.accent),
                          const SizedBox(width: 12),
                          Text(cat.label, style: const TextStyle(color: AppColors.textPrimary)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) notifier.setCategory(val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Durum Seçimi: Gezildi & Gitmek istiyorum
            const Text(
              'Durum',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _StatusOptionButton(
                    label: 'Gezildi',
                    icon: Icons.check_rounded,
                    isSelected: formState.status == PlaceStatus.visited,
                    onTap: () => notifier.setStatus(PlaceStatus.visited),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatusOptionButton(
                    label: 'Gitmek istiyorum',
                    icon: Icons.favorite_border_rounded,
                    isSelected: formState.status == PlaceStatus.planned,
                    onTap: () => notifier.setStatus(PlaceStatus.planned),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Gezildi seçildiğinde Puan ve Fotoğraf
            if (formState.status == PlaceStatus.visited) ...[
              Row(
                children: [
                  // Fotoğraf Ekle Butonu
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.cardBorder),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: formState.canAddMorePhotos
                          ? () => _showPhotoSourceSheet(notifier)
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: AppColors.surface,
                                  content: Text(
                                    'Bir mekâna en fazla 5 fotoğraf eklenebilir.',
                                    style: TextStyle(color: AppColors.textPrimary),
                                  ),
                                ),
                              );
                            },
                      icon: const Icon(Icons.add_photo_alternate_outlined, size: 20, color: AppColors.accent),
                      label: Text(
                        'Fotoğraf (${formState.photos.length}/5)',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Puan Yıldızları
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Puan · isteğe bağlı',
                        style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: List.generate(5, (index) {
                          final star = index + 1;
                          final isFilled = formState.rating != null && formState.rating! >= star;
                          return GestureDetector(
                            onTap: () => notifier.setRating(star),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                isFilled ? Icons.star_rounded : Icons.star_border_rounded,
                                color: isFilled ? AppColors.starRating : AppColors.textMuted,
                                size: 24,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
              if (formState.photos.isNotEmpty) ...[
                const SizedBox(height: 14),
                SizedBox(
                  height: 82,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: formState.photos.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final photo = formState.photos[index];
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.file(
                              File(photo.filePath),
                              width: 82,
                              height: 82,
                              fit: BoxFit.cover,
                              cacheWidth: 240,
                              errorBuilder: (_, _, _) => Container(
                                width: 82,
                                height: 82,
                                color: AppColors.surfaceVariant,
                                child: const Icon(Icons.broken_image_outlined, color: AppColors.textMuted),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => notifier.removePhoto(photo.id),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withAlpha(170),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ] else ...[
              // İstek Listem Bilgi Kutusu
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant.withAlpha(150),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.favorite_border_rounded, color: AppColors.wishlistText, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Bu mekân İstek Listem’de görünecek. Gittiğinde durumunu değiştirebilirsin.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // Not Alanı
            const Text(
              'Not · isteğe bağlı',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              onChanged: notifier.setNote,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Kahvesi çok iyi. Pencere kenarında kitap okumak için yeniden gel.',
              ),
            ),
            const SizedBox(height: 32),
            // Kaydet Butonu
            ElevatedButton(
              onPressed: formState.isSubmitting
                  ? null
                  : () async {
                      final success = await notifier.savePlace();
                      if (success && context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
              child: formState.isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(isEdit ? 'Değişiklikleri kaydet' : 'Mekânı kaydet'),
                      ],
                    ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                'Yalnızca bu cihazda, sana özel.',
                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _StatusOptionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StatusOptionButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.cardBorder,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
