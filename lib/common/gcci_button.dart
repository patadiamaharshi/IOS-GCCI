import 'package:flutter/material.dart';
import 'package:gcci/common/dimension.dart';

import '../theme/app_color.dart';
import '../utils/app_strings.dart';
import '../utils/app_text_styles.dart';
import 'gcci_label.dart';

class GCCIButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback onPressed;
  final String text;
  final Color backgroundColor;
  final IconData? icon;
  final IconData? leadingIcon;
  final bool fullWidth;
  final double? height;

  const GCCIButton({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    this.text = '',
    this.backgroundColor = AppColor.buttonColor,
    this.icon,          // after text (existing)
    this.leadingIcon,
    this.fullWidth = true,// before text (new)
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child:
      Column(

        children: [
          //VerticalSpacer.normalMedium,
          // VerticalSpacer.large,
          SizedBox(
            height: height ?? 55,
            width: fullWidth ? double.infinity : null,
            child: TextButton(
              onPressed: isEnabled ? onPressed : null,
              style: TextButton.styleFrom(
                backgroundColor: isEnabled ? backgroundColor : AppColor.disableButtonColor,
                foregroundColor: AppColor.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child:Row(
                      children: [
                        if (leadingIcon != null) ...[
                          Icon(
                            leadingIcon,
                            size: 28,
                            color: AppColor.white,
                          ),
                          HorizontalSpacer.tiny,
                        ],
                        GCCILabel(
                          text.isEmpty ? AppStrings.ok : text,
                          style: AppTextStyles.button,
                        ),
                        if (icon != null) ...[
                          HorizontalSpacer.medium,
                          Icon(
                            icon,
                            size: 25,
                            color: AppColor.white,
                          ),
                        ],
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ) ,
    );
  }
}