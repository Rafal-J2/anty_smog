import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/services/get_api.dart';
import 'package:google_maps_rest_api/utils/marker_helper.dart';
import 'package:google_maps_rest_api/utils/marker_icon_loader.dart';


class MarkerCubit extends Cubit<Map<String, Marker>> {
  MarkerCubit() : super({});

  final MarkerIconLoader _iconLoader = MarkerIconLoader();
  late MarkerHelper _markerHelper;

  Future<void> fetchAndSetMarkers() async {
    _iconLoader.loadMarkerIcons();
    _markerHelper = MarkerHelper(_iconLoader);

    final List<dynamic> stations = await fetchApiData();
    final Map<String, Marker> newMarkers = {};
    for (final station in stations) {
        final marker = _markerHelper.buildMarker(station, () {});
      newMarkers[station['school']['name']] = marker;
    }
    emit(newMarkers);
  }
}