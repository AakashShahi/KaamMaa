import 'package:flutter/material.dart';

@immutable
class LoginEvent {}

class NavigateToSignUpViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToSignUpViewEvent({required this.context});
}

class NavigateToDashBoardViewEvent extends LoginEvent {
  final BuildContext context;

  NavigateToDashBoardViewEvent({required this.context});
}

class LoginWithEmailAndPasswordEvent extends LoginEvent {
  final BuildContext context;
  final String username;
  final String password;

  LoginWithEmailAndPasswordEvent({
    required this.context,
    required this.username,
    required this.password,
  });
}
