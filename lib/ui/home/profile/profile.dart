import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/common_form.dart';
import 'package:gcci/common/common_toolbar.dart';
import 'package:gcci/common/gcci_button.dart';
import 'package:gcci/common/image_picker_utils.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/home/profile/profile_viewmodel.dart';
import 'package:gcci/utils/validators.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _Profile(),
    );
  }
}

class _Profile extends StatefulWidget {
  const _Profile();

  @override
  State<_Profile> createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  final _formKey = GlobalKey<FormState>();

  /* @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChangePasswordViewModel>().loadInitialData(context);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    return Scaffold(
      appBar: const CommonToolbar(title: AppStrings.profile),
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () => showImagePickerOptions(
                            context: context,
                            onFilePicked: (File imageFile) async {
                              debugPrint("image path ----- $imageFile");

                              vm.profileImage = imageFile;
                              vm.profileImageUrl = null;
                              await vm.uploadPhoto();
                            },
                            onRemove: () {
                              vm.removeProfileImage();
                            },
                            showDeleteOption:
                                vm.profileImage != null ||
                                (vm.profileImageUrl?.isNotEmpty ?? false),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            // border thickness
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColor.primary, // border color
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: AppColor.white,
                              child: vm.profileImage != null
                                  ? ClipOval(
                                      child: Image.file(
                                        vm.profileImage!,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : (vm.profileImageUrl != null &&
                                            vm.profileImageUrl!.isNotEmpty
                                        ? ClipOval(
                                            child: Image.network(
                                              vm.profileImageUrl!,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return const Icon(
                                                      Icons.camera_alt,
                                                      size: 50,
                                                      color: AppColor.primary,
                                                    );
                                                  },
                                            ),
                                          )
                                        : const Icon(
                                            Icons.camera_alt,
                                            size: 50,
                                            color: AppColor.primary,
                                          )),
                            ),
                          ),
                        ),
                      ),

                      VerticalSpacer.normalMedium,

                      buildFormField({
                        'label': 'Full Name *',
                        'hint': 'Full Name',
                        "icon": Icons.person,
                        'controller': vm.fullName,
                        'type': 'name',
                      }, context),

                      //VerticalSpacer.normal,
                      buildFormField({
                        // 'readOnly': true,
                        'label': 'Mobile Number *',
                        "icon": Icons.phone,
                        'type': 'number',
                        'hint': 'Mobile',
                        'maxLength': 10,
                        'controller': vm.mobile,
                        'validator': (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.mobileRequired;
                          }
                          if (!Validators.isValidMobile(value)) {
                            return AppStrings.mobileNotValid;
                          }
                          return null;
                        },
                      }, context),

                      buildFormField({
                        'type': 'email',
                        'label': 'Email *',
                        'hint': 'Email',
                        // 'readOnly': true,
                        "icon": Icons.mail,
                        'controller': vm.email,
                        'required': true,
                        'validator': (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppStrings.emailRequired;
                          }
                          if (!Validators.isValidEmail(value)) {
                            return AppStrings.emailNotValid;
                          }
                          return null;
                        },
                      }, context),

                      //VerticalSpacer.normal,
                      /*buildFormField({
                        'label': 'Date of Birth',
                        'type': 'date',
                        'icon': Icons.calendar_today,
                        'previousDate': true,
                        'futureDate': false,
                        'controller': vm.dateOfBirth,
                      }, context),*/

                      //VerticalSpacer.normal,
                    /*  buildFormField({
                        "type": 'radio',
                        "label": 'Gender',
                        "options": ['Male', 'Female', 'Others'],
                        "groupValue": vm.gender,
                        "onChanged": (value) {
                          setState(() {
                            vm.gender = value!;
                          });
                        },
                      }, context),
                     */
                      VerticalSpacer.large,

                      GCCIButton(
                        isEnabled: vm.isVerify,
                        text: AppStrings.save,
                        icon: Icons.arrow_forward,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            vm.saveProfile(context);
                          }
                        },
                      ),
                      VerticalSpacer.large,
                    ],
                  ),
                ),
              ),
            ),
            //if (vm.isLoading)
              //Center(child: CircularProgress(isLoading: vm.isLoading)),
          ],
        ),
      ),
    );
  }
}
