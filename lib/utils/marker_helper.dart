import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import '../bloc/pm_data_cubit.dart';
import 'marker_icon_loader.dart';

class MarkerHelper {
  final MarkerIconLoader _iconLoader;
  MarkerHelper(this._iconLoader, this.pmDataCubit, this.chartPanelCubit);
  final PMDataCubit pmDataCubit;
  final ChartPanelCubit chartPanelCubit;

// This method builds a marker for a given station.
// It takes a Map representing a station as a parameter.
// The station Map should contain 'school' and 'data' keys.
// The 'school' key should map to another Map containing 'name', 'latitude', and 'longitude' keys.
// The 'data' key should map to another Map containing 'pm25_avg' key.
// It returns a Marker object.

  Marker buildMarker(Map<String, dynamic> station) {
    num pm25Avg = station['data']['pm25_avg'] as num;
    return Marker(
      markerId: MarkerId(station['school']['name'].toString()),
      position: LatLng(double.parse(station['school']['latitude']),
          double.parse(station['school']['longitude'])),
      infoWindow: InfoWindow(
        title: station['school']['name'],
        snippet: 'PM 2.5: ${pm25Avg.toInt()}',
      ),
      onTap: () {
        pmDataCubit.updateData(
            pm25Avg.toDouble()); // Retrieves data for a panel with charts
        chartPanelCubit.togglePanel(true);
      },
      icon: getIconBasedOnPm25(pm25Avg.toDouble()),
    );
  }

  BitmapDescriptor getIconBasedOnPm25(double pm25Avg) {
    const highPm25Level = 55;
    const mediumPm25Level = 35;
    const lowPm25Level = 13;

    if (pm25Avg > highPm25Level) {
      return _iconLoader.markerIcon4;
    } else if (pm25Avg > mediumPm25Level) {
      return _iconLoader.markerIcon3;
    } else if (pm25Avg > lowPm25Level) {
      return _iconLoader.markerIcon2;
    } else {
      return _iconLoader.markerIcon;
    }
  }
}
