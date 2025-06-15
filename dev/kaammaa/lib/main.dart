import 'package:flutter/widgets.dart';
import 'package:kaammaa/app/app.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(App());
}
