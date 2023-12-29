// pm_data_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';

class PMDataState {
  final String name;
  final double pm25Value;

  PMDataState(this.name, this.pm25Value);
}

class PMDataCubit extends Cubit<PMDataState> {
  PMDataCubit() : super(PMDataState('', 0));

  void updateData(String name, double pm25Value) {
    emit(PMDataState(name, pm25Value));
  }
}
