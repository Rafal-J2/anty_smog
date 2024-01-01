import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screens/maps.dart';

class PMDataState {
  final double pm25Value;
  PMDataState(this.pm25Value);
}

class PMDataCubit extends Cubit<PMDataState> {
  PMDataCubit() : super(PMDataState(0));

  void updateData(double pm25Value) {
    logger.i('PMDataCubit: Updating data to PM2.5 Value: $pm25Value');
    emit(PMDataState(pm25Value));
  }
}
