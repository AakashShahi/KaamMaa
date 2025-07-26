import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/common/app_alertdialog.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/common/shake_detector.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/help_and_support_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/profile_setings_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/terms_and_condition_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_state.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_viewmodel.dart';
import 'package:local_auth/local_auth.dart';

class CustomerProfileView extends StatefulWidget {
  const CustomerProfileView({super.key});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  late final ShakeDetector _shakeDetector;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();

    // Load user profile
    Future.microtask(() {
      context.read<CustomerProfileViewModel>().add(FetchCustomerProfileEvent());
    });

    // Setup shake detector to show logout dialog
    _shakeDetector = ShakeDetector(
      onPhoneShake: () {
        _showLogoutDialog(context);
      },
    );
    _shakeDetector.startListening();
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    final tokenSharedPrefs = serviceLocater<TokenSharedPrefs>();
    final result = await tokenSharedPrefs.logout();

    result.fold(
      (failure) {
        print('Logout failed: ${failure.message}');
      },
      (_) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                (_) => BlocProvider.value(
                  value: serviceLocater<LoginViewModel>(),
                  child: const Loginview(),
                ),
          ),
          (route) => false,
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AppAlertDialog(
            title: "Confirm Logout",
            message: "Shake detected. Do you want to logout?",
            confirmText: "Logout",
            cancelText: "Cancel",
            onConfirmed: () {
              Navigator.pop(context);
              _logout(context);
            },
          ),
    );
  }

  Future<bool> _authenticate() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      print('canCheckBiometrics: $canCheckBiometrics');
      print('availableBiometrics: $availableBiometrics');
      print('isDeviceSupported: $isDeviceSupported');

      if (!canCheckBiometrics || !isDeviceSupported) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Biometric authentication not available'),
          ),
        );
        return false;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access Profile Settings',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // fallback allowed
        ),
      );

      print('didAuthenticate: $didAuthenticate');
      return didAuthenticate;
    } catch (e, stacktrace) {
      print('Error during biometric authentication: $e');
      print('Stacktrace: $stacktrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Authentication error: $e')));
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerProfileViewModel, CustomerProfileState>(
      builder: (context, state) {
        if (state is CustomerProfileLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CustomerProfileLoaded) {
          final user = state.user;

          return Column(
            children: [
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 55,
                backgroundImage:
                    user.profilePic != null
                        ? NetworkImage(getBackendImageUrl(user.profilePic!))
                        : const AssetImage('assets/images/default_user.png')
                            as ImageProvider,
              ),
              const SizedBox(height: 14),
              Text(
                user.name ?? "No Name",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildListTile(
                      icon: Icons.settings,
                      title: "Profile Settings",
                      onTap: () async {
                        final authenticated = await _authenticate();
                        if (authenticated) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProfileSettingView(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Authentication failed'),
                            ),
                          );
                        }
                      },
                    ),
                    _buildListTile(
                      icon: Icons.help_outline,
                      title: "Help & Support",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportView(),
                          ),
                        );
                      },
                    ),
                    _buildListTile(
                      icon: Icons.policy,
                      title: "Terms and Conditions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TermsConditionsView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else if (state is CustomerProfileError) {
          return Center(child: Text("Error: ${state.failure.message}"));
        } else {
          return const Center(child: Text("Loading profile..."));
        }
      },
    );
  }

  ListTile _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
