import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

/// LocationGps is a Cubit that manages the fetching of the current user's location.
class LocationGps extends Cubit<Position?> {
  LocationGps() : super(null);

  /// Fetches the current location of the user using the Geolocator package.
  ///
  /// This method performs several checks and actions:
  /// - Checks if location services are enabled on the device. If not, it throws an exception.
  /// - Checks the app's permission to access the user's location. If permissions are denied,
  ///   it attempts to request them. If permissions are permanently denied, it throws an exception.
  /// - Once permissions are granted, it fetches the current location with a specified accuracy.
  /// - Emits the fetched location to the Cubit stream, making it available to listeners.
  ///
  /// Exceptions:
  /// - Throws an exception if location services are disabled.
  /// - Throws an exception if location permissions are denied or permanently denied.
  ///
  /// Usage:
  /// To fetch and listen to the user's current location, create an instance of LocationGps
  /// and call getCurrentLocation(). Listen to the LocationGps Cubit to receive the current location.
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    // Check the app's permission to access the user's location.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permissions are granted, fetch the current location.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    // Emit the fetched location to the Cubit stream.
    emit(position);
  }
}
