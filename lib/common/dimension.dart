import 'package:flutter/widgets.dart';

// Define common spacing values
const spacingTiny = 4.0;
const spacingXSmall = 5.0;
const spacingSmall = 8.0;
const spacingMedium = 10.0;
const spacingSmallMedium = 12.0;
const spacingNormal = 16.0;
const spacingNormalMedium = 20.0;
const spacingLarge = 24.0;
const spacingXLarge = 48.0;
const spacingXXLarge = 32.0;
const spacingXXXLarge = 40.0;

// Vertical Spacers
class VerticalSpacer {
  static const tiny = SizedBox(height: spacingTiny);
  static const xSmall = SizedBox(height: spacingXSmall);
  static const small = SizedBox(height: spacingSmall);
  static const medium = SizedBox(height: spacingMedium);
  static const smallMedium = SizedBox(height: spacingSmallMedium);
  static const normal = SizedBox(height: spacingNormal);
  static const normalMedium = SizedBox(height: spacingNormalMedium);
  static const large = SizedBox(height: spacingLarge);
  static const xLarge = SizedBox(height: spacingXLarge);
  static const xxLarge = SizedBox(height: spacingXXLarge);
  static const xxxLarge = SizedBox(height: spacingXXXLarge);
}

// Horizontal Spacers
class HorizontalSpacer {
  static const tiny = SizedBox(width: spacingTiny);
  static const xSmall = SizedBox(width: spacingXSmall);
  static const small = SizedBox(width: spacingSmall);
  static const medium = SizedBox(width: spacingMedium);
  static const smallMedium = SizedBox(width: spacingSmallMedium);
  static const normal = SizedBox(width: spacingNormal);
  static const large = SizedBox(width: spacingLarge);
  static const xxLarge = SizedBox(width: spacingXXLarge);
  static const xxxLarge = SizedBox(width: spacingXXXLarge);
}
