import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/app_textfield.dart';
import 'package:kaammaa/core/common/kaammaa_loading_overlay.dart'; // <-- Import loading overlay here
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';

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

    return BlocProvider(
      create: (_) => serviceLocater<LoginViewModel>(),
      child: BlocBuilder<LoginViewModel, LoginState>(
        builder: (context, state) {
          final loginBloc = context.read<LoginViewModel>();

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(15),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: KaammaaLoadingOverlay(
                          // <-- Wrap with loading overlay here
                          isLoading: state.isLoading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                onPressed:
                                    () => loginBloc.add(
                                      NavigateToSignUpViewEvent(
                                        context: context,
                                      ),
                                    ),
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
                                      labelText: "Enter your email or username",
                                      obscureText: false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Please enter your email or username";
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
                                            _obscurePassword =
                                                !_obscurePassword;
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
                              _buildSignInButton(context, loginBloc, state),
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
                              _buildSignUpOption(context, loginBloc),
                              const Spacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignInButton(
    BuildContext context,
    LoginViewModel bloc,
    LoginState state,
  ) {
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
          onPressed:
              state.isLoading
                  ? null
                  : () {
                    if (_formKey.currentState!.validate()) {
                      bloc.add(
                        LoginWithEmailAndPasswordEvent(
                          context: context,
                          username: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        ),
                      );
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

  Widget _buildSignUpOption(BuildContext context, LoginViewModel bloc) {
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
              bloc.add(NavigateToSignUpViewEvent(context: context));
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
