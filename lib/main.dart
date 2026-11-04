import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DietProApp());
}

class DietProApp extends StatelessWidget {
  const DietProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diet Pro',
      debugShowCheckedModeBanner: false,
      theme: buildDietProTheme(),
      home: const SplashScreen(),
    );
  }
}
