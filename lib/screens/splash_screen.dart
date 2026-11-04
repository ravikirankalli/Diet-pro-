import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/splash_background_art.dart';
import '../widgets/svg_path.dart';
import 'login_screen.dart';

/// Purely visual launch screen: botanical corners, the centred Diet Pro logo
/// group and the Andhra Educational Trust attribution.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _hold = Duration(milliseconds: 2600);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );

  late final Animation<double> _scale = Tween<double>(
    begin: 0.92,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future.delayed(_hold, _goToLogin);
  }

  void _goToLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors.splashBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: _SplashBackgroundPainter()),
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  const Spacer(flex: 16),
                  ScaleTransition(
                    scale: _scale,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          AppAssets.chef,
                          width: width * 0.60,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: width * 0.03),
                        Image.asset(
                          AppAssets.wordmark,
                          width: width * 0.66,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 16),
                  const _Attribution(),
                  const Spacer(flex: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'From',
          style: TextStyle(
            fontSize: 15,
            height: 1.15,
            fontWeight: FontWeight.w400,
            color: AppColors.attributionLight,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Andhra Educational Trust',
          style: TextStyle(
            fontSize: 16,
            height: 1.15,
            fontWeight: FontWeight.w700,
            color: AppColors.attributionBold,
          ),
        ),
      ],
    );
  }
}

/// The screen artwork from design/splash_background.svg.
class _SplashBackgroundPainter extends CustomPainter {
  const _SplashBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.splashBackground,
    );
    paintArt(
      canvas,
      size,
      SplashBackgroundArt.shapes,
      viewWidth: SplashBackgroundArt.viewWidth,
      viewHeight: SplashBackgroundArt.viewHeight,
    );
  }

  @override
  bool shouldRepaint(covariant _SplashBackgroundPainter oldDelegate) => true;
}
