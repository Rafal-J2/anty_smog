import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconLoader {
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _markerIcon2;
  late BitmapDescriptor _markerIcon3;
  late BitmapDescriptor _markerIcon4;

  Future<BitmapDescriptor> _addMarkerIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), assetPath);
  }

  Future<void> loadMarkerIcons() async {
    _markerIcon = await _addMarkerIcon('assets/images/dot_green_48.png');
    _markerIcon2 = await _addMarkerIcon('assets/images/dot_yellow_48.png');
    _markerIcon3 = await _addMarkerIcon('assets/images/dot_orange_48.png');
    _markerIcon4 = await _addMarkerIcon('assets/images/dot_red_48.png');
  }

  BitmapDescriptor get markerIcon => _markerIcon;
  BitmapDescriptor get markerIcon2 => _markerIcon2;
  BitmapDescriptor get markerIcon3 => _markerIcon3;
  BitmapDescriptor get markerIcon4 => _markerIcon4;
}