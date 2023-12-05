// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferencesHelper {
//   static Future<void> saveData(String key, int value) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.setInt(key, value);
//     } catch (e) {
//       print('Failed to save data: $e');
//     }
//   }

//   static Future<int?> loadData(String key) async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       return prefs.getInt(key);
//     } catch (e) {
//       print('Failed to load data: $e');
//     }
//     return null;
//   }
// }