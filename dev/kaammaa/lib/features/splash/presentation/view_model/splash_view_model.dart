// features/splash/presentation/view_model/splash_view_model.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: serviceLocater<OnboardingViewModel>(),
                  child: const OnboardingView(),
                ),
          ),
        );
      }
    });
  }
}
