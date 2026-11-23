import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/features/places/domain/entities/place.dart';
import 'package:mekandefterim/features/places/domain/entities/place_status.dart';
import 'package:mekandefterim/features/places/presentation/widgets/place_card.dart';
import 'package:mekandefterim/features/places/presentation/widgets/wishlist_card.dart';

void main() {
  group('Phase 3 Widgets Tests', () {
    testWidgets('PlaceCard renders place details and triggers callbacks', (tester) async {
      final place = Place(
        id: 'place-1',
        name: 'Montag Coffee',
        categoryKey: 'cafe',
        status: PlaceStatus.visited,
        latitude: 40.98,
        longitude: 29.02,
        addressLabel: 'Kadıköy, İstanbul',
        rating: 5,
        isFavorite: true,
      );

      var tapped = false;
      var favoriteTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlaceCard(
              place: place,
              onTap: () => tapped = true,
              onFavoriteTap: () => favoriteTapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Montag Coffee'), findsOneWidget);
      expect(find.text('Kafe · Kadıköy, İstanbul'), findsOneWidget);
      expect(find.text('5.0'), findsOneWidget);
      expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

      await tester.tap(find.text('Montag Coffee'));
      expect(tapped, isTrue);

      await tester.tap(find.byIcon(Icons.favorite_rounded));
      expect(favoriteTapped, isTrue);
    });

    testWidgets('WishlistCard renders note and triggers mark visited callback', (tester) async {
      final place = Place(
        id: 'place-2',
        name: 'Müze Gazhane',
        categoryKey: 'culture',
        status: PlaceStatus.planned,
        latitude: 40.99,
        longitude: 29.04,
        addressLabel: 'Kadıköy, İstanbul',
        note: 'Arkadaşımla git. Yeni sergiye birlikte bakalım.',
      );

      var marked = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WishlistCard(
              place: place,
              onTap: () {},
              onMarkVisited: () => marked = true,
            ),
          ),
        ),
      );

      expect(find.text('Müze Gazhane'), findsOneWidget);
      expect(find.text('“Arkadaşımla git. Yeni sergiye birlikte bakalım.”'), findsOneWidget);
      expect(find.text('Gezildi olarak işaretle'), findsOneWidget);

      await tester.tap(find.text('Gezildi olarak işaretle'));
      expect(marked, isTrue);
    });
  });
}
