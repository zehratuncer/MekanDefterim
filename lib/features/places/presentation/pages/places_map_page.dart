import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/services/place_search_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/utils/app_haptics.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../domain/entities/place.dart';
import '../../domain/entities/place_category.dart';
import '../../domain/entities/place_status.dart';
import '../controllers/places_list_controller.dart';
import '../widgets/place_map_marker.dart';
import 'location_picker_page.dart';

class PlacesMapPage extends ConsumerStatefulWidget {
  final double? initialLat;
  final double? initialLng;
  final TileProvider? tileProvider;

  const PlacesMapPage({
    super.key,
    this.initialLat,
    this.initialLng,
    this.tileProvider,
  });

  @override
  ConsumerState<PlacesMapPage> createState() => _PlacesMapPageState();
}

class _PlacesMapPageState extends ConsumerState<PlacesMapPage> {
  static const _defaultCenter = LatLng(40.9876, 29.0234); // Kadıköy, İstanbul
  static const _defaultZoom = 13.5;

  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final PlaceSearchService _searchService = PlaceSearchService();

  Timer? _searchDebounce;
  PlaceStatus? _statusFilter;
  String _searchQuery = '';
  Place? _selectedPlace;
  PlaceSearchResult? _selectedSearchResult;
  List<PlaceSearchResult> _remoteResults = const [];
  bool _isSearchingRemote = false;
  LatLng? _userLocation;
  bool _isLocating = false;

  LatLng get _initialCenter {
    if (widget.initialLat != null && widget.initialLng != null) {
      return LatLng(widget.initialLat!, widget.initialLng!);
    }
    return _defaultCenter;
  }

