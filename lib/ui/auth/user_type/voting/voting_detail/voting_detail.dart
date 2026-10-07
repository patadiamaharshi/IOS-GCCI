import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/voting/voting_detail/voting_detail_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../utils/validators.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../../common/circular_progress.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../../theme/app_color.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../network/model/business_size_response.dart';
import '../../../../../network/model/entity_response.dart';
import '../../../../../network/model/house_type_response.dart';
import '../../../../../network/model/location_response.dart';
import '../../../../../network/model/membership_category_response.dart';
import '../../../../../network/model/nature_business_response.dart';

class VotingDetailScreen extends StatelessWidget {
  //final Function(String?, String?)? onNext;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const VotingDetailScreen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VotingDetailViewModel(onNext: onNext),
      child: _VotingDetailScreen(
        onNext: onNext,
        onBack: onBack,
        currentStep: currentStep,
      ),
    );
  }
}

class _VotingDetailScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _VotingDetailScreen({
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  State<_VotingDetailScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<_VotingDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VotingDetailViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VotingDetailViewModel>();

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
                          'readOnly': true,
                          'type': 'name',
                        }, context),

                        buildFormField<Location>({
                          'label': 'Location *',
                          'type': 'dropDown',
                          'hint': 'Select Location',
                          'items': vm.locationItems,
                          'value': vm.location,
                          'labelBuilder': (Location item) =>
                              item.locationName ?? '',
                          'onChanged': (Location? selected) {
                            setState(() {
                              vm.location = selected;
                            });
                          },
                          'validator': (Location? value) {
                            if (value == null) {
                              return AppStrings.locationReq;
                            }
                            return null;
                          },
                        }, context),

                        if (vm.memberType == "Voting") ...[
                          buildFormField<Category>({
                            'label': 'Membership Category *',
                            'type': 'dropDown',
                            'hint': 'Select Membership Category',
                            'items': vm.categoryItems,
                            'value': vm.category,
                            'labelBuilder': (Category item) =>
                                item.categoryName ?? '',
                            'onChanged': (Category? selected) {
                              vm.categorySelected(selected);
                            },
                            'validator': (Category? value) {
                              if (value == null) {
                                return AppStrings.categoryReq;
                              }
                              return null;
                            },
                          }, context),

                          if (vm.category?.categoryId == "4")
                            buildFormField({
                              'label': 'Turn Over',
                              'hint': 'Turn Over',
                              'controller': vm.turnover,
                              'icon': Icons.currency_rupee,
                              'type': 'number',
                            }, context),

                          buildFormField<Entity>({
                            'label': 'Type of Entity *',
                            'type': 'dropDown',
                            'hint': 'Select Type of Entity',
                            'items': vm.entityItems,
                            'value': vm.entity,
                            'labelBuilder': (Entity item) =>
                                item.entityName ?? '',
                            'onChanged': (Entity? selected) {
                              setState(() {
                                vm.entity = selected;
                              });
                            },
                            'validator': (Entity? value) {
                              if (value == null) {
                                return AppStrings.entTypeReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<NatureBusiness>({
                            'label': 'Nature of Business *',
                            'type': 'dropDown',
                            'hint': 'Select Nature of Business',
                            'items': vm.natureBusinessItems,
                            'value': vm.natureBusiness,
                            'labelBuilder': (NatureBusiness item) =>
                                item.natureBusinessName ?? '',
                            'onChanged': (NatureBusiness? selected) {
                              setState(() {
                                vm.natureBusiness = selected;
                              });
                            },
                            'validator': (NatureBusiness? value) {
                              if (value == null) {
                                return AppStrings.natureBusReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<SizeBusiness>({
                            'label': 'Size of Business *',
                            'type': 'dropDown',
                            'hint': 'Select Size of Business',
                            'items': vm.businessSizeItems,
                            'value': vm.businessSize,
                            'labelBuilder': (SizeBusiness item) =>
                                item.businessSize ?? '',
                            'onChanged': (SizeBusiness? selected) {
                              setState(() {
                                vm.businessSize = selected;
                              });
                            },
                            'validator': (SizeBusiness? value) {
                              if (value == null) {
                                return AppStrings.sizeBusReq;
                              }
                              return null;
                            },
                          }, context),
                        ],

                        if (vm.memberType == "Non-Voting") ...[
                          buildFormField<NatureBusiness>({
                            'label': 'Nature of Business *',
                            'type': 'dropDown',
                            'hint': 'Select Nature of Business',
                            'items': vm.natureBusinessItems,
                            'value': vm.natureBusiness,
                            'labelBuilder': (NatureBusiness item) =>
                                item.natureBusinessName ?? '',
                            'onChanged': (NatureBusiness? selected) {
                              setState(() {
                                vm.natureBusiness = selected;
                              });
                            },
                            'validator': (NatureBusiness? value) {
                              if (value == null) {
                                return AppStrings.natureBusReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField({
                            'label': 'Manufacturing Details',
                            'hint': 'Manufacturing Details',
                            'controller': vm.manufacturing,
                            'icon': Icons.factory,
                            'type': 'text',
                          }, context),

                          buildFormField({
                            'label': 'Trading Details',
                            'hint': 'Trading Details',
                            'controller': vm.trading,
                            'icon': Icons.trending_up,
                            'type': 'text',
                          }, context),

                          buildFormField({
                            'label': 'Services Details',
                            'hint': 'Services Details',
                            'controller': vm.services,
                            'icon': Icons.miscellaneous_services,
                            'type': 'text',
                          }, context),

                          buildFormField<HouseList>({
                            'label': 'House Type',
                            'type': 'dropDown',
                            'hint': 'Select House Type',
                            'items': vm.houseItems,
                            'value': vm.houseType,
                            'labelBuilder': (HouseList item) =>
                                item.house ?? '',
                            'onChanged': (HouseList? selected) {
                              setState(() {
                                vm.houseType = selected;
                              });
                            },
                            'validator': (HouseList? value) {
                              if (value == null) {
                                return AppStrings.houseTypeReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField({
                            'label': 'Exports Details & Country Name',
                            'hint': 'Exports Details & Country Name',
                            'controller': vm.export,
                            'icon': Icons.arrow_upward,
                            'type': 'text',
                          }, context),

                          buildFormField({
                            'label': 'Imports Details & Country Name',
                            'hint': 'Imports Details & Country Name',
                            'controller': vm.import,
                            'icon': Icons.arrow_downward,
                            'type': 'text',
                          }, context),

                          buildFormField<SizeBusiness>({
                            'label': 'Size of Business *',
                            'type': 'dropDown',
                            'hint': 'Select Size of Business',
                            'items': vm.businessSizeItems,
                            'value': vm.businessSize,
                            'labelBuilder': (SizeBusiness item) =>
                                item.businessSize ?? '',
                            'onChanged': (SizeBusiness? selected) {
                              setState(() {
                                vm.businessSize = selected;
                              });
                            },
                            'validator': (SizeBusiness? value) {
                              if (value == null) {
                                return AppStrings.sizeBusReq;
                              }
                              return null;
                            },
                          }, context),
                        ],

                        if (vm.memberType == "Association") ...[
                          buildFormField<Entity>({
                            'label': 'Type of Registration',
                            'type': 'dropDown',
                            'hint': 'Select Type of Registration',
                            'items': vm.regItems,
                            'value': vm.regType,
                            'labelBuilder': (Entity item) =>
                                item.entityName ?? '',
                            'onChanged': (Entity? selected) {
                              setState(() {
                                vm.regType = selected;
                              });
                            },
                            'validator': (Entity? value) {
                              if (value == null) {
                                return AppStrings.regReq;
                              }
                              return null;
                            },
                          }, context),

                          buildFormField<NatureBusiness>({
                            'label': 'Nature of Business *',
                            'type': 'dropDown',
                            'hint': 'Select Nature of Business',
                            'items': vm.natureBusinessItems,
                            'value': vm.natureBusiness,
                            'labelBuilder': (NatureBusiness item) =>
                                item.natureBusinessName ?? '',
                            'onChanged': (NatureBusiness? selected) {
                              setState(() {
                                vm.natureBusiness = selected;
                              });
                            },
                            'validator': (NatureBusiness? value) {
                              if (value == null) {
                                return AppStrings.natureBusReq;
                              }
                              return null;
                            },
                          }, context),
                        ],

                        buildFormField({
                          'label': 'Pan No *',
                          'hint': 'Pan No',
                          'type': 'alphanumeric',
                          'maxLength': 10,
                          'controller': vm.panNo,
                          'capital': true,
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
                          'label': 'GST No',
                          'hint': 'GST No',
                          'type': 'alphanumeric',
                          'maxLength': 15,
                          'capital': true,
                          'controller': vm.gstNo,
                          'icon': Icons.receipt_long,
                          'validator': (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return null; // do not show any error
                            }

                            if (!Validators.isValidGST(value.trim())) {
                              return AppStrings.gstNotValid;
                            }

                            return null;
                          },
                        }, context),

                        if (vm.memberType == "Voting" ||
                            vm.memberType == "Association")
                          buildFormField({
                            "type": 'radio',
                            "label": 'Rejected during last 2 years',
                            "options": ['Yes', 'No'],
                            "groupValue": vm.rejectTwoYear,
                            "onChanged": (value) {
                              vm.setRejectTwoYear(value!);
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
                          vm.updateVotingMemberDetails(context);
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
