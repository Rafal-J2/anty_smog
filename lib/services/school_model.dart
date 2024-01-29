import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SchoolModel with ClusterItem {
  String schoolName;
  double airQualityPm25;
  double airQualityPm10;
  LatLng latLng;
  String city;

  SchoolModel({
    required this.schoolName,
    required this.latLng,
    required this.airQualityPm25,
    required this.airQualityPm10,
    required this.city,
  });
  @override
  LatLng get location => latLng;

  factory SchoolModel.fromJson(Map<String, dynamic> json) {
    return SchoolModel(
        latLng: LatLng(double.parse(json['school']['latitude']),
            double.parse(json['school']['longitude'])),
        airQualityPm25: json['data']['pm25_avg'],
        airQualityPm10: json['data']['pm10_avg'],
        schoolName: json['school']['name'],
        city: json['school']['city']);
  }
}




