import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcci/ui/home/system_profiles/system_profiles.dart';

import '../../../helper/shared_keys.dart';
import '../../../network/api_service/api_service.dart';
import '../../../network/model/login_response.dart';
import '../../../utils/pref_helper.dart';

class OtpViewModel extends ChangeNotifier {
  final String mobileNumber;
  final otp = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  OtpViewModel(this.mobileNumber) {
    otp.addListener(_onFieldChanged);
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  bool get isVerify => otp.text.trim().length == 5;

  Future<LoginResponse?> otpLogin(BuildContext context) async {
    _setLoading(true);

    try {
      final requestBody = jsonEncode({"mobile": mobileNumber, "otp": otp.text});
      final response = await ApiService.instance.post<LoginResponse>(
        "verifyLoginOTP",
        body: requestBody,
        fromJson: (data) => LoginResponse.fromJson(data),
      );

      return response.data;
    } catch (_) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> verifyOtp(BuildContext context) async {
    await Prefs.putData(SharedKeys.isLogin, true);
    await Prefs.putData(SharedKeys.mobileNO, mobileNumber);

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SystemProfileScreen()),
      (Route<dynamic> route) => false,
    );
  }

  Future<LoginResponse?> login(BuildContext context) async {
    _setLoading(true);

    try {
      final requestBody = jsonEncode({"mobile": mobileNumber});
      final response = await ApiService.instance.post<LoginResponse>(
        "chkUser",
        body: requestBody,
        fromJson: (data) => LoginResponse.fromJson(data),
      );

      return response.data;
    } catch (_) {
      return null;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
   // otp.removeListener(_onFieldChanged);
   // otp.dispose();
    super.dispose();
  }
}
