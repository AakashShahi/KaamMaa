import 'package:flutter/material.dart';
import 'package:kaammaa/view/loginview.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Loginview());
  }
}
