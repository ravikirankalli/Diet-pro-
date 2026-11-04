import 'package:flutter/material.dart';

/// Brand palette for Diet Pro, taken from the splash and login design specs.
class AppColors {
  AppColors._();

  // Base surfaces
  static const Color splashBackground = Color(0xFFFFFEFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color loginHeader = Color(0xFFF0F4DE);
  static const Color badgeCream = Color(0xFFFDF8EC);

  // Brand
  static const Color brandGreen = Color(0xFF07552A);
  static const Color headingGreen = Color(0xFF15582F);
  static const Color brandOrange = Color(0xFFF47700);
  static const Color buttonOrange = Color(0xFFF58220);
  static const Color taglineGreen = Color(0xFF285C3B);

  // Botanical decorations
  static const Color waveGreen = Color(0xFFA5CD6B);
  static const Color paleGreenTop = Color(0xFFEAF3D3);
  static const Color paleGreenBottom = Color(0xFFE6F0CD);
  static const Color paleYellow = Color(0xFFFFF2D6);
  static const Color splashYellow = Color(0xFFFFF0A8);
  static const Color leafGreen = Color(0xFFA8D46F);
  static const Color leafGreenSoft = Color(0xFFC6E4A0);
  static const Color leafHighlight = Color(0xFFD7EAB7);
  static const Color utensilGreen = Color(0xFFEDF3DE);

  // Form
  static const Color fieldBorder = Color(0xFFE2E2E2);
  static const Color cardBorder = Color(0xFFEDEDE6);
  static const Color fieldLabel = Color(0xFF858585);
  static const Color fieldHint = Color(0xFF929292);

  // Dashboard
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color cardBorder2 = Color(0xFFEDEFEA);
  static const Color headingDark = Color(0xFF1F2A37);
  static const Color mutedText = Color(0xFF8A9099);
  static const Color greetingGrey = Color(0xFF9AA0A6);
  static const Color accentGreen = Color(0xFF1C8A45);
  static const Color livePillBg = Color(0xFFE9F5E4);
  static const Color navBar = Color(0xFF16233E);
  static const Color navInactive = Color(0xFF8891A5);
  static const Color navActive = Color(0xFF3DC262);
  static const Color chipGrey = Color(0xFFF1F3F0);

  // Attribution
  static const Color attributionLight = Color(0xFF303036);
  static const Color attributionBold = Color(0xFF25252A);
}

/// Shared asset paths.
class AppAssets {
  AppAssets._();

  static const String chef = 'assets/images/chef.png';
  static const String wordmark = 'assets/images/logo_wordmark.png';
  static const String titleWordmark = 'assets/images/wordmark_title.png';
}
