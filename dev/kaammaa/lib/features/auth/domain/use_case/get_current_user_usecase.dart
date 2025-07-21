import 'package:dartz/dartz.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/app/use_case/use_case.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class GetCurrentUserUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;
  final TokenSharedPrefs _tokenSharedPrefs;

  const GetCurrentUserUsecase({
    required IAuthRepository authRepository,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _authRepository = authRepository,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<Either<Failure, AuthEntity>> call() async {
    final token = await _tokenSharedPrefs.getToken();
    return token.fold(
      (failure) => Left(failure),
      (tokenValue) => _authRepository.getCurrentUser(tokenValue),
    );
  }
}
