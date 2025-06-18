import 'package:hive_flutter/adapters.dart';
import 'package:kaammaa/app/constant/hive/hive_table_constant.dart';
import 'package:kaammaa/features/auth/data/model/auth_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    // Initialize the database
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}kaam_maa.db';

    Hive.init(path);

    // Register Adapters
    Hive.registerAdapter(AuthHiveModelAdapter());
  }

  Future<void> register(AuthHiveModel auth) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    await box.put(auth.userId, auth);
  }

  Future<AuthHiveModel?> login(String identifier, String password) async {
    var box = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);

    // Check if any user matches either email or username, and the password
    final user = box.values.firstWhere(
      (user) =>
          (user.username == identifier || user.email == identifier) &&
          user.password == password,
    );

    await box.close();
    return user;
  }
}
