// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataApi _$DataApiFromJson(Map<String, dynamic> json) => DataApi(
      json['name'] as String,
      json['street'] as String,
      json['city'] as String,
      (json['longitude'] as num).toDouble(),
      (json['latitude'] as num).toDouble(),
    );

Map<String, dynamic> _$DataApiToJson(DataApi instance) => <String, dynamic>{
      'name': instance.name,
      'street': instance.street,
      'city': instance.city,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
