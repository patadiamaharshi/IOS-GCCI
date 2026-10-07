import 'dart:convert';

class PrefixResponse {
  final List<Prefix> prefix;

  PrefixResponse({required this.prefix});

  factory PrefixResponse.fromJson(Map<String, dynamic> json) {
    return PrefixResponse(
      prefix: (json['prefixList'] as List<dynamic>? ?? [])
          .map((e) => Prefix.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'prefixList': prefix.map((e) => e.toJson()).toList()};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Prefix {
  final String? prefix;

  Prefix({this.prefix});

  factory Prefix.fromJson(Map<String, dynamic> json) {
    return Prefix(prefix: json['prefix']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'prefix': prefix};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
