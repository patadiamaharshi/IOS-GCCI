import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_button.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/ui/home/event/view/event_viewmodel.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:gcci/utils/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/common_section.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventViewModel(),
      child: const _EventScreen(),
    );
  }
}

class _EventScreen extends StatefulWidget {
  const _EventScreen();

  @override
  State<_EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<_EventScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventViewModel>().loadInitialData(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EventViewModel>();

    return Scaffold(
      body: Stack(
        children: [
          CommonSection(
            isLoading: vm.isLoading,
            isEmpty: vm.events.isEmpty,
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
                      "Upcoming Events",
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
                  itemCount: vm.events.length,
                  itemBuilder: (context, index) {
                    final event = vm.events[index];
                    // return InkWell(
                    //   onTap: () {
                    //     debugPrint("Clicked index: ${event.eventId}");
                    //   },

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: InkWell(
                        // onTap: () {
                        //   debugPrint("Clicked index: $event");
                        // },
                        child: Container(
                          // margin: const EdgeInsets.only(bottom: 20),
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
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       child: GCCILabel(
                              //         "user['ID']!",
                              //         style: AppTextStyles.label18primary700,
                              //       ),
                              //     ),
                              //
                              //     Container(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 8, vertical: 2),
                              //       decoration: BoxDecoration(
                              //         borderRadius: BorderRadius.circular(4),
                              //         color: ColorUtils.getStatusBackGroundColor(
                              //             "user['status'] ?? ''"),
                              //       ),
                              //       child: GCCILabel(
                              //         "user['status']!",
                              //         style: AppTextStyles.regular14White,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              //VerticalSpacer.medium,
                              GCCILabel(
                                event.eventName ?? "",
                                style: AppTextStyles.regular20Black600,
                              ),
                              VerticalSpacer.medium,
                              GCCILabel(
                                event.eventVenue ?? "",
                                style: AppTextStyles.regular,
                              ),
                              VerticalSpacer.medium,
                              GCCILabel(
                                '${event.fromDate ?? ""} TO ${event.toDate ?? ""} ${event.eventTime ?? ""}',
                                style: AppTextStyles.label18,
                              ),
                              VerticalSpacer.medium,

                              Align(
                                alignment: Alignment.centerRight,
                                // 👈 end (right)
                                child: GCCIButton(
                                  isEnabled: true,
                                  height: 40,
                                  fullWidth: false,
                                  text: AppStrings.bookNow,
                                  onPressed: () {
                                    if ((event.eventLink ?? "").trim().isNotEmpty) {
                                      launchUrl(
                                        Uri.parse(event.eventLink!),
                                        mode: LaunchMode.externalApplication,
                                      );
                                    } else {
                                      vm.newEvent(context, event);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    // );
                  },
                ),
              ],
            ),
          ),
          // if (vm.isLoading)
          //   Center(child: CircularProgress(isLoading: vm.isLoading)),

          // Positioned(
          //   bottom: 16,
          //   right: 16,
          //   child: GCCIButton(
          //     isEnabled: true,
          //     leadingIcon: Icons.add,
          //     fullWidth: false,
          //     text: AppStrings.newEvent,
          //     onPressed: () {
          //       vm.newEvent(context);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    await context.read<EventViewModel>().loadInitialData(context);
  }
}
