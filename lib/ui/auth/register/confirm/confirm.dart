import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/common_form.dart';
import '../../../../../../theme/app_color.dart';
import 'package:gcci/common/gcci_button.dart';
import 'confirm_vm.dart';

class Confirm extends StatelessWidget {
  final Function(String mobile, String email)? onNext;

  final VoidCallback? onBack;
  final int currentStep;

  const Confirm({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ConfirmViewModel(),
      child: _Screen(onBack: onBack, onNext: onNext, currentStep: currentStep),
    );
  }
}

class _Screen extends StatefulWidget {
  final Function(String mobile, String email)? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _Screen({this.onNext, this.onBack, required this.currentStep});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ConfirmViewModel>();

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

                        buildFormField({
                          'type': 'checkbox',
                          'label':
                              "I/We agree to the Constitution and Regulations of Gujarat Chamber of Commerce & Industry along with the amendments made from time to time, and shall abide by them.",
                          'value': vm.isAccept,
                          'onChanged': (value) {
                            vm.setAccept(value ?? false);
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
                      isEnabled: vm.isAccept,
                      icon: Icons.arrow_forward,
                      text: "Accept",
                      onPressed: () {
                        widget.onNext?.call('', '');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
