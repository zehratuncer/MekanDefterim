import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mekandefterim/core/services/location_service.dart';
import 'package:mekandefterim/features/places/domain/entities/place.dart';
import 'package:mekandefterim/features/places/domain/entities/place_status.dart';
import 'package:mekandefterim/features/places/presentation/controllers/places_list_controller.dart';
import 'package:mekandefterim/features/places/presentation/pages/location_picker_page.dart';
import 'package:mekandefterim/features/places/presentation/pages/places_map_page.dart';
import 'package:mekandefterim/features/places/presentation/widgets/place_map_marker.dart';

/// 1x1 şeffaf PNG (testlerde ağ isteği yapmadan harita çizimi için)
final Uint8List _transparentPng = Uint8List.fromList(const <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A,
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
  0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
  0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

class _FakeTileProvider extends TileProvider {
  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    return MemoryImage(_transparentPng);
  }
}

class _FakeLocationService implements LocationService {
  final LocationResult result;
  _FakeLocationService(this.result);

  @override
  Future<LocationResult> getCurrentLocation() async => result;
}

void main() {
  final samplePlaces = [
    Place(
      id: 'p1',
      name: 'Montag Coffee',
      categoryKey: 'cafe',
      status: PlaceStatus.visited,
      latitude: 40.9876,
      longitude: 29.0234,
      addressLabel: 'Caferağa, Kadıköy',
      rating: 5,
    ),
    Place(
      id: 'p2',
      name: 'Moda Sahil',
      categoryKey: 'nature',
      status: PlaceStatus.planned,
      latitude: 40.9840,
      longitude: 29.0260,
      addressLabel: 'Moda, Kadıköy',
    ),
  ];

  testWidgets('PlacesMapPage shows markers for visited and planned places and filters them',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allPlacesStreamProvider.overrideWith((ref) => Stream.value(samplePlaces)),
          locationServiceProvider.overrideWithValue(
            _FakeLocationService(LocationResult.permissionDenied()),
          ),
        ],
        child: MaterialApp(
          home: PlacesMapPage(tileProvider: _FakeTileProvider()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FlutterMap), findsOneWidget);
    expect(find.byType(PlaceMapMarker), findsNWidgets(2));
    expect(find.byType(RichAttributionWidget), findsOneWidget);

    // Sadece Gezildi filtresi
    await tester.tap(find.text('✓ Gezildi'));
    await tester.pumpAndSettle();
    expect(find.byType(PlaceMapMarker), findsOneWidget);

    // Sadece İstekler filtresi
    await tester.tap(find.text('♡ İstekler'));
    await tester.pumpAndSettle();
    expect(find.byType(PlaceMapMarker), findsOneWidget);

    // Tümü filtresi
    await tester.tap(find.text('Tümü (2)'));
    await tester.pumpAndSettle();
    expect(find.byType(PlaceMapMarker), findsNWidgets(2));
  });

  testWidgets('PlacesMapPage handles denied location permission gracefully without crashing',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allPlacesStreamProvider.overrideWith((ref) => Stream.value(samplePlaces)),
          locationServiceProvider.overrideWithValue(
            _FakeLocationService(LocationResult.permissionDenied()),
          ),
        ],
        child: MaterialApp(
          home: PlacesMapPage(tileProvider: _FakeTileProvider()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Konumum'));
    await tester.pumpAndSettle();

    expect(
      find.text('Konum izni verilmedi. Haritada istediğin noktayı elle seçebilirsin.'),
      findsOneWidget,
    );
  });

  testWidgets('LocationPickerPage returns selected coordinates on confirm', (tester) async {
    PickedLocation? result;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          locationServiceProvider.overrideWithValue(
            _FakeLocationService(LocationResult.success(latitude: 41.0, longitude: 29.0)),
          ),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  result = await Navigator.of(context).push<PickedLocation>(
                    MaterialPageRoute(
                      builder: (_) => LocationPickerPage(
                        initialLatitude: 40.9900,
                        initialLongitude: 29.0300,
                        tileProvider: _FakeTileProvider(),
                      ),
                    ),
                  );
                },
                child: const Text('Aç'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Aç'));
    await tester.pumpAndSettle();

    expect(find.text('Konum seç'), findsOneWidget);
    expect(find.text('Bu konumu seç'), findsOneWidget);

    await tester.tap(find.text('Bu konumu seç'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.latitude, closeTo(40.9900, 0.0001));
    expect(result!.longitude, closeTo(29.0300, 0.0001));
  });
}
