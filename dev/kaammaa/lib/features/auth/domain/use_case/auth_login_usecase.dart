import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/data/model/login_response_model.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class LoginParams extends Equatable {
  final String identifier;
  final String password;

  const LoginParams({required this.identifier, required this.password});

  const LoginParams.initial() : identifier = '', password = '';
  @override
  List<Object?> get props => [identifier, password];
}

// Change return type to LoginResponseModel
class AuthLoginUsecase
    implements UsecaseWithParams<LoginResponseModel, LoginParams> {
  final IAuthRepository _authRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthLoginUsecase({
    required IAuthRepository authRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       _authRepository = authRepository;

  @override
  Future<Either<Failure, LoginResponseModel>> call(LoginParams params) async {
    // Changed return type
    final loginResult = await _authRepository.loginUser(
      params.identifier,
      params.password,
    );

    return loginResult.fold((failure) => Left(failure), (loginResponse) async {
      // Use loginResponse
      // Save token
      await _tokenSharedPrefs.saveToken(loginResponse.token).then((result) {
        result.fold(
          (failure) => debugPrint("Failed to save token: ${failure.message}"),
          (_) => debugPrint("Token saved successfully"),
        );
      });

      // NEW: Save user ID
      await _tokenSharedPrefs.saveUserId(loginResponse.userId).then((result) {
        result.fold(
          (failure) => debugPrint("Failed to save user ID: ${failure.message}"),
          (_) => debugPrint("User ID saved successfully"),
        );
      });

      // NEW: Save user Name (if it's not null)
      if (loginResponse.name != null) {
        await _tokenSharedPrefs.saveUserName(loginResponse.name!).then((
          result,
        ) {
          // Assuming you add saveUserName
          result.fold(
            (failure) =>
                debugPrint("Failed to save user name: ${failure.message}"),
            (_) => debugPrint("User name saved successfully"),
          );
        });
      }

      // Optionally, save role here if it's consistently part of LoginResponseModel
      if (loginResponse.role != null) {
        await _tokenSharedPrefs.saveRole(loginResponse.role!).then((result) {
          result.fold(
            (failure) => debugPrint("Failed to save role: ${failure.message}"),
            (_) => debugPrint("Role saved successfully"),
          );
        });
      }

      return Right(loginResponse); // Return the full login response model
    });
  }
}
