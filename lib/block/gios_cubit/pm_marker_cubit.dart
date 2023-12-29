import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import 'gios_data_state.dart';

class GiosDataCubit extends Cubit<GiosDataState> {
  GiosDataCubit() : super(GiosDataInitial());
  final Dio _dio = Dio(); // Tworzy instancję Dio

  Future<void> fetchStations(int cityId) async {
    try {
      emit(GiosDataLoading()); // Emituj stan ładowania
      
      final response = await _dio.get('https://api.gios.gov.pl/pjp-api/rest/station/findAll/$cityId'); // Użyj Dio do zapytania

      if (response.statusCode == 200) {
        final pm10Data = response.data; // Dio automatycznie dekoduje odpowiedź
        emit(GiosDataLoaded(pm10Data)); // Emituj stan z załadowanymi danymi
      } else {
        emit(GiosDataError("Failed to load data")); // Emituj stan błędu
      }
    } catch (e) {
      if(e is DioException){
        emit(GiosDataError("Failed to load data: ${e.message}")); // Emituj stan błędu z komunikatem DioError
      }else{
        emit(GiosDataError("An unexpected error occurred")); // Emituj stan błędu dla innego wyjątku
      }
    }
  }
}
