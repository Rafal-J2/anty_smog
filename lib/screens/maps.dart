import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../block/location_gps.dart';
import '../block/marker_cubit.dart';
import '../shared/map_service.dart';
import '../shared/preferences_service.dart';
import 'package:logger/logger.dart';

import 'chart_panel.dart';

class AntySmogApp extends StatefulWidget {
  const AntySmogApp({super.key});
  @override
  AntySmogAppState createState() => AntySmogAppState();
}

var logger = Logger();

class AntySmogAppState extends State<AntySmogApp> {
  late GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;

//double _todayValue = 250;
  bool _isMarkerVisible = false;

  //final markerHelper = const MarkerHelperUdate();

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
              GoogleMap(
                onTap: (LatLng position) {
                  setState(() {
                    _isMarkerVisible = true;
                  });
                },
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
              if (_isMarkerVisible)
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    width: 500,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MarkerHelperUdate(),
                    ),
                  ),
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
