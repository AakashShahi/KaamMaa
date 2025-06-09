// features/splash/presentation/view/splash_screen_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:lottie/lottie.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  late final SplashViewModel splashViewModel;

  @override
  void initState() {
    super.initState();
    splashViewModel = context.read<SplashViewModel>();
    splashViewModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
            const SizedBox(height: 20),
            Image.asset(
              "assets/logo/kaammaa_txt.png",
              width: screenWidth * 0.4,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}
