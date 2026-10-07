import 'dart:convert';

class MemberShipCategoryResponse {
  final List<Category> memberShipCategory;

  MemberShipCategoryResponse({required this.memberShipCategory});

  factory MemberShipCategoryResponse.fromJson(Map<String, dynamic> json) {
    return MemberShipCategoryResponse(
      memberShipCategory:
          (json['MembershipCategoryList'] as List<dynamic>? ?? [])
              .map((e) => Category.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MembershipCategoryList': memberShipCategory
          .map((e) => e.toJson())
          .toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Category {
  final String? categoryId;
  final String? categoryName;

  Category({this.categoryId, this.categoryName});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'category_name': categoryName};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
