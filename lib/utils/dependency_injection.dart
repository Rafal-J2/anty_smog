import 'package:get_it/get_it.dart';
import 'package:google_maps_rest_api/shared/map_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<MapService>(() => MapService());
}

