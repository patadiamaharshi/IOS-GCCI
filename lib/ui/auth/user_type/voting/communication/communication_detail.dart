import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../common/gcci_label.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../../common/circular_progress.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../../theme/app_color.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../utils/app_text_styles.dart';
import '../../../../../network/model/city_response.dart';
import '../../../../../network/model/country_response.dart';
import '../../../../../network/model/state_response.dart';
import 'communication_detail_view_model.dart';

class CommunicationDetailScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const CommunicationDetailScreen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CommunicationDetailViewModel(onNext: onNext),
      child: _CommunicationDetailScreen(
        onNext: onNext,
        onBack: onBack,
        currentStep: currentStep,
      ),
    );
  }
}

class _CommunicationDetailScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _CommunicationDetailScreen({
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  State<_CommunicationDetailScreen> createState() =>
      _CommunicationDetailScreenState();
}

class _CommunicationDetailScreenState
    extends State<_CommunicationDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunicationDetailViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CommunicationDetailViewModel>();

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
                          "Business Place Address",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label': 'Address Line1 *',
                          'hint': 'Address Line1',
                          'controller': vm.businessAddress1,
                          'type': 'text',
                          'icon': Icons.location_on,
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.addressRequired;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Address Line2 *',
                          'hint': 'Address Line2',
                          'controller': vm.businessAddress2,
                          'icon': Icons.location_on,
                          'type': 'text',
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.addressRequired;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField<Country>({
                          'label': 'Country',
                          'type': 'dropDown',
                          'hint': 'Select Country',
                          'items': vm.countryItems,
                          'value': vm.busCountry,
                          'labelBuilder': (Country item) =>
                              item.countryName ?? '',
                          'onChanged': (Country? selected) {
                            vm.onBusCountrySelected(context, selected);
                          },
                          'validator': (Country? value) {
                            if (value == null) {
                              return AppStrings.countryReq;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField<StateList>({
                          'label': 'State',
                          'type': 'dropDown',
                          'hint': 'Select State',
                          'items': vm.busStateItems,
                          'value': vm.busState,
                          'labelBuilder': (StateList item) =>
                              item.stateName ?? '',
                          'onChanged': (StateList? selected) {
                            vm.onBusStateSelected(context, selected);
                          },
                          'validator': (StateList? value) {
                            if (value == null) {
                              return AppStrings.stateReq;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField<CityList>({
                          'label': 'City',
                          'type': 'dropDown',
                          'hint': 'Select City',
                          'items': vm.busCityItems,
                          'value': vm.busCity,
                          'labelBuilder': (CityList item) =>
                              item.cityName ?? '',
                          'onChanged': (CityList? selected) {
                            vm.onBusCitySelected(selected);
                          },
                          'validator': (CityList? value) {
                            if (value == null) {
                              return AppStrings.cityReq;
                            }
                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Pincode *',
                          'hint': 'Pincode',
                          'type': 'number',
                          'maxLength': 6,
                          'controller': vm.businessPinCode,
                          'icon': Icons.pin,
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.pinCodeRequired;
                            }

                            if (!Validators.isValidPinCode(value.trim())) {
                              return AppStrings.pinCodeNotValid;
                            }

                            return null;
                          },
                        }, context),

                        buildFormField({
                          'label': 'Mobile Number *',
                          'type': 'number',
                          'icon': Icons.phone,
                          'readOnly': true,
                          'hint': 'Enter your 10-digit mobile number',
                          'maxLength': 10,
                          'controller': vm.businessMobile,
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
                          'icon': Icons.email,
                          'controller': vm.businessEmail,
                          'required': true,
                          'readOnly': true,
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
                          'label': 'Website',
                          'hint': 'Website',
                          'type': 'text',
                          'controller': vm.website,
                          'icon': Icons.language,
                        }, context),

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Communication Address",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'type': 'checkbox',
                          'label': 'Same as Business Address',
                          'value': vm.isSameAddress,
                          'onChanged': (value) {
                            vm.setSameAddress(value ?? false);
                          },
                        }, context),

                        if (!vm.isSameAddress) ...[
                          buildFormField({
                            'label': 'Address Line1 *',
                            'hint': 'Address Line1',
                            'controller': vm.communicationAddress1,
                            'type': 'text',
                            'icon': Icons.location_on,
                            'validator': (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.addressRequired;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField({
                            'label': 'Address Line2 *',
                            'hint': 'Address Line2',
                            'controller': vm.communicationAddress2,
                            'type': 'text',
                            'icon': Icons.location_on,
                            'validator': (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.addressRequired;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<Country>({
                            'label': 'Country',
                            'type': 'dropDown',
                            'hint': 'Select Country',
                            'items': vm.countryItems,
                            'value': vm.commCountry,
                            'labelBuilder': (Country item) =>
                                item.countryName ?? '',
                            'onChanged': (Country? selected) {
                              vm.onCommCountrySelected(
                                context,
                                selected,
                              );
                            },
                            'validator': (Country? value) {
                              if (value == null) {
                                return AppStrings.countryReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<StateList>({
                            'label': 'State',
                            'type': 'dropDown',
                            'hint': 'Select State',
                            'items': vm.commStateItems,
                            'value': vm.commState,
                            'labelBuilder': (StateList item) =>
                                item.stateName ?? '',
                            'onChanged': (StateList? selected) {
                              vm.onCommStateSelected(
                                context,
                                selected,
                              );
                            },
                            'validator': (StateList? value) {
                              if (value == null) {
                                return AppStrings.stateReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<CityList>({
                            'label': 'City',
                            'type': 'dropDown',
                            'hint': 'Select City',
                            'items': vm.commCityItems,
                            'value': vm.commCity,
                            'labelBuilder': (CityList item) =>
                                item.cityName ?? '',
                            'onChanged': (CityList? selected) {
                              vm.onCommCitySelected(selected);
                            },
                            'validator': (CityList? value) {
                              if (value == null) {
                                return AppStrings.cityReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField({
                            'label': 'Pincode *',
                            'hint': 'Pincode',
                            'type': 'number',
                            'maxLength': 6,
                            'controller': vm.communicationPinCode,
                            'icon': Icons.pin,
                            'validator': (String? value) {
                              if (value == null || value.trim().isEmpty) {
                                return AppStrings.pinCodeRequired;
                              }

                              if (!Validators.isValidPinCode(value.trim())) {
                                return AppStrings.pinCodeNotValid;
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
                            'controller': vm.communicationMobile,
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
                            'icon': Icons.mail,
                            'controller': vm.communicationEmail,
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
                          vm.updateCommDetails(context);
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
