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

/// Class representing the state of the AntySmogApp.
/// It includes methods for initializing the camera position, updating map type,
/// and building the main application widget.
class AntySmogAppState extends State<AntySmogApp> {

  late GoogleMapController _controller;
  MapType _currentMapType = MapType.normal;
  bool _activateChartsPanel = false;


/// Toggles the map type between normal (street view) and satellite when the map type button is pressed.
/// This allows users to switch between different views of the map according to their preferences..
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

/// Initializes the camera position to the last known user position.
/// It retrieves the last known latitude, longitude, and zoom level from SharedPreferences,
/// which are saved whenever the user checks the air quality.
  void _initialCameraPosition() async {
    CameraPosition position = await MapService().initCameraPosition();
    _controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

/// Builds the main application widget.
///
/// This widget is the root of the application and contains a [GoogleMap] widget
/// that displays dynamic markers. It uses [BlocBuilder] to listen for changes
/// in [MarkerCubit], which manages the state of the markers based on geographical data.
///
/// The map displays markers for each station, which are provided by the state of
/// [MarkerCubit] as a set of markers (`state.values.toSet()`).
/// 
///  A GoogleMap widget that displays markers and allows interaction.
/// - `onTap`: Defines behavior when the map is tapped. Currently, it sets '_isMarkerVisible' to true,
///   which triggers the display of a panel with charts related to the tapped location.
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
                    _activateChartsPanel = true; // The operation of the function is described above in the documentation
                  });
                },
                mapType: _currentMapType,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onMapCreated: (GoogleMapController controller) async {
                  _controller = controller;
                  _printSavedCameraPosition();
                  _initialCameraPosition();
                },
                onCameraMove: (CameraPosition position) {
                  PreferencesService().saveCameraPosition(position);
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(52.237049, 21.017532),
                  zoom: 6,
                ),
                markers: state.values.toSet(),  // The operation of the function is described above in the documentation
              ),
              if (_activateChartsPanel) 
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

///  LocationGps Cubit, and how it updates the user's current location on the map.
///  Floating Action Button: A widget that triggers fetching the user's current location.
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


