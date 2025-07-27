import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract class ProfileSettingState {}

class ProfileSettingInitial extends ProfileSettingState {}

class ProfileSettingLoading extends ProfileSettingState {}

class ProfileSettingLoaded extends ProfileSettingState {
  final AuthEntity user;

  ProfileSettingLoaded({required this.user});
}

class ProfileSettingError extends ProfileSettingState {
  final String message;

  ProfileSettingError({required this.message});
}

class ProfileUpdating extends ProfileSettingState {}

class ProfileUpdated extends ProfileSettingState {}

class ProfileUpdateError extends ProfileSettingState {
  final String message;
  ProfileUpdateError({required this.message});
}
