import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerIconLoader {
  
  final Map<String, BitmapDescriptor> _iconCache = {};



Future<BitmapDescriptor> loadMarkerIcon(String assetPath) async {
    if (!_iconCache.containsKey(assetPath)) {
      _iconCache[assetPath] = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), assetPath);
    }
    return _iconCache[assetPath]!;
  }

  Future<void> loadMarkerIcons() async {
    await Future.wait([
      loadMarkerIcon('assets/images/dot_green_48.png'),
      loadMarkerIcon('assets/images/dot_yellow_48.png'),
      loadMarkerIcon('assets/images/dot_orange_48.png'),
      loadMarkerIcon('assets/images/dot_red_48.png'),
    ]);
  }

  BitmapDescriptor getMarkerIcon(String assetPath) {
    return _iconCache[assetPath] ?? BitmapDescriptor.defaultMarker;
  }


}
