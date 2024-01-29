import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// The MarkerIconLoader class manages the loading and caching of map marker icons.
class MarkerIconLoader {
   /// Cache for storing marker icons.
  final Map<String, BitmapDescriptor> _iconCache = {};

 /// Loads a marker icon and stores it in the cache.

  /// [assetPath] is the path to the marker icon asset.
  /// Returns a [BitmapDescriptor] for the loaded icon.
Future<BitmapDescriptor> loadMarkerIcon(String assetPath) async {
    if (!_iconCache.containsKey(assetPath)) {
      _iconCache[assetPath] = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(), assetPath);
    }
    return _iconCache[assetPath]!;
  }

  /// Loads all required marker icons into the cache.
  /// This method should be called during application initialization.
  Future<void> loadMarkerIcons() async {
    await Future.wait([
      loadMarkerIcon('assets/images/dot_green_48.png'),
      loadMarkerIcon('assets/images/dot_yellow_48.png'),
      loadMarkerIcon('assets/images/dot_orange_48.png'),
      loadMarkerIcon('assets/images/dot_red_48.png'),
    ]);
  }

  /// Retrieves a marker icon from the cache.
 
  /// [assetPath] is the path to the marker icon asset.
  /// Returns a [BitmapDescriptor] for the icon. If the icon is not available in the cache,
  /// returns the default marker icon.
  BitmapDescriptor getMarkerIcon(String assetPath) {
    return _iconCache[assetPath] ?? BitmapDescriptor.defaultMarker;
  }
}
