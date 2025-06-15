import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String identifier;
  final String password;

  const LoginParams({required this.identifier, required this.password});

  // Initial Constructor
  const LoginParams.initial() : identifier = '', password = '';
  @override
  List<Object?> get props => [identifier, password];
}

class AuthLoginUsecase implements UsecaseWithParams<String, LoginParams> {
  final IAuthRepository _authRepository;

  AuthLoginUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    return await _authRepository.loginUser(params.identifier, params.password);
  }
}
