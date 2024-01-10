import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/maps.dart';

class ChartPanelCubit extends Cubit<bool> {
  ChartPanelCubit() : super(false);

  void togglePanel(bool isActive) {
        logger.i('ChartPanelCubit: Toggling panel from: $state');
    emit(isActive);
  }

  // void setPanelActive(bool isActive) {
  //   logger.i('Setting panel active to: $isActive');
  //   emit(isActive);
  // }
}
