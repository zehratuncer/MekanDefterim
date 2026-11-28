import 'package:flutter/material.dart';

/// Mekan Defteri'm Tasarım Sistemi — Köşe Yarıçapı Standartları (Faz 9.0)
///
/// Uygulama genelinde yalnızca 16 / 20 / 28 yarıçap tokenları kullanılır:
/// - [sm] (16): Butonlar, metin alanları, filtre çipleri, küçük görsel kutuları.
/// - [md] (20): Standart kartlar (`AppCard`, `PlaceCard`, `WishlistCard`).
/// - [lg] (28): Büyük vitrin alanları, arama barları, diyaloglar ve alt paneller.
abstract final class AppRadius {
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 28.0;

  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));

  static const BorderRadius sheetTop = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
