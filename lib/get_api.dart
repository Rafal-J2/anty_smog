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