import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_rest_api/screens/maps.dart';
import '../block/location_gps.dart';
import 'block/cubit/chart_panel_cubit.dart';
import 'block/cubit/pm_data_cubit.dart';
import '../block/marker_cubit.dart';

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
        BlocProvider(
             create: (context) => MarkerCubit(
             context.read<PMDataCubit>(), 
             context.read())..fetchAndSetMarkers(),
             ),
      ],
      child:  const AntySmogApp (),
    ),
  );
}
