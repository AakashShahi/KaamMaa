import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kaammaa/core/common/app_colors.dart';
import 'package:kaammaa/core/utils/backend_image_url.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_event.dart';
import 'package:kaammaa/features/customer/customer_dashboard/presentation/view_model/customer_dashboard_view_model.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/customer_profile_viewmodel.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/cutsomer_profile_setting_viewmodel/profile_setting_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/cutsomer_profile_setting_viewmodel/profile_setting_state.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/cutsomer_profile_setting_viewmodel/profile_setting_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileSettingView extends StatefulWidget {
  const ProfileSettingView({super.key});

  @override
  State<ProfileSettingView> createState() => _ProfileSettingViewState();
}

class _ProfileSettingViewState extends State<ProfileSettingView> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  File? _pickedImage;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<ProfileSettingViewModel>().add(LoadCurrentUserEvent());
  }

  Future<bool> _checkPermissions() async {
    final photosPermission = Permission.photos;
    final cameraStatus = await Permission.camera.status;
    final photosStatus = await photosPermission.status;

    if (!cameraStatus.isGranted || !photosStatus.isGranted) {
      final result = await [Permission.camera, photosPermission].request();
      return result[Permission.camera]!.isGranted &&
          result[photosPermission]!.isGranted;
    }
    return true;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (!await _checkPermissions()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Camera and storage permissions required."),
        ),
      );
      return;
    }

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 60,
      );
      if (picked != null) {
        setState(() => _pickedImage = File(picked.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _submitUpdate() {
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isNotEmpty && password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    context.read<ProfileSettingViewModel>().add(
      UpdateProfileEvent(
        name: name,
        password: password.isNotEmpty ? password : null,
        profilePicPath: _pickedImage?.path,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSettingViewModel, ProfileSettingState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated successfully")),
          );

          // Trigger reload in other BLoCs here:
          context.read<CustomerProfileViewModel>().add(
            FetchCustomerProfileEvent(),
          );
          context.read<CustomerDashboardViewModel>().add(
            LoadCustomerUserEvent(),
          );
        } else if (state is ProfileUpdateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update failed: ${state.message}")),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        body: BlocBuilder<ProfileSettingViewModel, ProfileSettingState>(
          builder: (context, state) {
            if (state is ProfileSettingLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileSettingError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            if (state is ProfileSettingLoaded) {
              final AuthEntity user = state.user;
              nameController.text = user.name ?? '';

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage:
                              _pickedImage != null
                                  ? FileImage(_pickedImage!)
                                  : (user.profilePic != null
                                          ? NetworkImage(
                                            getBackendImageUrl(
                                              user.profilePic!,
                                            ),
                                          )
                                          : const AssetImage(
                                            'assets/images/default_user.png',
                                          ))
                                      as ImageProvider,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: _showImagePickerBottomSheet,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      label: "Name",
                      controller: nameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: "New Password",
                      controller: passwordController,
                      isVisible: passwordVisible,
                      toggleVisibility:
                          () => setState(
                            () => passwordVisible = !passwordVisible,
                          ),
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      label: "Confirm Password",
                      controller: confirmPasswordController,
                      isVisible: confirmPasswordVisible,
                      toggleVisibility:
                          () => setState(
                            () =>
                                confirmPasswordVisible =
                                    !confirmPasswordVisible,
                          ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: _submitUpdate,
                      icon: const Icon(Icons.update),
                      label: const Text("Update Profile"),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: Icon(icon, color: Colors.grey[700]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black87),
        prefixIcon: const Icon(Icons.lock, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey[700],
          ),
          onPressed: toggleVisibility,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
