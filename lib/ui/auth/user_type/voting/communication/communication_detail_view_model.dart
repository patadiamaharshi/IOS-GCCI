import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gcci/network/model/country_response.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../network/model/city_response.dart';
import '../../../../../network/model/profile_list_response.dart';
import '../../../../../network/model/state_response.dart';
import '../../../../../helper/shared_keys.dart';
import '../../../../../utils/pref_helper.dart';

class CommunicationDetailViewModel extends ChangeNotifier {
  final Function()? onNext;

  final businessAddress1 = TextEditingController();
  final businessAddress2 = TextEditingController();
  final businessPinCode = TextEditingController();
  final businessMobile = TextEditingController();
  final businessEmail = TextEditingController();
  final website = TextEditingController();

  final communicationAddress1 = TextEditingController();
  final communicationAddress2 = TextEditingController();
  final communicationPinCode = TextEditingController();
  final communicationMobile = TextEditingController();
  final communicationEmail = TextEditingController();

  bool isLoading = false;
  bool isSameAddress = true;
  String? errorMessage;

  List<Country> countryItems = [];

  /// Separate lists
  List<StateList> busStateItems = [];
  List<CityList> busCityItems = [];

  List<StateList> commStateItems = [];
  List<CityList> commCityItems = [];

  Country? busCountry;
  Country? commCountry;

  StateList? busState;
  StateList? commState;

  CityList? busCity;
  CityList? commCity;

  CommunicationDetailViewModel({this.onNext}) {
    _attachListeners();
  }

  void _attachListeners() async {
    businessAddress1.addListener(_onFieldChanged);
    businessAddress2.addListener(_onFieldChanged);
    businessPinCode.addListener(_onFieldChanged);
    businessMobile.addListener(_onFieldChanged);
    businessEmail.addListener(_onFieldChanged);

    final data = await Prefs.getObject(SharedKeys.member);
    if (data != null) {
      final member = ProfileList.fromJson(data);
      businessMobile.text = member.memberMobileno ?? '';
      businessEmail.text = member.memberEmail??'';
      notifyListeners();
    }
  }

  bool get isVerify =>
      businessAddress1.text.trim().isNotEmpty &&
      businessAddress2.text.trim().isNotEmpty &&
      businessPinCode.text.trim().length == 6 &&
      businessMobile.text.trim().length == 10 &&
      businessEmail.text.trim().isNotEmpty;

  Future<void> loadInitialData(BuildContext context) async {
    await getCounty(context);
    await getCommunicationDetails();
  }

