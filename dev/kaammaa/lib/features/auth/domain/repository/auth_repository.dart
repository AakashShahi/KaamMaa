import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/data/model/login_response_model.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, void>> registerUser(AuthEntity user);

  // Change return type to LoginResponseModel
  Future<Either<Failure, LoginResponseModel>> loginUser(
    String identifier,
    String password,
  );
}
