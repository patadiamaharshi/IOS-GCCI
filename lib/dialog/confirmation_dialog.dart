import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:gcci/utils/app_text_styles.dart';

import '../common/gcci_button.dart';
import '../helper/app_navigator.dart';

void confirmationDialog(
  BuildContext context, {
  String message = "Title",
  String btnLeft = AppStrings.cancel,
  String btnRight = AppStrings.ok,
  required Function() onClick,
}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            GCCILabel(message, style: AppTextStyles.primary22_600),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog first
                      //onClick(); // Invoke the callback
                    }, // Close dialog
                    style: ElevatedButton.styleFrom(
                      //minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColor.buttonColor,
                      // Button background color
                      foregroundColor: AppColor.buttonColor,
                      // Text color
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      elevation: 2,
                      // Shadow intensity
                      shadowColor: AppColor.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        // Rounded corners
                        side: const BorderSide(
                          color: AppColor.buttonColor,
                          width: 2,
                        ),
                      ),
                    ),
                    // child: Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 8),
                    // Vertical padding
                    child: GCCILabel(btnLeft,style: AppTextStyles.white_18_700),
                    // ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onClick();
                    },

                    // Close dialog
                    style: ElevatedButton.styleFrom(
                      //minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColor.buttonColor,
                      // Button background color
                      foregroundColor: AppColor.buttonColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 6,
                      ),
                      // Text color
                      elevation: 2,
                      // Shadow intensity
                      shadowColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        // Rounded corners
                        side: const BorderSide(
                          color: AppColor.buttonColor,
                          width: 2,
                        ),
                      ),
                    ),
                    // child: Padding(
                    //   padding: EdgeInsets.symmetric(vertical: 0),
                    // Vertical padding
                    child: GCCILabel(
                      btnRight,
                      style: AppTextStyles.white_18_700,
                    ),
                    // ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

class DialogHelper {
  static bool _isDialogOpen = false;

  static Future<void> alertDialog({
    String errorMessageHeading = "", //,
    String errorMessageTitle = "",
    String? iconPath,
    String? btnString,
    VoidCallback? onClick,
  }) async {
    //String appName = await Prefs.getData("appName") ?? "";
    final context = AppNavigator.context;
    if (context == null || _isDialogOpen) return;

    //if (_isDialogOpen) return;
    _isDialogOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        //onWillPop: () async => false,
        canPop: false,
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                //  Icon(Icons.wifi_off, color: Colors.black, size: 60),
                Image.asset(
                  iconPath ?? "assets/alert.png", // default icon
                  width: 100,
                  height: 100,
                ),
                // Icon(
                //   Icons.warning_amber_rounded,
                //   size: 100,
                //   color: Colors.grey,
                // ),
                // Icon(Icons.cloud_done   , size: 64, color: Colors.grey),
                //VerticalSpacer.normalMedium,
                VerticalSpacer.normalMedium,

                GCCILabel(
                  errorMessageHeading.isNotEmpty
                      ? errorMessageHeading
                      : AppStrings.networkError,
                  style: AppTextStyles.primary22_600,
                  // textAlign: TextAlign.center,
                ),

                // VerticalSpacer.large,
                VerticalSpacer.normalMedium,
                // VerticalSpacer.large,

                //  CrmText(AppStrings.noInternetMSG),
                GCCILabel(
                  errorMessageTitle.isNotEmpty
                      ? errorMessageTitle
                      : AppStrings.errorMessageSubHeading,
                  //  + appName + errorMessageTitle,
                  style: AppTextStyles.label18,
                  textAlign: TextAlign.center,
                ),
                VerticalSpacer.large,

                // VerticalSpacer.normalMedium,
                Row(
                  children: [
                    Expanded(
                      child: GCCIButton(
                        isEnabled: true,
                        height: 50,
                        text: btnString ?? AppStrings.ok,
                        onPressed: () async {
                          _isDialogOpen = false;
                          if (onClick != null) {
                            onClick();
                          } else {
                            Navigator.pop(context);
                          }
                        },
                      ),

                      /* child: ElevatedButton(
                        onPressed: () {
                          _isDialogOpen = false;
                          Navigator.pop(context);
                        },

                        // Close dialog
                        style: ElevatedButton.styleFrom(
                          //minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.white,
                          // Button background color
                          foregroundColor: Colors.black,
                          // Text color
                          //elevation: 5,
                          // Shadow intensity
                          shadowColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(
                              color: AppColor.appBarColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          // Vertical padding
                          child: GCCILabel(
                            AppStrings.ok,
                            style: AppTextStyles.label18,
                          ),
                        ),
                      ),*/
                    ),
                  ],
                ),

                //VerticalSpacer.xSmall,
              ],
            ),
          ),
        ),
      ),
    ).then((_) {
      _isDialogOpen = false;
    }); //reset __isDialogOpen to false after dialog close
  }
}
