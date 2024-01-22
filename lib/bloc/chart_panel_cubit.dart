import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/maps.dart';

class ChartPanelCubit extends Cubit<bool> {
  ChartPanelCubit() : super(false){
      logger.d('ChartPanelCubit created with ID: ${identityHashCode(this)}');
  }
  void togglePanel(bool isVisible) {
    emit(isVisible); 
  }
}
