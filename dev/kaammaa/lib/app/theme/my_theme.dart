import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    useMaterial3: false,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Inter",

    // Icon theme for default icons
    iconTheme: IconThemeData(color: AppColors.primary),

    // Elevated button theme
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

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.primary.withOpacity(0.5),
      selectedIconTheme: IconThemeData(color: AppColors.primary),
      unselectedIconTheme: IconThemeData(
        color: AppColors.primary.withOpacity(0.5),
      ),
      backgroundColor: Colors.white,
      showUnselectedLabels: true,
    ),
  );
}
