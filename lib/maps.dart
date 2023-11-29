import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'marker_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => MarkerCubit()..fetchAndSetMarkers(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
late GoogleMapController _controller;



  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Location permissions are denied, request permissions.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permissions are denied, return an error.
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, return an error.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // Location services are enabled, and we have permission to use location.
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: BlocBuilder<MarkerCubit, Map<String, Marker>>(
        builder: (context, state) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              _controller = controller;
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(52.237049, 21.017532),
              zoom: 6,
            ),
            markers: state.values.toSet(),
          );
        },
      ),
       floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              Position position = await _getCurrentLocation();
              _controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 12,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$e'),
                ),
              );
            }
          },
          child: const Icon(Icons.my_location),
        ),
    ));
  }
}
