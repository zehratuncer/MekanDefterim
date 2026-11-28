import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../utils/app_haptics.dart';
import 'pressable_scale.dart';

/// Mekan Defteri'm Standart Seçim / Filtre Çipi (Faz 9.0)
///
/// - Köşe yarıçapı: [AppRadius.sm] (16)
/// - Dokunma alanı: ≥ 48dp erişilebilir yükseklik
/// - Basıldığında [PressableScale] + sekme haptic geri bildirimi
class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? unselectedBackgroundColor;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
    this.unselectedBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final animDuration = AppMotion.duration(context, AppMotion.fast);

    return PressableScale(
      onTap: onTap,
      hapticFeedback: AppHaptics.tabChange,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Center(
          child: AnimatedContainer(
            duration: animDuration,
            curve: AppMotion.curve,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : (unselectedBackgroundColor ?? colors.surface),
              borderRadius: AppRadius.borderSm,
              border: Border.all(
                color: isSelected ? AppColors.primaryLight : colors.cardBorder,
                width: 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 15,
                    color: isSelected ? Colors.white : colors.accent,
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : colors.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
