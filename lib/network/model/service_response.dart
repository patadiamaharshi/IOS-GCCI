import 'dart:convert';

class ServiceResponse {
  final List<ServiceModel> services;

  ServiceResponse({required this.services});

  factory ServiceResponse.fromJson(Map<String, dynamic> json) {
    return ServiceResponse(
      services: (json['services'] as List<dynamic>? ?? [])
          .map((e) => ServiceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'services': services.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

class ServiceModel {
  final String? serviceId;
  final String? serviceName;

  final String? serviceHoliday;
  final String? serviceSaturday;
  final String? serviceSunday;

  final String? memberServiceAmount;
  final String? memberHolidayServicesRate;
  final String? memberAdditionalHoursServicesRate;
  final String? memberAdditionalHolidayServicesHoursRate;
  final String? memberFulldayWeekdayServicesRate;
  final String? memberFulldayHolidayServicesRate;

  final String? nonMemberServicesRate;
  final String? nonMemberHolidayServicesRate;
  final String? additionalHoursNonMemberServicesRate;
  final String? additionalHoursNonMemberHolidayServicesRate;
  final String? nonMemberFulldayWeekdayServicesRate;
  final String? nonMemberFulldayHolidayServicesRate;

  ServiceModel({
    this.serviceId,
    this.serviceName,
    this.serviceHoliday,
    this.serviceSaturday,
    this.serviceSunday,
    this.memberServiceAmount,
    this.memberHolidayServicesRate,
    this.memberAdditionalHoursServicesRate,
    this.memberAdditionalHolidayServicesHoursRate,
    this.memberFulldayWeekdayServicesRate,
    this.memberFulldayHolidayServicesRate,
    this.nonMemberServicesRate,
    this.nonMemberHolidayServicesRate,
    this.additionalHoursNonMemberServicesRate,
    this.additionalHoursNonMemberHolidayServicesRate,
    this.nonMemberFulldayWeekdayServicesRate,
    this.nonMemberFulldayHolidayServicesRate,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['service_id']?.toString(),
      serviceName: json['service_name']?.toString(),

      serviceHoliday: json['service_holiday']?.toString(),
      serviceSaturday: json['service_saturday']?.toString(),
      serviceSunday: json['service_sunday']?.toString(),

      memberServiceAmount: json['member_service_amount']?.toString(),
      memberHolidayServicesRate:
      json['member_holiday_services_rate']?.toString(),
      memberAdditionalHoursServicesRate:
      json['member_additional_hours_services_rate']?.toString(),
      memberAdditionalHolidayServicesHoursRate:
      json['member_additional_holiday_services_hours_rate']?.toString(),
      memberFulldayWeekdayServicesRate:
      json['member_fullday_weekday_services_rate']?.toString(),
      memberFulldayHolidayServicesRate:
      json['member_fullday_holiday_services_rate']?.toString(),

      nonMemberServicesRate:
      json['non_member_services_rate']?.toString(),
      nonMemberHolidayServicesRate:
      json['non_member_holiday_services_rate']?.toString(),
      additionalHoursNonMemberServicesRate:
      json['additional_hours_non_member_services_rate']?.toString(),
      additionalHoursNonMemberHolidayServicesRate:
      json['additional_hours_non_member_holiday_services_rate']
          ?.toString(),
      nonMemberFulldayWeekdayServicesRate:
      json['non_member_fullday_weekday_services_rate']?.toString(),
      nonMemberFulldayHolidayServicesRate:
      json['non_member_fullday_holiday_services_rate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'service_name': serviceName,

      'service_holiday': serviceHoliday,
      'service_saturday': serviceSaturday,
      'service_sunday': serviceSunday,

      'member_service_amount': memberServiceAmount,
      'member_holiday_services_rate': memberHolidayServicesRate,
      'member_additional_hours_services_rate':
      memberAdditionalHoursServicesRate,
      'member_additional_holiday_services_hours_rate':
      memberAdditionalHolidayServicesHoursRate,
      'member_fullday_weekday_services_rate':
      memberFulldayWeekdayServicesRate,
      'member_fullday_holiday_services_rate':
      memberFulldayHolidayServicesRate,

      'non_member_services_rate': nonMemberServicesRate,
      'non_member_holiday_services_rate':
      nonMemberHolidayServicesRate,
      'additional_hours_non_member_services_rate':
      additionalHoursNonMemberServicesRate,
      'additional_hours_non_member_holiday_services_rate':
      additionalHoursNonMemberHolidayServicesRate,
      'non_member_fullday_weekday_services_rate':
      nonMemberFulldayWeekdayServicesRate,
      'non_member_fullday_holiday_services_rate':
      nonMemberFulldayHolidayServicesRate,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}