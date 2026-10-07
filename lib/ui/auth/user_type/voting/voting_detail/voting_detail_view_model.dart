import 'package:flutter/material.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../helper/shared_keys.dart';
import '../../../../../network/model/business_size_response.dart';
import '../../../../../network/model/entity_response.dart';
import '../../../../../network/model/home_certificate_response.dart';
import '../../../../../network/model/house_type_response.dart';
import '../../../../../network/model/location_response.dart';
import '../../../../../network/model/membership_category_response.dart';
import '../../../../../network/model/nature_business_response.dart';
import '../../../../../utils/pref_helper.dart';

class VotingDetailViewModel extends ChangeNotifier {
  final Function()? onNext;

  final memberName = TextEditingController();
  final panNo = TextEditingController();
  final gstNo = TextEditingController();
  final manufacturing = TextEditingController();
  final trading = TextEditingController();
  final services = TextEditingController();
  final export = TextEditingController();
  final import = TextEditingController();
  final turnover = TextEditingController();

  String? rejectTwoYear = "No";

  bool isLoading = false;
  String? errorMessage;
  String? memberType = "";

  List<HouseList> houseItems = [];
  HouseList? houseType;

  List<Location> locationItems = [];
  Location? location;

  List<Category> categoryItems = [];
  Category? category;

  List<Entity> entityItems = [];
  Entity? entity;

  List<Entity> regItems = [];
  Entity? regType;

  List<NatureBusiness> natureBusinessItems = [];
  NatureBusiness? natureBusiness;

  List<SizeBusiness> businessSizeItems = [];
  SizeBusiness? businessSize;

  VotingDetailViewModel({this.onNext}) {
    panNo.addListener(_onFieldChanged);
  }

  Future<void> loadInitialData(BuildContext context) async {
    //rejectTwoYear = "No";
    // final data = await Prefs.getObject(SharedKeys.member);
    // debugPrint("result of member $data");
    // if (data != null) {
    //   final member = ProfileList.fromJson(data);
    //   debugPrint("memberName =========================  $data");
    //   debugPrint("memberType =========================  ${member.memberType}");
    //
    //   memberName.text = member.memberName;
    //   memberType = member.memberType;
    //
    //   debugPrint("memberName =========================  ${memberName.text}");
    // }
    setRejectTwoYear("No");
    await getCertificateList();
    await getLocation();
    await getMemberShipCategory();
    await getEntity();
    await getNatureBusiness();
    await getSizeBusiness();
    await getHouseType();
    getMemberDetail();
    notifyListeners();
  }

  Future<void> getCertificateList() async {
    _setLoading(true);

    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = {"member_id": memberID.toString()};

    try {
      final response = await ApiService.instance.post<HomeResponse>(
        // context,
        body: requestBody,
        "profileIDCertificateLetter",
        fromJson: (data) => HomeResponse.fromJson(data),
      );

      memberName.text = response.data.memberName ?? "";
      memberType = response.data.memberType ?? "";

      notifyListeners();
    } catch (e) {
      debugPrint('Error getCertificateList Home 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> getHouseType() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<HouseResponse>(
        //context,
        "houseList",
        fromJson: (data) => HouseResponse.fromJson(data),
      );

      houseItems = response.data.houseList;
      // if (houseItems.isNotEmpty) {
      //   houseType = houseItems.first;
      // }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getLocation() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<dynamic>(
        "locationList",
        fromJson: (data) => LocationResponse.fromJson(data),
      );
      locationItems = response.data.location ?? [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMemberShipCategory() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post(
        // context,
        'membershipCategoryList',
        fromJson: (data) => MemberShipCategoryResponse.fromJson(data),
      );
      categoryItems = response.data.memberShipCategory;
      //  category = categoryItems.first;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  categorySelected(Category? cat) {
    category = cat;

    if (cat?.categoryId != "4") {
      turnover.text = "";
    }

    notifyListeners();
  }

  void setRejectTwoYear(String value) {
    rejectTwoYear = value;
    notifyListeners();
  }

  Future<void> getEntity() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post(
        // context,
        'entityList',
        fromJson: (data) => EntityResponse.fromJson(data),
      );

      entityItems = (response.data.entity)
          .where((item) => item.displayInVoting == "Yes")
          .toList();
      regItems = (response.data.entity)
          .where((item) => item.displayInAssociation == "Yes")
          .toList();

      //regItems = response.data.entity ?? [];
      // entity = entityItems.first;
      //regType = regItems.first;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getNatureBusiness() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post(
        // context,
        'natureOfBusinessList',
        fromJson: (data) => NatureBusinessResponse.fromJson(data),
      );
      natureBusinessItems = response.data.natureBusiness;
      // natureBusiness = natureBusinessItems.first;
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getSizeBusiness() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post(
        //context,
        'sizeOfBusinessList',
        fromJson: (data) => SizeBusinessResponse.fromJson(data),
      );
      businessSizeItems = response.data.sizeBusiness;
      //businessSize = businessSizeItems.first;
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

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  //bool get isVerify => mobile.text.trim().length == 10;
  bool get isVerify => panNo.text.trim().isNotEmpty;

