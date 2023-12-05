import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'block/location_gps.dart';
import 'maps.dart';
import 'block/marker_cubit.dart';
import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = 'pl';
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MarkerCubit()..fetchAndSetMarkers(),
        ),
        BlocProvider(
          create: (context) => LocationGps()..getCurrentLocation(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
