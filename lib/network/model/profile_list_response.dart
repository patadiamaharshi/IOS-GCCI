import 'dart:convert';

import '../../helper/json_helper.dart';

class ProfileListResponse {
  String? action;
  String? message;
  List<ProfileList>? profileList;

  ProfileListResponse({this.action, this.message, this.profileList});

  factory ProfileListResponse.fromJson(Map<String, dynamic> json) {
    return ProfileListResponse(
      action: json['action'],
      message: json['message'],
      profileList: json['profile_list'] != null
          ? List<ProfileList>.from(
              (json['profile_list'] as List).map(
                (e) => ProfileList.fromJson(e),
              ),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'action': action,
      'message': message,
      'profile_list': profileList?.map((x) => x.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class ProfileList {
  final String memberId;
  final String? memberCode;
  final String? memberName;
  final String? memberType;
  final String? memberCategory;
  final String? memberFdate;
  final String? memberTdate;
  final String? memberStatus;
  final String? memberMobileno;
  final String? memberEmail;
  final String? memberAddress;
  final String memberGstno;

  final String memberRep1VotingNo;
  final String memberRep1Fname;
  final String memberRep1Lname;
  final String memberRep1Designation;
  final String memberRep1Mobile;
  final String memberRep1Emailid;
  final String memberRep1Photo;

  final String memberRep2VotingNo;
  final String memberRep2Fname;
  final String memberRep2Lname;
  final String memberRep2Designation;
  final String memberRep2Mobile;
  final String memberRep2Emailid;
  final String memberRep2Photo;

  ProfileList({
    required this.memberId,
    this.memberCode,
    this.memberName,
    required this.memberType,
    this.memberCategory,
    this.memberFdate,
    this.memberTdate,
    this.memberStatus,
    this.memberMobileno,
    this.memberEmail,
    this.memberAddress,
    required this.memberGstno,
    required this.memberRep1VotingNo,
    required this.memberRep1Fname,
    required this.memberRep1Lname,
    required this.memberRep1Designation,
    required this.memberRep1Mobile,
    required this.memberRep1Emailid,
    required this.memberRep1Photo,
    required this.memberRep2VotingNo,
    required this.memberRep2Fname,
    required this.memberRep2Lname,
    required this.memberRep2Designation,
    required this.memberRep2Mobile,
    required this.memberRep2Emailid,
    required this.memberRep2Photo,
  });

  factory ProfileList.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return ProfileList(
        memberId: '',
        memberCode: '',
        memberName: '',
        memberType: '',
        memberCategory: '',
        memberFdate: '',
        memberTdate: '',
        memberStatus: '',
        memberMobileno: '',
        memberEmail: '',
        memberAddress: '',
        memberGstno: '',
        memberRep1VotingNo: '',
        memberRep1Fname: '',
        memberRep1Lname: '',
        memberRep1Designation: '',
        memberRep1Mobile: '',
        memberRep1Emailid: '',
        memberRep1Photo: '',
        memberRep2VotingNo: '',
        memberRep2Fname: '',
        memberRep2Lname: '',
        memberRep2Designation: '',
        memberRep2Mobile: '',
        memberRep2Emailid: '',
        memberRep2Photo: '',
      );
    }

    return ProfileList(
      memberId: json['member_id']?.toString() ?? '',
      memberCode: JsonHelper.getString(json['member_code']),
      memberName: JsonHelper.getString(json['member_name']),
      memberType: json['member_type']?.toString() ?? '',
      memberCategory: JsonHelper.getString(json['member_category']),

      //json['member_category']?.toString() ?? '',
      memberFdate:JsonHelper.getString(json['member_fdate']),
      memberTdate:JsonHelper.getString(json['member_tdate']),
      memberStatus: JsonHelper.getString(json['member_status']),
      memberMobileno: JsonHelper.getString(json['member_mobileno']),
      memberEmail: JsonHelper.getString(json['member_email']),
      memberAddress: JsonHelper.getString(json['member_address']),
      memberGstno: json['member_gstno']?.toString() ?? '',

      memberRep1VotingNo: json['member_rep1_voting_no']?.toString() ?? '',
      memberRep1Fname: json['member_rep1_fname']?.toString() ?? '',
      memberRep1Lname: json['member_rep1_lname']?.toString() ?? '',
      memberRep1Designation: json['member_rep1_designation']?.toString() ?? '',
      memberRep1Mobile: json['member_rep1_mobile']?.toString() ?? '',
      memberRep1Emailid: json['member_rep1_emailid']?.toString() ?? '',
      memberRep1Photo: json['member_rep1_photo']?.toString() ?? '',

      memberRep2VotingNo: json['member_rep2_voting_no']?.toString() ?? '',
      memberRep2Fname: json['member_rep2_fname']?.toString() ?? '',
      memberRep2Lname: json['member_rep2_lname']?.toString() ?? '',
      memberRep2Designation: json['member_rep2_designation']?.toString() ?? '',
      memberRep2Mobile: json['member_rep2_mobile']?.toString() ?? '',
      memberRep2Emailid: json['member_rep2_emailid']?.toString() ?? '',
      memberRep2Photo: json['member_rep2_photo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'member_id': memberId,
    'member_code': memberCode,
    'member_name': memberName,
    'member_type': memberType,
    'member_category': memberCategory,
    'member_fdate': memberFdate,
    'member_tdate': memberTdate,
    'member_status': memberStatus,
    'member_mobileno': memberMobileno,
    'member_email': memberEmail,
    'member_address': memberAddress,
    'member_gstno': memberGstno,
    'member_rep1_voting_no': memberRep1VotingNo,
    'member_rep1_fname': memberRep1Fname,
    'member_rep1_lname': memberRep1Lname,
    'member_rep1_designation': memberRep1Designation,
    'member_rep1_mobile': memberRep1Mobile,
    'member_rep1_emailid': memberRep1Emailid,
    'member_rep1_photo': memberRep1Photo,
    'member_rep2_voting_no': memberRep2VotingNo,
    'member_rep2_fname': memberRep2Fname,
    'member_rep2_lname': memberRep2Lname,
    'member_rep2_designation': memberRep2Designation,
    'member_rep2_mobile': memberRep2Mobile,
    'member_rep2_emailid': memberRep2Emailid,
    'member_rep2_photo': memberRep2Photo,
  };

  @override
  String toString() => jsonEncode(toJson());
}
