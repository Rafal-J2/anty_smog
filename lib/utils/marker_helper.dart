import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../block/cubit/pm_data_cubit.dart';
import 'marker_icon_loader.dart';

class MarkerHelper {
  final MarkerIconLoader _iconLoader;
  MarkerHelper(this._iconLoader, this.pmDataCubit);
   final PMDataCubit pmDataCubit;


// This method builds a marker for a given station.
// It takes a Map representing a station as a parameter.
// The station Map should contain 'school' and 'data' keys.
// The 'school' key should map to another Map containing 'name', 'latitude', and 'longitude' keys.
// The 'data' key should map to another Map containing 'pm25_avg' key.
// It returns a Marker object.
  Marker buildMarker(Map<String, dynamic> station, ) {
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
        pmDataCubit.updateData(pm25Avg.toDouble()); 
      },
      icon: pm25Avg > 55
          ? _iconLoader.markerIcon4
          : pm25Avg > 35
          ? _iconLoader.markerIcon3
          : pm25Avg > 13
          ? _iconLoader.markerIcon2
          : _iconLoader.markerIcon,
    );
  }
}
