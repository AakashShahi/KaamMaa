import 'package:flutter/widgets.dart';
import 'package:kaammaa/app/app.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initDependencies();
  runApp(App());
}
