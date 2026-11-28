import 'package:flutter/material.dart';

/// Mekan Defteri'm Renk Tokenları (Faz 9.0)
///
/// Tasarım Kılavuzu:
/// - Arka plan: #3C000B tonları (Derin bordo/şarap rengi sıcak tonlar)
/// - Altın vurgu: #E8B27A
/// - Aksiyon butonları: Canlı ve doygun zümrüt yeşili (#1F6E58)
/// - Erişilebilirlik: İkincil ve soluk metinler WCAG AA (≥ 4.5:1) uyumlu
abstract final class AppColors {
  // Bordo Zemin Tonları (#3C000B tabanlı)
  static const Color background = Color(0xFF3C000B);
  static const Color backgroundLight = Color(0xFF4C0815);
  static const Color backgroundDark = Color(0xFF280006);

  // Yüzey ve Kart Renkleri (üstten alta hafif gradient destekli)
  static const Color surface = Color(0xFF4D101D);
  static const Color surfaceGradientEnd = Color(0xFF420B17);
  static const Color surfaceVariant = Color(0xFF5D1726);
  static const Color card = Color(0xFF4D101D);
  static const Color cardBorder = Color(0xFF702334);
  static const Color cardHighlight = Color(0x26FFF5EE);

  // Doygun & Parlak Zümrüt Yeşili Aksiyon Renkleri (WCAG AA beyaz metin uyumlu)
  static const Color primary = Color(0xFF1F6E58);
  static const Color primaryLight = Color(0xFF2D8C71);
  static const Color primaryDark = Color(0xFF165241);
  static const Color emerald = Color(0xFF247A62);
  static const Color onPrimary = Colors.white;

  // İkincil & Altın Vurgu Renkleri (#E8B27A)
  static const Color accent = Color(0xFFE8B27A);
  static const Color secondary = Color(0xFFD99E8C);

  // Metin Renkleri (WCAG AA ≥ 4.5:1 kontrast)
  static const Color textPrimary = Color(0xFFFDFBF7);
  static const Color textSecondary = Color(0xFFEDE0DD);
  static const Color textMuted = Color(0xFFCBB4B1);

  // Durum Rozet Renkleri
  static const Color visitedBadge = Color(0xFF1D5C4A);
  static const Color visitedText = Color(0xFF9BF0D6);
  static const Color wishlistBadge = Color(0xFF7A2033);
  static const Color wishlistText = Color(0xFFFFC2BA);

  static const Color starRating = Color(0xFFFFB800);
  static const Color error = Color(0xFFFF5449);
  static const Color divider = Color(0xFF631B2A);
}

/// Temaya duyarlı renk paleti (Koyu & Açık tema).
class AppPalette extends ThemeExtension<AppPalette> {
  final Color background;
  final Color navBarBackground;
  final Color surface;
  final Color surfaceGradientEnd;
  final Color surfaceVariant;
  final Color cardBorder;
  final Color cardHighlight;
  final Color shadowColor;
  final Color paperGrain;
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
    required this.surfaceGradientEnd,
    required this.surfaceVariant,
    required this.cardBorder,
    required this.cardHighlight,
    required this.shadowColor,
    required this.paperGrain,
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

  LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [surface, surfaceGradientEnd],
      );

  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: shadowColor,
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ];

  static const AppPalette dark = AppPalette(
    background: AppColors.background,
    navBarBackground: AppColors.backgroundDark,
    surface: AppColors.surface,
    surfaceGradientEnd: AppColors.surfaceGradientEnd,
    surfaceVariant: AppColors.surfaceVariant,
    cardBorder: AppColors.cardBorder,
    cardHighlight: AppColors.cardHighlight,
    shadowColor: Color(0x47000000),
    paperGrain: Color(0x09FFF6EE),
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
    surfaceGradientEnd: Color(0xFFFAF6EF),
    surfaceVariant: Color(0xFFF1ECE4),
    cardBorder: Color(0xFFE3DBD0),
    cardHighlight: Color(0xE6FFFFFF),
    shadowColor: Color(0x14241911),
    paperGrain: Color(0x074A3828),
    divider: Color(0xFFE5DDD2),
    textPrimary: Color(0xFF1F1A17),
    textSecondary: Color(0xFF453D37),
    textMuted: Color(0xFF5E554E),
    accent: Color(0xFF9A6222),
    visitedBadge: Color(0xFFDDF3EB),
    visitedText: Color(0xFF165241),
    wishlistBadge: Color(0xFFF9E5EA),
    wishlistText: Color(0xFF7A2033),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? navBarBackground,
    Color? surface,
    Color? surfaceGradientEnd,
    Color? surfaceVariant,
    Color? cardBorder,
    Color? cardHighlight,
    Color? shadowColor,
    Color? paperGrain,
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
      surfaceGradientEnd: surfaceGradientEnd ?? this.surfaceGradientEnd,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      cardBorder: cardBorder ?? this.cardBorder,
      cardHighlight: cardHighlight ?? this.cardHighlight,
      shadowColor: shadowColor ?? this.shadowColor,
      paperGrain: paperGrain ?? this.paperGrain,
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
      surfaceGradientEnd: Color.lerp(surfaceGradientEnd, other.surfaceGradientEnd, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      cardHighlight: Color.lerp(cardHighlight, other.cardHighlight, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      paperGrain: Color.lerp(paperGrain, other.paperGrain, t)!,
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
