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

  Future<Either<Failure, String?>> getRole() async {
    try {
      final role = _sharedPreferences.getString('role');
      return Right(role);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  // --- NEW: Save User ID ---
  Future<Either<Failure, void>> saveUserId(String userId) async {
    try {
      await _sharedPreferences.setString('userId', userId);
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  // --- NEW: Get User ID ---
  Future<Either<Failure, String?>> getUserId() async {
    try {
      final userId = _sharedPreferences.getString('userId');
      return Right(userId);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  // --- NEW: Save User Name ---
  Future<Either<Failure, void>> saveUserName(String name) async {
    try {
      await _sharedPreferences.setString('userName', name);
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  // --- NEW: Get User Name ---
  Future<Either<Failure, String?>> getUserName() async {
    try {
      final name = _sharedPreferences.getString('userName');
      return Right(name);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, void>> logout() async {
    try {
      await _sharedPreferences.remove('token');
      await _sharedPreferences.remove('role');
      await _sharedPreferences.remove('userId'); // Clear userId on logout
      await _sharedPreferences.remove('userName'); // Clear userName on logout
      return const Right(null);
    } catch (e) {
      return Left(SharedPreferenceFailure(message: e.toString()));
    }
  }

  Future<bool> isLoggedIn() async {
    final token = _sharedPreferences.getString('token');
    return token != null && token.isNotEmpty;
  }
}
