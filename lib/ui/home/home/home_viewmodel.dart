import 'package:flutter/material.dart';
import '../../../helper/shared_keys.dart';
import '../../../helper/file_downloader.dart';
import '../../../network/api_service/api_service.dart';
import '../../../network/model/home_certificate_response.dart';
import '../../../utils/pref_helper.dart';
import '../../auth/user_type/association/association.dart';
import '../../auth/user_type/non_voting/register_non_voting.dart';
import '../../auth/user_type/user_type.dart';
import '../../auth/user_type/voting/register_voting.dart';

class HomeViewModel extends ChangeNotifier {
  bool isLoading = false;
  bool becameMember = false;
  List<Map<String, dynamic>> idCard = [];
  List<Map<String, dynamic>> certificate = [];
  String? memberName;
  String? mobile;
  String? memberType;
  String? memberCode;
  String btnText = "Became a member";
  int repCount = 0;

  Future<void> loadInitialData(BuildContext context) async {
    await getCertificateList(context);
  }

  Future<void> getCertificateList(BuildContext context) async {
    _setLoading(true);

    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = {"member_id": memberID.toString()};

    try {
      final response = await ApiService.instance.post<HomeResponse>(
        body: requestBody,
        "profileIDCertificateLetter",
        fromJson: (data) => HomeResponse.fromJson(data),
      );
      idCard = [
        {"title": "ID Card", "link": response.data.icardLink},
      ];
      certificate = [
        {"title": "Certificate", "link": response.data.certificateLink},
        {"title": "Welcome Letter", "link": response.data.welcomeLink},
      ];

      memberName = response.data.memberName ?? "";
      mobile = response.data.memberMobile ?? "";
      memberCode = response.data.memberCode ?? "";
      memberType = response.data.memberType ?? "";
      repCount = int.tryParse(response.data.noRep ?? "0") ?? 0;

      debugPrint("repCount Home --------- $repCount");

      if (memberCode == "0") {
        becameMember = true;
        if ((memberType ?? "").isNotEmpty) {
          btnText = "Complete your profile";
        } else {
          btnText = "Became a member";
        }
      } else {
        becameMember = false;
        btnText = "Became a member";
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error getCertificateList Home 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  navigateTo(BuildContext context) {
    debugPrint("memberType Home -- $memberType");

    if (memberType == "Voting") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterVotingScreen(repCount: repCount),
        ),
      );
    } else if (memberType == "Non-Voting") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterNonVotingScreen(repCount: repCount),
        ),
      );
    } else if (memberType == "Association") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Association(repCount: repCount)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => UserTypeScreen(repCount: repCount)),
      );
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  onDownloadClick(linkUrl) async {
    debugPrint(" download file url ----------------- $linkUrl");
    FileDownloader.instance.downloadFile(url: linkUrl);
  }
}
