import 'dart:convert';

class NatureBusinessResponse {
  final List<NatureBusiness> natureBusiness;

  NatureBusinessResponse({required this.natureBusiness});

  factory NatureBusinessResponse.fromJson(Map<String, dynamic> json) {
    return NatureBusinessResponse(
      natureBusiness:
      (json['NatureOfBusiness'] as List<dynamic>? ?? [])
          .map((e) => NatureBusiness.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NatureOfBusiness':
      natureBusiness.map((e) => e.toJson()).toList()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class NatureBusiness {
  final String? natureBusinessId;
  final String? natureBusinessName;

  NatureBusiness({
    this.natureBusinessId,
    this.natureBusinessName,
  });

  factory NatureBusiness.fromJson(Map<String, dynamic> json) {
    return NatureBusiness(
      natureBusinessId: json['nature_of_business_id']?.toString() ?? '',
      natureBusinessName: json['nature_of_business_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nature_of_business_id': natureBusinessId,
      'nature_of_business_name': natureBusinessName,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}