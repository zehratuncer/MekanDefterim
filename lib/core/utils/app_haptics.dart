import 'package:flutter/services.dart';

/// Mekan Defteri'm Haptic Geri Bildirim Yardımcısı (Faz 9.0)
///
/// Kalp, tik, kaydet, sekme değişimi, dokunuş ve uzun basma aksiyonları için
/// tek merkezden dokunsal geri bildirim sağlar.
abstract final class AppHaptics {
  /// Genel hafif dokunuş (kart/çip basımı).
  static Future<void> tap() => HapticFeedback.selectionClick();

  /// Alt navigasyon ve filtre sekmesi değişimi.
  static Future<void> tabChange() => HapticFeedback.selectionClick();

  /// Favori (kalp) açma/kapatma.
  static Future<void> favorite() => HapticFeedback.lightImpact();

  /// "Gezildi" (tik) olarak işaretleme.
  static Future<void> check() => HapticFeedback.mediumImpact();

  /// Mekân kaydetme / güncelleme onayı.
  static Future<void> save() => HapticFeedback.mediumImpact();

  /// Haritada veya listede uzun basma.
  static Future<void> longPress() => HapticFeedback.heavyImpact();
}
