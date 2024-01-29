import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_rest_api/screens/maps.dart';

import 'bloc/chart_panel_cubit.dart';
import 'bloc/pm_data_cubit.dart';
import 'utils/dependency_injection.dart';

void main() {
  setupLocator();
  runApp(
    MultiBlocProvider(
      providers: [
          BlocProvider(
          create: (context) => ChartPanelCubit(),
        ),
        BlocProvider(
          create: (context) => PMDataCubit(),
        ),  
      ],
      child: const AntySmogApp(),
    ),
  );
}
