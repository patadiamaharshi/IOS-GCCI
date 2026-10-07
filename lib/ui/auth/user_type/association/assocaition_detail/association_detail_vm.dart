import 'package:flutter/material.dart';

import '../../../../../network/api_service/api_service.dart';
import '../../../../../network/model/major_activity_response.dart';

import '../../../../../helper/shared_keys.dart';
import '../../../../../utils/pref_helper.dart';

class AssociationDetailViewModel extends ChangeNotifier {
  final Function()? onNext;

  final estYear = TextEditingController();
  final noOfMember = TextEditingController();
  final memberBusinessEntities = TextEditingController();
  final totalAssociation = TextEditingController();
  final termStarting = TextEditingController();
  final termEnding = TextEditingController();
  final briefAssociation = TextEditingController();
  final buildingDetails = TextEditingController();
  final otherActivity = TextEditingController();
  String? ownBuilding = "No";
  String? womenWing = "No";
  String? youthWing = "No";
  String? certificateOrigin = "No";
  String? regType;

  // String? entity;
  String? businessNature;

  //String? businessSize;

  bool isLoading = false;
  String? errorMessage;

  List<MajorActivity> majorActivityItems = [];
  MajorActivity? majorActivity;

  AssociationDetailViewModel({this.onNext}) {
    _init();
  }

  Future<void> _init() async {
    onRegTypeSelected("Registration 1");
  }

  Future<void> loadInitialData(BuildContext context) async {
    await getMajorActivity(context);
    await getAssociationDetails();
  }

  buildingSelected(String? value) {
    ownBuilding = value;

    if (value == "No") {
      buildingDetails.text = "";
    }

    notifyListeners();
  }

  Future<void> getMajorActivity(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<MajorActivityResponse>(
        // context,
        "majorActivityList",
        fromJson: (data) => MajorActivityResponse.fromJson(data),
      );

      majorActivityItems = response.data.majorActivity;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateAssociationDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({
      "mid": memberID,

      "establishment_year": estYear.text,
      "total_member": noOfMember.text,
      "no_business_entity": memberBusinessEntities.text,
      "total_association": totalAssociation.text,
      "term_starting": termStarting.text,
      "term_ending": termEnding.text,
      "brif_association": briefAssociation.text,
      "own_building": ownBuilding,
      "building_details": buildingDetails.text,

      "major_activity": majorActivity?.activityName,
      "other_activity": otherActivity.text,

      "women_wing": womenWing,
      "youth_wing": youthWing,
      "certificate_origin": certificateOrigin,
    });

    debugPrint("updateAssociationDetails Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        // context,
        "updateAssociationDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['updateAssociationDetails']?[0]?['msg']?.toString();

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

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  // void _onFieldChanged() {
  //   errorMessage = null;
  //   notifyListeners();
  // }

  //bool get isVerify => mobile.text.trim().length == 10;
  bool get isVerify => true;

  // memberName.text.trim().isNotEmpty &&
  //     firstName.text.trim().isNotEmpty &&
  //     lastName.text.trim().isNotEmpty &&
  //     mobile.text.trim().length == 10 &&
  //     email.text.trim().isNotEmpty;

  void onRegTypeSelected(String? value) {
    regType = value;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> getAssociationDetails() async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "getAssociationDetails",
        body: requestBody,
      );

      final res = response.data;

      estYear.text = res['establishment_year'] ?? '';
      noOfMember.text = res['total_member'] ?? '';
      memberBusinessEntities.text = res['no_business_entity'] ?? '';
      totalAssociation.text = res['total_association'] ?? '';
      termStarting.text = res['term_starting'] ?? '';
      termEnding.text = res['term_ending'] ?? '';
      briefAssociation.text = res['brif_association'] ?? '';
      ownBuilding = res['own_building'] ?? '';
      buildingDetails.text = res['building_details'] ?? '';
      otherActivity.text = res['other_activity'] ?? '';
      womenWing = res['women_wing'] ?? '';
      youthWing = res['youth_wing'] ?? '';
      certificateOrigin = res['certificate_origin'] ?? '';

      majorActivity = res['major_activity'] == ""
          ? null
          : majorActivityItems.firstWhere(
              (e) => e.activityName == res['major_activity'],
              orElse: () => MajorActivity(),
            );
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    estYear.dispose();
    noOfMember.dispose();
    memberBusinessEntities.dispose();
    super.dispose();
  }
}
