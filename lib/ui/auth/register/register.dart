import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/auth/register/verify/verify.dart';
import '../../../../../common/common_toolbar.dart';
import '../../../../../utils/app_strings.dart';
import '../../home/system_profiles/system_profiles.dart';
import 'confirm/confirm.dart';
import 'detail/detail.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}

class _Screen extends StatefulWidget {
  const _Screen();

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  int currentStep = 0;
  final int totalSteps = 3;
  String? mobile;
  String? email;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  final List<String> stepTitles = [
    "Detail",
    "Verify",
    "Confirm",
  ];

  continueStep(String? mobile, String? email) {
    this.mobile = mobile;
    this.email = email;

    debugPrint("Register Mobile: ${this.mobile}");
    debugPrint("Register Email: ${this.email}");
    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
      _scrollToStep();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const SystemProfileScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void cancelStep() {
    if (currentStep > 0) {
      setState(() => currentStep--);
      _scrollToStep();
    }
  }

  void _scrollToStep() {
    _scrollController.animateTo(
      currentStep * 0, // width per step
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonToolbar(title: AppStrings.registerSmall),
      body: Column(
        children: [
          Material(
            elevation: 1,
            color: Colors.white,
            //borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: double.infinity,
              // height: 100,
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    children: List.generate(totalSteps, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // setState(() => currentStep = index);
                            // _scrollToStep();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: currentStep >= index
                                      ? AppColor.primary
                                      : AppColor.grey,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: index < currentStep
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                      : GCCILabel(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              GCCILabel(
                                stepTitles[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: currentStep >= index
                                      ? AppColor.primary
                                      : AppColor.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: IndexedStack(
                  index: currentStep,
                  children: [
                    Detail(onNext: continueStep),
                    VerifyScreen(
                      mobile: mobile,
                      email: email,
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    Confirm(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
