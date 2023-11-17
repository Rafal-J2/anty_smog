import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/get_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Map<String, Marker> _markers = {};

  Future<void> _fetchAndSetMarkers() async {
    final List<dynamic> stations = await fetchStations();
    setState(() {
      _markers.clear();
      for (final station in stations) {
        final marker = Marker(
          markerId: MarkerId(station['id'].toString()),
          position: LatLng(double.parse(station['gegrLat']), double.parse(station['gegrLon'])),
          infoWindow: InfoWindow(
            title: station['stationName'],
            snippet: 'ID: ${station['id']}',
          ),
        );
        _markers[station['id'].toString()] = marker;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleMap(
        onMapCreated: (GoogleMapController controller) {},
        initialCameraPosition: const CameraPosition(
          target: LatLng(52.237049, 21.017532), // Przykładowe współrzędne środkowe dla Polski
          zoom: 5,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }

  // Tu wstaw funkcję fetchStations(), którą wcześniej zdefiniowałeś
}

