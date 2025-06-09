import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kaammaa/app/service_locater/service_locater.dart';
import 'package:kaammaa/app/theme/my_theme.dart';
import 'package:kaammaa/features/splash/presentation/view/splash_screen_view.dart';
import 'package:kaammaa/features/splash/presentation/view_model/splash_view_model.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider.value(
        value: serviceLocater<SplashViewModel>(),
        child: SplashScreenView(),
      ),
      theme: getApplicationTheme(),
    );
  }
}
