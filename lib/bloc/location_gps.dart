import 'package:geolocator/geolocator.dart';

class LocationGps {
  /// Fetches the current location. If location services are disabled,
  /// attempts to return the last known position. Throws an exception
  /// if location permissions are denied or permanently denied.
  Future<Position?> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Return last known position if location services are disabled
      return await Geolocator.getLastKnownPosition();
    }

    // Check and request for location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    // Return current location if permissions are granted
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    }

    // Return null in case of any other issues
    return null;
  }
}
