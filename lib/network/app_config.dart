import 'dart:developer' as developer;
import '../helper/shared_keys.dart';
import '../utils/pref_helper.dart';

enum Flavor { dev, prod }

class AppConfig {
  static Flavor appFlavor = Flavor.dev;

  static String get baseUrl {
    switch (appFlavor) {
      case Flavor.prod:
        return "https://prod.api.example.com/api/";
      case Flavor.dev:
        return "https://www.gujaratchamber.org/api/api.php/";
    }
  }

  static Future<String?> getToken() async {
    final token = await Prefs.getData(SharedKeys.accessToken);
    developer.log('getToken --> $token', name: 'AppConfig');
    return token;
  }

  static Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }
}
