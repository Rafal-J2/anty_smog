import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconLoader {
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _markerIcon2;

  Future<BitmapDescriptor> _addMarkerIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      assetPath,
    );
  }

  Future<void> loadMarkerIcons() async {
    _markerIcon = await _addMarkerIcon('assets/images/dot_dark_green_48.png');
    _markerIcon2 = await _addMarkerIcon('assets/images/dot_dark_yellow_48.png');
  }

  BitmapDescriptor get markerIcon => _markerIcon;
  BitmapDescriptor get markerIcon2 => _markerIcon2;
}