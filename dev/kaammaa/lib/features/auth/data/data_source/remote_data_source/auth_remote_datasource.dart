import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/auth/data/data_source/auth_data_source.dart';
import 'package:kaammaa/features/auth/data/model/auth_api_model.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

class AuthRemoteDatasource implements IAuthDataSource {
  final ApiService _apiService;
  final TokenSharedPrefs _tokenSharedPrefs;

  AuthRemoteDatasource({
    required ApiService apiservice,
    required TokenSharedPrefs tokenSharedPrefs,
  }) : _apiService = apiservice,
       _tokenSharedPrefs = tokenSharedPrefs;

  @override
  Future<String> loginUser(String identifier, String password) async {
    try {
      final isEmail = RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(identifier.trim());

      final loginData =
          isEmail
              ? {"email": identifier.trim(), "password": password}
              : {"username": identifier.trim(), "password": password};

      final response = await _apiService.dio.post(
        ApiEndpoints.login,
        data: loginData,
      );

      if (response.statusCode == 200) {
        final role = response.data["data"]["role"];
        final roleResult = await _tokenSharedPrefs.saveRole(role);
        roleResult.fold(
          (failure) => debugPrint("Failed to save role: ${failure.message}"),
          (_) => debugPrint("Role saved"),
        );

        return response.data["token"];
      } else {
        throw Exception("Failed to login: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to login: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      // COnvert to api model
      final authApiModel = AuthApiModel.fromEntity(user);
      final response = await _apiService.dio.post(
        ApiEndpoints.register,
        data: authApiModel.toJson(),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception("Failed to register student:${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Failed to register:${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occured: $e");
    }
  }
}
