import 'dart:convert';

class HouseResponse {
  final List<HouseList> houseList;

  HouseResponse({required this.houseList});

  factory HouseResponse.fromJson(Map<String, dynamic> json) {
    return HouseResponse(
      houseList: (json['houseList'] as List<dynamic>? ?? [])
          .map((e) => HouseList.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseList': houseList.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class HouseList {
  final String? house;

  HouseList({
    this.house,
  });

  factory HouseList.fromJson(Map<String, dynamic> json) {
    return HouseList(
      house: json['house']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'house': house,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}