import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class AuthLocalRepository implements IAuthRepository {
  final AuthLocalDataSource _authLocalDatasource;

  AuthLocalRepository({required AuthLocalDataSource authLocalDatasource})
    : _authLocalDatasource = authLocalDatasource;

  @override
  Future<Either<Failure, String>> loginUser(
    String identifier,
    String password,
  ) async {
    try {
      final result = await _authLocalDatasource.loginUser(identifier, password);
      return Right(result);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to login: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authLocalDatasource.registerUser(user);
      return Right(null);
    } catch (e) {
      return Left(LocalDataBaseFailure(message: "Failed to register: $e"));
    }
  }
}
