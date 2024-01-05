
abstract class GiosDataState {}

class GiosDataInitial extends GiosDataState {} 

class GiosDataLoading extends GiosDataState {} 

class GiosDataLoaded extends GiosDataState {
  final List<dynamic> data; 
  GiosDataLoaded(this.data);
} 

class GiosDataError extends GiosDataState {
  final String message;
  GiosDataError(this.message);
} 