import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

part 'auth_api_model.g.dart'; // Make sure to run build_runner to generate this

@JsonSerializable()
class AuthApiModel extends Equatable {
  @JsonKey(name: "_id")
  final String? userId;
  final String username;
  final String email;
  final String password;
  final String role;
  final String? name;
  final String? profession;
  final List<String>? skills;
  final String? location;
  final bool? availability;
  final String? certificateUrl;
  final bool? isVerified;
  final String phone;

  const AuthApiModel({
    this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.name,
    this.profession,
    this.skills,
    this.location,
    this.availability,
    this.certificateUrl,
    this.isVerified,
    required this.phone,
  });

  /// Convert JSON to model
  factory AuthApiModel.fromJson(Map<String, dynamic> json) =>
      _$AuthApiModelFromJson(json);

  /// Convert model to JSON
  Map<String, dynamic> toJson() => _$AuthApiModelToJson(this);

  /// Convert single API model to domain entity
  AuthEntity toEntity() => AuthEntity(
    userId: userId,
    username: username,
    email: email,
    password: password,
    role: role,
    name: name,
    skills: skills?.join(','), // join List<String> into comma-separated string
    location: location,
    availability: availability?.toString(),
    certificateUrl: null, // Handle File separately if needed
    isVerified: isVerified?.toString(),
    phone: phone,
    profession: profession,
  );

  /// Convert single entity to API model
  factory AuthApiModel.fromEntity(AuthEntity entity) => AuthApiModel(
    userId: entity.userId,
    username: entity.username,
    email: entity.email,
    password: entity.password,
    role: entity.role,
    name: entity.name,
    skills: entity.skills?.split(','),
    location: entity.location,
    availability: entity.availability?.toLowerCase() == 'true',
    certificateUrl: entity.certificateUrl?.path,
    isVerified: entity.isVerified?.toLowerCase() == 'true',
    phone: entity.phone,
    profession: entity.profession,
  );

  /// Convert a list of models to a list of entities
  static List<AuthEntity> toEntityList(List<AuthApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
    userId,
    username,
    email,
    password,
    role,
    name,
    profession,
    skills,
    location,
    availability,
    certificateUrl,
    isVerified,
    phone,
  ];
}
