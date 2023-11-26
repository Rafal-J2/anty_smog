import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/get_api.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};
  late BitmapDescriptor _markerIcon;
  late BitmapDescriptor _markerIcon2;
  late BitmapDescriptor _markerIcon3;
  late BitmapDescriptor _markerIcon4;

  Future<BitmapDescriptor> _addMarkerIcon(String assetPath) async {
    return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), assetPath);
  }

  void _loadMarkerIcons() async {
    _markerIcon = await _addMarkerIcon('assets/images/dot_green_48.png');
    _markerIcon2 = await _addMarkerIcon('assets/images/dot_yellow_48.png');
    _markerIcon3 = await _addMarkerIcon('assets/images/dot_orange_48.png');
    _markerIcon4 = await _addMarkerIcon('assets/images/dot_red_48.png');
  }

  Future<void> _fetchAndSetMarkers() async {
    final List<dynamic> stations = await fetchApiData();
    setState(() {
      _markers.clear();
      for (final station in stations) {
        final marker = Marker(
          markerId: MarkerId(station['school']['name'].toString()),
          position: LatLng(double.parse(station['school']['latitude']),
              double.parse(station['school']['longitude'])),
          infoWindow: InfoWindow(
            title: station['school']['name'],
            snippet: 'PM 2.5: ${(station['data']['pm25_avg'] as num).toInt()}',
          ),
          icon: (station['data']['pm25_avg'] as num) > 55
              ? _markerIcon4
              : (station['data']['pm25_avg'] as num) > 35
                  ? _markerIcon3
                  : (station['data']['pm25_avg'] as num) > 15
                      ? _markerIcon2
                      : _markerIcon,
        );

        _markers[station['school']['name']] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetMarkers();
    _loadMarkerIcons();
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
