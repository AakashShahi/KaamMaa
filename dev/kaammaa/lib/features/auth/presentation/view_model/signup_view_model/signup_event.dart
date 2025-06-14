import 'package:flutter/material.dart';

@immutable
sealed class SignupEvent {}

class LoadCoursesAndBatchesEvent extends SignupEvent {}

class SignupUserEvent extends SignupEvent {
  final BuildContext context;
  final String username;
  final String email;
  final String password;
  final String role;

  SignupUserEvent({
    required this.context,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
  });
}
