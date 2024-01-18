import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/maps.dart';

class ChartPanelCubit extends Cubit<bool> {
  ChartPanelCubit() : super(false);

  void togglePanel(bool isActive) {
      logger.d('ChartPanelCubit: Toggling panel to $isActive');
    emit(isActive);
  }


}
