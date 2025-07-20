import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart'; // Run `flutter pub run build_runner build` after this

@JsonSerializable()
class LoginResponseModel extends Equatable {
  final String token;
  @JsonKey(name: "_id") // Assuming your backend sends user ID as "_id"
  final String userId;
  final String? name; // Assuming your backend sends user name as "name"
  final String? role; // Already handled, keep for consistency if needed here

  const LoginResponseModel({
    required this.token,
    required this.userId,
    this.name,
    this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);

  @override
  List<Object?> get props => [token, userId, name, role];
}
