import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:kaammaa/view/onboarding_view.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen(
      splash: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: screenHeight * 0.1,
                child: Lottie.asset(
                  "assets/lottie/Animation - 1747306401008.json",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20), // Spacing
              Image.asset(
                "assets/logo/kaammaa_txt.png",
                width: screenWidth * 0.4,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
      nextScreen: const OnboardingView(),
      splashIconSize:
          screenHeight, // Doesn't affect since we're customizing splash
      backgroundColor: Colors.white,
      duration: 2500,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
