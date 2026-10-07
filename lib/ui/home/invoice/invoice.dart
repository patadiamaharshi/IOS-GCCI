import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/home/invoice/invoice_viewmodel.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../common/common_section.dart';
import '../../../network/model/invoice_response.dart';

class InvoiceScreen extends StatelessWidget {
  const InvoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InvoiceViewModel(),
      child: const _Invoice(),
    );
  }
}

class _Invoice extends StatefulWidget {
  const _Invoice();

  @override
  State<_Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<_Invoice> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InvoiceViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<InvoiceViewModel>();

    return Scaffold(
      body: CommonSection(
        isLoading: vm.isLoading,
        isEmpty:
            (vm.invoiceResponse?.newMembership?.isEmpty ?? true) &&
            (vm.invoiceResponse?.membershipRenewal?.isEmpty ?? true) &&
            (vm.invoiceResponse?.membershipUpgradation?.isEmpty ?? true) &&
            (vm.invoiceResponse?.nonVotingPayment?.isEmpty ?? true) &&
            (vm.invoiceResponse?.offlineMembershipCorrection?.isEmpty ??
                true) &&
            (vm.invoiceResponse?.nonVotingToVoting?.isEmpty ?? true),
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
                  child: Icon(
                    Icons.receipt_long,
                    color: AppColor.primary,
                    size: 30,
                  ),
                ),
                HorizontalSpacer.medium,
                GCCILabel("Invoice", style: AppTextStyles.primary22_600),
              ],
            ),
            VerticalSpacer.medium,
            newMemberSection(vm),
          ],
        ),
      ),
    );
  }

  Widget newMemberSection(InvoiceViewModel vm) {
    final InvoiceResponse? res = vm.invoiceResponse;
    if (res == null) return const SizedBox();

    final sections = <MapEntry<String, List<Invoice>>>[
      MapEntry('New Membership', res.newMembership ?? []),
      MapEntry('Membership Renewal', res.membershipRenewal ?? []),
      MapEntry('Membership Upgradation', res.membershipUpgradation ?? []),
      MapEntry('Non-Voting Payment', res.nonVotingPayment ?? []),
      MapEntry(
        'Offline Membership Correction',
        res.offlineMembershipCorrection ?? [],
      ),
      MapEntry('Non Voting to Voting', res.nonVotingToVoting ?? []),
    ].where((e) => e.value.isNotEmpty).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sections.length,
      itemBuilder: (context, index) {
        final section = sections[index];
        final title = section.key;
        final children = section.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: GCCILabel(title, style: AppTextStyles.primary22_600),
            ),
            VerticalSpacer.medium,

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor),
              ),
              child: Column(
                children: children.map((child) {
                  final isLast = children.indexOf(child) == children.length - 1;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                GCCILabel(
                                  'Invoice : #${child.invoiceNo ?? ''}',
                                  style: AppTextStyles.label18primary700,
                                ),
                                const Spacer(),
                                GCCILabel(
                                  "₹${child.invoiceAmount ?? ''}",
                                  style: AppTextStyles.primary22_600,
                                ),
                              ],
                            ),

                            VerticalSpacer.small,

                            GCCILabel(
                              "FY ${child.financialYear ?? ''}",
                              style: AppTextStyles.regular20Black600,
                            ),
                            VerticalSpacer.small,

                            GCCILabel(
                              'Invoice Date : ${child.invoiceDate ?? ''}',
                              style: AppTextStyles.label18,
                            ),
                            VerticalSpacer.small,

                            Row(
                              children: [
                                if (child.fromDate != null &&
                                    child.toDate != null)
                                  GCCILabel(
                                    '${child.fromDate} TO ${child.toDate}',
                                    style: AppTextStyles.label18,
                                  ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    vm.onDownloadClick(
                                      child.paymentId,
                                      context,
                                    );
                                  },
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
                        Container(height: 1, color: AppColor.buttonColor),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await context.read<InvoiceViewModel>().loadInitialData(context);
  }
}
