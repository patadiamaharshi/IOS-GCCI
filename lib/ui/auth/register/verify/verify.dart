import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/register/verify/verify_vm.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../theme/app_color.dart';
import '../../../../../../utils/app_strings.dart';
import 'package:gcci/utils/validators.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../../../utils/app_text_styles.dart';
import '../../../../common/gcci_label.dart';

class VerifyScreen extends StatelessWidget {
  final String? mobile;
  final String? email;

  final Function(String mobile, String email)? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const VerifyScreen({
    super.key,
    this.mobile,
    this.email,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerifyViewModel(onNext: onNext),
      child: _VerifyScreen(
        //onNext: onNext,
        onBack: onBack,
        mobile: mobile,
        email: email,
        currentStep: currentStep,
      ),
    );
  }
}

class _VerifyScreen extends StatefulWidget {
  // final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String? mobile;
  final String? email;
  final int currentStep;

  const _VerifyScreen({
    // this.onNext,
    this.onBack,
    this.mobile,
    this.email,
    required this.currentStep,
  });

  @override
  State<_VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<_VerifyScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VerifyViewModel>();
    vm.email.text = widget.email.toString();
    vm.mobile.text = widget.mobile.toString();

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
                          'label': 'Mobile Number *',
                          'type': 'number',
                          "icon": Icons.phone,
                          "readOnly": true,
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

                        VerticalSpacer.medium,

                        // if (vm.mobile.text.trim().length == 10 &&
                        //     !vm.showMobileOTPBOX) ...[
                        //   Align(
                        //     alignment: Alignment.centerRight,
                        //     child: GCCIButton(
                        //       isEnabled: true,
                        //       fullWidth: false,
                        //       text: "GET MOBILE OTP",
                        //       onPressed: () {
                        //         vm.getMobileOTP();
                        //       },
                        //     ),
                        //   ),
                        //
                        //   VerticalSpacer.smallMedium,
                        // ],

                        // GCCILabel(
                        //   "GET OTP",
                        //   style: AppTextStyles.primary22_600,
                        // ),
                        if (vm.showMobileOTPBOX)
                          buildFormField({
                            'type': 'otp',
                            'length': 5,
                            'controller': vm.mobileOTP,
                            // 'validator': (value) {
                            //   if (value == null || value.length < 6) {
                            //     return "Enter valid OTP";
                            //   }
                            //   return null;
                            // },
                            'onChanged': (value) {
                            },
                          }, context),

                        // if (vm.retryOTPMobile) ...[
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       if (vm.showMobileTimer)
                        //         Expanded(
                        //           child: RichText(
                        //             textAlign: TextAlign.left,
                        //             text: TextSpan(
                        //               text: AppStrings.otpRetryIn,
                        //               style: AppTextStyles.label18black500,
                        //               children: [
                        //                 WidgetSpan(
                        //                   alignment:
                        //                       PlaceholderAlignment.middle,
                        //                   child: GestureDetector(
                        //                     onTap: () {},
                        //                     child: Text(
                        //                       "${vm.mobileSeconds} sec",
                        //                       style: AppTextStyles
                        //                           .label18primary700,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       if (vm.showMobileResend)
                        //         Expanded(
                        //           child: RichText(
                        //             textAlign: TextAlign.right,
                        //             text: TextSpan(
                        //               text: AppStrings.otpResendPrompt,
                        //               style: AppTextStyles.label18black500,
                        //               children: [
                        //                 WidgetSpan(
                        //                   alignment:
                        //                       PlaceholderAlignment.middle,
                        //                   child: GestureDetector(
                        //                     onTap: () {
                        //                       vm.resendMobileOTP();
                        //                     },
                        //                     child: Text(
                        //                       AppStrings.otpResend,
                        //                       style: AppTextStyles
                        //                           .label18primary700,
                        //                     ),
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //     ],
                        //   ),
                        //
                        //   VerticalSpacer.xSmall,
                        //   VerticalSpacer.xSmall,
                        // ],

