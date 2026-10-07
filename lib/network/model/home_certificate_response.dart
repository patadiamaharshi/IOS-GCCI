import '../../helper/json_helper.dart';

class HomeResponse {
  final String? certificateLink;
  final String? welcomeLink;
  final String? icardLink;
  final String? memberCode;
  final String? memberName;
  final String? memberMobile;
  final String? memberType;
  final String? noRep;

  HomeResponse({
    this.certificateLink,
    this.welcomeLink,
    this.icardLink,
    this.memberCode,
    this.memberName,
    this.memberMobile,
    this.memberType,
    this.noRep
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      certificateLink: json['certificateLink']?.toString() ?? '',
      welcomeLink: json['welcomeLink']?.toString() ?? '',
      icardLink: json['icardLink']?.toString() ?? '',
      memberCode: json['member_code']?.toString() ?? '',
      memberName: json['member_name']?.toString() ?? '',
      memberMobile: json['member_mobile']?.toString() ?? '',
      memberType: json['member_type']?.toString() ?? '',
      noRep: JsonHelper.getString(json['noRep']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificateLink': certificateLink,
      'welcomeLink': welcomeLink,
      'icardLink': icardLink,
      'member_code': memberCode,
      'member_name': memberName,
      'member_mobile': memberMobile,
      'member_type': memberType,
      'noRep': noRep,
    };
  }
}
