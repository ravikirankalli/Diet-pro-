import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The single source of truth for the app's theme, shared by the running
/// app and by any harness that renders a screen on its own.
ThemeData buildDietProTheme() {
  return ThemeData(
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brandGreen,
      primary: AppColors.brandGreen,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.surface,
    useMaterial3: true,
  );
}
