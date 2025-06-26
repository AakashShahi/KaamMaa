import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
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
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthLoginUsecase({
    required IAuthRepository authRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       _authRepository = authRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams params) async {
    final token = await _authRepository.loginUser(
      params.identifier,
      params.password,
    );
    return token.fold((failure) => Left(failure), (token) {
      //Save token here
      _tokenSharedPrefs.saveToken(token).then((result) {
        result.fold(
          (failure) => debugPrint("Failed to save token: ${failure.message}"),
          (_) => debugPrint("Token saved successfully"),
        );
      });
      return Right(token);
    });
  }
}
