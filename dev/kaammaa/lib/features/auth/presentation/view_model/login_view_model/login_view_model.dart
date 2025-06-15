import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/auth/presentation/view/signup_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';
import 'package:kaammaa/view/worker/dashboard_view.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  LoginViewModel() : super(const LoginState.initial()) {
    on<LoginWithEmailAndPasswordEvent>(_onLogin);
    on<NavigateToSignUpViewEvent>(_onNavigateToSignUp);
    on<NavigateToDashBoardViewEvent>(_onNavigateToDashboard);
  }

  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  Future<void> _onLogin(
    LoginWithEmailAndPasswordEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final input = event.username.trim();
    final password = event.password;

    final isEmail = _isEmail(input);

    // Dummy validation logic:
    // Accept either username 'admin' or email 'admin@example.com' with password 'userAdmin'
    final isValidUser =
        (isEmail && input == 'admin@gmail.com' && password == 'userAdmin') ||
        (!isEmail && input == 'admin' && password == 'userAdmin');

    if (isValidUser) {
      await Future.delayed(const Duration(seconds: 1));
      add(NavigateToDashBoardViewEvent(context: event.context));
    } else {
      await AppFlushbar.show(
        context: event.context,
        message: "Invalid credentials!",
        backgroundColor: AppColors.error,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
    emit(state.copyWith(isLoading: false));
  }

  void _onNavigateToSignUp(
    NavigateToSignUpViewEvent event,
    Emitter<LoginState> emit,
  ) {
    Navigator.push(
      event.context,
      MaterialPageRoute(
        builder:
            (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(value: serviceLocater<SignupViewModel>()),
                BlocProvider.value(value: serviceLocater<SelectionViewModel>()),
              ],
              child: Signupview(),
            ),
      ),
    );
  }

  void _onNavigateToDashboard(
    NavigateToDashBoardViewEvent event,
    Emitter<LoginState> emit,
  ) async {
    Navigator.pushAndRemoveUntil(
      event.context,
      MaterialPageRoute(builder: (_) => const DashboardView()),
      (route) => false,
    );
    await AppFlushbar.show(
      context: event.context,
      message: "Login successful!",
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}
