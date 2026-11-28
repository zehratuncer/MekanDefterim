import 'package:flutter/material.dart';

/// Mekan Defteri'm Tasarım Sistemi — Animasyon Standartları (Faz 9.0)
///
/// Standart süre: 200–300 ms, [Curves.easeOutCubic].
/// Yaylanma efektleri için [spring] / [springCurve].
/// Erişilebilirlik ("Animasyonları azalt") ayarına otomatik uyum sağlar.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration staggerStep = Duration(milliseconds: 45);

  static const Curve curve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve springCurve = Curves.easeOutBack;

  static const SpringDescription spring = SpringDescription(
    mass: 1.0,
    stiffness: 320.0,
    damping: 22.0,
  );

  /// Dokunulabilir kart ve butonlarda basılma ölçeği.
  static const double pressScale = 0.96;

  /// İşletim sisteminde "Animasyonları azalt" açık mı kontrol eder.
  static bool isReducedMotion(BuildContext context) {
    return MediaQuery.maybeDisableAnimationsOf(context) ?? false;
  }

  /// Erişilebilirlik ayarına göre animasyon süresini döndürür.
  static Duration duration(BuildContext context, [Duration base = normal]) {
    return isReducedMotion(context) ? Duration.zero : base;
  }
}
