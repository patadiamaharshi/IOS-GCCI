class JsonHelper {
  /// String safe
  static String getString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  /// int safe
  static int getInt(dynamic value) {
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  /// double safe
  static double getDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  /// bool safe
  static bool getBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString() == "1" || value.toString().toLowerCase() == "true";
  }

  /// List safe
  // static List getList(dynamic value) {
  //   if (value == null) return [];
  //   return value as List;
  // }

  static List<T> getList<T>(dynamic value, T Function(dynamic e) fromJson) {
    if (value == null) return [];

    return (value as List).map((e) => fromJson(e)).toList();
  }
}

// "member_additional_holiday_services_hours_rate": "0.00",
// "additional_hours_non_member_holiday_services_rate": "0.00",



