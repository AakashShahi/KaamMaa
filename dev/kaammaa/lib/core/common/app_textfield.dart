import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  required bool obscureText,
  required String? Function(String?) validator,
  Widget? suffixIcon,
  TextInputType keyboardType = TextInputType.text,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.textPrimary),
      filled: true,
      fillColor: AppColors.textFieldFill,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      suffixIcon: suffixIcon,
    ),
    validator: validator,
  );
}
