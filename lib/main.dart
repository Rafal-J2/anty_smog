import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'block/location_gps.dart';
import 'maps.dart';
import 'block/marker_cubit.dart';

void main() {
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
