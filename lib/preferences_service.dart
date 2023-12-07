import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PreferencesService {
  Future<void> saveCameraPosition(CameraPosition position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.target.latitude);
    await prefs.setDouble('longitude', position.target.longitude);
    await prefs.setDouble('zoom', position.zoom);
  }
}