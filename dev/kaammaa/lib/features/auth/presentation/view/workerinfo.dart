import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';

void showWorkerInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 50,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Access Restricted",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Workers can only use the web app to access the system.\nThank you!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: "Inter"),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Inter",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}
