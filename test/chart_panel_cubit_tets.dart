import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';


void main() {
  group('ChartPanelCubit Tests', () {
    blocTest<ChartPanelCubit, bool>(
      'emits true when togglePanel is called with true',
      build: () => ChartPanelCubit(),
      act: (cubit) => cubit.togglePanel(true),
      expect: () => [true],
    );

    blocTest<ChartPanelCubit, bool>(
      'emits false when togglePanel is called with false',
      build: () => ChartPanelCubit(),
      act: (cubit) => cubit.togglePanel(false),
      expect: () => [false],
    );
  });
}
