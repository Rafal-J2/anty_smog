
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import 'package:google_maps_rest_api/bloc/location_gps.dart';
import 'package:google_maps_rest_api/screens/maps.dart';

void main() {
  testWidgets('AntySmogApp test', (WidgetTester tester) async {
    final locationGps = LocationGps();
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ChartPanelCubit>(create: (_) => ChartPanelCubit()),
          BlocProvider<LocationGps>(create: (_) => locationGps),
     
        ],
        child: const MaterialApp(home: AntySmogApp()),
      ),
    );
  });
}