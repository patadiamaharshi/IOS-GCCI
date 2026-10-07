import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/voting/representative1/representative1_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../common/gcci_label.dart';
import '../../../../../../common/image_picker_utils.dart';
import '../../../../../../theme/app_color.dart';
import '../../../../../../utils/app_strings.dart';
import 'package:gcci/utils/validators.dart';
import 'package:gcci/common/gcci_button.dart';
import 'dart:io';

import '../../../../../../utils/app_text_styles.dart';
import '../../../../../network/model/designation_response.dart';
import '../../../../../network/model/prefix_response.dart';

class Representative1Screen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const Representative1Screen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Representative1ViewModel(onNext: onNext),
      child: _RepresentativeScreen(
        onNext: onNext,
        onBack: onBack,
        currentStep: currentStep,
      ),
    );
  }
}

class _RepresentativeScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _RepresentativeScreen({
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  State<_RepresentativeScreen> createState() => _RepresentativeScreenState();
}

class _RepresentativeScreenState extends State<_RepresentativeScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Representative1ViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<Representative1ViewModel>();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  controller: controller,
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Representative 1",
                          style: AppTextStyles.primary22_600,
                        ),

                        VerticalSpacer.normalMedium,

                        Center(
                          child: GestureDetector(
                            onTap: () => showImagePickerOptions(
                              context: context,
                              onFilePicked: (File imageFile) async {
                                debugPrint("image path ----- $imageFile");

                                vm.profileImage = imageFile;
                                vm.profileImageUrl = null;
                                await vm.uploadPhoto(context, imageFile, "1");
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
                                                    (
                                                      context,
                                                      error,
                                                      stackTrace,
                                                    ) {
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

                        VerticalSpacer.smallMedium,

                        buildFormField<Prefix>({
                          'label': 'Prefix',
                          'type': 'dropDown',
                          'hint': 'Select Prefix',
                          'items': vm.prefixItems,
                          'value': vm.prefix,
                          'labelBuilder': (Prefix item) => item.prefix ?? '',
                          'onChanged': (Prefix? selected) {
                            setState(() {
                              vm.prefix = selected;
                            });
                          },
                          'validator': (Prefix? value) {
                            if (value == null) {
                              return AppStrings.prefixReq;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'First Name *',
                          'hint': 'First Name',
                          'controller': vm.firstNameRep1,
                          'icon': Icons.person,
                          'type': 'name',
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.firstNameRequired;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Middle Name',
                          'hint': 'Middle Name',
                          'controller': vm.middleNameRep1,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        buildFormField({
                          'label': 'Last Name *',
                          'hint': 'Last Name',
                          'controller': vm.lastNameRep1,
                          'icon': Icons.person,
                          'type': 'name',
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.lastNameRequired;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField<Designation>({
                          'label': 'Designation *',
                          'type': 'dropDown',
                          'hint': 'Select Designation',
                          'items': vm.designationItems,
                          'value': vm.designation,
                          'labelBuilder': (Designation item) =>
                              item.designation ?? '',
                          'onChanged': (Designation? selected) {
                            setState(() {
                              vm.designation = selected;
                            });
                          },
                          'validator': (Designation? value) {
                            if (value == null) {
                              return AppStrings.designationReq;
                            }
                            return null;
                          },
                        }, context),

                        if (vm.memberType == "Association") ...[
                          buildFormField({
                            'label': 'From',
                            'type': 'date',
                            'icon': Icons.calendar_today,
                            'previousDate': true,
                            'futureDate': false,
                            'controller': vm.fromDate,
                          }, context),

                          buildFormField({
                            'label': 'To',
                            'type': 'date',
                            'icon': Icons.calendar_today,
                            'previousDate': true,
                            'futureDate': false,
                            'controller': vm.toDate,
                          }, context),
                        ],

                        buildFormField({
                          'label': 'Mobile Number *',
                          'type': 'number',
                          "icon": Icons.phone,
                          'hint': "Enter your 10-digit mobile number",
                          'required': true,
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
                          'label': 'Phone No(R)',
                          'type': 'number',
                          "icon": Icons.phone,
                          'hint': "Enter your phone number",
                          'maxLength': 15,
                          'controller': vm.landline,
                        }, context),

                        buildFormField({
                          'label': 'Pan No *',
                          'hint': 'Pan No',
                          'type': 'alphanumeric',
                          'maxLength': 10,
                          'capital': true,
                          'controller': vm.panNo,
                          'icon': Icons.receipt_long,
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.panRequired;
                            }

                            if (!Validators.isValidPAN(value.trim())) {
                              return AppStrings.panNotValid;
                            }

                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Aadhaar',
                          'type': 'number',
                          "icon": Icons.receipt_long,
                          'capital': true,
                          'hint': "Enter your Aadhaar",
                          'maxLength': 12,
                          'controller': vm.aadhaar,
                        }, context),

                        buildFormField({
                          'type': 'email',
                          'label': 'Email *',
                          'hint': 'Email',
                          'icon': Icons.mail,
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

                        buildFormField({
                          'label': 'Date of Birth',
                          'type': 'date',
                          'icon': Icons.calendar_today,
                          'previousDate': true,
                          'futureDate': false,
                          'controller': vm.dateOfBirth,
                          'onDateSelected': (value) {
                            vm.checkAge(vm.dateOfBirth.text);

                            if (vm.ageIS <= 35) {
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  controller.animateTo(
                                    controller.position.maxScrollExtent,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              );
                            }
                          },
                        }, context),

                        buildFormField({
                          "type": 'radio',
                          "label": 'Gender',
                          "options": ['Male', 'Female'],
                          "groupValue": vm.gender,
                          "onChanged": (value) {
                            setState(() {
                              vm.gender = value!;
                              if (value == "Female") {
                                Future.delayed(
                                  const Duration(milliseconds: 300),
                                  () {
                                    controller.animateTo(
                                      controller.position.maxScrollExtent,
                                      duration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                );
                              }
                            });
                          },
                        }, context),

                        if (vm.memberType != "Non-Voting") ...[
                          if (vm.gender == "Female")
                            buildFormField({
                              "type": 'radio',
                              "label":
                                  'I am interested to participate in Business Women Activities',
                              "options": ['Yes', 'No'],
                              "groupValue": vm.womenWing,
                              "onChanged": (value) {
                                setState(() {
                                  vm.womenWing = value!;
                                });
                              },
                            }, context),

                          // buildFormField({
                          //   'label': 'Women wing',
                          //   'type': 'dropDown',
                          //   'hint': 'Women wing',
                          //   'items': ['Yes', 'No'],
                          //   'value': vm.womenWing,
                          //   'labelBuilder': (String item) => item,
                          //   'onChanged': (String? v) {
                          //     vm.womenWing = v;
                          //   },
                          // }, context),
                          if (vm.ageIS <= 35 && vm.dateOfBirth.text.isNotEmpty)
                            buildFormField({
                              "type": 'radio',
                              "label":
                                  'My age is below 35 years and i am interested to participate in Youth Activities',
                              "options": ['Yes', 'No'],
                              "groupValue": vm.youthWing,
                              "onChanged": (value) {
                                setState(() {
                                  vm.youthWing = value!;
                                });
                              },
                            }, context),
                          // buildFormField({
                          //   'label': 'Youth wing',
                          //   'type': 'dropDown',
                          //   'hint': 'Youth wing',
                          //   'items': ['Yes', 'No'],
                          //   'value': vm.youthWing,
                          //   'labelBuilder': (String item) => item,
                          //   'onChanged': (String? v) {
                          //     vm.youthWing = v;
                          //   },
                          // }, context),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Row(
                children: [
                  if (widget.currentStep > 0)
                    Expanded(
                      child: GCCIButton(
                        isEnabled: true,
                        backgroundColor: AppColor.disableButtonColor,
                        text: "Back",
                        onPressed: () {
                          widget.onBack?.call();
                        },
                      ),
                    ),

                  if (widget.currentStep > 0) HorizontalSpacer.large,

                  Expanded(
                    child: GCCIButton(
                      isEnabled: vm.isVerify,
                      icon: Icons.arrow_forward,
                      text: "Next",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.updateRep1Details(context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (vm.isLoading)
          Center(child: CircularProgress(isLoading: vm.isLoading)),
      ],
    );
  }
}