  @override
  void didUpdateWidget(covariant PlacesMapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialLat != null &&
        widget.initialLng != null &&
        (widget.initialLat != oldWidget.initialLat ||
            widget.initialLng != oldWidget.initialLng)) {
      _mapController.move(LatLng(widget.initialLat!, widget.initialLng!), 15.5);
    }
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
    setState(() {
      _selectedSearchResult = result;
      _selectedPlace = null;
      _remoteResults = const [];
      _isSearchingRemote = false;
    });
    _mapController.move(LatLng(result.latitude, result.longitude), 16.0);
  }

  Future<void> _goToMyLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    final result = await ref.read(locationServiceProvider).getCurrentLocation();

    if (!mounted) return;
    setState(() => _isLocating = false);

    if (result.isSuccess) {
      final point = LatLng(result.latitude!, result.longitude!);
      setState(() => _userLocation = point);
      _mapController.move(point, 15.0);
    } else if (result.message != null) {
      final colors = context.colors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.message!,
            style: TextStyle(color: colors.textPrimary),
          ),
        ),
      );
    }
  }

  List<Place> _applyFilters(List<Place> places) {
    final q = _searchQuery.trim().toLowerCase();
    return places.where((p) {
      if (_statusFilter != null && p.status != _statusFilter) {
        return false;
      }
      if (q.isNotEmpty) {
        final inName = p.name.toLowerCase().contains(q);
        final inAddress = (p.addressLabel ?? '').toLowerCase().contains(q);
        if (!inName && !inAddress) return false;
      }
      return true;
    }).toList();
  }

  void _openNewPlaceAt(LatLng point) {
    AppHaptics.longPress();
    final picked = PickedLocation(
      latitude: point.latitude,
      longitude: point.longitude,
      addressLabel:
          '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
    );
    context.push('/places/new', extra: picked);
  }

  @override
  Widget build(BuildContext context) {
    final placesAsync = ref.watch(allPlacesStreamProvider);
    final places = placesAsync.asData?.value ?? const <Place>[];
    final filteredPlaces = _applyFilters(places);
    final colors = context.colors;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Diğer ekranlarla tek üst bar dili: düz kenar, serif başlık, temaya duyarlı yüzey
      appBar: AppBar(
        backgroundColor: colors.background.withValues(alpha: 0.94),
        title: const Text("Mekan Defteri'm"),
        actions: [
          IconButton(
            tooltip: 'Ayarlar',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: widget.initialLat != null ? 15.5 : _defaultZoom,
              minZoom: 3,
              maxZoom: 19,
              onTap: (_, _) {
                if (_selectedPlace != null ||
                    _selectedSearchResult != null ||
                    _remoteResults.isNotEmpty) {
                  setState(() {
                    _selectedPlace = null;
                    _selectedSearchResult = null;
                    _remoteResults = const [];
                  });
                }
              },
              onLongPress: (_, point) => _openNewPlaceAt(point),
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
              if (_userLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _userLocation!,
                      width: 24,
                      height: 24,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withAlpha(120),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              MarkerLayer(
                markers: filteredPlaces.map((place) {
                  final isSelected = _selectedPlace?.id == place.id;
                  return Marker(
                    point: LatLng(place.latitude, place.longitude),
                    width: 44,
                    height: 46,
                    alignment: Alignment.topCenter,
                    child: PlaceMapMarker(
                      place: place,
                      isSelected: isSelected,
                      onTap: () {
                        AppHaptics.tap();
                        setState(() => _selectedPlace = place);
                        _mapController.move(
                          LatLng(place.latitude, place.longitude),
                          _mapController.camera.zoom < 14
                              ? 15.0
                              : _mapController.camera.zoom,
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
              if (_selectedSearchResult != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(
                        _selectedSearchResult!.latitude,
                        _selectedSearchResult!.longitude,
                      ),
                      width: 44,
                      height: 44,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(100),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_location_alt_rounded,
                          color: AppColors.backgroundDark,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              const RichAttributionWidget(
                alignment: AttributionAlignment.bottomLeft,
                attributions: [
                  TextSourceAttribution('© OpenStreetMap katkıda bulunanları'),
                ],
              ),
            ],
          ),
          // Arama ve Filtre Çipleri
          Positioned(
            top: MediaQuery.paddingOf(context).top + kToolbarHeight + 12,
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
                                      _selectedSearchResult = null;
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
                    constraints: const BoxConstraints(maxHeight: 240),
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
                const SizedBox(height: 6),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      AppChip(
                        label: 'Tümü (${places.length})',
                        isSelected: _statusFilter == null,
                        unselectedBackgroundColor:
                            colors.surface.withValues(alpha: 0.94),
                        onTap: () => setState(() => _statusFilter = null),
                      ),
                      const SizedBox(width: 8),
                      AppChip(
                        label: '✓ Gezildi',
                        isSelected: _statusFilter == PlaceStatus.visited,
                        unselectedBackgroundColor:
                            colors.surface.withValues(alpha: 0.94),
                        onTap: () =>
                            setState(() => _statusFilter = PlaceStatus.visited),
                      ),
                      const SizedBox(width: 8),
                      AppChip(
                        label: '♡ İstekler',
                        isSelected: _statusFilter == PlaceStatus.planned,
                        unselectedBackgroundColor:
                            colors.surface.withValues(alpha: 0.94),
                        onTap: () =>
                            setState(() => _statusFilter = PlaceStatus.planned),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Seçili Mekân Önizleme Kartı
          if (_selectedPlace != null)
            Positioned(
              left: 16,
              right: 84,
              bottom: 20,
              child: _SelectedPlaceCard(
                place: _selectedPlace!,
                onClose: () => setState(() => _selectedPlace = null),
                onOpenDetail: () =>
                    context.push('/places/${_selectedPlace!.id}'),
              ),
            )
          else if (_selectedSearchResult != null)
            Positioned(
              left: 16,
              right: 84,
              bottom: 20,
              child: AppCard(
                radius: AppRadius.md,
                padding: const EdgeInsets.all(14),
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
                            _selectedSearchResult!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 36,
                            minHeight: 36,
                          ),
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.textMuted,
                            size: 18,
                          ),
                          onPressed: () =>
                              setState(() => _selectedSearchResult = null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedSearchResult!.addressLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          final result = _selectedSearchResult!;
                          setState(() => _selectedSearchResult = null);
                          context.push(
                            '/places/new',
                            extra: PickedLocation(
                              latitude: result.latitude,
                              longitude: result.longitude,
                              addressLabel: result.addressLabel,
                              name: result.name,
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: const Text('Bu mekânı ekle'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'my_location',
            tooltip: 'Konumum',
            backgroundColor: colors.surface,
            foregroundColor: colors.textPrimary,
            onPressed: _isLocating ? null : _goToMyLocation,
            child: _isLocating
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.accent,
                    ),
                  )
                : const Icon(Icons.my_location_rounded),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add_place',
            tooltip: 'Yeni mekân ekle',
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              AppHaptics.tap();
              context.push('/places/new');
            },
            child: const Icon(Icons.add_rounded, size: 30),
          ),
        ],
      ),
    );
  }
}

class _SelectedPlaceCard extends StatelessWidget {
  final Place place;
  final VoidCallback onClose;
  final VoidCallback onOpenDetail;

  const _SelectedPlaceCard({
    required this.place,
    required this.onClose,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    final category = PlaceCategory.fromKey(place.categoryKey);
    final isVisited = place.status == PlaceStatus.visited;
    final colors = context.colors;

    return AppCard(
      radius: AppRadius.md,
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      onTap: onOpenDetail,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceVariant,
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: colors.cardBorder),
            ),
            child: Icon(category.icon, color: colors.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  place.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${category.label} · ${isVisited ? "Gezildi" : "İstek"}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, size: 18, color: colors.textMuted),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
