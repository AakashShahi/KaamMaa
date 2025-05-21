import 'package:flutter/material.dart';
import 'package:kaammaa/view/selection_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: [
                  _buildPage(
                    imagePath: "assets/images/onboard1.png",
                    title: "Find Jobs or Hire Help — Locally",
                    description:
                        "Whether you're looking for quick gigs or reliable help, KaamMaa connects people in your neighborhood",
                  ),
                  _buildPage(
                    imagePath: "assets/images/onboard2.png",
                    title: "Post or Browse Jobs in Seconds",
                    description:
                        "Post a job with a few details, or browse nearby tasks based on your skills or needs.",
                  ),
                  _buildPage(
                    imagePath: "assets/images/onboard3.png",
                    title: "Reliable, Reviewed, and Local",
                    description:
                        "All users are verified. You can rate and review every interaction for a safer experience",
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.015,
              ),
              color: Colors.white,
              child:
                  isLastPage
                      ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFA5804),
                            padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Get Started",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontFamily: 'Inter',
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const SelectionView(),
                              ),
                            );
                          },
                        ),
                      )
                      : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.jumpToPage(2);
                            },
                            child: Text(
                              "Skip",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: screenWidth * 0.04,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SmoothPageIndicator(
                            controller: controller,
                            count: 3,
                            effect: JumpingDotEffect(
                              dotHeight: screenWidth * 0.03,
                              dotWidth: screenWidth * 0.03,
                              spacing: screenWidth * 0.03,
                              jumpScale: 1.5,
                              verticalOffset: screenWidth * 0.03,
                              dotColor: const Color(0xFFD3D3D3),
                              activeDotColor: const Color(0xFFFA5804),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFA5804),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                                horizontal: screenWidth * 0.05,
                              ),
                            ),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String description,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          imagePath,
          width: screenWidth,
          height: screenHeight,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: screenHeight * 0.15,
          left: screenWidth * 0.08,
          right: screenWidth * 0.08,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.04,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
