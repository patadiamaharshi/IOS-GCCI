import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // Save any data type (String, int, bool, double)
  static Future<bool> putData(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is double) {
      return await sharedPreferences.setDouble(key, value);
    } else {
      throw Exception("Unsupported data type");
    }
  }

  static Future<dynamic> getData(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }

  static Future<dynamic> putObject(String key,dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    String dataJson = jsonEncode(data.toJson()); // Convert object to JSON string
    await prefs.setString(key, dataJson);
  }

  static Future<dynamic> getObject(String key) async{
    final prefs = await SharedPreferences.getInstance();
    String? dataJson = prefs.getString(key); // Retrieve stored JSON
    if (dataJson == null) return null; // Handle null case
    return jsonDecode(dataJson);
  }

  static Future<bool> clearAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.clear();
  }
}