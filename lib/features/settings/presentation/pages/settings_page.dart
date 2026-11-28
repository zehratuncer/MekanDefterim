import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mekandefterim/app/providers.dart';
import 'package:mekandefterim/core/data/mock_places_seed.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';
import 'package:mekandefterim/core/theme/app_radius.dart';
import 'package:mekandefterim/core/theme/app_typography.dart';
import 'package:mekandefterim/core/utils/app_haptics.dart';
import 'package:mekandefterim/core/widgets/app_card.dart';
import '../controllers/theme_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeMode current,
  ) {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: AppRadius.sheetTop,
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              final isSelected = mode == current;
              return ListTile(
                leading: Icon(
                  mode == ThemeMode.dark
                      ? Icons.dark_mode_outlined
                      : mode == ThemeMode.light
                          ? Icons.light_mode_outlined
                          : Icons.settings_brightness_outlined,
                  color: isSelected ? colors.accent : colors.textMuted,
                ),
                title: Text(
                  mode.labelTr,
                  style: TextStyle(
                    color: colors.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_rounded, color: colors.accent)
                    : null,
                onTap: () {
                  AppHaptics.tabChange();
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                  Navigator.of(ctx).pop();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Senin haritan.\nSenin kontrolün.',
              style: AppTypography.serif(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            // Tema Ayarı
            AppCard(
              radius: AppRadius.md,
              padding: const EdgeInsets.all(16),
              onTap: () => _showThemePicker(context, ref, themeMode),
              child: Row(
                children: [
                  Icon(Icons.light_mode_outlined, color: colors.accent),
                  const SizedBox(width: 16),
                  Text(
                    'Tema',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: colors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    themeMode.labelTr,
                    style: TextStyle(color: colors.textMuted),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Gizlilik Kartı
            AppCard(
              radius: AppRadius.md,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined, color: colors.accent),
                      const SizedBox(width: 10),
                      Text(
                        'Gizlilik, önce gelir.',
                        style: AppTypography.serif(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: colors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _PrivacyItem(
                    icon: Icons.phone_android_rounded,
                    title: 'Kayıtların bu cihazda',
                    subtitle:
                        'Mekânların, fotoğrafların ve notların yalnızca cihazında saklanır.',
                  ),
                  const SizedBox(height: 14),
                  const _PrivacyItem(
                    icon: Icons.location_on_outlined,
                    title: 'Konum, yalnızca istediğinde',
                    subtitle:
                        'İzin sadece Konumum butonuna dokunduğunda istenir. Arka plan konumu kullanılmaz.',
                  ),
                  const SizedBox(height: 14),
                  const _PrivacyItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Hesapsız, sana özel',
                    subtitle:
                        'Hesap oluşturman veya kişisel bilgi paylaşman gerekmez.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Uyarı Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceVariant,
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: colors.cardBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: colors.accent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Uygulamayı silersen yerel kayıtların da silinebilir. Kayıtların başka cihazlara otomatik aktarılmaz.',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 20),
              AppCard(
                radius: AppRadius.md,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.science_outlined,
                          color: colors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Test Verileri (Debug)',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: const Size(0, 48),
                            ),
                            onPressed: () async {
                              await MockPlacesSeed.seed(
                                ref.read(placeRepositoryProvider),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('8 örnek mekân eklendi.'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.add_location_alt_outlined,
                              size: 18,
                            ),
                            label: const Text(
                              'Örnek Yükle',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: const Size(0, 48),
                            ),
                            onPressed: () async {
                              await MockPlacesSeed.clear(
                                ref.read(placeRepositoryProvider),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Örnek mekânlar temizlendi.'),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 18,
                            ),
                            label: const Text(
                              'Temizle',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    "Mekan Defteri'm",
                    style: AppTypography.serif(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Küçük keşifler, güzel anılar.\nSürüm 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PrivacyItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: colors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: colors.textMuted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
