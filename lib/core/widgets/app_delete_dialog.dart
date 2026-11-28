import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

class AppDeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;

  const AppDeleteDialog({
    super.key,
    this.title = 'Mekânı Sil',
    this.content =
        'Bu mekânı silmek istediğine emin misin? İlişkili fotoğraflar da cihazından temizlenecektir.',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: BorderSide(color: colors.cardBorder),
      ),
      title: Text(
        title,
        style: AppTypography.serif(
          color: colors.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: 14,
          height: 1.45,
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: const Size(88, 48),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Vazgeç', style: TextStyle(color: colors.textMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            minimumSize: const Size(104, 48),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
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
