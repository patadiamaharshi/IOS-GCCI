import 'dart:convert';

class HallSettingResponse {
  final List<HallSettingModel> hallSetting;

  HallSettingResponse({required this.hallSetting});

  factory HallSettingResponse.fromJson(Map<String, dynamic> json) {
    return HallSettingResponse(
      hallSetting: (json['hallSettings'] as List<dynamic>? ?? [])
          .map((e) => HallSettingModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hallSettings': hallSetting.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class HallSettingModel {
  final String? settingId;
  final String? settingsName;
  final String? settingAmount;

  HallSettingModel({
    this.settingId,
    this.settingsName,
    this.settingAmount,
  });

  factory HallSettingModel.fromJson(Map<String, dynamic> json) {
    return HallSettingModel(
      settingId: json['settings_id']?.toString() ?? '',
      settingsName: json['setting_name']?.toString() ?? '',
      settingAmount: json['setting_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'settings_id': settingId,
      'setting_name': settingsName,
      'setting_amount': settingAmount,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
