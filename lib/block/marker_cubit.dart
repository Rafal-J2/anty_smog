import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/services/get_api.dart';
import 'package:google_maps_rest_api/utils/marker_helper.dart';
import 'package:google_maps_rest_api/utils/marker_icon_loader.dart';
import '../screens/maps.dart';
import 'cubit/pm_data_cubit.dart';


class MarkerCubit extends Cubit<Map<String, Marker>> {
  MarkerCubit(this.pmDataCubit) : super({});

  final MarkerIconLoader _iconLoader = MarkerIconLoader();
  late MarkerHelper _markerHelper;
    final PMDataCubit pmDataCubit;  

  Future<void> fetchAndSetMarkers(BuildContext context) async {
    _iconLoader.loadMarkerIcons();
    _markerHelper = MarkerHelper(_iconLoader, pmDataCubit);

    final List<dynamic> stations = await fetchApiData();
     logger.i('MarkerCubit: Pobrano dane dla ${stations.length} stacji');
    final Map<String, Marker> newMarkers = {};
    for (final station in stations) {
        final marker = _markerHelper.buildMarker(station);
      newMarkers[station['school']['name']] = marker;
    }
    emit(newMarkers);
  }
}