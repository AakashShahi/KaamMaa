import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_state.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';

class SelectionView extends StatelessWidget {
  const SelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocProvider(
          create: (_) => serviceLocater<SelectionViewModel>(),
          child: BlocBuilder<SelectionViewModel, SelectionState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/logo/kaammaa.png",
                        height: imageSize,
                        width: imageSize,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Choose Your Type",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Choose whether you are looking for a job\nor a customer looking for a specialist\nto finish your work.",
                      style: TextStyle(
                        fontFamily: "Inter",
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSelectableCard(
                          context,
                          label: "Provider",
                          assetPath: "assets/logo/provider.png",
                          selected: state.selectedType == "worker",
                          onTap:
                              () => context
                                  .read<SelectionViewModel>()
                                  .selectType("worker"),
                        ),
                        _buildSelectableCard(
                          context,
                          label: "Customer",
                          assetPath: "assets/logo/customer.png",
                          selected: state.selectedType == "customer",
                          onTap:
                              () => context
                                  .read<SelectionViewModel>()
                                  .selectType("customer"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state.selectedType == null
                                ? null
                                : () => context
                                    .read<SelectionViewModel>()
                                    .onContinue(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              state.selectedType == null
                                  ? Colors.grey
                                  : AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableCard(
    BuildContext context, {
    required String label,
    required String assetPath,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = screenWidth * (selected ? 0.45 : 0.4);
    final height = selected ? 270.0 : 250.0;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color:
                  selected ? AppColors.primary.withAlpha(100) : Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2.5 : 1.0,
          ),
        ),
        child: Image.asset(assetPath, fit: BoxFit.contain),
      ),
    );
  }
}
