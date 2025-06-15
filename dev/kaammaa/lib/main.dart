import 'package:flutter/widgets.dart';
import 'package:kaammaa/app/app.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/core/network/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService().init();
  await initDependencies();
  runApp(App());
}
