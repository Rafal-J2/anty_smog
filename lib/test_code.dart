import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Set<Marker> _markers = {};
  final LatLng _initialPosition = const LatLng(52.237049, 21.017532); // Przykładowa lokalizacja - Warszawa

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    const url = 'https://api.gios.gov.pl/pjp-api/rest/station/findAll';
    try {
      final response = await http.get(Uri.parse(url));
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        for (var station in data) {
          final marker = Marker(
            markerId: MarkerId(station['id'].toString()),
            position: LatLng(double.parse(station['gegrLat']), double.parse(station['gegrLon'])),
            infoWindow: InfoWindow(
              title: station['stationName'],
              snippet: 'ID: ${station['id']}',
            ),
          );
          _markers.add(marker);
        }
      });
    } catch (e) {
      print(e); // W prawdziwej aplikacji użyłbyś tutaj jakiegoś mechanizmu logowania błędów.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Stacji Pomiarowych'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 6.0,
        ),
        markers: _markers,
      ),
    );
  }
}
