import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'get_api.dart';

class MyApp2 extends StatefulWidget {
  const MyApp2({super.key});

  @override
  State<MyApp2> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp2> {
  final Map<String, Marker> _markers = {};
  late GoogleMapController mapController; // Controller for Google map

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fetchAndSetMarkers();
  }

Future<void> _fetchAndSetMarkers() async {
  final List<dynamic> stations = await fetchStations();
  setState(() {
    _markers.clear();
    for (var station in stations) {
      fetchStationSensors(station['id']).then((sensors) {
        var pm10Sensor = sensors.firstWhere(
          (sensor) => sensor['param']['paramCode'] == 'PM10',
          orElse: () => null,
        );
        if (pm10Sensor != null) {
          fetchSensorData(pm10Sensor['id']).then((data) {
            // Przykład zakłada, że interesuje nas najnowsza wartość PM10.
            var pm10Value = data['values'].firstWhere(
              (v) => v['value'] != null,
              orElse: () => {'value': 'Brak danych'},
            )['value'];

            final marker = Marker(
              markerId: MarkerId(station['id'].toString()),
              position: LatLng(
                double.tryParse(station['gegrLat']) ?? 0.0,
                double.tryParse(station['gegrLon']) ?? 0.0,
              ),
              infoWindow: InfoWindow(
                title: station['stationName'] ?? 'Unknown',
                snippet: 'PM10: $pm10Value',
              ),
            );

            setState(() {
              _markers[station['id'].toString()] = marker;
            });
          });
        }
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stations on Map'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: LatLng(52.237049, 21.017532), // Central point in Poland
            zoom: 5,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp2());
}