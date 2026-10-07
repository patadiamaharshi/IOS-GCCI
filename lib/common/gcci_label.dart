import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

class GCCILabel extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  //final int? maxLines;
  //final TextOverflow? overflow;

  const GCCILabel(
      this.text, {
        super.key,
        this.style,
        this.textAlign,
       // this.maxLines,
    //    this.overflow,
      });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? AppTextStyles.regular,
      textAlign: textAlign,
    //  maxLines: maxLines,
    //  overflow: overflow,
    );
  }
}
