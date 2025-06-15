import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:kaammaa/app/constant/hive/hive_table_constant.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:uuid/uuid.dart';

part 'auth_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  @HiveField(1)
  final String username;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final String password;
  @HiveField(4)
  final String role;

  AuthHiveModel({
    String? userId,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const AuthHiveModel.initial()
    : userId = '',
      username = '',
      email = '',
      password = '',
      role = '';

  // From Entity
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      email: entity.email,
      username: entity.username,
      password: entity.password,
      role: entity.role,
    );
  }

  // To Entity
  AuthEntity toEntity() {
    return AuthEntity(
      userId: userId,
      username: username,
      email: email,
      password: password,
      role: role,
    );
  }

  @override
  List<Object?> get props => [userId, email, role, username, password];
}
