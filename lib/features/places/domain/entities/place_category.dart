import 'package:flutter/material.dart';

/// Mekân kategorileri tanımı ve sabitleri.
enum PlaceCategory {
  cafe('cafe', 'Kafe', Icons.coffee_rounded),
  restaurant('restaurant', 'Restoran', Icons.restaurant_rounded),
  bookstore('bookstore', 'Kitapçı', Icons.menu_book_rounded),
  nature('nature', 'Doğa / Park', Icons.park_rounded),
  culture('culture', 'Müze / Kültür', Icons.museum_rounded),
  shopping('shopping', 'Alışveriş', Icons.shopping_bag_rounded),
  seaside('seaside', 'Sahil / Manzara', Icons.waves_rounded),
  other('other', 'Diğer', Icons.place_rounded);

  final String key;
  final String label;
  final IconData icon;

  const PlaceCategory(this.key, this.label, this.icon);

  static PlaceCategory fromKey(String key) {
    return PlaceCategory.values.firstWhere(
      (c) => c.key == key,
      orElse: () => PlaceCategory.other,
    );
  }
}
