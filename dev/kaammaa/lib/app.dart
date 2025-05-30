import 'package:flutter/material.dart';
import 'package:kaammaa/theme/my_theme.dart';
import 'package:kaammaa/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenView(),
      theme: getApplicationTheme(),
    );
  }
}
