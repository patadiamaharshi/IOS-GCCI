import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../utils/pref_helper.dart';

class ReferenceViewModel extends ChangeNotifier {
  bool isLoading = false;

  final propMemNo = TextEditingController();
  final propMemName = TextEditingController();
  String? propErrMsg;
  List<String> propRepName = [];
  String? propRep = "";
  String? propMobileNo = "";
  bool showPropGetOtpBtn = false;
  bool showProMobileOTPBOX = false;
  final proMobileOTP = TextEditingController();
  bool propRetryOTP = false;
  bool propShowTimer = false;
  int propSeconds = 60;
  bool propShowResend = false;
  String? propOtpMsg = "";
  bool propReadOnly = false;

  final secMemNo = TextEditingController();
  final secMemName = TextEditingController();
  String? secErrMsg;
  List<String> secRepName = [];
  String? secRep = "";
  String? secMobileNo = "";
  bool showSecGetOtpBtn = false;
  bool showSecMobileOTPBOX = false;
  final secMobileOTP = TextEditingController();
  bool secRetryOTP = false;
  bool secShowTimer = false;
  int secSeconds = 60;
  bool secShowResend = false;
  String? secOtpMsg = "";
  bool secReadOnly = false;

  List<dynamic> propRepFullList = [];

  Timer? propTimer;
  Timer? secTimer;

  _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool get isVerify => propReadOnly && secReadOnly;

  // setError(String? message) {
  //   propOtpMsg = message;
  //   notifyListeners();
  // }

  ReferenceViewModel(BuildContext context) {
    getRefDetails();
  }

  void onMemNoChanged(BuildContext context, String memNo, String memType) {
    final isSame =
        propMemNo.text.isNotEmpty &&
        secMemNo.text.isNotEmpty &&
        propMemNo.text == secMemNo.text;

    if (isSame) {
      propErrMsg = "Proposer and Seconder cannot be same";
      secErrMsg = "Proposer and Seconder cannot be same";

      notifyListeners();
      return;
    }

    propErrMsg = null;
    secErrMsg = null;

    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      getMemberDetailFromCode(memNo, memType);
    });
  }

  void  onPropRepSelected(String value, String memType) {
    debugPrint("onPropRepSelected $value");

    final selectedRep = propRepFullList
        .cast<Map<String, dynamic>?>()
        .firstWhere((e) => e?['rep_name'] == value, orElse: () => null);
    if (selectedRep == null) return;

    final mobile = selectedRep['mobile_no']?.toString() ?? '';

    if (memType == "proposer") {
      propRep = value;
      propMobileNo = mobile;
      showPropGetOtpBtn = true;
    } else if (memType == "seconder") {
      secRep = value;
      secMobileNo = mobile;
      showSecGetOtpBtn = true;
    } else {
      return;
    }
    notifyListeners();
  }

  Future<void> getMemberDetailFromCode(
    String memNo,
    String memType,
  ) async {
    _setLoading(true);

    final requestBody = ({"member_code": memNo});

    try {
      final response = await ApiService.instance.post<dynamic>(
      //  context,
        "getMemberDetailsFromCode",
        body: requestBody,
      );

      final data = response.data?['representatives'] ?? [];
      propRepFullList = data;

      if (memType == "proposer") {
        propMemName.text = response.data?['member_name'] ?? '';
        propRepName = data
            .map<String>((e) => e['rep_name'].toString())
            .toList();
        propOtpMsg = "";
      } else if (memType == "seconder") {
        secMemName.text = response.data?['member_name'] ?? '';
        secRepName = data.map<String>((e) => e['rep_name'].toString()).toList();
        secOtpMsg = "";
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMobileOTP(
    BuildContext context,
    String memCode,
    String refNo,
    String memName,
    String repName,
    String mobNo,
    String memType,
  ) async {
    _setLoading(true);

    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = jsonEncode({
      "mid": memberID,
      "member_code": memCode,
      "member_name": memName,
      "rep_name": repName,
      "mobile_no": mobNo,
      "refNo": refNo,
    });

    debugPrint("------ ---- ----  $requestBody");
    try {
      final response = await ApiService.instance.post<dynamic>(
       // context,
        "sendRefOTP",
        body: requestBody,
      );

      final data = response.data;
      final message = data?['sendOTPResponse']?[0]?['msg']?.toString();

      if (message == "SUCCESS") {
        if (memType == "proposer") {
          showProMobileOTPBOX = true;
          showPropGetOtpBtn = false;
          propRetryOTP = true;
          startPropTimer();
        } else if (memType == "seconder") {
          showSecMobileOTPBOX = true;
          showSecGetOtpBtn = false;
          secRetryOTP = true;
          startSecTimer();
        }
        debugPrint("SUCCESS");
      } else {
        debugPrint("FAIL");
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void startPropTimer() {
    propTimer?.cancel();

    propSeconds = 60;
    propShowTimer = true;
    propShowResend = false;
    notifyListeners();

    propTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (propSeconds > 0) {
        propSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        propShowTimer = false;
        propShowResend = true;
        notifyListeners();
      }
    });
  }

  void startSecTimer() {
    secTimer?.cancel();

    secSeconds = 60;
    secShowTimer = true;
    secShowResend = false;
    notifyListeners();

    secTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secSeconds > 0) {
        secSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        secShowTimer = false;
        secShowResend = true;
        notifyListeners();
      }
    });
  }

  Future<void> verifyMobileOTP(
    BuildContext context,
    String otp,
    String refNo,
  ) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = jsonEncode({
      "mid": memberID,
      "otp": otp,
      "refNo": refNo,
    });

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "verifyRefOTP",
        body: requestBody,
      );

      final data = response.data;
      final message = data?['verifyRefOTPResponse']?[0]?['msg']?.toString();

      if (message == "VERIFIED") {
        if (refNo == "1") {
          showProMobileOTPBOX = false;
          propRetryOTP = false;
          //propOtpMsg = message;
        } else if (refNo == "2") {
          showSecMobileOTPBOX = false;
          secRetryOTP = false;
          //secOtpMsg = message;
        }
        getRefDetails();
      }

      if (message == "NOT VERIFIED") {
        if (refNo == "1") {
          propOtpMsg = message;
        } else if (refNo == "2") {
          secOtpMsg = message;
        }
      } else {
        debugPrint("FAIL");
      }
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getRefDetails() async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
      //  context,
        "getRefDetails",
        body: requestBody,
      );

      final res = response.data;

      if (res['proRefMember']['verification_status'] == "Verified") {
        propMemNo.text = res['proRefMember']['member_code'] ?? '';
        propMemName.text = res['proRefMember']['member_name'] ?? '';
        propReadOnly = true;
        propRep = res['proRefMember']['member_name'] ?? '';
      }
      if (res['secRefMember']['verification_status'] == "Verified") {
        secMemNo.text = res['secRefMember']['member_code'] ?? '';
        secMemName.text = res['secRefMember']['member_name'] ?? '';
        secReadOnly = true;
        secRep = res['secRefMember']['member_name'] ?? '';
      }

      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }
}
