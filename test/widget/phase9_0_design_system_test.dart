import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/core/theme/app_colors.dart';
import 'package:mekandefterim/core/theme/app_motion.dart';
import 'package:mekandefterim/core/theme/app_radius.dart';
import 'package:mekandefterim/core/theme/app_theme.dart';
import 'package:mekandefterim/core/widgets/app_card.dart';
import 'package:mekandefterim/core/widgets/app_chip.dart';
import 'package:mekandefterim/core/widgets/paper_grain_background.dart';
import 'package:mekandefterim/core/widgets/pressable_scale.dart';
import 'package:mekandefterim/core/widgets/shimmer_card.dart';
import 'package:mekandefterim/core/widgets/staggered_list.dart';
import 'package:mekandefterim/features/places/presentation/controllers/places_list_controller.dart';
import 'package:mekandefterim/features/places/presentation/pages/place_detail_page.dart';
import 'package:mekandefterim/features/places/presentation/pages/place_form_page.dart';

double _contrastRatio(Color fg, Color bg) {
  final l1 = fg.computeLuminance();
  final l2 = bg.computeLuminance();
  final lighter = math.max(l1, l2);
  final darker = math.min(l1, l2);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  group('Faz 9.0 Tasarım Sistemi Temel Testleri', () {
    test('Renk tokenları ve ikincil/placeholder metinler WCAG AA (>= 4.5:1) kontrastını sağlar', () {
      expect(AppColors.accent, const Color(0xFFE8B27A));

      // Koyu tema kontrastları
      const dark = AppPalette.dark;
      expect(_contrastRatio(dark.textPrimary, dark.background), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(dark.textSecondary, dark.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(dark.textMuted, dark.background), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(dark.textMuted, dark.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(dark.textMuted, dark.surfaceVariant), greaterThanOrEqualTo(4.5));

      // Açık tema kontrastları
      const light = AppPalette.light;
      expect(_contrastRatio(light.textPrimary, light.background), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(light.textSecondary, light.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(light.textMuted, light.background), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(light.textMuted, light.surface), greaterThanOrEqualTo(4.5));
      expect(_contrastRatio(light.textMuted, light.surfaceVariant), greaterThanOrEqualTo(4.5));

      // Zümrüt buton üzeri beyaz metin kontrastı
      expect(_contrastRatio(AppColors.onPrimary, AppColors.primary), greaterThanOrEqualTo(4.5));
    });

    test('Köşe yarıçapı standartları 16 / 20 / 28 tokenlarını korur', () {
      expect(AppRadius.sm, 16.0);
      expect(AppRadius.md, 20.0);
      expect(AppRadius.lg, 28.0);
    });

    testWidgets('PressableScale basılınca 0.96 ölçeğine iner ve reduceMotion açıkken animasyonu atlar',
        (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: Scaffold(
            body: Center(
              child: PressableScale(
                onTap: () => tapped = true,
                child: const SizedBox(
                  width: 120,
                  height: 60,
                  child: Text('Dokun'),
                ),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(tester.getCenter(find.text('Dokun')));
      await tester.pump(AppMotion.fast);

      final scaleWidget = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(scaleWidget.scale, AppMotion.pressScale);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(tapped, isTrue);

      // Animasyonları azalt açıkken ölçek 1.0 kalmalı
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: PressableScale(
                  onTap: () {},
                  child: const SizedBox(
                    width: 120,
                    height: 60,
                    child: Text('Azaltılmış'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      final reducedGesture =
          await tester.startGesture(tester.getCenter(find.text('Azaltılmış')));
      await tester.pump();
      final reducedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(reducedScale.scale, 1.0);
      await reducedGesture.up();
    });

    testWidgets('AppCard, AppChip (>=48dp), StaggeredList, ShimmerCard ve PaperGrain açık/koyu temada çizilir',
        (tester) async {
      for (final theme in [AppTheme.darkTheme, AppTheme.lightTheme]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: MediaQuery(
              data: const MediaQueryData(disableAnimations: true),
              child: PaperGrainOverlay(
                child: Scaffold(
                  body: Column(
                    children: [
                      AppCard(
                        padding: const EdgeInsets.all(16),
                        onTap: () {},
                        child: const Text('Kart İçeriği'),
                      ),
                      AppChip(
                        label: 'Kafe',
                        isSelected: true,
                        onTap: () {},
                      ),
                      const ShimmerCard(),
                      Expanded(
                        child: StaggeredList(
                          itemCount: 2,
                          itemBuilder: (_, idx) => Text('Öğe $idx'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pump();

        expect(find.text('Kart İçeriği'), findsOneWidget);
        expect(find.text('Kafe'), findsOneWidget);
        expect(find.text('Öğe 0'), findsOneWidget);

        // AppChip dokunma yüksekliği en az 48dp olmalı
        final chipSize = tester.getSize(find.byType(AppChip));
        expect(chipSize.height, greaterThanOrEqualTo(48.0));
      }
    });

    testWidgets('Yeni Mekân ve Mekân detayı ekran başlıkları serif tipografi kullanır',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: AppTheme.darkTheme,
            home: const PlaceFormPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Yeni Mekân'), findsOneWidget);
      final appBarTheme = AppTheme.darkTheme.appBarTheme;
      expect(appBarTheme.titleTextStyle?.fontFamily, contains('PlayfairDisplay'));

      await tester.pumpWidget(
        ProviderScope(
          key: UniqueKey(),
          overrides: [
            placeDetailProvider('missing').overrideWith((_) async => null),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            home: const PlaceDetailPage(placeId: 'missing'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mekân detayı'), findsOneWidget);
      expect(
        AppTheme.lightTheme.appBarTheme.titleTextStyle?.fontFamily,
        contains('PlayfairDisplay'),
      );
    });
  });
}
