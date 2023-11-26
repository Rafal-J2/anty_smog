// To parse this JSON data, do
//
//     final smog = smogFromJson(jsonString);

import 'dart:convert';

Smog smogFromJson(String str) => Smog.fromJson(json.decode(str));

String smogToJson(Smog data) => json.encode(data.toJson());

class Smog {
    List<SmogDatum> smogData;
    bool itHasNextPage;
    dynamic pagesTotal;

    Smog({
        required this.smogData,
        required this.itHasNextPage,
        required this.pagesTotal,
    });

    factory Smog.fromJson(Map<String, dynamic> json) => Smog(
        smogData: List<SmogDatum>.from(json["smog_data"].map((x) => SmogDatum.fromJson(x))),
        itHasNextPage: json["it_has_next_page"],
        pagesTotal: json["pages_total"],
    );

    Map<String, dynamic> toJson() => {
        "smog_data": List<dynamic>.from(smogData.map((x) => x.toJson())),
        "it_has_next_page": itHasNextPage,
        "pages_total": pagesTotal,
    };
}

class SmogDatum {
    School school;
    Data data;
    DateTime timestamp;

    SmogDatum({
        required this.school,
        required this.data,
        required this.timestamp,
    });

    factory SmogDatum.fromJson(Map<String, dynamic> json) => SmogDatum(
        school: School.fromJson(json["school"]),
        data: Data.fromJson(json["data"]),
        timestamp: DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "school": school.toJson(),
        "data": data.toJson(),
        "timestamp": timestamp.toIso8601String(),
    };
}

class Data {
    double? humidityAvg;
    double? pressureAvg;
    double? temperatureAvg;
    double pm10Avg;
    double pm25Avg;

    Data({
        required this.humidityAvg,
        required this.pressureAvg,
        required this.temperatureAvg,
        required this.pm10Avg,
        required this.pm25Avg,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        humidityAvg: json["humidity_avg"]?.toDouble(),
        pressureAvg: json["pressure_avg"]?.toDouble(),
        temperatureAvg: json["temperature_avg"]?.toDouble(),
        pm10Avg: json["pm10_avg"]?.toDouble(),
        pm25Avg: json["pm25_avg"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "humidity_avg": humidityAvg,
        "pressure_avg": pressureAvg,
        "temperature_avg": temperatureAvg,
        "pm10_avg": pm10Avg,
        "pm25_avg": pm25Avg,
    };
}

class School {
    String name;
    String? street;
    String postCode;
    String city;
    String longitude;
    String latitude;

    School({
        required this.name,
        required this.street,
        required this.postCode,
        required this.city,
        required this.longitude,
        required this.latitude,
    });

    factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        street: json["street"],
        postCode: json["post_code"],
        city: json["city"],
        longitude: json["longitude"],
        latitude: json["latitude"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "street": street,
        "post_code": postCode,
        "city": city,
        "longitude": longitude,
        "latitude": latitude,
    };
}
