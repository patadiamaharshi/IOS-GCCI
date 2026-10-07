import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../helper/shared_keys.dart';
import '../../../../../network/api_service/api_service.dart';
import '../../../../../network/app_config.dart';
import '../../../../../network/model/designation_response.dart';
import '../../../../../network/model/home_certificate_response.dart';
import '../../../../../network/model/prefix_response.dart';
import '../../../../../utils/pref_helper.dart';

class Representative1ViewModel extends ChangeNotifier {
  final Function()? onNext;

  final firstNameRep1 = TextEditingController();
  final middleNameRep1 = TextEditingController();
  final lastNameRep1 = TextEditingController();
  final mobile = TextEditingController();
  final landline = TextEditingController();
  final panNo = TextEditingController();
  final aadhaar = TextEditingController();
  final email = TextEditingController();
  final dateOfBirth = TextEditingController();
  final fromDate = TextEditingController();
  final toDate = TextEditingController();
  String? gender = "Male";

  String? womenWing = "No";
  String? youthWing = "No";

  bool isLoading = false;
  String? errorMessage;

  File? profileImage;
  String? profileImageUrl;
  String? id;
  String? photoUploadId;
  String? photoFileName;

  //String isMemberType = "";
  String memberType = "";

  List<Prefix> prefixItems = [];
  Prefix? prefix;

  List<Designation> designationItems = [];
  Designation? designation;

  int ageIS = 0;

  Representative1ViewModel({this.onNext}) {
    firstNameRep1.addListener(_onFieldChanged);
    lastNameRep1.addListener(_onFieldChanged);
    mobile.addListener(_onFieldChanged);
    panNo.addListener(_onFieldChanged);
    email.addListener(_onFieldChanged);
  }

  bool get isVerify =>
      firstNameRep1.text.trim().isNotEmpty &&
      lastNameRep1.text.trim().isNotEmpty &&
      mobile.text.trim().isNotEmpty &&
      email.text.trim().isNotEmpty;

  Future<void> loadInitialData(BuildContext context) async {
    await getCertificateList(context);
    await getPrefix();
    await getDesignation();

    // final data = await Prefs.getObject(SharedKeys.member);
    // debugPrint("result of member $data");
    // if (data != null) {
    //   final member = ProfileList.fromJson(data);
    //   memberType = member.memberType;
    //   debugPrint("memberName =========================  $memberType");
    //
    //   notifyListeners();
    // }

    getRep1Details(/*context*/);
  }

