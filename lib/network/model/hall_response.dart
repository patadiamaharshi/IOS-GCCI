import 'dart:convert';

class HallResponse {
  final List<HallModel> halls;

  HallResponse({required this.halls});

  factory HallResponse.fromJson(Map<String, dynamic> json) {
    return HallResponse(
      halls: (json['halls'] as List<dynamic>? ?? [])
          .map((e) => HallModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'halls': halls.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class HallModel {
  final String? hallId;
  final String? hallName;
  final String? hallCapacity;
  final String? hallHours;
  final String? holiday;
  final String? sunday;
  final String? saturday;

  final String? memberHallRate;
  final String? memberHolidayHallRate;
  final String? memberAdditionalHoursRate;
  final String? memberAdditionalHolidayHoursRate;
  final String? memberFulldayWeekdayRate;
  final String? memberFulldayHolidayRate;

  final String? nonMemberHourRate;
  final String? nonMemberHolidayHourRate;
  final String? additionalNonMemberHoursRate;
  final String? additionalNonMemberHolidayHoursRate;
  final String? nonMemberFulldayWeekday;
  final String? nonMemberFulldayHoliday;

  HallModel({
    this.hallId,
    this.hallName,
    this.hallCapacity,
    this.hallHours,
    this.holiday,
    this.sunday,
    this.saturday,
    this.memberHallRate,
    this.memberHolidayHallRate,
    this.memberAdditionalHoursRate,
    this.memberAdditionalHolidayHoursRate,
    this.memberFulldayWeekdayRate,
    this.memberFulldayHolidayRate,
    this.nonMemberHourRate,
    this.nonMemberHolidayHourRate,
    this.additionalNonMemberHoursRate,
    this.additionalNonMemberHolidayHoursRate,
    this.nonMemberFulldayWeekday,
    this.nonMemberFulldayHoliday,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      hallId: json['hall_id']?.toString() ?? '',
      hallName: json['getHall']?.toString() ?? '',
      hallCapacity: json['hall_capacity']?.toString() ?? '',
      hallHours: json['hall_hours']?.toString() ?? '',
      holiday: json['holiday']?.toString() ?? '',
      sunday: json['sunday']?.toString() ?? '',
      saturday: json['saturday']?.toString() ?? '',
      memberHallRate: json['member_hall_rate']?.toString() ?? '',
      memberHolidayHallRate:
      json['member_holiday_hall_rate']?.toString() ?? '',
      memberAdditionalHoursRate:
      json['member_additional_hours_rate']?.toString() ?? '',
      memberAdditionalHolidayHoursRate:
      json['member_additional_holiday_hours_rate']?.toString() ?? '',
      memberFulldayWeekdayRate:
      json['member_fullday_weekday_rate']?.toString() ?? '',
      memberFulldayHolidayRate:
      json['member_fullday_holiday_rate']?.toString() ?? '',
      nonMemberHourRate: json['non_member_hour_rate']?.toString() ?? '',
      nonMemberHolidayHourRate:
      json['non_member_holiday_hour_rate']?.toString() ?? '',
      additionalNonMemberHoursRate:
      json['additional_non_member_hours_rate']?.toString() ?? '',
      additionalNonMemberHolidayHoursRate:
      json['additional_non_member_holiday_hours_rate']?.toString() ?? '',
      nonMemberFulldayWeekday:
      json['non_member_fullday_weekday']?.toString() ?? '',
      nonMemberFulldayHoliday:
      json['non_member_fullday_holiday']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hall_id': hallId,
      'getHall': hallName,
      'hall_capacity': hallCapacity,
      'hall_hours': hallHours,
      'holiday': holiday,
      'sunday': sunday,
      'saturday': saturday,
      'member_hall_rate': memberHallRate,
      'member_holiday_hall_rate': memberHolidayHallRate,
      'member_additional_hours_rate': memberAdditionalHoursRate,
      'member_additional_holiday_hours_rate':
      memberAdditionalHolidayHoursRate,
      'member_fullday_weekday_rate': memberFulldayWeekdayRate,
      'member_fullday_holiday_rate': memberFulldayHolidayRate,
      'non_member_hour_rate': nonMemberHourRate,
      'non_member_holiday_hour_rate': nonMemberHolidayHourRate,
      'additional_non_member_hours_rate':
      additionalNonMemberHoursRate,
      'additional_non_member_holiday_hours_rate':
      additionalNonMemberHolidayHoursRate,
      'non_member_fullday_weekday': nonMemberFulldayWeekday,
      'non_member_fullday_holiday': nonMemberFulldayHoliday,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
/*
class HallModel {
  final String? hallId;
  final String? hallName;
  final String? hallCapacity;
  final String? hallHours;
  final String? hallAmount;

  HallModel({
    this.hallId,
    this.hallName,
    this.hallCapacity,
    this.hallHours,
    this.hallAmount,
  });

  factory HallModel.fromJson(Map<String, dynamic> json) {
    return HallModel(
      hallId: json['hall_id']?.toString() ?? '',
      hallName: json['getHall']?.toString() ?? '',
      hallCapacity: json['hall_capacity']?.toString() ?? '',
      hallHours: json['hall_hours']?.toString() ?? '',
      hallAmount: json['hall_amount']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hall_id': hallId,
      'getHall': hallName,
      'hall_capacity': hallCapacity,
      'hall_hours': hallHours,
      'hall_amount': hallAmount,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}*/
