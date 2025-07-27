import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class UpdateCustomerParams extends Equatable {
  final String? name;
  final String? password;
  final File? profilePic;

  const UpdateCustomerParams({this.name, this.password, this.profilePic});

  @override
  List<Object?> get props => [name, password, profilePic];
}

class AuthUpdateCustomerUsecase
    implements UsecaseWithParams<void, UpdateCustomerParams> {
  final IAuthRepository _authRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthUpdateCustomerUsecase({
    required IAuthRepository authRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _tokenSharedPrefs = tokenSharedPrefs,
       _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(UpdateCustomerParams params) async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _authRepository.updateUser(
        params.name,
        params.password,
        params.profilePic,
        tokenValue,
      ),
    );
  }
}
