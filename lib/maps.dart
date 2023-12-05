import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'block/location_gps.dart';
import 'block/marker_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late GoogleMapController _controller;

  

  void _initCameraPosition() async {
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble('latitude');
    double? longitude = prefs.getDouble('longitude');
    double? zoom = prefs.getDouble('zoom');

    if (latitude != null && longitude != null && zoom != null) {
      _controller.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: zoom,
          ),
        ),
      );
    } else {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          const CameraPosition(
            target: LatLng(52.237049, 21.017532), // default location
            zoom: 6,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'CustomFont'),
       localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
         supportedLocales: const [
        Locale('pl', ''), // Polish
        // other locales...
      ],
        home: Scaffold(
      body: BlocBuilder<MarkerCubit, Map<String, Marker>>(
        builder: (context, state) {
          return GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) async {
              _controller = controller;
              _initCameraPosition();
            },
            onCameraMove: (CameraPosition position) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setDouble('latitude', position.target.latitude);
              await prefs.setDouble('longitude', position.target.longitude);
              await prefs.setDouble('zoom', position.zoom);
            },
            initialCameraPosition: const CameraPosition(
              target: LatLng(52.237049, 21.017532),
              zoom: 6,
            ),
            markers: state.values.toSet(),
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
