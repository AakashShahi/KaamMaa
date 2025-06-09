import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingViewModel(),
      child: const _OnboardingViewContent(),
    );
  }
}

class _OnboardingViewContent extends StatelessWidget {
  const _OnboardingViewContent();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingViewModel>();

    return BlocBuilder<OnboardingViewModel, OnboardingState>(
      builder: (context, state) {
        if (state is OnboardingInProgress) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: cubit.pageController,
                      onPageChanged: cubit.pageChanged,
                      children: [
                        _buildPage(
                          imagePath: "assets/images/onboard1.png",
                          title: "Find Jobs or Hire Help — Locally",
                          description:
                              "Whether you're looking for quick gigs or reliable help, KaamMaa connects people in your neighborhood",
                          context: context,
                        ),
                        _buildPage(
                          imagePath: "assets/images/onboard2.png",
                          title: "Post or Browse Jobs in Seconds",
                          description:
                              "Post a job with a few details, or browse nearby tasks based on your skills or needs.",
                          context: context,
                        ),
                        _buildPage(
                          imagePath: "assets/images/onboard3.png",
                          title: "Reliable, Reviewed, and Local",
                          description:
                              "All users are verified. You can rate and review every interaction for a safer experience",
                          context: context,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child:
                        state.isLastPage
                            ? ElevatedButton(
                              onPressed: () {
                                cubit.completeOnboarding(context);
                              },
                              child: const Text('Get Started'),
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: cubit.skipToLastPage,
                                  child: const Text(
                                    "Skip",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SmoothPageIndicator(
                                  controller: cubit.pageController,
                                  count: 3,
                                  effect: JumpingDotEffect(
                                    dotHeight: 10,
                                    dotWidth: 10,
                                    activeDotColor: AppColors.primary,
                                    dotColor: Colors.grey,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: cubit.nextPage,
                                  child: const Text("Next"),
                                ),
                              ],
                            ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _buildPage({
    required String imagePath,
    required String title,
    required String description,
    required BuildContext context,
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
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: screenHeight * 0.015),
              Text(
                description,
                style: TextStyle(
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
