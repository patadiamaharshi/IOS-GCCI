import 'package:flutter/material.dart';
import 'package:gcci/ui/home/dashboard/dashboard_screen.dart';
import '../../../helper/shared_keys.dart';
import '../../../network/api_service/api_service.dart';
import '../../../network/model/profile_list_response.dart';
import '../../../utils/pref_helper.dart';

class SystemProfileViewModel extends ChangeNotifier {
  List<ProfileList> userProfile = [];
  bool isLoading = false;
  String? errorMessage;

  SystemProfileViewModel(/*List<dynamic> profileList*/) {
    // userProfile = profileList;
    notifyListeners();
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  Future<void> loadInitialData(BuildContext context) async {
    await getProfileList(context);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getProfileList(BuildContext context) async {
    final mobile = await Prefs.getData(SharedKeys.mobileNO);
    debugPrint("----- $mobile");
    _setLoading(true);
    try {
      final requestBody = {"mobile": mobile};

      final response = await ApiService.instance.post<ProfileListResponse>(
      //  context,
        "getProfileList",
        body: requestBody,
        fromJson: (data) => ProfileListResponse.fromJson(data),
      );
      // final response = await HomeService.instance.getProfileList(
      //   requestBody,
      //   context,
      // );
      userProfile = response.data.profileList ?? [];

      if (response.data.action == "Failed") {
        setError(response.data.message ?? "User verification failed.");

        Future.delayed(const Duration(seconds: 2), () {
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Dashboard()),
          );
        });
      }
    } catch (e) {
      debugPrint('Error getProfileList System profile screen 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  onMemberSelected(BuildContext context, ProfileList member) async {
    await Prefs.putData(SharedKeys.isProfileSelected, true);
    // await Prefs.putData(SharedKeys.isLogin, true);
    await Prefs.putData(SharedKeys.memberId, member.memberId);
    await Prefs.putObject(SharedKeys.member, member);

    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Dashboard()),
      (Route<dynamic> route) => false,
    );

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const Dashboard()),
    // );
  }
}

/*
I/flutter (13597): ║    {
I/flutter (13597): ║         "profile_list": [
I/flutter (13597): ║            {
I/flutter (13597): ║                 "member_id": "ZWxyMWVveWNvRnNHTzZsTXVKTHRLQT09",
I/flutter (13597): ║                 "member_code": "0",
I/flutter (13597): ║                 "member_name": "company",
I/flutter (13597): ║                 "member_type": "",
I/flutter (13597): ║                 "member_category": "",
I/flutter (13597): ║                 "member_fdate": "",
I/flutter (13597): ║                 "member_tdate": "",
I/flutter (13597): ║                 "member_status": "New",
I/flutter (13597): ║                 "member_mobileno": "1121111113",
I/flutter (13597): ║                 "member_email": "texet1@gmail.com",
I/flutter (13597): ║                 "member_address": " ",
I/flutter (13597): ║                 "member_gstno": "",
I/flutter (13597): ║                 "member_rep1_voting_no": "",
I/flutter (13597): ║                 "member_rep1_fname": "f",
I/flutter (13597): ║                 "member_rep1_lname": "",
I/flutter (13597): ║                 "member_rep1_designation": "",
I/flutter (13597): ║                 "member_rep1_mobile": "",
I/flutter (13597): ║                 "member_rep1_emailid": "",
I/flutter (13597): ║                 "member_rep1_photo": "https://www.gujaratchamber.org/member_photo/",
I/flutter (13597): ║                 "member_rep2_voting_no": "",
I/flutter (13597): ║                 "member_rep2_fname": "",
I/flutter (13597): ║                 "member_rep2_lname": "",
I/flutter (13597): ║                 "member_rep2_designation": "",
I/flutter (13597): ║                 "member_rep2_mobile": "",
I/flutter (13597): ║                 "member_rep2_emailid": "",
I/flutter (13597): ║                 "member_rep2_photo": "https://www.gujaratchamber.org/member_photo/"
I/flutter (13597): ║            }
I/flutter (13597): ║         ]
I/flutter (13597): ║    }*/
