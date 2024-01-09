import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'gios_data_state.dart';

class GiosDataCubit extends Cubit<GiosDataState> {
  GiosDataCubit() : super(GiosDataInitial());
  final Dio _dio = Dio(); // 

  Future<void> fetchStations(int cityId) async {
    try {
      emit(GiosDataLoading()); 
      
      final response = await _dio.get('https://api.gios.gov.pl/pjp-api/rest/station/findAll/$cityId'); 

      if (response.statusCode == 200) {
        final pm10Data = response.data; 
        emit(GiosDataLoaded(pm10Data)); 
      } else {
        emit(GiosDataError("Failed to load data")); // Emituj stan błędu
      }
    } catch (e) {
      if(e is DioException){
        emit(GiosDataError("Failed to load data: ${e.message}"));
      }else{
        emit(GiosDataError("An unexpected error occurred"));
      }
    }
  }
}
