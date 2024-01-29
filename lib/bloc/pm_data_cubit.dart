import 'package:flutter_bloc/flutter_bloc.dart';

class PMDataState {
  final double pm25Value;
  final double pm10Value;
  PMDataState(this.pm25Value, this.pm10Value);
}

class PMDataCubit extends Cubit<PMDataState> {
  PMDataCubit() : super(PMDataState(0, 0));

  void updateData(double pm25Value, double pm10Value) {
    emit(PMDataState(pm25Value, pm10Value));
  }
}
