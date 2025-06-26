import 'package:dartz/dartz.dart';
import 'package:kaammaa/core/error/failure.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenSharedPrefs {
  final SharedPreferences _sharedPreferences;

  TokenSharedPrefs({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, void>> saveToken(String token) async {
    try {
      await _sharedPreferences.setString('token', token);
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, String?>> getToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> saveRole(String role) async {
    try {
      await _sharedPreferences.setString('role', role);
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  // Get role
  Future<Either<Failure, String?>> getRole() async {
    try {
      final role = _sharedPreferences.getString('role');
      return Right(role);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }
}
