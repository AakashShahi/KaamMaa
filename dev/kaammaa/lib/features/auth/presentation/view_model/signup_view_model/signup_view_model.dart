import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_state.dart';

class SignupViewModel extends Bloc<SignupEvent, SignupState> {
  SignupViewModel() : super(const SignupState.initial()) {
    on<SignupUserEvent>(_onSignupUser);
  }

  Future<void> _onSignupUser(
    SignupUserEvent event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      // Simulate network request delay
      await Future.delayed(const Duration(seconds: 1));

      // Print submitted data
      print('📝 Submitted Data:');
      print('Username: ${event.username}');
      print('Email: ${event.email}');
      print('Password: ${event.password}');
      print('Role: ${event.role}');

      emit(state.copyWith(isLoading: false, isSuccess: true));

      Navigator.push(
        event.context,
        MaterialPageRoute(builder: (_) => const Loginview()),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }
}
