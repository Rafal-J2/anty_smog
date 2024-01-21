import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/maps.dart';

class ChartPanelState extends Equatable {
  final bool isPanelVisible;
  const ChartPanelState(this.isPanelVisible);
  
  @override
  List<Object?> get props => [isPanelVisible];
}

class ChartPanelCubit extends Cubit<ChartPanelState> {
  ChartPanelCubit() : super(const ChartPanelState(false));

   void togglePanel(bool isActive) {
    logger.d('ChartPanelCubit: Toggling panel to $isActive');
    emit(ChartPanelState(isActive));
  }
}

