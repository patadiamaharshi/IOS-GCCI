import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../../common/dimension.dart';
import '../../../../../../common/circular_progress.dart';
import '../../../../../../theme/app_color.dart';
import 'package:gcci/common/gcci_button.dart';

import '../../../../../common/common_form.dart';
import '../../../../../common/gcci_label.dart';
import '../../../../../utils/app_text_styles.dart';
import 'business_detail_view_model.dart';

class BusinessDetailScreen extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const BusinessDetailScreen({
    super.key,
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BusinessDetailViewModel(onNext: onNext),
      child: _BusinessDetailScreen(
        onNext: onNext,
        onBack: onBack,
        currentStep: currentStep,
      ),
    );
  }
}

class _BusinessDetailScreen extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final int currentStep;

  const _BusinessDetailScreen({
    this.onNext,
    this.onBack,
    required this.currentStep,
  });

  @override
  State<_BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<_BusinessDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessDetailViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BusinessDetailViewModel>();
    return Stack(
      children: [
        Column(
          children: [

            VerticalSpacer.normal,

            buildFormField({
              'hint': 'Search',
              'controller': vm.searchKey,
              'icon': Icons.search,
              'type': 'text',
              'onChanged': (value) {
                setState(() {
                  if(vm.searchKey.text.isEmpty) return ;
                  vm.searchKey.text = vm.searchKey.text.toLowerCase();
                });
              },
            }, context),

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: vm.busCatList.length,
                        itemBuilder: (context, index) {
                          final category = vm.busCatList[index];
                          final subCategory = category['subcategories'];

                          final filteredSubCategory = subCategory.where((sub) {
                            final name =(sub['subcategory_name'] ?? '').toString().toLowerCase();
                            return name.contains(vm.searchKey.text);
                          }).toList();

                          if (filteredSubCategory.isEmpty) {
                            return const SizedBox();
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VerticalSpacer.large,
                              GCCILabel(
                                category['category_name'],
                                style: AppTextStyles.primary22_600,
                              ),

                              VerticalSpacer.medium,

                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: subCategory.length,
                                itemBuilder: (context, subIndex) {
                                  final subId =
                                      subCategory[subIndex]['subcategory_id'];
                                  return buildFormField({
                                    'type': 'checkbox',
                                    'label':
                                        subCategory[subIndex]['subcategory_name'],
                                    'value': vm.subCatId.contains(subId),
                                    'onChanged': (value) {
                                      vm.toggleSubCategory(
                                        subId,
                                        value ?? false,
                                      );
                                    },
                                  }, context);
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
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
                        vm.updateMemberBusCategory(context);
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