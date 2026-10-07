import 'dart:convert';

class LocationResponse {
  final List<Location> location;

  LocationResponse({required this.location});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      location: (json['location'] as List<dynamic>? ?? [])
          .map((e) => Location.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Location {
  final String? locationId;
  final String? locationName;

  Location({
    this.locationId,
    this.locationName,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationId: json['location_id']?.toString() ?? '',
      locationName: json['location_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'location_name': locationName,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
