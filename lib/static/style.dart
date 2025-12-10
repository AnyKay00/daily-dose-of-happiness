import 'package:flutter/material.dart';

class AppColors {
  const AppColors();

  static const Color primaryColor = Color(0xFFF7D774);

  static const Color secondaryColor = Color(0xFF4EC5C1);

  static const Color backgroundColor = Color(0xFFFAF9F7);

  static const Color ligthTextColor = Color.fromARGB(255, 160, 160, 160);
}

class AppTextStyle {
  const AppTextStyle();
  static TextStyle getdynamicTextStyle(Color clr, double size) {
    return TextStyle(fontSize: size, color: clr, fontFamily: 'Montserrat');
  }

  static TextStyle getHeaderTextStyle(Color clr) {
    return TextStyle(fontSize: 18, color: clr);
  }
}

class AppGradients {
  const AppGradients();
  static LinearGradient linearGradient = const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomCenter,
      colors: [
        /*   AppColors.primaryColorGradientStart,
        // AppColors.primaryColorGradientMiddle,
        AppColors.primaryColorGradientEnd */
        AppColors.primaryColor,
        AppColors.secondaryColor,
      ]);
  static LinearGradient backgroundGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.secondaryColor,
        AppColors.primaryColor,
      ]);
}