  Future<void> getCounty(BuildContext context) async {
    _setLoading(true);

    try {
      final response = await ApiService.instance.post<CountryResponse>(
        // context,
        "countryList",
        fromJson: (data) => CountryResponse.fromJson(data),
      );

      countryItems = response.data.country;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  /// ================= BUSINESS =================

  Future<void> getBusinessState(String? countryId) async {
    _setLoading(true);

    final requestBody = jsonEncode({"country_id": countryId});

    try {
      final response = await ApiService.instance.post<StateResponse>(
        "stateList",
        body: requestBody,
        fromJson: (data) => StateResponse.fromJson(data),
      );

      busStateItems = response.data.state;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getBussCity(String? stateId) async {
    _setLoading(true);

    final requestBody = jsonEncode({"state_id": stateId});

    try {
      final response = await ApiService.instance.post<CityResponse>(
        "cityList",
        body: requestBody,
        fromJson: (data) => CityResponse.fromJson(data),
      );

      busCityItems = response.data.city;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void onBusCountrySelected(BuildContext context, Country? country) async {
    busCountry = country;

    busState = null;
    busCity = null;

    busStateItems = [];
    busCityItems = [];

    notifyListeners();

    await getBusinessState(country?.countryId);
  }

  void onBusStateSelected(BuildContext context, StateList? state) async {
    busState = state;

    busCity = null;
    busCityItems = [];

    notifyListeners();

    await getBussCity(state?.stateId);
  }

  void onBusCitySelected(CityList? city) {
    busCity = city;
    notifyListeners();
  }

  /// ================= COMMUNICATION =================

  Future<void> getCommState(String? countryId) async {
    _setLoading(true);

    final requestBody = jsonEncode({"country_id": countryId});
    try {
      final response = await ApiService.instance.post<StateResponse>(
        "stateList",
        body: requestBody,
        fromJson: (data) => StateResponse.fromJson(data),
      );

      commStateItems = response.data.state;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getCommCity(String? stateId) async {
    _setLoading(true);

    final requestBody = jsonEncode({"state_id": stateId});

    try {
      final response = await ApiService.instance.post<CityResponse>(
        "cityList",
        body: requestBody,
        fromJson: (data) => CityResponse.fromJson(data),
      );

      commCityItems = response.data.city;
      notifyListeners();
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void onCommCountrySelected(BuildContext context, Country? country) async {
    commCountry = country;

    commState = null;
    commCity = null;

    commStateItems = [];
    commCityItems = [];

    notifyListeners();

    await getCommState(country?.countryId);
  }

  void onCommStateSelected(BuildContext context, StateList? state) async {
    commState = state;

    commCity = null;
    commCityItems = [];

    notifyListeners();

    await getCommCity(state?.stateId);
  }

  void onCommCitySelected(CityList? city) {
    commCity = city;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setSameAddress(bool value) {
    isSameAddress = value;

    if (value) {
      communicationAddress1.text = businessAddress1.text;
      communicationAddress2.text = businessAddress2.text;
      commCountry = busCountry;
      commState = busState;
      commCity = busCity;
      communicationPinCode.text = businessPinCode.text;
      communicationMobile.text = businessMobile.text;
      communicationEmail.text = businessEmail.text;
    }

    notifyListeners();
  }

  Future<void> updateCommDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({
      "mid": memberID,
      "busAddLine1": businessAddress1.text.trim(),
      "busAddLine2": businessAddress2.text.trim(),
      "busCountry": busCountry?.countryId,
      "busState": busState?.stateId,
      "busCity": busCity?.cityId,
      "busPincode": businessPinCode.text.trim(),
      "busPhone": businessMobile.text.trim(),
      "bussEmail": businessEmail.text.trim(),
      "busWebsite": website.text.trim(),
      "sameAddress": isSameAddress ? "Yes" : "No",

      if (!isSameAddress) ...{
        "commAddLine1": communicationAddress1.text.trim(),
        "commAddLine2": communicationAddress2.text.trim(),
        "commCountry": commCountry?.countryId,
        "commState": commState?.stateId,
        "commCity": commCity?.cityId,
        "commPincode": communicationPinCode.text.trim(),
        "commPhone": communicationMobile.text.trim(),
        "commEmail": communicationEmail.text.trim(),
      },

      /*  if(isSameAddress !="Yes"){
        "commAddLine1": isSameAddress
            ? businessAddress1.text.trim()
            : communicationAddress1.text.trim(),
        "commAddLine2": isSameAddress
            ? businessAddress2.text.trim()
            : communicationAddress2.text.trim(),
        "commCountry": isSameAddress
            ? busCountry?.countryId
            : commCountry?.countryId,
        "commState": isSameAddress
            ? busState?.stateId
            : commState?.stateId,
        "commCity": isSameAddress ? busCity?.cityId : commCity?.cityId,
        "commPincode": isSameAddress
            ? businessPinCode.text.trim()
            : communicationPinCode.text.trim(),
        "commPhone": isSameAddress
            ? businessMobile.text.trim()
            : communicationMobile.text.trim(),
        "commEmail": isSameAddress
            ? businessEmail.text.trim()
            : communicationEmail.text.trim(),
      }*/
    });

    debugPrint("updateCommDetails Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        // context,
        "updateCommunicationDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['communicationDetails']?[0]?['msg']?.toString();

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

  /// ================= EDIT SCREEN DATA LOAD =================

  Future<void> getCommunicationDetails() async {
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final response = await ApiService.instance.post<dynamic>(
      //context,
      "getCommunicationDetails",
      body: {"mid": memberID},
    );

    final res = response.data;

    businessAddress1.text = res['busAddLine1'] ?? '';
    businessAddress2.text = res['busAddLine2'] ?? '';
    businessPinCode.text = res['busPincode'] ?? '';
    website.text = res['busWebsite'] ?? '';
    isSameAddress = res['sameAddress'] == "Yes";

    communicationAddress1.text = res['commAddLine1'] ?? '';
    communicationAddress2.text = res['commAddLine2'] ?? '';
    communicationPinCode.text = res['commPincode'] ?? '';
    communicationMobile.text = res['commPhone'] ?? '';
    communicationEmail.text = res['commEmail'] ?? '';

    /// ===== BUSINESS FLOW =====

    busCountry = res['busCountry'] == "0"
        ? null
        : countryItems.firstWhere(
            (e) => e.countryId == res['busCountry'],
            orElse: () => countryItems.first,
          );

    await getBusinessState(busCountry?.countryId);

    busState = res['busState'] == "0"
        ? null
        : busStateItems.firstWhere(
            (e) => e.stateId == res['busState'],
            orElse: () =>
                busStateItems.isNotEmpty ? busStateItems.first : StateList(),
          );

    await getBussCity(busState?.stateId);

    busCity = res['busCity'] == "0"
        ? null
        : busCityItems.firstWhere(
            (e) => e.cityId == res['busCity'],
            orElse: () =>
                busCityItems.isNotEmpty ? busCityItems.first : CityList(),
          );

    /// ===== COMMUNICATION FLOW =====

    commCountry = res['commCountry'] == "0"
        ? null
        : countryItems.firstWhere(
            (e) => e.countryId == res['commCountry'],
            orElse: () => countryItems.first,
          );

    await getCommState(commCountry?.countryId);

    commState = res['commState'] == "0"
        ? null
        : commStateItems.firstWhere(
            (e) => e.stateId == res['commState'],
            orElse: () =>
                commStateItems.isNotEmpty ? commStateItems.first : StateList(),
          );

    await getCommCity(commState?.stateId);

    commCity = res['commCity'] == "0"
        ? null
        : commCityItems.firstWhere(
            (e) => e.cityId == res['commCity'],
            orElse: () =>
                commCityItems.isNotEmpty ? commCityItems.first : CityList(),
          );

    notifyListeners();
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  void disposeControllers() {
    businessAddress1.dispose();
    businessAddress2.dispose();
    businessPinCode.dispose();
    businessMobile.dispose();
    businessEmail.dispose();
    website.dispose();
    communicationAddress1.dispose();
    communicationAddress2.dispose();
    communicationPinCode.dispose();
    communicationMobile.dispose();
    communicationEmail.dispose();
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }
}

/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gcci/network/model/country_response.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../network/api_service/register_service.dart';
import '../../../../../network/model/city_response.dart';
import '../../../../../network/model/profile_list_response.dart';
import '../../../../../network/model/state_response.dart';
import '../../../../../feature/constant/shared_keys.dart';
import '../../../../../utils/pref_helper.dart';

class CommunicationDetailViewModel extends ChangeNotifier {
  final Function()? onNext;

  final businessAddress1 = TextEditingController();
  final businessAddress2 = TextEditingController();
  final businessPinCode = TextEditingController();
  final businessMobile = TextEditingController();
  final businessEmail = TextEditingController();
  final website = TextEditingController();

  final communicationAddress1 = TextEditingController();
  final communicationAddress2 = TextEditingController();
  final communicationPinCode = TextEditingController();
  final communicationMobile = TextEditingController();
  final communicationEmail = TextEditingController();

  bool isLoading = false;
  bool isSameAddress = true;
  String? errorMessage;

  //List<Country> countryItems = [];
  List<Country> countryItems = [];
  List<StateList> busStateItems = [];
  List<CityList> busCityItems = [];

  //List<Country> commCountryItems = [];
  List<StateList> commStateItems = [];
  List<CityList> commCityItems = [];

  Country? busCountry;
  Country? commCountry;





  List<StateList> stateItems = [];
  StateList? busState;
  StateList? commState;

  List<CityList> cityItems = [];
  CityList? busCity;
  CityList? commCity;

  CommunicationDetailViewModel({this.onNext}) {
    _attachListeners();
  }

  void _attachListeners() async {
    businessAddress1.addListener(_onFieldChanged);
    businessAddress2.addListener(_onFieldChanged);
    businessPinCode.addListener(_onFieldChanged);
    businessMobile.addListener(_onFieldChanged);
    businessEmail.addListener(_onFieldChanged);

    final data = await Prefs.getObject(SharedKeys.member);
    debugPrint("result of member $data");
    if (data != null) {
      final member = ProfileList.fromJson(data);
      businessMobile.text = member.memberMobileno;
      businessEmail.text = member.memberEmail;
      notifyListeners();
    }
  }

  bool get isVerify =>
      businessAddress1.text.trim().isNotEmpty &&
      businessAddress2.text.trim().isNotEmpty &&
      businessPinCode.text.trim().length == 6 &&
      businessMobile.text.trim().length == 10 &&
      businessEmail.text.trim().isNotEmpty;

  Future<void> loadInitialData(BuildContext context) async {
    await getCounty(context);
    await getCommunicationDetails(context);
  }

  Future<void> getCounty(BuildContext context) async {
    _setLoading(true);
    try {
      final response = await RegisterService.instance.postApi<CountryResponse>(
        context,
        "countryList",
        fromJson: (data) => CountryResponse.fromJson(data),
      );

      countryItems = response.data.country ?? [];
      //  if (countryItems.isNotEmpty) {
      //    final defaultCountry = countryItems.firstWhere(
      //      (item) => item.countryDefault == "1",
      //      orElse: () => countryItems.first,
      //    );
      //  onbusCountrySelected(context, defaultCountry);
      //  //commCountry = defaultCountry;
      //    debugPrint("--------------------- this get county" );
      // }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getBusinessState(BuildContext context, String? countryId) async {
    final requestBody = jsonEncode({"country_id": countryId});

    final response = await RegisterService.instance.postApi<StateResponse>(
      context,
      "stateList",
      requestBody: requestBody,
      fromJson: (data) => StateResponse.fromJson(data),
    );

    busStateItems = response.data.state ?? [];
  }

  Future<void> getCommState(BuildContext context, String? countryId) async {
    final requestBody = jsonEncode({"country_id": countryId});

    final response = await RegisterService.instance.postApi<StateResponse>(
      context,
      "stateList",
      requestBody: requestBody,
      fromJson: (data) => StateResponse.fromJson(data),
    );

    commStateItems = response.data.state ?? [];
  }

  // Future<void> getState(BuildContext context, String? countryId) async {
  //   final requestBody = jsonEncode({"country_id": countryId});
  //
  //   _setLoading(true);
  //   try {
  //     final response = await RegisterService.instance.postApi<StateResponse>(
  //       context,
  //       "stateList",
  //       requestBody: requestBody,
  //       fromJson: (data) => StateResponse.fromJson(data),
  //     );
  //
  //     stateItems = response.data.state ?? [];
  //     // if (stateItems.isNotEmpty) {
  //     //   final defaultState = stateItems.firstWhere(
  //     //     (item) => item.stateDefault == "1",
  //     //     orElse: () => stateItems.first,
  //     //   );
  //     //
  //     //   onBusinessStateSelected(context, defaultState);
  //     //   commState = defaultState;
  //     // }
  //   } catch (_) {
  //     return;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<void> getBussCity(BuildContext context, String? stateId) async {
    final requestBody = jsonEncode({"state_id": stateId});

    _setLoading(true);
    try {
      final response = await RegisterService.instance.postApi<CityResponse>(
        context,
        "cityList",
        requestBody: requestBody,
        fromJson: (data) => CityResponse.fromJson(data),
      );
      busCityItems = response.data.city ?? [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }
  Future<void> getCommCity(BuildContext context, String? stateId) async {
    final requestBody = jsonEncode({"state_id": stateId});

    _setLoading(true);
    try {
      final response = await RegisterService.instance.postApi<CityResponse>(
        context,
        "cityList",
        requestBody: requestBody,
        fromJson: (data) => CityResponse.fromJson(data),
      );
      commCityItems = response.data.city ?? [];
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  void _onFieldChanged() {
    errorMessage = null;
    notifyListeners();
  }

  void setError(String? message) {
    errorMessage = message;
    notifyListeners();
  }

  void onBusCountrySelected(BuildContext context, Country? country) async {
    busCountry = country;

    // ✅ Clear old selections
    busState = null;
    busCity = null;

    // ✅ Clear old lists
    busStateItems = [];
    busCityItems = [];

    notifyListeners();

    // ✅ Load new states
    await getBusinessState(context, country?.countryId);
  }
  //
  // void onBusCountrySelected(BuildContext context, Country? country) async {
  //   busCountry = country;
  //
  //   // ✅ Clear old selections
  //   busState = null;
  //   busCity = null;
  //
  //   // ✅ Clear old lists
  //   busStateItems = [];
  //   busCityItems = [];
  //
  //   notifyListeners();
  //
  //   // ✅ Load new states
  //   await getBusinessState(context, country?.countryId);
  // }

  void onCommCountrySelected(BuildContext context, Country? country)async {
    commCountry = country;
    notifyListeners();
    await getState(context, country?.countryId);
  }

  void onBusStateSelected(BuildContext context, StateList? state) {
    busState = state;
    notifyListeners();
    getCity(context, state?.stateId);
  }

  void onCommStateSelected(BuildContext context, StateList? state) {
    commState = state;
    notifyListeners();
    getCity(context, state?.stateId);
  }

  void onBusCitySelected(BuildContext context, CityList? city) {
    busCity = city;
    notifyListeners();
  }

  void onCommCitySelected(BuildContext context, CityList? city) {
    commCity = city;
    notifyListeners();
  }




  Future<void> getCommunicationDetails(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        context,
        "getCommunicationDetails",
        body: requestBody,
      );

      final res = response.data;

      businessAddress1.text = res['busAddLine1'] ?? '';
      businessAddress2.text = res['busAddLine2'] ?? '';
      businessPinCode.text = res['busPincode'] ?? '';
      website.text = res['busWebsite'] ?? '';
      isSameAddress = res['sameAddress'] == "Yes";

      communicationAddress1.text = res['commAddLine1'] ?? '';
      communicationAddress2.text = res['commAddLine2'] ?? '';
      communicationPinCode.text = res['commPincode'] ?? '';
      communicationMobile.text = res['commPhone'] ?? '';
      communicationEmail.text = res['commEmail'] ?? '';

      if (countryItems.isNotEmpty) {

        if (res['busCountry'] == "0" || res['busCountry'] == null) {
          // ✅ Use default country
          busCountry = countryItems.firstWhere(
                (item) => item.countryDefault == "1",
            orElse: () => countryItems.first,
          );
        } else {
          // ✅ Use API country
          busCountry = countryItems.firstWhere(
                (e) => e.countryId == res['busCountry'],
            orElse: () => countryItems.first,
          );
        }

        notifyListeners();

        // ✅ IMPORTANT — wait for states
        await getState(context, busCountry?.countryId);

        /// --------------------------
        /// BUSINESS STATE
        /// --------------------------

        if (stateItems.isNotEmpty) {

          if (res['busState'] == "0" || res['busState'] == null) {
            // ✅ Use default state
            busState = stateItems.firstWhere(
                  (item) => item.stateDefault == "1",
              orElse: () => stateItems.first,
            );
          } else {
            // ✅ Use API state
            busState = stateItems.firstWhere(
                  (e) => e.stateId == res['busState'],
              orElse: () => stateItems.first,
            );
          }

          notifyListeners();

          // ✅ IMPORTANT — wait for cities
          await getCity(context, busState?.stateId);

          /// --------------------------
          /// BUSINESS CITY
          /// --------------------------

          if (cityItems.isNotEmpty) {

            if (res['busCity'] == "0" || res['busCity'] == null) {
              busCity = cityItems.first;
            } else {
              busCity = cityItems.firstWhere(
                    (e) => e.cityId == res['busCity'],
                orElse: () => cityItems.first,
              );
            }

            notifyListeners();
          }
        }
      }


      /// --------------------------
      /// COMMUNICATION COUNTRY
      /// --------------------------

      if (countryItems.isNotEmpty) {

        if (res['commCountry'] == "0" || res['commCountry'] == null) {
          // ✅ default country
          commCountry = countryItems.firstWhere(
                (item) => item.countryDefault == "1",
            orElse: () => countryItems.first,
          );
        } else {
          // ✅ API country
          commCountry = countryItems.firstWhere(
                (e) => e.countryId == res['commCountry'],
            orElse: () => countryItems.first,
          );
        }

        notifyListeners();

        // ✅ WAIT for communication states
        await getState(context, commCountry?.countryId);

        /// --------------------------
        /// COMMUNICATION STATE
        /// --------------------------

        if (stateItems.isNotEmpty) {

          if (res['commState'] == "0" || res['commState'] == null) {
            commState = stateItems.firstWhere(
                  (item) => item.stateDefault == "1",
              orElse: () => stateItems.first,
            );
          } else {
            commState = stateItems.firstWhere(
                  (e) => e.stateId == res['commState'],
              orElse: () => stateItems.first,
            );
          }

          notifyListeners();

          // ✅ WAIT for communication cities
          await getCity(context, commState?.stateId);

          /// --------------------------
          /// COMMUNICATION CITY
          /// --------------------------

          if (cityItems.isNotEmpty) {

            if (res['commCity'] == "0" || res['commCity'] == null) {
              commCity = cityItems.first;
            } else {
              commCity = cityItems.firstWhere(
                    (e) => e.cityId == res['commCity'],
                orElse: () => cityItems.first,
              );
            }

            notifyListeners();
          }
        }
      }

    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    businessAddress1.dispose();
    businessAddress2.dispose();
    businessPinCode.dispose();
    businessMobile.dispose();
    businessEmail.dispose();
    website.dispose();

    communicationAddress1.dispose();
    communicationAddress2.dispose();
    communicationPinCode.dispose();
    communicationMobile.dispose();
    communicationEmail.dispose();

    super.dispose();
  }
}
*/