  //    &&
  //     lastName.text.trim().isNotEmpty &&
  //     mobile.text.trim().length == 10 &&
  //     email.text.trim().isNotEmpty;

  Future<void> updateVotingMemberDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({
      "mid": memberID,
      "location": location?.locationId,
      "category": category?.categoryId,
      "entity": entity?.entityId,
      "business_nature": natureBusiness?.natureBusinessId,
      "panno": panNo.text,
      "gstno": gstNo.text,

      if (memberType == "Voting") "turnover": turnover.text,

      if (memberType != "Association")
        "business_size": businessSize?.businessSizeId,

      if (memberType == "Voting" || memberType == "Association")
        "reject_two_year": rejectTwoYear,

      if (memberType == "Association") "type_of_reg": regType?.entityId,

      if (memberType == "Non-Voting") "manuf_detail": manufacturing.text,
      "trading_detail": trading.text,
      "service_detail": services.text,
      "house_type": houseType?.house,
      "export_detail": export.text,
      "import_detail": import.text,
    });

    debugPrint("updateVotingMemberDetails Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "updateVotingMemberDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['updateVotingMemberDetails']?[0]?['msg']
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

  getMemberDetail() async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        //  context,
        "getMembershipDetails",
        body: requestBody,
      );

      final res = response.data;

      turnover.text = res['turnover'] ?? '';
      panNo.text = res['panno'] ?? '';
      gstNo.text = res['gstno'] ?? '';
      rejectTwoYear = (res['reject_two_year']?.toString().isEmpty ?? true)
          ? "No"
          : res['reject_two_year'];
      services.text = res['service_detail'] ?? '';
      export.text = res['export_detail'] ?? '';
      import.text = res['import_detail'] ?? '';
      trading.text = res['trading_detail'] ?? '';
      manufacturing.text = res['manuf_detail'] ?? '';

      location = res['location'] == "0"
          ? null
          : locationItems.firstWhere(
              (e) => e.locationId == res['location'],
              orElse: () => Location(),
            );

      category = res['category'] == "0"
          ? null
          : categoryItems.firstWhere(
              (e) => e.categoryId.toString() == res['category'],
              orElse: () => Category(),
            );

      entity = res['entity'] == "0"
          ? null
          : entityItems.firstWhere(
              (e) => e.entityId.toString() == res['entity'],
              orElse: () => Entity(),
            );

      regType = res['type_of_reg'] == "0"
          ? null
          : regItems.firstWhere(
              (e) => e.entityId.toString() == res['type_of_reg'],
              orElse: () => Entity(),
            );

      natureBusiness = res['business_nature'] == "0"
          ? null
          : natureBusinessItems.firstWhere(
              (e) => e.natureBusinessId.toString() == res['business_nature'],
              orElse: () => NatureBusiness(),
            );

      businessSize = res['business_size'] == "0"
          ? null
          : businessSizeItems.firstWhere(
              (e) => e.businessSizeId.toString() == res['business_size'],
              orElse: () => SizeBusiness(),
            );

      houseType = res['house_type'] == ""
          ? null
          : houseItems.firstWhere(
              (e) => e.house.toString() == res['house_type'],
              orElse: () => HouseList(),
            );
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
    //company.dispose();
    panNo.dispose();
    gstNo.dispose();
    super.dispose();
  }
}
