import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/common/common_toolbar.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/home/system_profiles/system_profiles_viewmodel.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:provider/provider.dart';

import '../../../common/common_section.dart';

class SystemProfileScreen extends StatelessWidget {
  // final List<dynamic>? profileList;

  const SystemProfileScreen({super.key /*, this.profileList*/});

  @override
  Widget build(BuildContext context) {
    // debugPrint('Profile List: $profileList');
    return ChangeNotifierProvider(
      create: (_) => SystemProfileViewModel(/*profileList ?? []*/),
      child: _SystemProfile(),
    );
  }
}

class _SystemProfile extends StatefulWidget {
  const _SystemProfile();

  @override
  State<_SystemProfile> createState() => _SystemProfileState();
}

class _SystemProfileState extends State<_SystemProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SystemProfileViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SystemProfileViewModel>();
    return Scaffold(
      appBar: const CommonToolbar(
        title: AppStrings.chooseProfile,
        showBackButton: false,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          CommonSection(
            isLoading: vm.isLoading,
            onRefresh: _onRefresh,
            isEmpty: vm.userProfile.isEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacer.medium,

                if (vm.errorMessage != null) ...[
                  GCCILabel(vm.errorMessage!, style: AppTextStyles.error),
                ],
                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 0),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.userProfile.length,
                  itemBuilder: (context, index) {
                    final data = vm.userProfile[index];
                    // return InkWell(
                    // onTap: () {
                    //   vm.onMemberSelected(context, data);
                    // },

                    return InkWell(
                      onTap: () {
                        vm.onMemberSelected(context, data);
                      },

                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColor.buttonColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: GCCILabel(
                                    data.memberName ?? '',
                                    style: AppTextStyles.primary22_600,
                                  ),
                                ),
                                HorizontalSpacer.small,

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      // border: Border.all(
                                      //   color: AppColor.buttonColor,
                                      // ),
                                      color: Colors.grey[300],
                                    ),
                                    child: GCCILabel(
                                      data.memberStatus ?? '',
                                      style: AppTextStyles.regular14Black,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            VerticalSpacer.medium,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/user_verified.png',
                                  width: 25,
                                  height: 25,
                                  fit: BoxFit.contain,
                                ),
                                HorizontalSpacer.smallMedium,
                                Expanded(
                                  child: GCCILabel(
                                    '${data.memberCode ?? ''} - '
                                    '${data.memberType ?? ''} - '
                                    '${data.memberCategory ?? ''}',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                              ],
                            ),

                            VerticalSpacer.medium,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.phone),
                                HorizontalSpacer.smallMedium,
                                Expanded(
                                  child: GCCILabel(
                                    data.memberMobileno ?? '',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                              ],
                            ),

                            VerticalSpacer.medium,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.mail),
                                HorizontalSpacer.smallMedium,
                                Expanded(
                                  child: GCCILabel(
                                    data.memberEmail ?? '',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                              ],
                            ),

                            VerticalSpacer.medium,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Icon(Icons.location_on_outlined),
                                ),
                                HorizontalSpacer.smallMedium,
                                Expanded(
                                  child: GCCILabel(
                                    data.memberAddress ?? '',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                              ],
                            ),

                            VerticalSpacer.medium,

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.calendar_month, size: 25),
                                HorizontalSpacer.smallMedium,
                                Expanded(
                                  child: GCCILabel(
                                    '${data.memberFdate ?? ''} TO ${data.memberTdate ?? ''}',
                                    style: AppTextStyles.regular,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                    // );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await context.read<SystemProfileViewModel>().loadInitialData(context);
  }
}

/*
          "member_id": "eDNPcGsrWWJkV3FVekQ1eElNVXZVQT09",
            "member_gstno": "",
            "member_rep1_voting_no": "00002030",
            "member_rep1_fname": "Pranlal  Bhogilal",
            "member_rep1_lname": "",
            "member_rep1_designation": "",
            "member_rep1_mobile": "9879055327",
            "member_rep1_emailid": "",
            "member_rep1_photo": "https://www.gujaratchamber.org/member_photo/00002030.webp",
            "member_rep2_voting_no": "00004114",
            "member_rep2_fname": "Bhailal B. Patel",
            "member_rep2_lname": "",
            "member_rep2_designation": "",
            "member_rep2_mobile": "8866632632",
            "member_rep2_emailid": "",
            "member_rep2_photo": "https://www.gujaratchamber.org/member_photo/1677675681.JPG"
 */
