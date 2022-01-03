import 'package:flutter/material.dart';
import 'package:khind/themes/app_colors.dart';

class TextStyles {
  static TextStyle textW500 = TextStyle(fontWeight: FontWeight.w500);
  static TextStyle textSm = TextStyle(fontSize: 12);
  static TextStyle textDefault = TextStyle(fontSize: 14, color: Colors.black);
  static TextStyle textDefaultBold =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textTitle =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black);
  static TextStyle textWhite = TextStyle(fontSize: 14, color: Colors.white);
  static TextStyle textWhiteBold =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle textPrimary = TextStyle(fontSize: 14, color: AppColors.primary);
  static TextStyle textPrimaryBold =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary);
  static TextStyle textSecondary = TextStyle(fontSize: 14, color: AppColors.secondary);
  static TextStyle textSecondaryBold =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.secondary);
  static TextStyle textGrey = TextStyle(fontSize: 14, color: AppColors.grey);
  static TextStyle textGreyDark = TextStyle(fontSize: 14, color: Colors.grey[700]);
}
