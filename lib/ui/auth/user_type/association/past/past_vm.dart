import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../utils/pref_helper.dart';

class PastViewModel extends ChangeNotifier {
  final Function()? onNext;

  List<PastPresidentModal> presidentForms = [PastPresidentModal()];
  List<PastSecretaryModal> secretaryForms = [PastSecretaryModal()];

  bool isLoading = false;

  PastViewModel({this.onNext, required BuildContext context}) {
    getPastPreSecDetails(context);
  }

  Future<void> updatePastPreSecDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    List<Map<String, String>> preData = presidentForms.map((form) {
      return {
        "name": form.presidentName.text,
        "mobile": form.presidentMobile.text,
        "year": form.presidentYear.text,
      };
    }).toList();

    List<Map<String, String>> secData = secretaryForms.map((form) {
      return {
        "name": form.secretaryName.text,
        "mobile": form.secretaryMobile.text,
        "year": form.secretaryYear.text,
      };
    }).toList();

    final requestBody = jsonEncode({
      "mid": memberID,
      "past_presidents": preData,
      "past_hon_secretaries": secData,
    });

    debugPrint("updatePastPreSecDetails Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "updatePastPreSecDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['updatePastPreSecDetails']?[0]?['msg']?.toString();

      if (message == "SUCCESS") {
        onNext?.call();
      } else {}
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

  void addPresidentForms() {
    if (presidentForms.length < 5) {
      presidentForms.add(PastPresidentModal());
    }
    notifyListeners();
  }

  void addSecretaryForms() {
    if (secretaryForms.length < 5) {
      secretaryForms.add(PastSecretaryModal());
    }
    notifyListeners();
  }

  removeAtPresident(index) {
    presidentForms.removeAt(index);
    notifyListeners();
  }

  removeAtSecretary(index) {
    secretaryForms.removeAt(index);
    notifyListeners();
  }

  getPastPreSecDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "getPastPreSecDetails",
        body: requestBody,
      );

      final res = response.data;
      final List<dynamic> president = res['past_presidents'] ?? [];
      final List<dynamic> secretaries = res['past_hon_secretaries'] ?? [];

      // List<PastPresidentModal> presidentForms = [PastPresidentModal()];
      // List<PastSecretaryModal>  =
      presidentForms = president.map((item) {
        final form = PastPresidentModal();

        form.presidentName.text = item['name'] ?? '';
        form.presidentMobile.text = item['mobile'] ?? '';
        form.presidentYear.text = item['year'] ?? '';
        return form;
      }).toList();

      secretaryForms = secretaries.map((item) {
        final form = PastSecretaryModal();

        form.secretaryName.text = item['name'] ?? '';
        form.secretaryMobile.text = item['mobile'] ?? '';
        form.secretaryYear.text = item['year'] ?? '';
        return form;
      }).toList();

      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }
}

class PastPresidentModal {
  TextEditingController presidentName = TextEditingController();
  TextEditingController presidentMobile = TextEditingController();
  TextEditingController presidentYear = TextEditingController();
}

class PastSecretaryModal {
  TextEditingController secretaryName = TextEditingController();
  TextEditingController secretaryMobile = TextEditingController();
  TextEditingController secretaryYear = TextEditingController();
}
