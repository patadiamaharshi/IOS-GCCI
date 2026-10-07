import 'dart:convert';

class SizeBusinessResponse {
  final List<SizeBusiness> sizeBusiness;

  SizeBusinessResponse({required this.sizeBusiness});

  factory SizeBusinessResponse.fromJson(Map<String, dynamic> json) {
    return SizeBusinessResponse(
      sizeBusiness:
      (json['SizeOfBusiness'] as List<dynamic>? ?? [])
          .map((e) => SizeBusiness.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SizeOfBusiness':
      sizeBusiness.map((e) => e.toJson()).toList()
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class SizeBusiness {
  final String? businessSizeId;
  final String? businessSize;

  SizeBusiness({
    this.businessSizeId,
    this.businessSize,
  });

  factory SizeBusiness.fromJson(Map<String, dynamic> json) {
    return SizeBusiness(
      businessSizeId: json['business_size_id']?.toString() ?? '',
      businessSize: json['business_size']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_size_id': businessSizeId,
      'business_size': businessSize,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}