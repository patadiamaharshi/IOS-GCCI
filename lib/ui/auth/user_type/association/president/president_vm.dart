import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../utils/pref_helper.dart';

class PresidentViewModel extends ChangeNotifier {
  final Function()? onNext;

  final presidentName = TextEditingController();
  final presidentMobile = TextEditingController();
  final presidentEmail = TextEditingController();
  final secretaryName = TextEditingController();
  final secretaryMobile = TextEditingController();
  final secretaryEmail = TextEditingController();
  final sgName = TextEditingController();
  final sgMobile = TextEditingController();
  final sgEmail = TextEditingController();

  List<OfficeBearerModal> bearerForms = [OfficeBearerModal()];

  bool isLoading = false;
  String? errorMessage;

  PresidentViewModel({this.onNext, required BuildContext context}) {
    presidentMobile.addListener(_onFieldChanged);
    presidentEmail.addListener(_onFieldChanged);
    secretaryMobile.addListener(_onFieldChanged);
    secretaryEmail.addListener(_onFieldChanged);
    sgMobile.addListener(_onFieldChanged);
    sgEmail.addListener(_onFieldChanged);

    getCurrentPreSecDetails(context);
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  bool get isVerify =>
      presidentMobile.text.trim().isNotEmpty &&
      presidentEmail.text.trim().isNotEmpty &&
      secretaryMobile.text.trim().isNotEmpty &&
      secretaryEmail.text.trim().isNotEmpty &&
      sgMobile.text.trim().isNotEmpty &&
      sgEmail.text.trim().isNotEmpty;

  Future<void> updateCurrentPreSecDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    List<Map<String, String>> data = bearerForms.map((form) {
      return {
        "name": form.name.text,
        "email": form.email.text,
        "designation": form.designation.text,
        "website": form.website.text,
        "mobile": form.mobile.text,
      };
    }).toList();

    final requestBody = jsonEncode({
      "mid": memberID,
      "current_president": {
        "name": presidentName.text.trim(),
        "mobile": presidentMobile.text.trim(),
        "email": presidentEmail.text.trim(),
      },
      "current_secretary": {
        "name": secretaryName.text.trim(),
        "mobile": secretaryMobile.text.trim(),
        "email": secretaryEmail.text.trim(),
      },
      "current_sg": {
        "name": sgName.text,
        "mobile": sgMobile.text,
        "email": sgEmail.text,
      },
      "office_bearers": data,
    });

    debugPrint("updateCurrentPreSecDetails Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "updateCurrentPreSecDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['updateCurrentPreSecDetails']?[0]?['msg']
          ?.toString();

      if (message == "SUCCESS") {
        onNext?.call();

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

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void addBearerForm() {
    bearerForms.add(OfficeBearerModal());
    notifyListeners();
  }

  removeAt(index) {
    bearerForms.removeAt(index);
    notifyListeners();
  }

  getCurrentPreSecDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "getCurrentPreSecDetails",
        body: requestBody,
      );

      final res = response.data;

      presidentName.text = res['current_president']['name'] ?? '';
      presidentMobile.text = res['current_president']['mobile'] ?? '';
      presidentEmail.text = res['current_president']['email'] ?? '';

      secretaryName.text = res['current_secretary']['name'] ?? '';
      secretaryMobile.text = res['current_secretary']['mobile'] ?? '';
      secretaryEmail.text = res['current_secretary']['email'] ?? '';

      sgName.text = res['current_sg']['name'] ?? '';
      sgMobile.text = res['current_sg']['mobile'] ?? '';
      sgEmail.text = res['current_sg']['email'] ?? '';

      final List<dynamic> officeBearers = res['office_bearers'] ?? [];

      bearerForms = officeBearers.map((item) {
        final form = OfficeBearerModal();

        form.name.text = item['name'] ?? '';
        form.designation.text = item['designation'] ?? '';
        form.mobile.text = item['mobile'] ?? '';
        form.email.text = item['email'] ?? '';
        form.website.text = item['website'] ?? '';

        return form;
      }).toList();

      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    presidentName.dispose();
    presidentMobile.dispose();
    presidentEmail.dispose();
    secretaryName.dispose();
    secretaryMobile.dispose();
    secretaryEmail.dispose();
    super.dispose();
  }
}

class OfficeBearerModal {
  TextEditingController name = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController website = TextEditingController();
}
