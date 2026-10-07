import 'package:flutter/material.dart';

import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../utils/pref_helper.dart';

class BusinessDetailViewModel extends ChangeNotifier {
  final Function()? onNext;
  final searchKey = TextEditingController();

  bool isLoading = false;
  List<dynamic> busCatList = [];
  List<dynamic> result = [];
  List<String> subCatId = [];

  BusinessDetailViewModel({this.onNext});

  Future<void> loadInitialData(BuildContext context) async {
    await getBusinessCatList(context);
    getMemberBusCategory(/*context*/);
  }

  Future<void> getBusinessCatList(BuildContext context) async {
    _setLoading(true);
    try {
      debugPrint("businss api");
      final response = await ApiService.instance.post<dynamic>(
       // context,
        "businessCateList",
      );

      busCatList = response.data?['businessCategory'] ?? [];
      result = [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateMemberBusCategory(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({
      "mid": memberID,
      "business_cate": subCatId.join(','),
    });

    debugPrint("updateMemberBusCategory Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "updateMemberBusCategory",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['memberBusCategory']?[0]?['msg']?.toString();

      if (message == "SUCCESS") {
        onNext?.call();
      } else {
        debugPrint("FAIL");
      }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void toggleSubCategory(String subId, bool value) {
    if (value) {
      subCatId.add(subId);
    } else {
      subCatId.remove(subId);
    }

    notifyListeners();
  }

  bool get isVerify => subCatId.isNotEmpty;

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  getMemberBusCategory(/*BuildContext context*/) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
       // context,
        "getMemberBusCategory",
        body: requestBody,
      );

      final res = response.data;
      List<String> idList =
          (res['busCategory'] as String?)?.split(",") ?? [];
      subCatId = idList;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }
}