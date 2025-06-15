import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_textfield.dart';
import 'package:kaammaa/core/common/kaammaa_loading_overlay.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_state.dart';
import 'package:kaammaa/features/auth/presentation/view_model/signup_view_model/signup_view_model.dart';
import 'package:kaammaa/features/selection/presentation/view_model/selection_view_model.dart';

class Signupview extends StatelessWidget {
  Signupview({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    final role = context.watch<SelectionViewModel>().state.selectedType ?? "";
    final bloc = context.read<SignupViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: BlocBuilder<SignupViewModel, SignupState>(
                      builder:
                          (context, state) => KaammaaLoadingOverlay(
                            isLoading: state.isLoading,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      final shouldExit = await showDialog<bool>(
                                        context: context,
                                        builder:
                                            (_) => AlertDialog(
                                              title: const Text('Exit App'),
                                              content: const Text(
                                                'Do you want to exit the app?',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text(
                                                    'Exit',
                                                    style: TextStyle(
                                                      color: AppColors.error,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                      if (shouldExit == true) exit(0);
                                    },
                                    icon: Image.asset(
                                      "assets/logo/backlogo.png",
                                      height: 40,
                                      width: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    "Register to new account",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  buildTextField(
                                    controller: _usernameController,
                                    labelText: "Enter your username",
                                    validator:
                                        (value) =>
                                            value == null || value.isEmpty
                                                ? "Please enter your username"
                                                : null,
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 20),
                                  buildTextField(
                                    controller: _emailController,
                                    labelText: "Enter your email",
                                    validator:
                                        (value) =>
                                            value == null || value.isEmpty
                                                ? "Please enter your email"
                                                : null,
                                    obscureText: false,
                                  ),
                                  const SizedBox(height: 15),
                                  ValueListenableBuilder<bool>(
                                    valueListenable: _obscurePassword,
                                    builder:
                                        (context, value, _) => buildTextField(
                                          controller: _passwordController,
                                          labelText: "Enter your password",
                                          obscureText: value,
                                          validator:
                                              (value) =>
                                                  value == null || value.isEmpty
                                                      ? "Please enter your password"
                                                      : null,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              value
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                            onPressed:
                                                () =>
                                                    _obscurePassword.value =
                                                        !value,
                                          ),
                                        ),
                                  ),
                                  const SizedBox(height: 30),
                                  Center(
                                    child: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.8,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            bloc.add(
                                              SignupUserEvent(
                                                context: context,
                                                username:
                                                    _usernameController.text
                                                        .trim(),
                                                email:
                                                    _emailController.text
                                                        .trim(),
                                                password:
                                                    _passwordController.text
                                                        .trim(),
                                                role: role,
                                              ),
                                            );
                                            _usernameController.clear();
                                            _emailController.clear();
                                            _passwordController.clear();
                                          }
                                        },
                                        child: const Text(
                                          "Sign-Up",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildSignUpOption(context),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Already in ", style: TextStyle(fontSize: 16)),
          Image.asset("assets/logo/kaammaa_txt.png", height: 100, width: 100),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              context.read<SignupViewModel>().add(
                NavigateToLoginEvent(context: context),
              );
            },
            child: const Text(
              "Sign in",
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
