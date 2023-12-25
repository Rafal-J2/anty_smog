// gios_data_state.dart

abstract class GiosDataState {}

class GiosDataInitial extends GiosDataState {} // Stan początkowy

class GiosDataLoading extends GiosDataState {} // Stan ładowania danych

class GiosDataLoaded extends GiosDataState {
  final List<dynamic> data; // Załóżmy, że dane są listą dynamiczną
  GiosDataLoaded(this.data);
} // Stan z załadowanymi danymi

class GiosDataError extends GiosDataState {
  final String message; // Wiadomość błędu
  GiosDataError(this.message);
} // Stan błędu