  Future<void> getCertificateList(BuildContext context) async {
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
      memberType = response.data.memberType ?? "";

      notifyListeners();
    } catch (e) {
      debugPrint('Error getCertificateList Home 👉 $e');
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> getPrefix() async {
    _setLoading(true);
    try {
      final response = await ApiService.instance.post<PrefixResponse>(
        //context,
        "prefixList",
        fromJson: (data) => PrefixResponse.fromJson(data),
      );

      prefixItems = response.data.prefix;
      // if (prefixItems.isNotEmpty) {
      //   prefix = prefixItems.first;
      // }
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getDesignation() async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);
    final requestBody = ({"mid": memberID});
    try {
      final response = await ApiService.instance.post<DesignationResponse>(
        //  context,
        "noRepsnDesignation",
        body: requestBody,
        fromJson: (data) => DesignationResponse.fromJson(data),
      );

      designationItems = response.data.designation;
      // if (designationItems.isNotEmpty) {
      //   designation = designationItems.first;
      // }
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

  Future<dynamic> updateRep1Details(BuildContext context) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({
      "mid": memberID,
      "repno": "1",
      "prefix": prefix?.prefix,
      "fname": firstNameRep1.text.trim(),
      "mname": middleNameRep1.text.trim(),
      "lname": lastNameRep1.text.trim(),
      "designation": designation?.designation,
      "mobileno": mobile.text.trim(),
      "phoneno": landline.text.trim(),
      "panno": panNo.text.trim(),
      "aadharno": aadhaar.text.trim(),
      "emailid": email.text.trim(),
      "dob": dateOfBirth.text.trim(),
      "gender": gender,
      "womenwing": womenWing,
      "youthwing": youthWing,
    });

    debugPrint("updateRep1 Details Request ---> $requestBody");

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "updateRepDetails",
        body: requestBody,
      );

      final data = response.data;

      final message = data?['repDetails']?[0]?['msg']?.toString();

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

  void removeProfileImage() {
    profileImage = null;
    profileImageUrl = null;
    photoUploadId = null;
    photoFileName = null;
    notifyListeners();
  }

  Future<void> uploadPhoto(
    BuildContext context,
    File imageFile,
    String repNO,
  ) async {
    try {
      _setLoading(true);

      String fileName = imageFile.path.split('/').last;
      final memberID = await Prefs.getData(SharedKeys.memberId);

      debugPrint("------------- upload image request");

      debugPrint("memberID $memberID");
      debugPrint("repNO $repNO");
      debugPrint("fileName $fileName");
      debugPrint("path ${imageFile.path}");

      debugPrint("------------- upload image request");

      FormData formData = FormData.fromMap({
        "mid": memberID.toString(),
        "repno": repNO,
        "photo_image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await Dio().post(
        "${AppConfig.baseUrl}uploadRepPhoto",
        //   "https://www.gujaratchamber.org/api/api.php/uploadDocument",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      debugPrint("Upload Response: ${response.data}");
      final data = response.data;
      final bool status = data['status'] == true;
      final String message =
          data['message']?.toString() ?? "Something went wrong";
      if (!context.mounted) return;
      if (status) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        debugPrint("SUCCESS");
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        debugPrint("FAIL");
      }
    } catch (e) {
      debugPrint("Upload Error: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Upload Failed")));
    } finally {
      _setLoading(false);
    }
  }

  checkAge(String dob) {
    debugPrint("Rep1 DOB is ------ $dob");
    DateFormat format = DateFormat("dd/MM/yyyy");
    DateTime birthDate = format.parseStrict(dob);
    DateTime today = DateTime.now();

    int age = today.year - birthDate.year;

    if (today.isBefore(DateTime(today.year, birthDate.month, birthDate.day))) {
      age--;
    }
    ageIS = age;
    notifyListeners();
    debugPrint("your age is ----- $age");
  }

  getRep1Details(/*BuildContext context*/) async {
    _setLoading(true);
    final memberID = await Prefs.getData(SharedKeys.memberId);

    final requestBody = ({"mid": memberID});

    try {
      final response = await ApiService.instance.post<dynamic>(
        //context,
        "getRep1Details",
        body: requestBody,
      );

      final res = response.data;

      firstNameRep1.text = res['fname'] ?? '';
      middleNameRep1.text = res['mname'] ?? '';
      lastNameRep1.text = res['lname'] ?? '';
      mobile.text = res['mobileno'] ?? '';
      landline.text = res['phoneno'] ?? '';

      panNo.text = res['panno'] ?? '';
      aadhaar.text = res['aadharno'] ?? '';
      email.text = res['emailid'] ?? '';
      dateOfBirth.text = res['dob'] ?? '';
      gender = res['gender'] ?? '';
      womenWing = res['womenwing'] ?? '';
      youthWing = res['youthwing'] ?? '';
      profileImageUrl = res['memberPhoto'] ?? '';

      // isSameAddress = res['sameAddress'] == "Yes";

      prefix = res['prefix'] == "0"
          ? null
          : prefixItems.firstWhere(
              (e) => e.prefix == res['prefix'],
              orElse: () => Prefix(),
            );

      designation = res['designation'] == "0"
          ? null
          : designationItems.firstWhere(
              (e) => e.designation == res['designation'],
              orElse: () => Designation(),
            );
      // onBusinessCountrySelected(context, businessCountry);
    } catch (_) {
      return;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    firstNameRep1.dispose();
    middleNameRep1.dispose();
    lastNameRep1.dispose();
    mobile.dispose();
    landline.dispose();
    panNo.dispose();
    aadhaar.dispose();
    email.dispose();
    dateOfBirth.dispose();
    super.dispose();
  }
}
