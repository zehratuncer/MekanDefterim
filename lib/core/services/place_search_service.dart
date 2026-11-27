import 'dart:convert';
import 'dart:io';

/// OpenStreetMap (Nominatim) üzerinden dönen canlı arama sonucu.
class PlaceSearchResult {
  final String name;
  final String addressLabel;
  final double latitude;
  final double longitude;

  const PlaceSearchResult({
    required this.name,
    required this.addressLabel,
    required this.latitude,
    required this.longitude,
  });
}

/// Türkiye geneli ücretsiz OpenStreetMap (Nominatim) mekân/adres arama servisi.
class PlaceSearchService {
  static const _userAgent = 'MekanDefterim/1.0 (com.zehratuncer.mekandefterim)';

  Future<List<PlaceSearchResult>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];

    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'q': trimmed,
      'format': 'jsonv2',
      'addressdetails': '1',
      'countrycodes': 'tr',
      'limit': '6',
      'accept-language': 'tr',
    });

    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, _userAgent);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();
      if (response.statusCode != 200) return const [];

      final body = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(body);
      if (decoded is! List) return const [];

      final results = <PlaceSearchResult>[];
      for (final item in decoded) {
        if (item is! Map<String, dynamic>) continue;
        final lat = double.tryParse('${item['lat']}');
        final lon = double.tryParse('${item['lon']}');
        if (lat == null || lon == null) continue;

        final displayName = (item['display_name'] as String?) ?? '';
        final rawName = (item['name'] as String?)?.trim();
        final name = (rawName != null && rawName.isNotEmpty)
            ? rawName
            : displayName.split(',').first.trim();
        if (name.isEmpty) continue;

        final address = item['address'];
        final addressLabel = _formatAddress(address is Map<String, dynamic> ? address : null, displayName);

        results.add(
          PlaceSearchResult(
            name: name,
            addressLabel: addressLabel,
            latitude: lat,
            longitude: lon,
          ),
        );
      }
      return results;
    } catch (_) {
      return const [];
    } finally {
      client.close(force: true);
    }
  }

  String _formatAddress(Map<String, dynamic>? address, String fallback) {
    if (address == null) return fallback;

    final parts = <String>[];
    void addIfPresent(List<String> keys) {
      for (final key in keys) {
        final val = (address[key] as String?)?.trim();
        if (val != null && val.isNotEmpty && !parts.contains(val)) {
          parts.add(val);
          return;
        }
      }
    }

    addIfPresent(['neighbourhood', 'suburb', 'quarter']);
    addIfPresent(['town', 'county', 'city_district', 'district']);
    addIfPresent(['city', 'province', 'state']);

    if (parts.isEmpty) {
      final segments = fallback.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      return segments.length > 1 ? segments.skip(1).take(2).join(', ') : fallback;
    }
    return parts.join(', ');
  }
}
