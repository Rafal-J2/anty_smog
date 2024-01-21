// Plik: test/widget_test.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import 'package:google_maps_rest_api/screens/maps.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final chartPanelCubit = ChartPanelCubit();
    await tester.pumpWidget(BlocProvider<ChartPanelCubit>(
      create: (context) => chartPanelCubit,
      child: const MaterialApp(
        home: AntySmogApp(),
      ),
    ));
  });
}
