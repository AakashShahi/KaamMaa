import 'package:flutter/material.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/view/signup_view.dart';

class SelectionView extends StatefulWidget {
  const SelectionView({super.key});

  @override
  State<SelectionView> createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  String? selectedType;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
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
                Center(
                  child: Column(
                    children: const [
                      Text(
                        "Choose Your Type",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Choose whether you are looking for a job\nor a customer looking for a specialist\nto finish your work.",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSelectableCard(
                      context,
                      label: "Provider",
                      assetPath: "assets/logo/provider.png",
                      selected: selectedType == "provider",
                      onTap: () => setState(() => selectedType = "provider"),
                    ),
                    _buildSelectableCard(
                      context,
                      label: "Customer",
                      assetPath: "assets/logo/customer.png",
                      selected: selectedType == "customer",
                      onTap: () => setState(() => selectedType = "customer"),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        selectedType == null
                            ? null
                            : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Signupview(),
                                ),
                              );
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedType == null
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
    final double width =
        MediaQuery.of(context).size.width * (selected ? 0.45 : 0.4);
    final double height = selected ? 270 : 250;

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
