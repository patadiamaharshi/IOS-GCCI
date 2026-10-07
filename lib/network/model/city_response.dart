import 'dart:convert';

class CityResponse {
  final List<CityList> city;

  CityResponse({required this.city});

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      city: (json['cityList'] as List<dynamic>? ?? [])
          .map((e) => CityList.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'cityList': city.map((e) => e.toJson()).toList()};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class CityList {
  final String? cityId;
  final String? cityName;

  CityList({this.cityId, this.cityName});

  factory CityList.fromJson(Map<String, dynamic> json) {
    return CityList(
      cityId: json['city_id']?.toString() ?? '',
      cityName: json['city_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'city_id': cityId, 'city_name': cityName};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
