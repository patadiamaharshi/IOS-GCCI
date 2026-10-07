import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/auth/user_type/voting/reference/reference.dart';
import 'package:gcci/ui/auth/user_type/voting/representative1/representative1.dart';
import 'package:gcci/ui/auth/user_type/voting/representative2/representative2.dart';
import 'package:gcci/ui/auth/user_type/voting/voting_detail/voting_detail.dart';
import '../../../../../common/common_toolbar.dart';
import '../../../../../utils/app_strings.dart';
import '../../../home/dashboard/dashboard_screen.dart';
import 'business/business_detail.dart';
import 'communication/communication_detail.dart';
import 'declaration/declaration.dart';
import 'document/document.dart';

class RegisterVotingScreen extends StatelessWidget {
  final int repCount;

  const RegisterVotingScreen({super.key, required this.repCount});

  @override
  Widget build(BuildContext context) {
    return _Screen(repCount: repCount);
  }
}

class _Screen extends StatefulWidget {
  final int repCount;

  const _Screen({required this.repCount});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  int currentStep = 0;
  //final int totalSteps = 8;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  List<String> get stepTitles {
    List<String> steps = [
      "Detail",
      "Communication",
      "Representative 1",
    ];

    if (widget.repCount == 2) {
      steps.add("Representative 2");
    }

    steps.addAll([
      "Business",
      "Reference",
      "Document",
      "Declaration",
    ]);

    return steps;
  }
  int get totalSteps => stepTitles.length;
  // final List<String> stepTitles = [
  //   "Detail",
  //   "Communication",
  //   "Representative 1",
  //   "Representative 2",
  //   "Business",
  //   "Reference",
  //   "Document",
  //   "Declaration",
  // ];

  continueStep() {
    if (currentStep < totalSteps - 1) {
      setState(() => currentStep++);
      _scrollToStep();
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Dashboard()),
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
      currentStep * 100, // width per step
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonToolbar(title: AppStrings.registerVoting),
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
                child: _buildStepScreen(),
                /*   child: IndexedStack(
                  index: currentStep,
                  children: [
                   // SignUpScreen(onNext: continueStep),
                    VotingDetailScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    CommunicationDetailScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    Representative1Screen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    Representative2Screen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    BusinessDetailScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    ReferenceScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    DocumentScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                    DeclarationScreen(
                      onNext: continueStep,
                      onBack: cancelStep,
                      currentStep: currentStep,
                    ),
                  ],
                ),*/
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepScreen() {

    int stepIndex = 0;

    if (currentStep == stepIndex++) {
      return VotingDetailScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    if (currentStep == stepIndex++) {
      return CommunicationDetailScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    if (currentStep == stepIndex++) {
      return Representative1Screen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    if (widget.repCount == 2) {
      if (currentStep == stepIndex++) {
        return Representative2Screen(
          onNext: continueStep,
          onBack: cancelStep,
          currentStep: currentStep,
        );
      }
    }

    if (currentStep == stepIndex++) {
      return BusinessDetailScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    if (currentStep == stepIndex++) {
      return ReferenceScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    if (currentStep == stepIndex++) {
      return DocumentScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }
    if (currentStep == stepIndex++) {
      return DeclarationScreen(
        onNext: continueStep,
        onBack: cancelStep,
        currentStep: currentStep,
      );
    }

    return const SizedBox();
  }
  // Widget _buildStepScreen() {
  //   switch (currentStep) {
  //     case 0:
  //       return VotingDetailScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 1:
  //       return CommunicationDetailScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 2:
  //       return Representative1Screen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 3:
  //       return Representative2Screen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 4:
  //       return BusinessDetailScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 5:
  //       return ReferenceScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 6:
  //       return DocumentScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     case 7:
  //       return DeclarationScreen(
  //         onNext: continueStep,
  //         onBack: cancelStep,
  //         currentStep: currentStep,
  //       );
  //
  //     default:
  //       return const SizedBox();
  //   }
  // }
}
