import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/theme/app_colors.dart';

class PickedLocation {
  final double latitude;
  final double longitude;
  final String addressLabel;
  final String? name;

  const PickedLocation({
    required this.latitude,
    required this.longitude,
    required this.addressLabel,
    this.name,
  });
}

class LocationPickerPage extends ConsumerStatefulWidget {
  final double initialLatitude;
  final double initialLongitude;
  final TileProvider? tileProvider;

  const LocationPickerPage({
    super.key,
    this.initialLatitude = 40.9876,
    this.initialLongitude = 29.0234,
    this.tileProvider,
  });

  @override
  ConsumerState<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends ConsumerState<LocationPickerPage> {
  final MapController _mapController = MapController();
  late LatLng _selectedPoint;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _selectedPoint = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    final result = await ref.read(locationServiceProvider).getCurrentLocation();

    if (!mounted) return;
    setState(() => _isLocating = false);

    if (result.isSuccess) {
      final point = LatLng(result.latitude!, result.longitude!);
      setState(() => _selectedPoint = point);
      _mapController.move(point, 15.5);
    } else if (result.message != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.surface,
          content: Text(
            result.message!,
            style: const TextStyle(color: AppColors.textPrimary),
          ),
        ),
      );
    }
  }

  void _confirmSelection() {
    final label =
        '${_selectedPoint.latitude.toStringAsFixed(4)}, ${_selectedPoint.longitude.toStringAsFixed(4)}';
    Navigator.of(context).pop(
      PickedLocation(
        latitude: _selectedPoint.latitude,
        longitude: _selectedPoint.longitude,
        addressLabel: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum seç'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '1 / 2',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textMuted.withAlpha(200),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedPoint,
              initialZoom: 14.5,
              minZoom: 3,
              maxZoom: 19,
              onTap: (_, point) {
                setState(() => _selectedPoint = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zehratuncer.mekandefterim',
                tileProvider: widget.tileProvider,
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPoint,
                    width: 48,
                    height: 48,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                      Icons.location_pin,
                      color: AppColors.accent,
                      size: 46,
                    ),
                  ),
                ],
              ),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution('OpenStreetMap katkıda bulunanları'),
                ],
              ),
            ],
          ),
          // Üst Bilgi Bandı
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface.withAlpha(235),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_rounded, color: AppColors.accent, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Mekânı işaretlemek için haritada bir noktaya dokun.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Konumum Butonu
          Positioned(
            right: 16,
            bottom: 136,
            child: FloatingActionButton.small(
              heroTag: 'picker_my_location',
              tooltip: 'Konumum',
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.textPrimary,
              onPressed: _isLocating ? null : _goToMyLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.accent,
                      ),
                    )
                  : const Icon(Icons.my_location_rounded),
            ),
          ),
          // Alt Onay Kartı
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(90),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_selectedPoint.latitude.toStringAsFixed(5)}, ${_selectedPoint.longitude.toStringAsFixed(5)}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _confirmSelection,
                      icon: const Icon(Icons.check_rounded, size: 20),
                      label: const Text('Bu konumu seç'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
