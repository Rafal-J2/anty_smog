import 'package:dio/dio.dart';

Future<List<dynamic>> fetchApiData() async {
  var dio = Dio();
  final response = await dio.get('https://public-esa.ose.gov.pl/api/v1/smog');
  if (response.statusCode == 200) {
    return response.data['smog_data'];
  } else {
    throw Exception('Failed to load data');
  }
}

Future<List<dynamic>> fetchStations() async {
  var dio = Dio();
  final response = await dio.get('https://api.gios.gov.pl/pjp-api/rest/station/findAll');
  if (response.statusCode == 200) {
    return response.data; 
  } else {
    throw Exception('Failed to load stations');
  }
}

Future<List<dynamic>> fetchStationSensors(int stationId) async {
  var dio = Dio();
  final response = await dio.get('https://api.gios.gov.pl/pjp-api/rest/station/sensors/$stationId');
  if (response.statusCode == 200) {
    return response.data;
  } else {
    throw Exception('Failed to load sensors for station $stationId');
  }
}

Future<Map<String, dynamic>> fetchSensorData(int sensorId) async {
  var dio = Dio();
  final response = await dio.get('https://api.gios.gov.pl/pjp-api/rest/data/getData/$sensorId');
  if (response.statusCode == 200) {
    return response.data; 
  } else {
    throw Exception('Failed to load sensor data for sensor $sensorId');
  }
}
