import 'dart:convert';

class CountryResponse {
  final List<Country> country;

  CountryResponse({required this.country});

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      country: (json['countryList'] as List<dynamic>? ?? [])
          .map((e) => Country.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'countryList': country.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Country {
  final String? countryId;
  final String? countryName;
  final String? countryDefault;

  Country({
    this.countryId,
    this.countryName,
    this.countryDefault,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryId: json['country_id']?.toString() ?? '',
      countryName: json['country_name']?.toString() ?? '',
      countryDefault: json['country_defalut']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country_id': countryId,
      'country_name': countryName,
      'country_defalut': countryDefault,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}