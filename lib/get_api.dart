import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<dynamic>> fetchApiData() async {
  final response = await http.get(Uri.parse('https://public-esa.ose.gov.pl/api/v1/smog'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body)['smog_data'];
  } else {
    throw Exception('Failed to load data');
  }
}