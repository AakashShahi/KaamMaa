import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

class ProfilePageView extends StatelessWidget {
  const ProfilePageView({super.key});

  Future<void> _logout(BuildContext context) async {
    final tokenSharedPrefs = serviceLocater<TokenSharedPrefs>();
    final result = await tokenSharedPrefs.logout();

    result.fold(
      (failure) async {
        // Show error if needed, for now just print
        print('Logout failed: ${failure.message}');
      },
      (_) async {
        // Navigate to login and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: serviceLocater<LoginViewModel>(),
                  child: const Loginview(),
                ),
          ),
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
