import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:kaammaa/common/app_colors.dart'; // NEW
import 'package:kaammaa/common/app_textfield.dart';
import 'package:kaammaa/view/worker/dashboard_view.dart';
import 'package:kaammaa/view/signup_view.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(15),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Image.asset(
                          "assets/logo/backlogo.png",
                          height: 40,
                          width: 40,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            buildTextField(
                              controller: _emailController,
                              labelText: "Enter your email",
                              obscureText: false,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            buildTextField(
                              controller: _passwordController,
                              labelText: "Enter your password",
                              obscureText: _obscurePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: AppColors.textPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildSignInButton(size),
                      const SizedBox(height: 40),
                      Center(
                        child: Image.asset(
                          "assets/images/continuewith.png",
                          width: size.width * 0.8,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/logo/google.png",
                            width: size.width * 0.1,
                          ),
                          SizedBox(width: size.width * 0.1),
                          Image.asset(
                            "assets/logo/fb.png",
                            width: size.width * 0.1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSignUpOption(),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSignInButton(Size size) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();

              if (email == "admin" && password == "userAdmin") {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardView(),
                  ),
                  (Route<dynamic> route) =>
                      false, // This removes ALL previous routes
                );
                Flushbar(
                  message: "Login successful!",
                  messageColor: Colors.white,
                  backgroundColor: AppColors.primary,
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(15),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(20),
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 800),
                  forwardAnimationCurve: Curves.bounceInOut,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                ).show(context);
              } else {
                Flushbar(
                  message: "Invalid credentials!",
                  messageColor: Colors.white,
                  backgroundColor: AppColors.error,
                  duration: const Duration(seconds: 2),
                  borderRadius: BorderRadius.circular(15),
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(20),
                  flushbarPosition: FlushbarPosition.BOTTOM,
                  animationDuration: const Duration(milliseconds: 800),
                  forwardAnimationCurve: Curves.bounceInOut,
                  icon: const Icon(Icons.error, color: Colors.white),
                ).show(context);
              }
            }
          },
          child: const Text(
            "Sign-In",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Inter",
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpOption() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "New to ",
            style: TextStyle(fontFamily: "Inter", fontSize: 16),
          ),
          Image.asset("assets/logo/kaammaa_txt.png", height: 100, width: 100),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Signupview()),
              );
            },
            child: const Text(
              "Sign up",
              style: TextStyle(
                color: AppColors.primary,
                fontFamily: "Inter",
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
