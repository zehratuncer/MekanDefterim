import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/place_search_service.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final PlaceSearchService _searchService = PlaceSearchService();

  Timer? _searchDebounce;
  late LatLng _selectedPoint;
  String _searchQuery = '';
  List<PlaceSearchResult> _remoteResults = const [];
  bool _isSearchingRemote = false;

  @override
  void initState() {
    super.initState();
    _selectedPoint = LatLng(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
      if (value.trim().length < 2) {
        _remoteResults = const [];
        _isSearchingRemote = false;
      }
    });

    _searchDebounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.length < 2) return;

    _searchDebounce = Timer(const Duration(milliseconds: 450), () async {
      if (!mounted) return;
      setState(() => _isSearchingRemote = true);
      final results = await _searchService.search(trimmed);
      if (!mounted || _searchController.text.trim() != trimmed) return;
      setState(() {
        _remoteResults = results;
        _isSearchingRemote = false;
      });
    });
  }

  void _selectRemoteResult(PlaceSearchResult result) {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop(
      PickedLocation(
        latitude: result.latitude,
        longitude: result.longitude,
        addressLabel: result.addressLabel,
        name: result.name,
      ),
    );
  }

  void _selectPointOnMap(LatLng point) {
    final label =
        '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
    Navigator.of(context).pop(
      PickedLocation(
        latitude: point.latitude,
        longitude: point.longitude,
        addressLabel: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konum seç'),
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
                setState(() {
                  _selectedPoint = point;
                  _remoteResults = const [];
                });
                _selectPointOnMap(point);
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
            ],
          ),
          // Arama Çubuğu ve Sonuç Listesi
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface.withAlpha(240),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Bir mekân ya da semt ara',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                      suffixIcon: _isSearchingRemote
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.accent,
                                ),
                              ),
                            )
                          : _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.textMuted,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchDebounce?.cancel();
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                      _remoteResults = const [];
                                      _isSearchingRemote = false;
                                    });
                                  },
                                )
                              : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                if (_remoteResults.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 260),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withAlpha(248),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(90),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: _remoteResults.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        color: AppColors.divider,
                        indent: 44,
                      ),
                      itemBuilder: (context, index) {
                        final item = _remoteResults[index];
                        return ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            item.addressLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () => _selectRemoteResult(item),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