                        // if (vm.mobileOTP.text.trim().length == 5)
                        //   Align(
                        //     alignment: Alignment.centerRight,
                        //     child: GCCIButton(
                        //       isEnabled: true,
                        //       fullWidth: false,
                        //       text: "VERIFY MOBILE OTP",
                        //       onPressed: () async {
                        //         final res = await vm.otpRegVerify(context);
                        //
                        //         if (res != null &&
                        //             res['memberRegisterVerification'] != null &&
                        //             res['memberRegisterVerification'].isNotEmpty &&
                        //             res['memberRegisterVerification'][0]['verification']
                        //                 ?.toString()
                        //                 .toLowerCase() ==
                        //                 "success") {
                        //
                        //           debugPrint("Verify Successfully");
                        //           // vm.next(context);
                        //
                        //         } else {
                        //           vm.setError(
                        //             res?['memberRegisterVerification'][0]['Error'] ??
                        //                 "INVALID OTP.",
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   ),

                        /* GCCILabel(
                          "VERIFY OTP",
                          style: AppTextStyles.primary22_600,
                        ),*/
                        buildFormField({
                          'type': 'email',
                          'label': 'Email *',
                          'hint': 'Email',
                          'icon': Icons.mail,
                          'controller': vm.email,
                          "readOnly": true,
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

                        VerticalSpacer.medium,

                        if (vm.email.text.trim().isNotEmpty &&
                            Validators.isValidEmail(vm.email.text) &&
                            !vm.showEmailOTPBOX) ...[
                          Align(
                            alignment: Alignment.centerRight,
                            child: GCCIButton(
                              isEnabled: true,
                              fullWidth: false,
                              text: "GET EMAIL OTP",
                              onPressed: () {
                                vm.getEmailOTP();
                              },
                            ),
                          ),
                          VerticalSpacer.smallMedium,
                          VerticalSpacer.normalMedium,
                        ],

                        // GCCILabel(
                        //   "GET EMAIL OTP",
                        //   style: AppTextStyles.primary22_600,
                        // ),
                        //VerticalSpacer.normalMedium,
                        if (vm.showEmailOTPBOX)
                          buildFormField({
                            'type': 'otp',
                            'length': 5,
                            'controller': vm.emailOTP,
                            // 'validator': (value) {
                            //   if (value == null || value.length < 6) {
                            //     return "Enter valid Email OTP";
                            //   }
                            //   return null;
                            // },
                            'onChanged': (value) {
                            },
                          }, context),

                        if (vm.retryOTPEmail) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (vm.showEmailTimer)
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
                                              "${vm.emailSeconds} sec",
                                              style: AppTextStyles
                                                  .label18primary700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (vm.showEmailResend)
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
                                              vm.resendEmailOTP(context);
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

                        // if (vm.emailOTP.text.trim().length == 5)
                        //   Align(
                        //     alignment: Alignment.centerRight,
                        //     child: GCCIButton(
                        //       isEnabled: true,
                        //       fullWidth: false,
                        //       text: "VERIFY EMAIL OTP",
                        //       onPressed: () async {
                        //         final res = await vm.otpRegVerify(context);
                        //
                        //         if (res != null &&
                        //             res['memberRegisterVerification'] != null &&
                        //             res['memberRegisterVerification'].isNotEmpty &&
                        //             res['memberRegisterVerification'][0]['verification']
                        //                 ?.toString()
                        //                 .toLowerCase() ==
                        //                 "success") {
                        //
                        //           debugPrint("Verify Successfully");
                        //           // vm.next(context);
                        //
                        //         } else {
                        //           vm.setError(
                        //             res?['memberRegisterVerification'][0]['Error'] ??
                        //                 "INVALID OTP.",
                        //           );
                        //         }
                        //       },
                        //     ),
                        //   ),

                        if (vm.errorMessage != null) ...[
                          VerticalSpacer.tiny,
                          GCCILabel(
                            vm.errorMessage!,
                            style: AppTextStyles.error,
                          ),
                        ],


                        // GCCILabel(
                        //   "VERIFY EMAIL OTP",
                        //   style: AppTextStyles.primary22_600,
                        // ),
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
                      isEnabled: true,//vm.isVerify,
                      icon: Icons.arrow_forward,
                      text: "Confirm",
                      onPressed: () {
                        vm.otpRegVerify(context);
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
