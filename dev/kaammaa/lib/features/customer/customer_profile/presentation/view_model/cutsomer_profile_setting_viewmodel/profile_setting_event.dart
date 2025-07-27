abstract class ProfileSettingEvent {}

class LoadCurrentUserEvent extends ProfileSettingEvent {}

class PickImageEvent extends ProfileSettingEvent {}

class UpdateProfileEvent extends ProfileSettingEvent {
  final String? name;
  final String? password;
  final String? profilePicPath; // local path

  UpdateProfileEvent({this.name, this.password, this.profilePicPath});
}
