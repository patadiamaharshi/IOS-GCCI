import 'dart:convert';

class MajorActivityResponse {
  final List<MajorActivity> majorActivity;

  MajorActivityResponse({required this.majorActivity});

  factory MajorActivityResponse.fromJson(Map<String, dynamic> json) {
    return MajorActivityResponse(
      majorActivity: (json['majorActivityList'] as List<dynamic>? ?? [])
          .map((e) => MajorActivity.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'majorActivityList': majorActivity.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class MajorActivity {
  final String? activityName;

  MajorActivity({
    this.activityName,
  });

  factory MajorActivity.fromJson(Map<String, dynamic> json) {
    return MajorActivity(
      activityName: json['activityname']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityname': activityName,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}