import 'package:flutter/material.dart';
import 'package:gcci/common/gcci_label.dart';
import 'package:gcci/utils/app_strings.dart';
import 'package:gcci/utils/app_text_styles.dart';

class CrmNoDataText extends StatelessWidget {
  final String? message;
  final TextStyle? style;

  const CrmNoDataText({
    super.key,
    this.message,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GCCILabel(
        message ?? AppStrings.noRecordFound,
        style: style ?? AppTextStyles.primary22_600,
      ),
    );
  }
}
