import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registerUser(AuthEntity user);

  Future<Either<Failure, String>> loginUser(String identifier, String password);
}
