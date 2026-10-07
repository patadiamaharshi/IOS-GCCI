import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../../utils/app_strings.dart';
import 'package:gcci/common/gcci_button.dart';

import '../../../../common/dimension.dart';
import '../../../../network/model/prefix_response.dart';
import '../../../../utils/app_text_styles.dart';
import 'detail_vm.dart';
import 'package:gcci/common/gcci_label.dart';

class Detail extends StatelessWidget {
  final Function(String mobile, String email)? onNext;

  const Detail({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailViewModel(onNext: onNext),
      child: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  // final Function(String mobile, String email)? onNext;

  const Screen({super.key /*, this.onNext*/});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DetailViewModel>();

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
                          'label': 'Member/Company Name *',
                          'hint': 'Member/Company Name',
                          'controller': vm.memberName,
                          'icon': Icons.business,
                          'type': 'name',
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.memberNameRequired;
                            }
                            return null;
                          },
                        }, context),

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



                        // buildFormField<Prefix>({
                        //   'label': 'Prefix',
                        //   'type': 'dropDown',
                        //   'hint': 'Select Prefix',
                        //   'items': vm.prefixItems,
                        //   'value': vm.prefix,
                        //   'labelBuilder': (Prefix item) => item.prefix,
                        //   'onChanged': (Prefix? selected) {
                        //     vm.prefix = selected;
                        //   },
                        //   'validator': (Prefix? value) {
                        //     if (value == null) {
                        //       return AppStrings.prefixReq;
                        //     }
                        //     return null;
                        //   },
                        // }, context),

                        buildFormField({
                          'label': 'First Name *',
                          'hint': 'First Name',
                          'controller': vm.firstName,
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
                          'label': 'Last Name *',
                          'hint': 'Last Name',
                          'controller': vm.lastName,
                          'icon': Icons.person,
                          'type': 'name',
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.lastNameRequired;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Mobile Number *',
                          'type': 'number',
                          'icon': Icons.phone,
                          'hint': 'Enter your 10-digit mobile number',
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

                        if (vm.errorMessage != null) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.errorMessage!,
                            style: AppTextStyles.error,
                          ),
                        ],

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
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: GCCIButton(
                isEnabled: vm.isVerify,
                text: "Verify",
                icon: Icons.arrow_forward,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    vm.register(context);
                  }
                },
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
