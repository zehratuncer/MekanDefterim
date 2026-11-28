import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';
import 'package:mekandefterim/core/theme/app_radius.dart';
import 'package:mekandefterim/core/theme/app_typography.dart';
import 'package:mekandefterim/core/widgets/app_card.dart';
import 'package:mekandefterim/core/widgets/pressable_scale.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final colors = context.colors;
    final titleColor = isLight ? AppColors.background : colors.textPrimary;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "𝐌𝐞𝐤𝐚𝐧 𝐃𝐞𝐟𝐭𝐞𝐫𝐢'𝐦",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: titleColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: AppRadius.borderSm,
                      border: Border.all(color: colors.cardBorder),
                    ),
                    child: Text(
                      'KEŞİF GÜNLÜĞÜN',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: colors.accent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Kart Önizleme Alanı
              Expanded(
                child: AppCard(
                  radius: AppRadius.lg,
                  child: Image.asset(
                    'assets/images/onboard.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Güzel yerler sende kalsın.',
                style: AppTypography.serif(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Gezdiğin yerleri hatırla. Gitmek istediklerini biriktir. Kendi keşif haritanı oluştur.',
                style: TextStyle(
                  fontSize: 15,
                  color: colors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 18,
                    color: colors.accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hesap gerekmez. Kayıtların yalnızca bu cihazda saklanır.',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PressableScale.button(
                child: ElevatedButton(
                  onPressed: () => context.go('/places'),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Keşfetmeye başla'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
