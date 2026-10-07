import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class AppTextStyles {
  static const String _fontFamily = 'Poppins';

  static TextStyle _base({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColor.black,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle heading = _base(size: 30, color:AppColor.primary, weight: FontWeight.w700);
  static TextStyle label = _base(size: 18,color:AppColor.charcoalGray, weight: FontWeight.w500);

  static TextStyle regular = _base(size: 18,color:AppColor.black, weight: FontWeight.w400);
  static TextStyle regular20Black600 = _base(size: 20,color:AppColor.black, weight: FontWeight.w600);


  static TextStyle regular22Black500 = _base(size: 22,color:AppColor.black, weight: FontWeight.w500);
  static TextStyle regular14Black = _base(size: 14,color:AppColor.black);
  static TextStyle regular14White = _base(size: 14,color:AppColor.white);


  static TextStyle white_18_700 = _base(size: 18,color:AppColor.white,weight: FontWeight.w700);



  static TextStyle hint = _base(size: 18, color: AppColor.grey);
  static TextStyle error = _base(size: 14, color: AppColor.error,weight: FontWeight.w500);
  static TextStyle button = _base(size: 18, color: AppColor.white,weight: FontWeight.w700);

  static TextStyle label18 = _base(size: 18,color:AppColor.charcoalGray, weight: FontWeight.w400);


  static TextStyle label18black500 = _base(size: 18,color:AppColor.black, weight: FontWeight.w500);
  static TextStyle label18primary700 = _base(size: 18,color:AppColor.primary, weight: FontWeight.w700);

  // static TextStyle primary20_500 = _base(size: 20,color:AppColor.primary, weight: FontWeight.w500);
  static TextStyle primary22_600 = _base(size: 20,color:AppColor.primary, weight: FontWeight.w600);

  static TextStyle title = _base(size: 18, weight: FontWeight.w600);
}
