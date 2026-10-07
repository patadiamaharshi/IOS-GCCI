import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_button.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../../common/common_section.dart';
import 'booking_vm.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingViewModel(),
      child: const _BookingScreen(),
    );
  }
}

class _BookingScreen extends StatefulWidget {
  const _BookingScreen();

  @override
  State<_BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<_BookingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BookingViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          CommonSection(
            isLoading: vm.isLoading,
            isEmpty: vm.bookings.isEmpty,
            onRefresh: _onRefresh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VerticalSpacer.medium,

                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.event,
                        color: AppColor.primary,
                        size: 30,
                      ),
                    ),
                    HorizontalSpacer.medium,
                    GCCILabel(
                      "Hall Booking",
                      style: AppTextStyles.primary22_600,
                    ),
                  ],
                ),

                VerticalSpacer.medium,
                VerticalSpacer.medium,

                ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.bookings.length,
                  itemBuilder: (context, index) {
                    final hall = vm.bookings[index];
                    return InkWell(
                      // onTap: () {
                      //   debugPrint('Clicked index: $hall');
                      // },
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
                            /*   Row(
                              children: [
                                Expanded(
                                  child: GCCILabel(
                                    user['ID']!,
                                    style: AppTextStyles.label18primary700,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: ColorUtils.getStatusBackGroundColor(
                                        user['status'] ?? ''),
                                  ),
                                  child: GCCILabel(
                                    user['status']!,
                                    style: AppTextStyles.regular14White,
                                  ),
                                ),
                              ],
                            ),
                            VerticalSpacer.medium,*/
                            GCCILabel(
                              hall.hallName ?? '',
                              style: AppTextStyles.regular20Black600,
                            ),

                            VerticalSpacer.small,

                            GCCILabel(
                              'Capacity : ${hall.hallCapacity ?? ''}',
                              style: AppTextStyles.label18,
                            ),

                            VerticalSpacer.small,

                            GCCILabel(
                              'Hour : ${hall.hallHours ?? ''}',
                              style: AppTextStyles.label18,
                            ),

                            VerticalSpacer.small,

                            // GCCILabel(
                            //   'Booking Amount : ${hall.hallAmount ?? ''}',
                            //   style: AppTextStyles.label18,
                            // ),

                            VerticalSpacer.small,

                            Align(
                              alignment: Alignment.centerRight,
                              child: GCCIButton(
                                isEnabled: true,
                                height: 40,
                                fullWidth: false,
                                text: AppStrings.bookNow,
                                onPressed: () {
                                  vm.newBooking(context /*,hall*/);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: GCCIButton(
              isEnabled: true,
              leadingIcon: Icons.add,
              fullWidth: false,
              text: AppStrings.newBooking,
              onPressed: () {
                vm.newBooking(context /*,hall*/);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await context.read<BookingViewModel>().loadInitialData(context);
  }
}
