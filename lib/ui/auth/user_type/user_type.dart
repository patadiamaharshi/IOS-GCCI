import 'package:flutter/material.dart';
import 'package:gcci/ui/auth/user_type/user_type_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../common/dimension.dart';
import 'package:gcci/common/gcci_button.dart';
import '../../../../common/gcci_label.dart';
import '../../../../utils/app_text_styles.dart';
import 'package:gcci/common/common_toolbar.dart';

import '../../../common/circular_progress.dart';

class UserTypeScreen extends StatelessWidget {
  final int repCount;

  const UserTypeScreen({super.key ,required this.repCount});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserTypeViewModel(repCount: repCount),
      child: _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserTypeViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserTypeViewModel>();

    return Scaffold(
      appBar: const CommonToolbar(title: ''),
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
                    VerticalSpacer.medium,

                    GCCILabel('Registered as', style: AppTextStyles.heading),

                    VerticalSpacer.large,
                    VerticalSpacer.medium,
                    VerticalSpacer.medium,

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vm.type.length,
                      itemBuilder: (context, index) {
                        final item = vm.type[index];
                        return Column(
                          children: [
                            GCCIButton(
                              isEnabled: true,
                              text: item['type'],
                              onPressed: () {
                                vm.voting(context,item['type']);
                              },
                            ),
                            VerticalSpacer.large,
                            VerticalSpacer.medium,
                          ],
                        );
                      },
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
}
