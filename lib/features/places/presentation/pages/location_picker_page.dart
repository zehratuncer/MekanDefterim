import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/place_search_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/pressable_scale.dart';

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
  String? _selectedName;
  String? _selectedAddress;
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

  String get _currentAddressLabel =>
      _selectedAddress ??
      '${_selectedPoint.latitude.toStringAsFixed(4)}, ${_selectedPoint.longitude.toStringAsFixed(4)}';

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
    setState(() {
      _selectedPoint = LatLng(result.latitude, result.longitude);
      _selectedName = result.name;
      _selectedAddress = result.addressLabel;
      _remoteResults = const [];
      _isSearchingRemote = false;
    });
    _mapController.move(_selectedPoint, 16.0);
  }

  void _confirmSelection() {
    AppHaptics.check();
    Navigator.of(context).pop(
      PickedLocation(
        latitude: _selectedPoint.latitude,
        longitude: _selectedPoint.longitude,
        addressLabel: _currentAddressLabel,
        name: _selectedName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                AppHaptics.tap();
                setState(() {
                  _selectedPoint = point;
                  _selectedName = null;
                  _selectedAddress = null;
                  _remoteResults = const [];
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.zehratuncer.mekandefterim',
                tileProvider: widget.tileProvider,
                keepBuffer: 4,
                panBuffer: 1,
                maxNativeZoom: 19,
                tileDisplay: const TileDisplay.fadeIn(
                  duration: Duration(milliseconds: 150),
                ),
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
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.96),
                    borderRadius: AppRadius.borderLg,
                    border: Border.all(color: colors.cardBorder),
                    boxShadow: colors.cardShadow,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: TextStyle(color: colors.textPrimary, fontSize: 14),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: 'Bir mekân ya da semt ara',
                      hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
                      prefixIcon:
                          Icon(Icons.search_rounded, color: colors.textMuted),
                      suffixIcon: _isSearchingRemote
                          ? Padding(
                              padding: const EdgeInsets.all(14),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.accent,
                                ),
                              ),
                            )
                          : _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: colors.textMuted,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                if (_remoteResults.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 260),
                    decoration: BoxDecoration(
                      color: colors.surface.withValues(alpha: 0.97),
                      borderRadius: AppRadius.borderMd,
                      border: Border.all(color: colors.cardBorder),
                      boxShadow: colors.cardShadow,
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      itemCount: _remoteResults.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: colors.divider,
                        indent: 44,
                      ),
                      itemBuilder: (context, index) {
                        final item = _remoteResults[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: colors.accent,
                            size: 20,
                          ),
                          title: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            item.addressLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.textMuted,
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
          // Alt Konum Onay Kartı
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: AppCard(
                radius: AppRadius.md,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          color: colors.accent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _selectedName ?? _currentAddressLabel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_selectedName != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        _currentAddressLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: colors.textMuted, fontSize: 12),
                      ),
                    ],
                    const SizedBox(height: 12),
                    PressableScale.button(
                      enableHaptic: false,
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
          ),
        ],
      ),
    );
  }
}
