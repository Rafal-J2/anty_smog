import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/utils/marker_icon_loader.dart';
import 'maps.dart';

class MapScreen extends StatelessWidget {
  final MarkerIconLoader markerIconLoader;
  const MapScreen({super.key, required this.markerIconLoader});

  Future<void> loadMarkers() async {
    await markerIconLoader.loadMarkerIcons();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadMarkers(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(52.237049, 21.017532),
                zoom: 6,
              ),
            );
          } else {
            logger.i('massage');
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
