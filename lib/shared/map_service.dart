import 'package:google_maps_rest_api/screens/maps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  static const defaultLatitude = 52.237049;
  static const defaultLongitude = 21.017532;
  static const defaultZoom = 6.0;

  /// Initializes the position of the map camera to the last known position of the user.
  /// Retrieves the last known latitude and longitude and zoom level
  /// from SharedPreferences, which are saved each time the user
  /// checks the air quality. If the data is not available, the
  /// the default location.
  Future<CameraPosition> initCameraPosition() async {
    try {
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
          target: LatLng(defaultLatitude, defaultLongitude),
          zoom: defaultZoom,
        );
      }
    } catch (e) {
      logger.i('Error while reading SharedPreferences: $e');
      return const CameraPosition(
        target: LatLng(defaultLatitude, defaultLongitude),
        zoom: defaultZoom,
      );
    }
  }
}
