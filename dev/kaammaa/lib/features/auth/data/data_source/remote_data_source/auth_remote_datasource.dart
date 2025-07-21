import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:kaammaa/app/constant/api/api_endpoints.dart';
import 'package:kaammaa/app/shared_pref/token_shared_prefs.dart';
import 'package:kaammaa/core/network/api_service.dart';
import 'package:kaammaa/features/auth/data/data_source/auth_data_source.dart';
import 'package:kaammaa/features/auth/data/model/auth_api_model.dart';
import 'package:kaammaa/features/auth/data/model/login_response_model.dart';
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
  Future<LoginResponseModel> loginUser(
    String identifier,
    String password,
  ) async {
    // Changed return type
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
        // Assume backend response structure:
        // { "token": "...", "data": { "_id": "userId", "name": "UserName", "role": "..." } }
        final responseData = response.data; // Get the full response body map

        final token = responseData["token"];
        final userData =
            responseData["data"]; // This should be the map containing user details

        final userId = userData["_id"]; // Extract userId
        final name = userData["name"]; // Extract name
        final role = userData["role"]; // Extract role

        // Save role immediately if AuthRemoteDatasource is still doing it
        // It's generally better to let the Usecase handle all shared_prefs saves
        final roleResult = await _tokenSharedPrefs.saveRole(role);
        roleResult.fold(
          (failure) => debugPrint("Failed to save role: ${failure.message}"),
          (_) => debugPrint("Role saved"),
        );

        // Return the new LoginResponseModel
        return LoginResponseModel(
          token: token,
          userId: userId,
          name: name,
          role: role,
        );
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
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<AuthEntity> getCurrentUser(String? token) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.getCustomer,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final userData = response.data['data'];
        return AuthApiModel.fromJson(userData).toEntity();
      } else {
        throw Exception(
          "Failed to fetch current user: ${response.statusMessage}",
        );
      }
    } on DioException catch (e) {
      throw Exception("Failed to get data:${e.message}");
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }
}
