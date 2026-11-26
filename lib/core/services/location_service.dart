import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

enum LocationResultStatus {
  success,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  error,
}

class LocationResult {
  final LocationResultStatus status;
  final double? latitude;
  final double? longitude;
  final String? message;

  const LocationResult._({
    required this.status,
    this.latitude,
    this.longitude,
    this.message,
  });

  factory LocationResult.success({
    required double latitude,
    required double longitude,
  }) {
    return LocationResult._(
      status: LocationResultStatus.success,
      latitude: latitude,
      longitude: longitude,
    );
  }

  factory LocationResult.serviceDisabled() {
    return const LocationResult._(
      status: LocationResultStatus.serviceDisabled,
      message: 'Konum servisleri kapalı. Ayarlardan konumu açarak tekrar deneyebilirsin.',
    );
  }

  factory LocationResult.permissionDenied() {
    return const LocationResult._(
      status: LocationResultStatus.permissionDenied,
      message: 'Konum izni verilmedi. Haritada istediğin noktayı elle seçebilirsin.',
    );
  }

  factory LocationResult.permissionDeniedForever() {
    return const LocationResult._(
      status: LocationResultStatus.permissionDeniedForever,
      message: 'Konum izni kalıcı olarak reddedildi. Uygulama ayarlarından izin verebilirsin.',
    );
  }

  factory LocationResult.error(String message) {
    return LocationResult._(
      status: LocationResultStatus.error,
      message: message,
    );
  }

  bool get isSuccess =>
      status == LocationResultStatus.success && latitude != null && longitude != null;
}

abstract class LocationService {
  Future<LocationResult> getCurrentLocation();
}

class GeolocatorLocationService implements LocationService {
  @override
  Future<LocationResult> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.serviceDisabled();
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.permissionDenied();
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.permissionDeniedForever();
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return LocationResult.success(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return LocationResult.error('Konum alınamadı. Haritada elle gezinebilirsin.');
    }
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});
