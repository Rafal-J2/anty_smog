import 'package:flutter_bloc/flutter_bloc.dart';

class ChartPanelCubit extends Cubit<bool> {
  ChartPanelCubit() : super(false);
  void togglePanel(bool isVisible) {
    emit(isVisible);
  }
}
