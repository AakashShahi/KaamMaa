import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view/customer_dashboard_view.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/onboarding/presentation/view/onboarding_view.dart';
import 'package:kaammaa/features/onboarding/presentation/view_model/onboarding_view_model.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view/worker_dashboard_view.dart';
import 'package:kaammaa/features/worker/worker_dashboard/presentation/view_model/worker_dashboard_view_model.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));

    final tokenPrefs = serviceLocater<TokenSharedPrefs>();
    final tokenResult = await tokenPrefs.getToken();
    final roleResult = await tokenPrefs.getRole();

    final token = tokenResult.fold((_) => null, (token) => token);
    final role = roleResult.fold((_) => null, (role) => role);

    if (!context.mounted) return;

    if (token != null && token.isNotEmpty && role != null) {
      // User already logged in
      if (role == "worker") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: serviceLocater<WorkerDashboardViewModel>(),
                  child: const WorkerDashboardView(),
                ),
          ),
        );
      } else if (role == "customer") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: serviceLocater<CustomerDashboardViewModel>(),
                  child: const CustomerDashboardView(),
                ),
          ),
        );
      } else {
        // Fallback to onboarding if unknown role
        _navigateToOnboarding(context);
      }
    } else {
      // User not logged in, go to onboarding
      _navigateToOnboarding(context);
    }
  }

  void _navigateToOnboarding(BuildContext context) {
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
}
