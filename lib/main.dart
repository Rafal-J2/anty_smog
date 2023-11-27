import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/maps/marker_icon_loader.dart';
import 'package:google_maps_rest_api/get_api.dart';
import 'maps/marker_helper.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  final MarkerIconLoader _iconLoader = MarkerIconLoader();
  late MarkerHelper _markerHelper;

  Future<void> _fetchAndSetMarkers() async {
    final List<dynamic> stations = await fetchApiData();
    setState(() {
      _markers.clear();
      for (final station in stations) {
        final marker = _markerHelper.buildMarker(station);
        _markers[station['school']['name']] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetMarkers();
    _iconLoader.loadMarkerIcons();
    _markerHelper = MarkerHelper(_iconLoader);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CustomFont',
      ),
      home: GoogleMap(
        onMapCreated: (GoogleMapController controller) {},
        initialCameraPosition: const CameraPosition(
          target: LatLng(52.237049, 21.017532),
          zoom: 5,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
