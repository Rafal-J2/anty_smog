import 'package:http/http.dart' as http;
import 'dart:convert';

  Future<List<dynamic>> fetchStations() async {
    final response = await http.get(Uri.parse('https://api.gios.gov.pl/pjp-api/rest/station/findAll'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<List<dynamic>> fetchStationSensors(int stationId) async {
  final response = await http.get(Uri.parse('https://api.gios.gov.pl/pjp-api/rest/station/sensors/$stationId'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load sensors');
  }
}


Future<Map<String, dynamic>> fetchSensorData(int sensorId) async {
  final response = await http.get(Uri.parse('https://api.gios.gov.pl/pjp-api/rest/data/getData/$sensorId'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load sensor data');
  }
}
