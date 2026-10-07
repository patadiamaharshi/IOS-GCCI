import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/home/receipt/receipt_viewmodel.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../../common/common_section.dart';

class ReceiptScreen extends StatelessWidget {
  const ReceiptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReceiptViewModel(),
      child: const _Receipt(),
    );
  }
}

class _Receipt extends StatefulWidget {
  const _Receipt();

  @override
  State<_Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<_Receipt> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReceiptViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReceiptViewModel>();

    return Scaffold(
      body: CommonSection(
        isLoading: vm.isLoading,
        isEmpty: vm.receipt.isEmpty,
        onRefresh: _onRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacer.medium,

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.receipt, color: AppColor.primary, size: 30),
                ),
                HorizontalSpacer.medium,
                GCCILabel("Receipt", style: AppTextStyles.primary22_600),
              ],
            ),
            VerticalSpacer.medium,
            certificateSection(vm),
          ],
        ),
      ),
    );
  }

  Widget certificateSection(ReceiptViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vm.receipt.length,
      itemBuilder: (context, index) {
        final item = vm.receipt[index];
        final List? children = item['children'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Padding(
              padding: const EdgeInsets.only(top:0 ),
              child: GCCILabel(
                item['title'],
                style: AppTextStyles.primary22_600,
              ),
            ),
            VerticalSpacer.medium,
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (children != null)
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children.map<Widget>((child) {
                          final isLast =
                              children.indexOf(child) == children.length - 1;

                          return InkWell(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          GCCILabel(
                                            child['No'],
                                            style: AppTextStyles.label18primary700,
                                          ),
                                          const Spacer(),
                                          GCCILabel(
                                            "₹${child['Amount']}",
                                            style: AppTextStyles.primary22_600,
                                          ),
                                        ],
                                      ),
                                      VerticalSpacer.small,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: GCCILabel(
                                              child['Name'],
                                              style: AppTextStyles.regular20Black600,
                                            ),
                                          ),

                                        ],
                                      ),

                                      VerticalSpacer.small,

                                      Row(
                                        children: [
                                          GCCILabel(
                                            child['created_at'],
                                            style: AppTextStyles.label18,
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: vm.onDownloadClick,
                                            child: Icon(
                                              Icons.download,
                                              size: 28,
                                              color: AppColor.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                if (!isLast)
                                  Container(
                                    height: 1,
                                    color: AppColor.buttonColor,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await context.read<ReceiptViewModel>().loadInitialData(context);
  }
}
