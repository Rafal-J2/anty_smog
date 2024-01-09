import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class School with ClusterItem {
  int? id;
  String? name;
  LatLng latLng;
  double pm25Avg;

  School({required this.id, required this.name, required this.latLng, required this.pm25Avg});

  @override
  LatLng get location => latLng;
}