import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../../common/circular_progress.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../common/dimension.dart';
import '../../../../../common/gcci_label.dart';
import '../../../../../network/model/major_activity_response.dart';
import '../../../../../theme/app_color.dart';
import '../../../../../utils/app_text_styles.dart';
import 'association_detail_vm.dart';

class AssociationDetail extends StatelessWidget {
  //final Function(String?, String?)? onNext;
  final VoidCallback? onNext;

  final VoidCallback? onBack;
  final int currentStep;

  const AssociationDetail({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssociationDetailViewModel(onNext: onNext),
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssociationDetailViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AssociationDetailViewModel>();

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
                          'label': 'Year of Establishment',
                          'hint': 'Year of Establishment',
                          'controller': vm.estYear,
                          'icon': Icons.calendar_today,
                          'type': 'number',
                          'maxLength': 4,
                        }, context),

                        buildFormField({
                          'label': 'Total Number of Members',
                          'hint': 'Total Number of Members',
                          'controller': vm.noOfMember,
                          'icon': Icons.pin,
                          'type': 'number',
                        }, context),

                        buildFormField({
                          'label': 'Number of Member Business Entities',
                          'hint': 'Number of Member Business Entities',
                          'controller': vm.memberBusinessEntities,
                          'icon': Icons.pin,
                          'type': 'number',
                        }, context),

                        buildFormField({
                          'label': 'Number of Member Association',
                          'hint': 'Number of Member Association',
                          'controller': vm.totalAssociation,
                          'icon': Icons.pin,
                          'type': 'number',
                        }, context),

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Term of President and Office Bearers",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label': 'Starting',
                          'type': 'date',
                          'icon': Icons.calendar_today,
                          'previousDate': true,
                          'futureDate': true,
                          'controller': vm.termStarting,
                        }, context),

                        buildFormField({
                          'label': 'Valid Upto',
                          'type': 'date',
                          'icon': Icons.calendar_today,
                          'previousDate': true,
                          'futureDate': true,
                          'controller': vm.termEnding,
                        }, context),

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Brief Details about Association (Including Business Sector)",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label': 'Brief Detail about Association',
                          'hint': 'Brief Detail about Association',
                          'controller': vm.briefAssociation,
                          'type': 'text',
                          'minLines': 3,
                          'maxLines': 5,
                          'maxLength': 400,
                        }, context),

                        buildFormField({
                          'label': 'Do you have own building',
                          "type": 'radio',
                          "options": ['Yes', 'No'],
                          "groupValue": vm.ownBuilding,
                          "onChanged": (value) {
                            setState(() {
                              vm.buildingSelected(value);
                              //vm.ownBuilding = value.toString();
                            });
                          },
                        }, context),

                        if (vm.ownBuilding == "Yes")
                          buildFormField({
                            'label': 'If yes, then please submit the details',
                            'hint': 'If yes, then please submit the details',
                            'controller': vm.buildingDetails,
                            'type': 'text',
                            'minLines': 3,
                            'maxLines': 5,
                            'maxLength': 400,
                          }, context),

                        buildFormField<MajorActivity>({
                          'label':
                              'Major Activities Carried out by Association',
                          'type': 'dropDown',
                          'hint': 'Major Activities Carried out by Association',
                          'items': vm.majorActivityItems,
                          'value': vm.majorActivity,
                          'labelBuilder': (MajorActivity item) =>
                              item.activityName ?? '',
                          'onChanged': (MajorActivity? selected) {
                            setState(() {
                              vm.majorActivity = selected;
                            });
                          },
                          'validator': (MajorActivity? value) {
                            if (value == null) {
                              return AppStrings.majorActivityReq;
                            }
                            return null;
                          },
                        }, context),

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Other activities carried out by your Association, Please specify",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label':
                              'Other activities carried out by your Association, Please specify',
                          'hint':
                              'Other activities carried out by your Association, Please specify',
                          'controller': vm.otherActivity,
                          'type': 'text',
                          'minLines': 3,
                          'maxLines': 5,
                          'maxLength': 400,
                        }, context),

                        buildFormField({
                          'label': 'Do you have Business Women Wing/Committee?',
                          "type": 'radio',
                          "options": ['Yes', 'No'],
                          "groupValue": vm.womenWing,
                          "onChanged": (value) {
                            setState(() {
                              vm.womenWing = value!;
                            });
                          },
                        }, context),

                        buildFormField({
                          'label': 'Do you have Youth Wing/Committee?',
                          "type": 'radio',
                          "options": ['Yes', 'No'],
                          "groupValue": vm.youthWing,
                          "onChanged": (value) {
                            setState(() {
                              vm.youthWing = value!;
                            });
                          },
                        }, context),

                        buildFormField({
                          'label': 'Do you issue Certificate of Origin?',
                          "type": 'radio',
                          "options": ['Yes', 'No'],
                          "groupValue": vm.certificateOrigin,
                          "onChanged": (value) {
                            setState(() {
                              vm.certificateOrigin = value!;
                            });
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
                      isEnabled: true,
                      icon: Icons.arrow_forward,
                      text: "Next",
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          vm.updateAssociationDetails(context);
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
