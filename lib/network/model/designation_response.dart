import 'dart:convert';

class DesignationResponse {
  final List<Designation> designation;

  DesignationResponse({required this.designation});

  factory DesignationResponse.fromJson(Map<String, dynamic> json) {
    return DesignationResponse(
      designation: (json['noRepDesignationList'] as List<dynamic>? ?? [])
          .map((e) => Designation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noRepDesignationList': designation.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Designation {
  final String? designation;

  Designation({this.designation});

  factory Designation.fromJson(Map<String, dynamic> json) {
    return Designation(designation: json['designation']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'designation': designation};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
