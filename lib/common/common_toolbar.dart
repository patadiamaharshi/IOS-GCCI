import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/theme/app_color.dart';
import '../utils/app_text_styles.dart';

class CommonToolbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final Color iconColor;
  final Color titleColor;
  final bool centerTitle;
  final TextStyle? titleTextStyle;

  const CommonToolbar({
    super.key,
    required this.title,
    this.centerTitle = false,
    this.showBackButton = true,
    this.backgroundColor = AppColor.appBarColor,
    this.iconColor = AppColor.primary,
    this.titleColor = AppColor.primary,
    this.titleTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      titleSpacing: 10,
      centerTitle: centerTitle,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.only(
                left: 5,
              ), // or any padding you want
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: iconColor, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      title: Padding(
        padding: EdgeInsets.only(
          left: showBackButton ? 0 : 0,
        ),
        child: GCCILabel(
          title,
          style: titleTextStyle ?? AppTextStyles.primary22_600,
          textAlign: centerTitle ? TextAlign.center : TextAlign.start,
        ),
      ),

      /* title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: GCCILabel(
          title,
          style: titleTextStyle ?? AppTextStyles.primary22_600,
        ),
      ),*/

     // title: GCCILabel(title, style: AppTextStyles.regular22Black500),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
