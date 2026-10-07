import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gcci/helper/shared_keys.dart';
import 'package:gcci/utils/pref_helper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../network/model/profile_list_response.dart';

class ProfileViewModel extends ChangeNotifier {
  final fullName = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final type = TextEditingController();
  final dateOfBirth = TextEditingController();

  String? gender;
  File? profileImage;
  bool isLoading = false;
  String? profileImageUrl;
  String? id;
  String? photoUploadId;
  String? photoFileName;

  final ImagePicker _picker = ImagePicker();

  ProfileViewModel() {
    _init();
    _loadPrefs();
    fullName.addListener(_onFieldChanged);
    mobile.addListener(_onFieldChanged);
    email.addListener(_onFieldChanged);
  }

  Future<void> _loadPrefs() async {
    mobile.text = await Prefs.getData(SharedKeys.mobileNO) ?? '';
    notifyListeners();
  }

  void _onFieldChanged() => notifyListeners();

  bool get isVerify =>
      fullName.text.isNotEmpty &&
      mobile.text.isNotEmpty &&
      email.text.isNotEmpty;

  Future<void> _init() async {
    final data = await Prefs.getObject(SharedKeys.member);
    debugPrint("result of member $data");

    if (data != null) {
      final member = ProfileList.fromJson(data);
      fullName.text = member.memberName ?? '';
      mobile.text = member.memberMobileno ?? '';
      email.text = member.memberEmail ?? '';
    }
  }

  Future<void> pickImage(BuildContext context, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage = File(pickedFile.path);
        profileImageUrl = null;
        notifyListeners();
        await uploadPhoto();
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  //bool get isVerify =>otpController.text.isNotEmpty && otpController.length == 6 ;


  // void _setLoading(bool value) {
  //   isLoading = value;
  //   notifyListeners();
  // }

  Future<void> uploadPhoto() async {
    /* _setLoading(true);
    try {
      var response = await AuthService.instance.saveImage(profileImage!, context);
      // Optionally handle response
      photoUploadId = response['ID'];
      photoFileName = response['FileName'];
    } catch (e) {
      // Handle error
    }
    _setLoading(false);*/
    notifyListeners();
  }

  Future<void> saveProfile(BuildContext context) async {}

  void removeProfileImage() {
    profileImage = null;
    profileImageUrl = null;
    notifyListeners();
  }

  @override
  void dispose() {
    fullName.dispose();
    mobile.dispose();
    email.dispose();
    super.dispose();
  }
}
