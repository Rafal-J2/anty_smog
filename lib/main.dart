import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_maps_rest_api/screens/maps.dart';
import 'bloc/location_gps.dart';
import 'bloc/chart_panel_cubit.dart';
import 'bloc/pm_data_cubit.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PMDataCubit(),
        ),
        BlocProvider(
          create: (context) => ChartPanelCubit(),
        ),
        BlocProvider(
          create: (context) => LocationGps()..getCurrentLocation(),
        ),
      ],
      child: const AntySmogApp(),
    ),
  );
}
