import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  // Konum izni iste
  static Future<bool> requestPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  // Mevcut konumu al
  static Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestPermission();

      if (!hasPermission) {
        return null;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Konum alınamadı: $e');
      return null;
    }
  }

  // İki konum arası mesafe hesapla (metre)
  static double calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  // Mekan yakınında mı kontrol et
  static Future<bool> isNearLocation({
    required double mekanLat,
    required double mekanLon,
    double maxDistance = 100, // 100 metre
  }) async {
    Position? position = await getCurrentLocation();

    if (position == null) {
      return false;
    }

    double distance = calculateDistance(
      position.latitude,
      position.longitude,
      mekanLat,
      mekanLon,
    );

    return distance <= maxDistance;
  }
}