import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_rest_api/bloc/chart_panel_cubit.dart';
import '../bloc/pm_data_cubit.dart';
import '../services/school_model.dart';
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

  Marker buildMarker(
    Map<String, dynamic> station) {
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

  Future<Marker> buildClusterMarker(Cluster<SchoolModel> cluster) async {
    double avgPm25 =
        cluster.items.fold(0, (sum, school) => sum + school.pm25 as int) /
            cluster.items.length;
    BitmapDescriptor icon = getIconBasedOnPm25(avgPm25);

    return Marker(
      markerId: MarkerId(cluster.isMultiple
          ? cluster.getId()
          : cluster.items.single.name.toString()),
      position: cluster.location,
      infoWindow: InfoWindow(
        title: 'Klaster ${cluster.items.length} szkół',
        snippet: 'Średni PM 2.5: ${avgPm25.toStringAsFixed(2)}',
      ),
      onTap: () {
      },
      icon: icon,
    );
  }

  BitmapDescriptor getIconBasedOnPm25(double pm25Avg) {
    if (pm25Avg > 55) {
      return _iconLoader.markerIcon4;
    } else if (pm25Avg > 35) {
      return _iconLoader.markerIcon3;
    } else if (pm25Avg > 13) {
      return _iconLoader.markerIcon2;
    } else {
      return _iconLoader.markerIcon;
    }
  }
}
