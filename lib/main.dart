import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../block/location_gps.dart';
import 'block/cubit/pm_data_cubit.dart';
import 'screens/maps.dart';
import '../block/marker_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PMDataCubit(),  // Dodaj ten provider
        ),
        BlocProvider(  
          create: (context) => MarkerCubit(context.read<PMDataCubit>())..fetchAndSetMarkers(context),
        ),
        BlocProvider(
          create: (context) => LocationGps()..getCurrentLocation(),
        ),
      ],
      child: const AntySmogApp(),
    ),
  );
}
