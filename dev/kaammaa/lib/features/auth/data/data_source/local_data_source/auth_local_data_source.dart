import 'package:kaammaa/core/network/hive_service.dart';
import 'package:kaammaa/features/auth/data/data_source/auth_data_source.dart';
import 'package:kaammaa/features/auth/data/model/auth_hive_model.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

class AuthLocalDataSource implements IAuthDataSource {
  final HiveService _hiveService;

  AuthLocalDataSource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<String> loginUser(String identifier, String password) async {
    try {
      final authData = await _hiveService.login(identifier, password);
      if (authData != null && authData.password == password) {
        return "Login successful";
      } else {
        throw Exception("Invalid username or password");
      }
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> registerUser(AuthEntity user) async {
    try {
      final userHiveModel = AuthHiveModel.fromEntity(user);
      await _hiveService.register(userHiveModel);
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }
}
