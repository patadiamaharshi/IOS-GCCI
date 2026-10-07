import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/ui/home/home/home_viewmodel.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:gcci/theme/app_color.dart';
import '../../../common/common_section.dart';
import '../../../common/gcci_button.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: CommonSection(
                isLoading: vm.isLoading,
                onRefresh: _onRefresh,
                isEmpty: vm.idCard.isEmpty && vm.certificate.isEmpty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VerticalSpacer.medium,
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Icon(
                            Icons.home,
                            color: AppColor.primary,
                            size: 30,
                          ),
                        ),
                        HorizontalSpacer.medium,
                        GCCILabel("Home", style: AppTextStyles.primary22_600),
                      ],
                    ),

                    if (vm.memberCode != "0" &&
                        (vm.memberType == "Voting" || vm.memberType == "Association")) ...[
                      VerticalSpacer.medium,
                      idCardSection(vm),
                    ],

                    if(vm.memberCode !="0" && vm.memberType == "Non-Voting")...[
                      certificateSection(vm),
                    ],
                  ],
                ),
              ),
            ),

            if (vm.becameMember)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: GCCIButton(
                  isEnabled: true,
                  text: vm.btnText,
                  icon: Icons.arrow_forward,
                  onPressed: () async {
                    vm.navigateTo(context);
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget idCardSection(HomeViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vm.idCard.length,
      itemBuilder: (context, index) {
        final item = vm.idCard[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            GCCILabel(item['title']!, style: AppTextStyles.primary22_600),
            VerticalSpacer.medium,
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColor.buttonColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/gcci_icon.png',
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    ),

                                    VerticalSpacer.small,

                                    GCCILabel(
                                      vm.memberName?.toString() ?? "",
                                      style: AppTextStyles.regular20Black600,
                                    ),

                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GCCILabel(
                                          vm.mobile?.toString() ?? "",
                                          style: AppTextStyles.regular,
                                        ),

                                        if (item['link'] != null &&
                                            item['link'].toString().isNotEmpty)
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {
                                                  vm.onDownloadClick(
                                                    item['link'],
                                                  );
                                                  // vm.onDownloadClick(
                                                  //   child['link'],
                                                  // );
                                                },
                                                child: Icon(
                                                  Icons.download,
                                                  size: 28,
                                                  color: AppColor.primary,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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

  Widget certificateSection(HomeViewModel vm) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 20),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: vm.certificate.length,
      itemBuilder: (context, index) {
        final item = vm.certificate[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: AppColor.buttonColor, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      GCCILabel(
                        item['title'],
                        style: AppTextStyles.primary22_600,
                      ),
                      const Spacer(),

                      if (item['link'] != null &&
                          item['link'].toString().isNotEmpty)
                        InkWell(
                          onTap: () {
                            vm.onDownloadClick(item['link']);
                          },
                          child: Icon(
                            Icons.download,
                            size: 28,
                            color: AppColor.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    await context.read<HomeViewModel>().getCertificateList(context);
  }
}
