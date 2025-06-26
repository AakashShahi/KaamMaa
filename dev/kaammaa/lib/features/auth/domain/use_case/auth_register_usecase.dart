import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class RegisterUserParams extends Equatable {
  final String username;
  final String email;
  final String role;
  final String password;
  final String phone;

  const RegisterUserParams({
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    required this.phone,
  });

  //intial constructor
  const RegisterUserParams.initial({
    required this.role,
    required this.username,
    required this.password,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [email, role, username, password];
}

class AuthRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IAuthRepository _authRepository;

  AuthRegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final authEntity = AuthEntity(
      username: params.username,
      email: params.email,
      password: params.password,
      role: params.role,
      phone: params.phone,
    );
    return _authRepository.registerUser(authEntity);
  }
}
