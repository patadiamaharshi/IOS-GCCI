import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../network/api_service/api_service.dart';
import '../../../../network/model/prefix_response.dart';
import '../../../../network/model/register_response.dart';
import '../../../../helper/shared_keys.dart';
import '../../../../utils/pref_helper.dart';

class DetailViewModel extends ChangeNotifier {
  final Function(String mobile, String email)? onNext;

  final memberName = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();

  List<Prefix> prefixItems = [];
  Prefix? prefix;

  bool isLoading = false;
  bool isAccept = false;
  String? errorMessage;

  DetailViewModel({this.onNext}) {
    memberName.addListener(_onFieldChanged);
    firstName.addListener(_onFieldChanged);
    lastName.addListener(_onFieldChanged);
    mobile.addListener(_onFieldChanged);
    email.addListener(_onFieldChanged);
  }

  Future<void> loadInitialData(BuildContext context) async {
    await getPrefix(context);
  }

  Future<void> getPrefix(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<PrefixResponse>(
        //context,
        "prefixList",
        fromJson: (data) => PrefixResponse.fromJson(data),
      );

      prefixItems = response.data.prefix;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void _onFieldChanged() {
    // if (errorMessage != null) {
    //   errorMessage = null;
    notifyListeners();
    // }
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  bool get isVerify =>
      memberName.text.trim().isNotEmpty &&
      firstName.text.trim().isNotEmpty &&
      lastName.text.trim().isNotEmpty &&
      mobile.text.trim().isNotEmpty &&
      email.text.trim().isNotEmpty;

  bool get isConfirm => isAccept;

  void setAccept(bool value) {
    isAccept = value;
    notifyListeners();
  }

  Future<void> register(BuildContext context) async {
    _setLoading(true);

    final requestBody = jsonEncode({
      "member_name": memberName.text.trim(),
      "prefix": prefix?.prefix,
      "fname": firstName.text.trim(),
      "lName": lastName.text.trim(),
      "mobileno": mobile.text.trim(),
      "emailid": email.text.trim(),
    });

    try {
      // final response = await ApiService.instance.performRegister(
      //   requestBody,
      //   context,
      // );

      final response = await ApiService.instance.post<RegisterResponse>(
        //context,
        "memberRegister",
        body: requestBody,
        fromJson: (data) => RegisterResponse.fromJson(data),
      );

      if (response.data.memberRegister.isNotEmpty == true) {
        final data = response.data.memberRegister[0];

        final regAction = data['regaction']?.toString().toLowerCase();

        if (regAction == "success") {
          debugPrint("Registration Success Block Running $data");

          await Prefs.putData(
            SharedKeys.memberId,
            data['mid']?.toString() ?? '',
          );
          await Prefs.putData("mobileOTP", data['mobileOTP']?.toString() ?? '');
          await Prefs.putData("emailOTP", data['emailOTP']?.toString() ?? '');
          await Prefs.putData(SharedKeys.mobileNO, mobile.text.trim());

          debugPrint("Data Saved Successfully");

          onNext?.call(mobile.text.trim(), email.text.trim());
        } else {
          setError(data['Error'] ?? "Email Already Registered.");
        }
      } else {
        setError("Something went wrong. Please try again.");
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    memberName.dispose();
    firstName.dispose();
    lastName.dispose();
    mobile.dispose();
    email.dispose();
    super.dispose();
  }
}
