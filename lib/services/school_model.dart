import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//late ClusterManager clusterManager;

class SchoolModel with ClusterItem {
  String name;
  double pm25;
  LatLng latLng;
  String city;

  SchoolModel({
    required this.name,
    required this.latLng,
    required this.pm25,
    required this.city,
  });
  @override
  LatLng get location => latLng;

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
        latLng: LatLng(double.parse(json['school']['latitude']),
            double.parse(json['school']['longitude'])),
        pm25: json['data']['pm25_avg'],
        name: json['school']['name'],
        city: json['school']['city']);
  }
}




