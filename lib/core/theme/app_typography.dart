import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Mekan Defteri'm Tipografi Sistemi (Faz 9.0)
///
/// - Tüm ekran ve bölüm başlıkları serif (`Playfair Display`) ile "defter" kimliğini taşır.
/// - Gövde metinleri, etiketler ve form kontrolleri okunaklı sans-serif (`Plus Jakarta Sans`) kullanır.
abstract final class AppTypography {
  /// Üst bar (AppBar) ekran başlığı stili (tüm ekranlarda tek dil).
  static TextStyle appBarTitle(Color color) {
    return GoogleFonts.playfairDisplay(
      color: color,
      fontSize: 23,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    );
  }

  /// Sayfa içi serif başlık yardımcısı.
  static TextStyle serif({
    required Color color,
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w700,
    double? height,
    double letterSpacing = -0.3,
  }) {
    return GoogleFonts.playfairDisplay(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Verilen [AppPalette] ile uyumlu tam [TextTheme].
  static TextTheme buildTextTheme(AppPalette palette) {
    final base = GoogleFonts.plusJakartaSansTextTheme();

    return base.copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      titleLarge: GoogleFonts.playfairDisplay(
        color: palette.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 22,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        color: palette.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.plusJakartaSans(
        color: palette.textSecondary,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        color: palette.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        color: palette.textSecondary,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        color: palette.textMuted,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        color: palette.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
