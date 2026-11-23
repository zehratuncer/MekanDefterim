import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AppDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const AppDeleteDialog({
    super.key,
    this.title = 'Mekânı Sil',
    this.content = 'Bu mekânı silmek istediğine emin misin? İlişkili fotoğraflar da cihazından temizlenecektir.',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      title: Text(
        title,
        style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç', style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            minimumSize: const Size(100, 42),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: const Text('Sil'),
        ),
      ],
    );
  }
}
