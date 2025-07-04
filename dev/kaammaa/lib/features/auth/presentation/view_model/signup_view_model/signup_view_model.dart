import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_flushbar.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_register_usecase.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  final AuthRegisterUsecase _authRegisterUsecase;

  SignupViewModel(this._authRegisterUsecase)
    : super(const SignupState.initial()) {
    on<SignupUserEvent>(_onSignupUser);
    on<NavigateToLoginEvent>(_onNavigateToLoginEvent);
  }

  Future<void> _onSignupUser(
    SignupUserEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await Future.delayed(const Duration(seconds: 1));

    // Print submitted data
    print('📝 Submitted Data:');
    print('Username: ${event.username}');
    print('Email: ${event.email}');
    print('Password: ${event.password}');
    print('Role: ${event.role}');

    final result = await _authRegisterUsecase(
      RegisterUserParams(
        email: event.email,
        username: event.username,
        password: event.password,
        role: event.role,
        phone: event.phone,
      ),
    );

    result.fold(
      (l) async {
        emit(state.copyWith(isLoading: false));

        if (event.context.mounted) {
          await AppFlushbar.show(
            context: event.context,
            message: "Something went wrong!",
            backgroundColor: AppColors.error,
            icon: const Icon(Icons.error, color: Colors.white),
          );
        }
      },
      (r) async {
        emit(state.copyWith(isLoading: false, isSuccess: true));

        if (event.context.mounted) {
          Navigator.push(
            event.context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: serviceLocater<LoginViewModel>(),
                    child: Loginview(),
                  ),
            ),
          );
          await AppFlushbar.show(
            context: event.context,
            message: "Signup successful!",
            backgroundColor: AppColors.primary,
            icon: const Icon(Icons.check_circle, color: Colors.white),
          );
        }
      },
    );
  }

  void _onNavigateToLoginEvent(
    NavigateToLoginEvent event,
    Emitter<SignupState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider.value(
                value: serviceLocater<LoginViewModel>(),
                child: Loginview(),
              ),
        ),
      );
    }
  }
}
