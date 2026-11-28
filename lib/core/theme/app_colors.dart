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

/// Temaya duyarlı renk paleti (Koyu & Açık tema).
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color navBarBackground;
  final Color surface;
  final Color surfaceVariant;
  final Color cardBorder;
  final Color divider;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color visitedBadge;
  final Color visitedText;
  final Color wishlistBadge;
  final Color wishlistText;

  const AppPalette({
    required this.background,
    required this.navBarBackground,
    required this.surface,
    required this.surfaceVariant,
    required this.cardBorder,
    required this.divider,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.visitedBadge,
    required this.visitedText,
    required this.wishlistBadge,
    required this.wishlistText,
  });

  static const AppPalette dark = AppPalette(
    background: AppColors.background,
    navBarBackground: AppColors.backgroundDark,
    surface: AppColors.surface,
    surfaceVariant: AppColors.surfaceVariant,
    cardBorder: AppColors.cardBorder,
    divider: AppColors.divider,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textMuted: AppColors.textMuted,
    accent: AppColors.accent,
    visitedBadge: AppColors.visitedBadge,
    visitedText: AppColors.visitedText,
    wishlistBadge: AppColors.wishlistBadge,
    wishlistText: AppColors.wishlistText,
  );

  static const AppPalette light = AppPalette(
    background: Color(0xFFF9F6F0),
    navBarBackground: Color(0xFFFFFFFF),
    surface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFFF1ECE4),
    cardBorder: Color(0xFFE7E0D6),
    divider: Color(0xFFE7E0D6),
    textPrimary: Color(0xFF1F1A17),
    textSecondary: Color(0xFF4A423C),
    textMuted: Color(0xFF736A63),
    accent: Color(0xFFB87D3B),
    visitedBadge: Color(0xFFE2F2EC),
    visitedText: Color(0xFF1B4D3E),
    wishlistBadge: Color(0xFFF8E6EA),
    wishlistText: Color(0xFF7A2033),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? navBarBackground,
    Color? surface,
    Color? surfaceVariant,
    Color? cardBorder,
    Color? divider,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? accent,
    Color? visitedBadge,
    Color? visitedText,
    Color? wishlistBadge,
    Color? wishlistText,
  }) {
    return AppPalette(
      background: background ?? this.background,
      navBarBackground: navBarBackground ?? this.navBarBackground,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      cardBorder: cardBorder ?? this.cardBorder,
      divider: divider ?? this.divider,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      accent: accent ?? this.accent,
      visitedBadge: visitedBadge ?? this.visitedBadge,
      visitedText: visitedText ?? this.visitedText,
      wishlistBadge: wishlistBadge ?? this.wishlistBadge,
      wishlistText: wishlistText ?? this.wishlistText,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      navBarBackground: Color.lerp(navBarBackground, other.navBarBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      visitedBadge: Color.lerp(visitedBadge, other.visitedBadge, t)!,
      visitedText: Color.lerp(visitedText, other.visitedText, t)!,
      wishlistBadge: Color.lerp(wishlistBadge, other.wishlistBadge, t)!,
      wishlistText: Color.lerp(wishlistText, other.wishlistText, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get colors => Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;
}
