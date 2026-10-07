import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/helper/extension.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/auth/otp/otp_viewmodel.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:provider/provider.dart';
import '../../../common/dimension.dart';
import '../../../common/circular_progress.dart';
import '../../../common/gcci_button.dart';
import '../../../utils/app_text_styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpViewModel(mobileNumber),
      child: _OtpForm(mobileNumber: mobileNumber),
    );
  }
}

class _OtpForm extends StatefulWidget {
  final String mobileNumber;

  const _OtpForm({required this.mobileNumber});

  @override
  State<_OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<_OtpForm> {
  final _formKey = GlobalKey<FormState>();

  bool _showTimerOptions = true;
  int _seconds = 60;
  late Timer? _timer;
  bool _showResendOptions = false;

  @override
  void initState() {
    super.initState();

    _timer = Timer(Duration(seconds: 0), () {});
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OtpViewModel>();
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),

              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Image.asset('assets/gcci_icon.png', height: 180),
                    ),

                    VerticalSpacer.large,

                    GCCILabel('VERIFY', style: AppTextStyles.heading),

                    VerticalSpacer.large,

                    GCCILabel(
                      AppStrings.otpHint + maskPhoneNumber(widget.mobileNumber),
                      style: AppTextStyles.label18,
                      textAlign: TextAlign.center,
                    ),

                    VerticalSpacer.large,

                    PinCodeTextField(
                      appContext: context,
                      length: 5,
                      // OTP length
                      controller: vm.otp,
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      cursorColor: AppColor.black,
                      showCursor: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 50,
                        inactiveColor: AppColor.grey,
                        inactiveFillColor: AppColor.white,

                        activeFillColor: AppColor.white,
                        activeColor: AppColor.black,

                        selectedColor: AppColor.black,
                        selectedFillColor: AppColor.white,
                      ),
                      /*  validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "OTP is required";
                        }
                        return _otpError;
                         else if (value.length < 6) {
                             return "Enter a valid 6-digit OTP"; // Error if OTP is incomplete
                             }
                        return null;
                      },*/
                      onChanged: (value) {},
                    ),

                    if (vm.errorMessage != null) ...[
                      VerticalSpacer.tiny,
                      GCCILabel(vm.errorMessage!, style: AppTextStyles.error),
                    ],

                    VerticalSpacer.large,

                    GCCIButton(
                      isEnabled: vm.isVerify,
                      text: AppStrings.verify,
                      icon: Icons.arrow_forward,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final res = await vm.otpLogin(context);
                          if (!context.mounted) return;
                          if (res?.action == "Success") {
                            vm.verifyOtp(context);
                          } else {
                            vm.setError(
                              res?.message ??
                                  "User verification failed or Incorrect OTP.",
                            );
                          }
                        }
                      },
                    ),
                    VerticalSpacer.normal,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_showTimerOptions)
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                text: AppStrings.otpRetryIn,
                                style: AppTextStyles.label18black500,
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Text(
                                        "$_seconds sec",
                                        style: AppTextStyles.label18primary700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_showResendOptions)
                          Expanded(
                            child: RichText(
                              textAlign: TextAlign.right,
                              text: TextSpan(
                                text: AppStrings.otpResendPrompt,
                                style: AppTextStyles.label18black500,
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () {
                                        _resendOTP(vm);
                                      },
                                      child: Text(
                                        AppStrings.otpResend,
                                        style: AppTextStyles.label18primary700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (vm.isLoading)
            Center(child: CircularProgress(isLoading: vm.isLoading)),
        ],
      ),
    );
  }

  _resendOTP(OtpViewModel vm) async {
    startTimer();
    if (_formKey.currentState!.validate()) {
     /* final res = */await vm.login(context);

      // if (res?.action == "Success") {
      //   vm.saveLoginData(context);
      // }
    }
  }

  @override
  void dispose() {
    _timer
        ?.cancel(); // Cancel the timer to avoid calling setState after dispose
    super.dispose();
  }

  void startTimer() {
    debugPrint("startTimer successfully");
    _timer?.cancel();

    setState(() {
      _seconds = 60;
      _showTimerOptions = true;
      _showResendOptions = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _showResendOptions = true;
          _showTimerOptions = false;
        });
      }
    });
  }
}
