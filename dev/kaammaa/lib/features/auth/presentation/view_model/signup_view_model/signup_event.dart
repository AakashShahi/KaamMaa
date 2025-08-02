import 'package:flutter/material.dart';

@immutable
class SignupEvent {}

class LoadCoursesAndBatchesEvent extends SignupEvent {}

class NavigateToLoginEvent extends SignupEvent {
  final BuildContext context;
  NavigateToLoginEvent({required this.context});
}

class SetSignupRoleEvent extends SignupEvent {
  final String role;
  SetSignupRoleEvent(this.role);
}

class SignupUserEvent extends SignupEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String password;
  final String role;
  final String phone;

  SignupUserEvent({
    required this.context,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
  });
}
