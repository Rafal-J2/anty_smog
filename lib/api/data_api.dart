import 'package:json_annotation/json_annotation.dart';

part 'data_api.g.dart';

@JsonSerializable()
class DataApi {
  final String name;
  final String street;
  final String city;
  final double longitude;
  final double latitude;

  DataApi(this.name, this.street, this.city, this.longitude, this.latitude);
  factory DataApi.fromJson(Map<String, dynamic> json) =>
      _$DataApiFromJson(json);
  Map<String, dynamic> toJson() => _$DataApiToJson(this);
}
