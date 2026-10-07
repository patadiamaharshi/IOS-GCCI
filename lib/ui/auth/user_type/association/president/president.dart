import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/association/president/president_vm.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../../common/circular_progress.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../common/dimension.dart';
import '../../../../../common/gcci_label.dart';
import '../../../../../theme/app_color.dart';
import '../../../../../utils/app_text_styles.dart';

class President extends StatelessWidget {
  //final Function(String?, String?)? onNext;
  final VoidCallback? onNext;

  final VoidCallback? onBack;
  final int currentStep;

  const President({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PresidentViewModel(onNext: onNext, context: context),
      child: Screen(onNext: onNext, onBack: onBack, currentStep: currentStep),
    );
  }
}

class Screen extends StatefulWidget {
  final VoidCallback? onNext;

  final VoidCallback? onBack;
  final int currentStep;

  const Screen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PresidentViewModel>();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
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
                        buildFormField({
                          'label': 'Name of Current President',
                          'hint': 'Name of Current President',
                          'controller': vm.presidentName,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        buildFormField({
                          'label': 'Current President Mobile No *',
                          'type': 'number',
                          "icon": Icons.phone,
                          'hint': "Enter your 10-digit mobile number",
                          'maxLength': 10,
                          'controller': vm.presidentMobile,
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
                          'label': 'Current President Email *',
                          'hint': 'Email',
                          "icon": Icons.mail,
                          'controller': vm.presidentEmail,
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
                          'label': 'Name of Current Hon.Secretary',
                          'hint': 'Name of Current Hon.Secretary',
                          'controller': vm.secretaryName,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        buildFormField({
                          'label': 'Current Hon.Secretary Mobile No *',
                          'type': 'number',
                          "icon": Icons.phone,
                          'hint': "Enter your 10-digit mobile number",
                          'maxLength': 10,
                          'controller': vm.secretaryMobile,
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
                          'label': 'Current Hon.Secretary Email *',
                          'hint': 'Email',
                          "icon": Icons.mail,
                          'controller': vm.secretaryEmail,
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

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Name of other Current Office Bearers",
                          style: AppTextStyles.primary22_600,
                        ),

                        VerticalSpacer.normalMedium,

                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vm.bearerForms.length,
                              itemBuilder: (context, index) {
                                final form = vm.bearerForms[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: AppColor.buttonColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (vm.bearerForms.length > 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              vm.removeAt(index);
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 24,
                                            ),
                                          ),
                                        ),

                                      buildFormField({
                                        'label': 'Name',
                                        'hint': 'Name',
                                        'controller': form.name,
                                        'icon': Icons.person,
                                        'type': 'name',
                                      }, context),

                                      buildFormField({
                                        'label': 'Designation',
                                        'hint': 'Designation',
                                        'controller': form.designation,
                                        'icon': Icons.work,
                                        'type': 'name',
                                      }, context),

                                      buildFormField({
                                        'label': 'Mobile Number',
                                        'type': 'number',
                                        "icon": Icons.phone,
                                        'hint':
                                            "Enter your 10-digit mobile number",
                                        'maxLength': 10,
                                        'controller': form.mobile,
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return null;
                                          }
                                          if (!Validators.isValidMobile(
                                            value,
                                          )) {
                                            return AppStrings.mobileNotValid;
                                          }
                                          return null;
                                        },
                                      }, context),

                                      buildFormField({
                                        'type': 'email',
                                        'label': 'Email',
                                        'hint': 'Email',
                                        "icon": Icons.mail,
                                        'controller': form.email,
                                        'required': true,
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return null;
                                          }
                                          if (!Validators.isValidEmail(value)) {
                                            return AppStrings.emailNotValid;
                                          }
                                          return null;
                                        },
                                      }, context),

                                      buildFormField({
                                        'label': 'Website',
                                        'hint': 'Website',
                                        'controller': form.website,
                                        'icon': Icons.language,
                                        'type': 'text',
                                      }, context),

                                      /*  if (vm.bearerForms.length > 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              vm.removeAt(index);
                                            },
                                          ),
                                        ),*/
                                    ],
                                  ),
                                );
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GCCIButton(
                                isEnabled: true,
                                leadingIcon: Icons.add,
                                fullWidth: false,
                                text: "Add More",
                                onPressed: () {
                                  vm.addBearerForm();
                                },
                              ),
                            ),
                          ],
                        ),

                        buildFormField({
                          'label':
                              'Name of Secretary General or Top Executive (who is a current employee)',
                          'hint':
                              'Name of Secretary General or Top Executive (who is a current employee)',
                          'controller': vm.sgName,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        buildFormField({
                          'label':
                              'Secretary General or Top Executive Mobile No *',
                          'type': 'number',
                          "icon": Icons.phone,
                          'hint': "Enter your 10-digit mobile number",
                          'maxLength': 10,
                          'controller': vm.sgMobile,
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
                          'label': 'Secretary General or Top Executive Email *',
                          'hint': 'Email',
                          "icon": Icons.mail,
                          'controller': vm.sgEmail,
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
                          vm.updateCurrentPreSecDetails(context);
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
