import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'block/location_gps.dart';
import 'block/marker_cubit.dart';
import 'shared preferences/map_service.dart';
import 'shared preferences/preferences_service.dart';
import 'package:logger/logger.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

var logger = Logger();

class MyAppState extends State<MyApp> {
  late GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _printSavedCameraPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');
    logger.i('Saved latitude: $latitude');
    logger.i('Saved longitude: $longitude');
    logger.i('Saved zoom: $zoom');
  }

  void _initCameraPosition() async {
    CameraPosition position = await MapService().initCameraPosition();
    _controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: BlocBuilder<MarkerCubit, Map<String, Marker>>(
        builder: (context, state) {
         return Stack(
  children: [
    Stack(
      children: [
        GoogleMap(
          mapType: _currentMapType,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            _controller = controller;
            _printSavedCameraPosition();
            _initCameraPosition();
          },
          onCameraMove: (CameraPosition position) {
            PreferencesService().saveCameraPosition(position);
          },
          initialCameraPosition: const CameraPosition(
            target: LatLng(52.237049, 21.017532),
            zoom: 6,
          ),
          markers: state.values.toSet(),
        ),
  Positioned(
  bottom: 240,
  right: 10,
  child: FloatingActionButton(
    onPressed: _onMapTypeButtonPressed,
    child: _currentMapType == MapType.normal
        ? const Icon(Icons.map)
        : const Icon(Icons.satellite),
  ),
),
      ],
    ),
    // other widgets...
  ],
);
        },
      ),
      floatingActionButton: BlocConsumer<LocationGps, Position?>(
        listener: (context, position) {},
        builder: (context, position) {
          return FloatingActionButton(
            onPressed: () {
              if (position != null) {
                final locationCubit = BlocProvider.of<LocationGps>(context);
                locationCubit.getCurrentLocation();
                _controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 12,
                    ),
                  ),
                );
              }
            },
              child: const Icon(Icons.my_location),
          );
        },
      ),
    ));
  }
}
