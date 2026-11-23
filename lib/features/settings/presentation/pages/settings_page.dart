import 'package:flutter/material.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Senin haritan.\nSenin kontrolün.',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 24),
            // Tema Ayarı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.light_mode_outlined, color: AppColors.textPrimary),
                  SizedBox(width: 16),
                  Text('Tema', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  Spacer(),
                  Text('Koyu', style: TextStyle(color: AppColors.textMuted)),
                  SizedBox(width: 8),
                  Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Gizlilik Kartı
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified_user_outlined, color: AppColors.accent),
                      SizedBox(width: 10),
                      Text(
                        'Gizlilik, önce gelir.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _PrivacyItem(
                    icon: Icons.phone_android_rounded,
                    title: 'Kayıtların bu cihazda',
                    subtitle: 'Mekânların, fotoğrafların ve notların yalnızca cihazında saklanır.',
                  ),
                  SizedBox(height: 14),
                  _PrivacyItem(
                    icon: Icons.location_on_outlined,
                    title: 'Konum, yalnızca istediğinde',
                    subtitle: 'İzin sadece Konumum butonuna dokunduğunda istenir. Arka plan konumu kullanılmaz.',
                  ),
                  SizedBox(height: 14),
                  _PrivacyItem(
                    icon: Icons.lock_outline_rounded,
                    title: 'Hesapsız, sana özel',
                    subtitle: 'Hesap oluşturman veya kişisel bilgi paylaşman gerekmez.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Uyarı Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withAlpha(150),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.accent, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Uygulamayı silersen yerel kayıtların da silinebilir. Kayıtların başka cihazlara otomatik aktarılmaz.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  const Text(
                    "Mekan Defteri'm",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Küçük keşifler, güzel anılar.\nSürüm 1.0.0',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
