import 'package:bloc_test/bloc_test.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CharPanelCubit', () {
    blocTest<ChartPanelCubit, ChartPanelState>(
      'emits [ChartPanelState(true)] when togglePanel(true) is called.',
      build: () => ChartPanelCubit(),
      act: (cubit) => cubit.togglePanel(true),
      expect: () => [
        isA<ChartPanelState>()
            .having((state) => state.isPanelVisible, 'isPanelVisible', true)
      ],
    );

    blocTest<ChartPanelCubit, ChartPanelState>(
      'emits [ChartPanelState(true)] when togglePanel(false) is called.',
      build: () => ChartPanelCubit(),
      act: (cubit) => cubit.togglePanel(false),
      expect: () => [
        isA<ChartPanelState>()
            .having((state) => state.isPanelVisible, 'isPanelVisible', false)
      ],
    );
  });
}
