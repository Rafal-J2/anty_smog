import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  Future<CameraPosition> initCameraPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');

    if (latitude != null && longitude != null && zoom != null) {
      return CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: zoom,
      );
    } else {
      return const CameraPosition(
        target: LatLng(52.237049, 21.017532), // default location
        zoom: 6,
      );
    }
  }
}