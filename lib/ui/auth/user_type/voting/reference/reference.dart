import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/voting/reference/reference_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../common/gcci_label.dart';
import '../../../../../../theme/app_color.dart';
import 'package:gcci/common/gcci_button.dart';

import '../../../../../../utils/app_text_styles.dart';
import '../../../../../utils/app_strings.dart';

class ReferenceScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const ReferenceScreen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReferenceViewModel(context),
      child: _ReferenceScreen(
        onNext: onNext,
        onBack: onBack,
        currentStep: currentStep,
      ),
    );
  }
}

class _ReferenceScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _ReferenceScreen({this.onNext, this.onBack, required this.currentStep});

  @override
  State<_ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends State<_ReferenceScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReferenceViewModel>();

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
                          "Proposer",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label': 'Membership No',
                          'hint': 'Membership No',
                          'controller': vm.propMemNo,
                          'readOnly': vm.propReadOnly,
                          'icon': Icons.pin,
                          'type': 'number',
                          'onChanged': (value) {
                            vm.onMemNoChanged(context, value, "proposer");
                          },
                        }, context),

                        if (vm.propErrMsg != null) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.propErrMsg.toString(),
                            style: AppTextStyles.error,
                          ),
                        ],

                        buildFormField({
                          'label': 'Name of Member',
                          'hint': 'Name of Member',
                          'readOnly': true,
                          'controller': vm.propMemName,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        if (vm.propRepName.isNotEmpty)
                          buildFormField({
                            "type": 'radio',
                            "label": 'Name of Representative',
                            "options": vm.propRepName,
                            "groupValue": vm.propRep,
                            "onChanged": (value) {
                              vm.onPropRepSelected(value, "proposer");
                            },
                          }, context),

                        VerticalSpacer.xSmall,

                        if (vm.showPropGetOtpBtn) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GCCIButton(
                              isEnabled: true,
                              fullWidth: false,
                              text: "GET OTP",
                              onPressed: () {
                                vm.getMobileOTP(
                                  context,
                                  vm.propMemNo.text.toString(),
                                  "1",
                                  vm.propMemName.text.toString(),
                                  vm.propRep.toString(),
                                  vm.propMobileNo.toString(),
                                  "proposer",
                                );
                              },
                            ),
                          ),
                        ],

                        if (vm.showProMobileOTPBOX) ...[
                          VerticalSpacer.normalMedium,
                          buildFormField({
                            'type': 'otp',
                            'length': 5,
                            'controller': vm.proMobileOTP,
                            'onChanged': (value) {},
                          }, context),
                        ],

                        if (vm.propRetryOTP) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (vm.propShowTimer)
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: AppStrings.otpRetryIn,
                                      style: AppTextStyles.label18black500,
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Text(
                                              "${vm.propSeconds} sec",
                                              style: AppTextStyles
                                                  .label18primary700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (vm.propShowResend)
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text: AppStrings.otpResendPrompt,
                                      style: AppTextStyles.label18black500,
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: GestureDetector(
                                            onTap: () {
                                              vm.getMobileOTP(
                                                context,
                                                vm.propMemNo.text.toString(),
                                                "1",
                                                vm.propMemName.text.toString(),
                                                vm.propRep.toString(),
                                                vm.propMobileNo.toString(),
                                                "proposer",
                                              );
                                              //vm.resendOTP(context, "proposer");
                                            },
                                            child: Text(
                                              AppStrings.otpResend,
                                              style: AppTextStyles
                                                  .label18primary700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          VerticalSpacer.xSmall,
                          VerticalSpacer.xSmall,
                        ],
                        // vm.mobile.text.trim().length == 10 &&
                        if (vm.showProMobileOTPBOX) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GCCIButton(
                              isEnabled: true,
                              fullWidth: false,
                              text: "Verify OTP",
                              onPressed: () {
                                vm.verifyMobileOTP(
                                  context,
                                  vm.proMobileOTP.text.toString(),
                                  "1",
                                );
                              },
                            ),
                          ),

                          VerticalSpacer.smallMedium,
                        ],

                        if (vm.propOtpMsg != null && vm.propOtpMsg!.isNotEmpty) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.propOtpMsg.toString(),
                            style: vm.propOtpMsg == "VERIFIED"
                                ? AppTextStyles.label18primary700
                                : AppTextStyles.error,
                          ),
                        ],

                        if (vm.propReadOnly) ...[
                          VerticalSpacer.tiny,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: GCCILabel(
                                  vm.propRep.toString(),
                                  style: AppTextStyles.primary22_600,
                                ),
                              ),

                              const SizedBox(width: 10), // small gap

                              const Icon(
                                Icons.verified,
                                color: AppColor.primary,
                                size: 24,
                              ),
                            ],
                          ),
                        ],

                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Seconder",
                          style: AppTextStyles.primary22_600,
                        ),

                        buildFormField({
                          'label': 'Membership No',
                          'hint': 'Membership No',
                          'controller': vm.secMemNo,
                          'readOnly': vm.secReadOnly,
                          'icon': Icons.pin,
                          'type': 'number',
                          'onChanged': (value) {
                            vm.onMemNoChanged(context, value, "seconder");
                          },
                        }, context),

                        if (vm.secErrMsg != null) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.secErrMsg.toString(),
                            style: AppTextStyles.error,
                          ),
                        ],

                        buildFormField({
                          'label': 'Name of Member',
                          'readOnly': true,
                          'hint': 'Name of Member',
                          'controller': vm.secMemName,
                          'icon': Icons.person,
                          'type': 'name',
                        }, context),

                        if (vm.secRepName.isNotEmpty)
                          buildFormField({
                            "type": 'radio',
                            "label": 'Name of Representative',
                            "options": vm.secRepName,
                            "groupValue": vm.secRep,
                            "onChanged": (value) {
                              vm.onPropRepSelected(value, "seconder");
                            },
                          }, context),

                        VerticalSpacer.xSmall,

                        if (vm.showSecGetOtpBtn) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GCCIButton(
                              isEnabled: true,
                              fullWidth: false,
                              text: "GET OTP",
                              onPressed: () {
                                vm.getMobileOTP(
                                  context,
                                  vm.secMemNo.text.toString(),
                                  "2",
                                  vm.secMemName.text.toString(),
                                  vm.secRep.toString(),
                                  vm.secMobileNo.toString(),
                                  "seconder",
                                );
                              },
                            ),
                          ),
                        ],

                        if (vm.showSecMobileOTPBOX) ...[
                          VerticalSpacer.normalMedium,
                          buildFormField({
                            'type': 'otp',
                            'length': 5,
                            'controller': vm.secMobileOTP,
                            'onChanged': (value) {},
                          }, context),
                        ],

                        if (vm.secRetryOTP) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (vm.secShowTimer)
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: AppStrings.otpRetryIn,
                                      style: AppTextStyles.label18black500,
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Text(
                                              "${vm.secSeconds} sec",
                                              style: AppTextStyles
                                                  .label18primary700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (vm.secShowResend)
                                Expanded(
                                  child: RichText(
                                    textAlign: TextAlign.right,
                                    text: TextSpan(
                                      text: AppStrings.otpResendPrompt,
                                      style: AppTextStyles.label18black500,
                                      children: [
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: GestureDetector(
                                            onTap: () {
                                              vm.getMobileOTP(
                                                context,
                                                vm.secMemNo.text.toString(),
                                                "2",
                                                vm.secMemName.text.toString(),
                                                vm.secRep.toString(),
                                                vm.secMobileNo.toString(),
                                                "seconder",
                                              );
                                              //vm.resendOTP(context, "seconder");
                                            },
                                            child: Text(
                                              AppStrings.otpResend,
                                              style: AppTextStyles
                                                  .label18primary700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          VerticalSpacer.xSmall,
                          VerticalSpacer.xSmall,
                        ],

                        if (vm.showSecMobileOTPBOX) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GCCIButton(
                              isEnabled: true,
                              fullWidth: false,
                              text: "Verify OTP",
                              onPressed: () {
                                vm.verifyMobileOTP(
                                  context,
                                  vm.secMobileOTP.text.toString(),
                                  "2",
                                );
                              },
                            ),
                          ),
                          VerticalSpacer.smallMedium,
                        ],

                        if (vm.secOtpMsg != null && vm.secOtpMsg!.isNotEmpty) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.secOtpMsg.toString(),
                            style: vm.secOtpMsg == "VERIFIED"
                                ? AppTextStyles.label18primary700
                                : AppTextStyles.error,
                          ),
                        ],

                        if (vm.secReadOnly) ...[
                          VerticalSpacer.tiny,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: GCCILabel(
                                  vm.secRep.toString(),
                                  style: AppTextStyles.primary22_600,
                                ),
                              ),

                              const SizedBox(width: 10), // small gap

                              const Icon(
                                Icons.verified,
                                color: AppColor.primary,
                                size: 24,
                              ),
                            ],
                          ),
                        ],



                        VerticalSpacer.normalMedium,

                        GCCILabel(
                          "Only existing voting members of GCCI acts as Proposer or Seconder: In case the Proposer  or Seconder is a firm, company or association, only the representatives registered with GCCI can act as signatory.",
                          style: AppTextStyles.error,
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
                      isEnabled: vm.isVerify,
                      icon: Icons.arrow_forward,
                      text: "Next",
                      onPressed: () {
                        //if (_formKey.currentState!.validate()) {
                        widget.onNext?.call();
                        //}
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
