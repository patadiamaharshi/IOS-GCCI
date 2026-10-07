import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gcci/network/model/login_response.dart';
import 'package:gcci/ui/auth/otp/otp_screen.dart';

import '../../../network/api_service/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  final mobile = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  LoginViewModel() {
    mobile.addListener(_onFieldChanged);
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  bool get isVerify => mobile.text.trim().length == 10;

  Future<LoginResponse?> login(BuildContext context) async {
    _setLoading(true);

    try {
      final requestBody = jsonEncode({"mobile": mobile.text.trim()});

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

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> saveLoginData(BuildContext context) async {
    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => OtpScreen(mobileNumber: mobile.text)),
    );
  }

  @override
  void dispose() {
    mobile.dispose();
    super.dispose();
  }
}
