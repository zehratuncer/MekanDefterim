import 'package:flutter/material.dart';

/// Mekan Defteri'm Renk Paleti
///
/// Tasarım Kılavuzu:
/// - Arka plan: #3C000B tonları (Derin bordo/şarap rengi sıcak tonlar)
/// - Aksiyon butonları: Zümrüt / Orman yeşili (#1E4D40 / #224E41)
/// - Yüzey ve yumuşak kartlar: Arka planla uyumlu tonlar
class AppColors {
  // Arka Plan Tonları (#3C000B tabanlı)
  static const Color background = Color(0xFF3C000B);
  static const Color backgroundLight = Color(0xFF4C0815);
  static const Color backgroundDark = Color(0xFF2C0007);

  // Yüzey ve Kart Renkleri
  static const Color surface = Color(0xFF4A0E1A);
  static const Color surfaceVariant = Color(0xFF581523);
  static const Color card = Color(0xFF4A0E1A);
  static const Color cardBorder = Color(0xFF6B2030);

  // Zümrüt & Orman Yeşili Aksiyon Renkleri
  static const Color primary = Color(0xFF1E4D40);
  static const Color primaryLight = Color(0xFF2B6656);
  static const Color primaryDark = Color(0xFF14382E);
  static const Color emerald = Color(0xFF224E41);
  static const Color onPrimary = Colors.white;

  // İkincil & Vurgu Renkleri
  static const Color accent = Color(0xFFE2B072); // Sıcak altın / bej vurgu
  static const Color secondary = Color(0xFFD49A89);

  // Metin Renkleri
  static const Color textPrimary = Color(0xFFFDFBF7);
  static const Color textSecondary = Color(0xFFE0D0CE);
  static const Color textMuted = Color(0xFFB39B9B);

  // Durum Renkleri
  static const Color visitedBadge = Color(0xFF224E41); // Gezildi rozeti
  static const Color visitedText = Color(0xFF8CE0C8);
  static const Color wishlistBadge = Color(0xFF7A2033); // İstek rozeti
  static const Color wishlistText = Color(0xFFFFB4AB);

  static const Color starRating = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF5449);
  static const Color divider = Color(0xFF601A29);
}
