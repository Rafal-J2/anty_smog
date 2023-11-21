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

  void _addMarkerIcon() async {
    _markerIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      'assets/images/dot_64.png',
    );
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
          snippet: 'PM 2.5: ${(station['data']['pm25_avg'] as num).toInt()}\nPM 10: ${(station['data']['pm10_avg'] as num).toInt()}',
          ),
          icon: _markerIcon,
        );

        _markers[station['school']['name']] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetMarkers();
    _addMarkerIcon();
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
