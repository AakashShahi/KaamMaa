import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/features/auth/domain/use_case/auth_update_customer_usecase.dart';
import 'package:kaammaa/features/auth/domain/use_case/get_current_user_usecase.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/cutsomer_profile_setting_viewmodel/profile_setting_event.dart';
import 'package:kaammaa/features/customer/customer_profile/presentation/view_model/cutsomer_profile_setting_viewmodel/profile_setting_state.dart';

class ProfileSettingViewModel
    extends Bloc<ProfileSettingEvent, ProfileSettingState> {
  final GetCurrentUserUsecase getCurrentUserUsecase;
  final AuthUpdateCustomerUsecase authUpdateCustomerUsecase;

  ProfileSettingViewModel({
    required this.getCurrentUserUsecase,
    required this.authUpdateCustomerUsecase,
  }) : super(ProfileSettingInitial()) {
    on<LoadCurrentUserEvent>(_onLoadCurrentUser);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUserEvent event,
    Emitter<ProfileSettingState> emit,
  ) async {
    emit(ProfileSettingLoading());
    final result = await getCurrentUserUsecase();
    result.fold(
      (failure) => emit(ProfileSettingError(message: failure.message)),
      (user) => emit(ProfileSettingLoaded(user: user)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileSettingState> emit,
  ) async {
    emit(ProfileUpdating());

    final result = await authUpdateCustomerUsecase.call(
      UpdateCustomerParams(
        name: event.name,
        password: event.password,
        profilePic:
            event.profilePicPath != null ? File(event.profilePicPath!) : null,
      ),
    );

    result.fold(
      (failure) => emit(ProfileUpdateError(message: failure.message)),
      (_) => emit(ProfileUpdated()),
    );

    add(LoadCurrentUserEvent());
  }
}
