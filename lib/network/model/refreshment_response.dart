import 'dart:convert';

class RefreshmentResponse {
  final List<RefreshmentModel> refreshment;

  RefreshmentResponse({required this.refreshment});

  factory RefreshmentResponse.fromJson(Map<String, dynamic> json) {
    return RefreshmentResponse(
      refreshment: (json['refreshment'] as List<dynamic>? ?? [])
          .map((e) => RefreshmentModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refreshment': refreshment.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class RefreshmentModel {
  final String? refreshmentId;
  final String? refreshmentName;
  final String? refreshmentAmount;

  RefreshmentModel({
    this.refreshmentId,
    this.refreshmentName,
    this.refreshmentAmount,
  });

  factory RefreshmentModel.fromJson(Map<String, dynamic> json) {
    return RefreshmentModel(
      refreshmentId: json['refreshment_id']?.toString() ?? '',
      refreshmentName: json['refreshment_name']?.toString() ?? '',
      refreshmentAmount: json['refreshment_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refreshment_id': refreshmentId,
      'refreshment_name': refreshmentName,
      'refreshment_amount': refreshmentAmount,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}