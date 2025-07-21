import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:kaammaa/features/auth/data/data_source/remote_data_source/auth_remote_datasource.dart';
import 'package:kaammaa/features/auth/data/model/login_response_model.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';
import 'package:kaammaa/features/auth/domain/repository/auth_repository.dart';

class AuthRemoteRepository implements IAuthRepository {
  final AuthRemoteDatasource _authRemoteDatasource;

  AuthRemoteRepository({required AuthRemoteDatasource authRemoteDataSource})
    : _authRemoteDatasource = authRemoteDataSource;

  @override
  // CHANGE 1: Update the return type to Future<Either<Failure, LoginResponseModel>>
  Future<Either<Failure, LoginResponseModel>> loginUser(
    String identifier,
    String password,
  ) async {
    try {
      // CHANGE 2: The datasource now returns LoginResponseModel
      final loginResponse = await _authRemoteDatasource.loginUser(
        identifier,
        password,
      );
      // CHANGE 3: Return Right with the LoginResponseModel
      return Right(loginResponse);
    } catch (e) {
      // Keep error handling consistent
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

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser(String? token) async {
    try {
      final customer = await _authRemoteDatasource.getCurrentUser(token);
      return Right(customer);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
