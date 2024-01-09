import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screens/maps.dart';

class ChartPanelCubit extends Cubit<bool> {
  ChartPanelCubit() : super(true);

  void togglePanel() {
        logger.i('ChartPanelCubit: Toggling panel from: $state');
    emit(!state);
  }

  void setPanelActive(bool isActive) {
    logger.i('Setting panel active to: $isActive');
    emit(isActive);
  }
}
