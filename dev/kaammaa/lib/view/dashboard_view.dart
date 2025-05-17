import 'package:flutter/material.dart';
import 'package:kaammaa/constants/app_colors.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
