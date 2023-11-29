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
  Future<Position> _getCurrentLocation() async {
  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CustomFont',
      ),
      home: BlocBuilder<MarkerCubit, Map<String, Marker>>(
        builder: (context, state) {
          return GoogleMap(
            onMapCreated: (GoogleMapController controller) async {
              final position = await _getCurrentLocation();
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 5,
                  ),
                ),
              );           
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(52.237049, 21.017532),
              zoom: 5,
            ),
            markers: state.values.toSet(),
          );
        },
      ),
    );
  }
}
