import 'dart:io';

import 'package:kaammaa/features/auth/data/model/login_response_model.dart';
import 'package:kaammaa/features/auth/domain/entity/auth_entity.dart';

abstract interface class IAuthDataSource {
  Future<void> registerUser(AuthEntity user);

  // Change return type to LoginResponseModel
  Future<LoginResponseModel> loginUser(String identifier, String password);

  Future<AuthEntity> getCurrentUser(String? token);

  Future<void> updateUser(
    String? name,
    String? password,
    File? profilePic,
    String? token,
  );
}
