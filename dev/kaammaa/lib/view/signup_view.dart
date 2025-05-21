import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kaammaa/constants/app_colors.dart';
import 'package:kaammaa/constants/app_textfield.dart';
import 'package:kaammaa/view/login_view.dart';

class Signupview extends StatefulWidget {
  const Signupview({super.key});

  @override
  State<Signupview> createState() => _SignupviewState();
}

class _SignupviewState extends State<Signupview> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                                    (context) => AlertDialog(
                                      title: const Text('Exit App'),
                                      content: const Text(
                                        'Do you want to exit the app?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
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

                              if (shouldExit == true) {
                                exit(0);
                              }
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
                              fontFamily: "Inter",
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
                          buildTextField(
                            labelText: "Enter your password",
                            obscureText: _obscurePassword,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? "Please enter your password"
                                        : null,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed:
                                  () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                            ),
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFA5804),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Handle signup
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
                          const SizedBox(height: 40),
                          Center(
                            child: Image.asset(
                              "assets/images/continuewith.png",
                              width: MediaQuery.of(context).size.width * 0.8,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/logo/google.png",
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                              const SizedBox(width: 30),
                              Image.asset(
                                "assets/logo/fb.png",
                                width: MediaQuery.of(context).size.width * 0.1,
                              ),
                            ],
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
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Loginview()),
                ),
            child: const Text(
              "Sign in",
              style: TextStyle(
                color: Color(0xFFFA5804),
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
