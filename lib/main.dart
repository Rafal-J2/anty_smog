import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../block/location_gps.dart';
import 'block/cubit/chart_panel_cubit.dart';
import 'block/cubit/pm_data_cubit.dart';
import '../block/marker_cubit.dart';
import 'services/cluster_manager.dart';

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
      child:  const MyApp (),
    ),
  );
}
