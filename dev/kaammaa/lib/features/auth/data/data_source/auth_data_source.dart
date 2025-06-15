import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> registerUser(AuthEntity user);

  Future<String> loginUser(String identifier, String password);
}
