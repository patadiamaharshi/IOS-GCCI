import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/ui/home/youtube/youtube.dart';
import 'package:provider/provider.dart';
import '../../../common/circular_progress.dart';
import '../../../common/dimension.dart';
import '../../../common/gcci_button.dart';
import '../../../common/common_form.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/app_text_styles.dart';
import '../../../utils/validators.dart';
import '../register/register.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginForm(),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();
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

                    GCCILabel('LOGIN', style: AppTextStyles.heading),

                    VerticalSpacer.large,

                    // Mobile Number Field
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

                    if (vm.errorMessage != null) ...[
                      VerticalSpacer.tiny,
                      GCCILabel(vm.errorMessage!, style: AppTextStyles.error),
                    ],

                    VerticalSpacer.large,

                    GCCIButton(
                      isEnabled: vm.isVerify,
                      text: AppStrings.getOTP,
                      icon: Icons.arrow_forward,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {

                          final res = await vm.login(context);
                          if (!context.mounted) return;

                          if (res?.action == "Success") {
                            vm.saveLoginData(context);
                          } else {
                            vm.setError(
                              res?.message ??
                                  "No membership record was found for this mobile number.",
                            );
                          }
                        }
                      },
                    ),
                    VerticalSpacer.large,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: GCCILabel(
                            AppStrings.notAccount,
                            style: AppTextStyles.label,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => Register()),//UserTypeScreen()),
                            );
                          },
                          child: GCCILabel(
                            AppStrings.register,
                            style: AppTextStyles.label18primary700
                          ),
                        ),
                      ],
                    ),

                    VerticalSpacer.large,

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => Youtube()), // Or UserTypeScreen()
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /*Icon(
                            FontAwesomeIcons.youtube,// Small YouTube-style icon
                            color: Colors.red,
                            size: 25,
                          ),*/
                          const SizedBox(width: 4),
                          Flexible(
                            child: GCCILabel(
                              " Subscribe our channel ",
                              style: AppTextStyles.label,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Youtube()), // Or UserTypeScreen()
                              );
                            }, // No need, row handles click
                            child: GCCILabel(
                              AppStrings.appName,
                              style: AppTextStyles.label18primary700,
                            ),
                          ),
                        ],
                      ),
                    )
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
}
