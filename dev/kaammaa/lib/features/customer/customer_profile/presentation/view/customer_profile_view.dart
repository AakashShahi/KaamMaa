import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/common/app_alertdialog.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/auth/presentation/view/login_view.dart';
import 'package:kaammaa/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/help_and_support_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/profile_setings_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view/terms_and_condition_view.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_state.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_viewmodel.dart';

class CustomerProfileView extends StatelessWidget {
  const CustomerProfileView({super.key});

  Future<void> _logout(BuildContext context) async {
    final tokenSharedPrefs = serviceLocater<TokenSharedPrefs>();
    final result = await tokenSharedPrefs.logout();

    result.fold(
      (failure) {
        // Optional: Show snackbar/toast
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
            message: "Are you sure you want to logout?",
            confirmText: "Logout",
            cancelText: "Cancel",
            onConfirmed: () {
              Navigator.pop(context); // Close the dialog
              _logout(context); // Perform logout
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      context.read<CustomerProfileViewModel>().add(FetchCustomerProfileEvent());
    });

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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileSettingView(),
                          ),
                        );
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
