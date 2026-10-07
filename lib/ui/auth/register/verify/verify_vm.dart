import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../helper/shared_keys.dart';
import '../../../../../../utils/pref_helper.dart';
import '../../../../network/api_service/api_service.dart';

class VerifyViewModel extends ChangeNotifier {
  final Function(String mobile, String email)? onNext;

  final mobile = TextEditingController();
  final mobileOTP = TextEditingController();
  final email = TextEditingController();
  final emailOTP = TextEditingController();

  bool showMobileOTPBOX = false;
  bool showEmailOTPBOX = false;

  //bool retryOTPMobile = false;
  bool retryOTPEmail = false;

  bool isLoading = false;
  String? errorMessage;

  // 🔹 Mobile Timer
  // Timer? _mobileTimer;
  // int mobileSeconds = 60;
  // bool showMobileTimer = false;
  // bool showMobileResend = false;

  // 🔹 Email Timer
  Timer? _emailTimer;
  int emailSeconds = 60;
  bool showEmailTimer = false;
  bool showEmailResend = false;

  VerifyViewModel({this.onNext}) {
    getMobileOTP();
    getEmailOTP();
  }

  Future<void> init() async {
    mobileOTP.addListener(_onFieldChanged);
    emailOTP.addListener(_onFieldChanged);

    notifyListeners();
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  bool get isVerify => mobileOTP.text.length == 5 && emailOTP.text.length == 5;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> otpRegVerify(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    try {
      final requestBody = jsonEncode({
        "mid": memberID,
        "mobileOTP": mobileOTP.text,
        "emailOTP": emailOTP.text,
      });

      final response = await ApiService.instance.post<dynamic>(
        "verifyRegOTP",
        body: requestBody,
      );

      if (response.data['memberRegisterVerification'] != null &&
          response.data['memberRegisterVerification'].isNotEmpty &&
          response.data['memberRegisterVerification'][0]['verification']
                  ?.toString()
                  .toLowerCase() ==
              "success") {
        onNext?.call(mobile.text.trim(), email.text.trim());
      } else {
        setError(
          response.data?['memberRegisterVerification'][0]['Error'] ??
              "INVALID OTP.",
        );
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void getMobileOTP() {
    showMobileOTPBOX = true;
    //  retryOTPMobile = true;
    // startMobileTimer();
    notifyListeners();
  }

  //
  // void startMobileTimer() {
  //   _mobileTimer?.cancel();
  //
  //   mobileSeconds = 60;
  //   showMobileTimer = true;
  //   showMobileResend = false;
  //   notifyListeners();
  //
  //   _mobileTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     if (mobileSeconds > 0) {
  //       mobileSeconds--;
  //       notifyListeners();
  //     } else {
  //       timer.cancel();
  //       showMobileTimer = false;
  //       showMobileResend = true;
  //       notifyListeners();
  //     }
  //   });
  // }
  //
  // void resendMobileOTP() {
  //   startMobileTimer();
  // }

  void getEmailOTP() {
    showEmailOTPBOX = true;
    retryOTPEmail = true;
    startEmailTimer();
    notifyListeners();
  }

  void startEmailTimer() {
    _emailTimer?.cancel();

    emailSeconds = 60;
    showEmailTimer = true;
    showEmailResend = false;
    notifyListeners();

    _emailTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (emailSeconds > 0) {
        emailSeconds--;
        notifyListeners();
      } else {
        timer.cancel();
        showEmailTimer = false;
        showEmailResend = true;
        notifyListeners();
      }
    });
  }

  Future<void> resendEmailOTP(BuildContext context) async {
    startEmailTimer();

    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    try {
      final requestBody = jsonEncode({"mid": memberID});

      await ApiService.instance.post<dynamic>(
        "resendRegOTP",
        body: requestBody,
      );
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    // _mobileTimer?.cancel();
    _emailTimer?.cancel();

    mobile.dispose();
    email.dispose();
    mobileOTP.dispose();
    emailOTP.dispose();

    super.dispose();
  }
}
