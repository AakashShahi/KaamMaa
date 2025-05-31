import 'package:flutter/material.dart';
import 'package:kaammaa/common/app_colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Inter",
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: TextStyle(
          fontFamily: "Inter",
          fontSize: 18,
          color: AppColors.secondary,
        ),
      ),
    ),
  );
}
