import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRemoteRepository({required AuthRemoteDatasource authRemoteDataSource})
    : _authRemoteDatasource = authRemoteDataSource;

  @override
  Future<Either<Failure, String>> loginUser(
    String identifier,
    String password,
  ) async {
    try {
      final user = await _authRemoteDatasource.loginUser(identifier, password);
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      await _authRemoteDatasource.registerUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
