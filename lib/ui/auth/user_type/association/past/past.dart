import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/association/past/past_vm.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../common/circular_progress.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../common/dimension.dart';
import '../../../../../common/gcci_label.dart';
import '../../../../../theme/app_color.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_text_styles.dart';
import '../../../../../utils/validators.dart';

class Past extends StatelessWidget {
  //final Function(String?, String?)? onNext;
  final VoidCallback? onNext;

  final VoidCallback? onBack;
  final int currentStep;

  const Past({super.key, this.onNext, this.onBack, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PastViewModel(onNext: onNext, context: context),
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
    final vm = context.watch<PastViewModel>();

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
                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Details of Past Presidents of Last 5 Years",
                          style: AppTextStyles.primary22_600,
                        ),

                        VerticalSpacer.normalMedium,

                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vm.presidentForms.length,
                              itemBuilder: (context, index) {
                                final form = vm.presidentForms[index];
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
                                      buildFormField({
                                        'label': 'Name *',
                                        'hint': 'Name',
                                        'controller': form.presidentName,
                                        'icon': Icons.person,
                                        'type': 'name',
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Name is required";
                                          }
                                          return null;
                                        },
                                      }, context),

                                      buildFormField({
                                        'label': 'Mobile Number *',
                                        'type': 'number',
                                        "icon": Icons.phone,
                                        'hint':
                                            "Enter your 10-digit mobile number",
                                        'maxLength': 10,
                                        'controller': form.presidentMobile,
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return AppStrings.mobileRequired;
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
                                        'label': 'Select Year',
                                        'type': 'date',
                                        'hint': "YYYY",
                                        'icon': Icons.calendar_today,
                                        'showYearOnly': true,
                                        'controller': form.presidentYear,
                                      }, context),

                                      if (vm.presidentForms.length > 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              vm.removeAtPresident(index);
                                            },
                                          ),
                                        ),
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
                                  vm.addPresidentForms();
                                },
                              ),
                            ),
                          ],
                        ),

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Details of Past Hon. Secretaries of Last 5 Years",
                          style: AppTextStyles.primary22_600,
                        ),

                        VerticalSpacer.normalMedium,

                        Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vm.secretaryForms.length,
                              itemBuilder: (context, index) {
                                final form = vm.secretaryForms[index];
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
                                      buildFormField({
                                        'label': 'Name *',
                                        'hint': 'Name',
                                        'controller': form.secretaryName,
                                        'icon': Icons.person,
                                        'type': 'name',
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return "Name is required";
                                          }
                                          return null;
                                        },
                                      }, context),

                                      buildFormField({
                                        'label': 'Mobile Number *',
                                        'type': 'number',
                                        "icon": Icons.phone,
                                        'hint':
                                            "Enter your 10-digit mobile number",
                                        'maxLength': 10,
                                        'controller': form.secretaryMobile,
                                        'validator': (String? value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return AppStrings.mobileRequired;
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
                                        'label': 'Select Year',
                                        'type': 'date',
                                        'icon': Icons.calendar_today,
                                        'hint': "YYYY",
                                        'showYearOnly': true,
                                        'controller': form.secretaryYear,
                                      }, context),

                                      if (vm.secretaryForms.length > 1)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              vm.removeAtSecretary(index);
                                            },
                                          ),
                                        ),
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
                                  vm.addSecretaryForms();
                                },
                              ),
                            ),
                          ],
                        ),
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
                      isEnabled: true,
                      icon: Icons.arrow_forward,
                      text: "Next",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.updatePastPreSecDetails(context);
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
