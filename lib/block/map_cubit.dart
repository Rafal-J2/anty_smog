import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapCubit extends Cubit<CameraPosition> {
  MapCubit() : super(_defaultCameraPosition());

  static CameraPosition _defaultCameraPosition() {
    return const CameraPosition(
      target: LatLng(52.237049, 21.017532), 
      zoom: 6,
    );
  }

  Future<void> initCameraPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');

    if (latitude != null && longitude != null && zoom != null) {
      emit(CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: zoom,
      ));
    } else {
      emit(_defaultCameraPosition());
    }
  }

    Future<void> savePosition(CameraPosition position) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', position.target.latitude);
    await prefs.setDouble('longitude', position.target.longitude);
    await prefs.setDouble('zoom', position.zoom);
  }
}