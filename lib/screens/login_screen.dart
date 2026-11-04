import 'package:flutter/material.dart';

import '../features/auth/auth_service.dart';
import '../theme/app_colors.dart';
import '../theme/login_background_art.dart';
import '../widgets/botanical.dart';
import '../widgets/svg_path.dart';
import 'dashboard/dashboard_shell.dart';

/// Dietitian sign-in screen: pale green branding header with the circular
/// chef badge, a white form panel and the orange primary action.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dietitianIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _dietitianIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final result = await _authService.login(
      chefId: _dietitianIdController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (!result.success) {
      _showMessage(result.message ?? 'Login failed. Please try again.');
      return;
    }

    final chefCode =
        result.chef?.chefCode ?? _dietitianIdController.text.trim();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => DashboardShell(dietitianId: chefCode),
      ),
    );
  }

  Future<void> _onForgotPassword() async {
    final email = _dietitianIdController.text.trim();
    if (!email.contains('@')) {
      _showMessage(
        'Enter the e-mail address registered for your account, then tap '
        'Forgot password.',
      );
      return;
    }

    setState(() => _submitting = true);
    final result = await _authService.requestPasswordReset(email);
    if (!mounted) return;
    setState(() => _submitting = false);

    _showMessage(
      result.message ?? 'If the e-mail exists, a reset code has been sent.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final width = constraints.maxWidth;
          final sidePadding = width * 0.085;

          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: height),
              child: CustomPaint(
                painter: _LoginBackgroundPainter(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: height * 0.345,
                      child: _BrandingHeader(
                        width: width,
                        height: height,
                        sidePadding: sidePadding,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        sidePadding,
                        height * 0.034,
                        sidePadding,
                        0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                fontSize: width * 0.098,
                                fontWeight: FontWeight.w700,
                                color: AppColors.headingGreen,
                              ),
                            ),
                            SizedBox(height: height * 0.034),
                            const _FieldLabel('Dietitian ID'),
                            SizedBox(height: height * 0.010),
                            _InputField(
                              controller: _dietitianIdController,
                              hintText: 'Enter your Dietitian ID',
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  (value == null || value.trim().isEmpty)
                                  ? 'Please enter your Dietitian ID'
                                  : null,
                            ),
                            SizedBox(height: height * 0.026),
                            const _FieldLabel('Password'),
                            SizedBox(height: height * 0.010),
                            _InputField(
                              controller: _passwordController,
                              hintText: 'Enter your password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _obscurePassword,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _signIn(),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Please enter your password'
                                  : null,
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: AppColors.fieldHint,
                                  size: 21,
                                ),
                                tooltip: _obscurePassword
                                    ? 'Show password'
                                    : 'Hide password',
                              ),
                            ),
                            SizedBox(height: height * 0.030),
                            Center(
                              child: GestureDetector(
                                onTap: _onForgotPassword,
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontSize: width * 0.038,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.headingGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.028),
                            Center(
                              child: _SignInButton(
                                width: size.width * 0.645,
                                busy: _submitting,
                                onPressed: _signIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.12),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Wordmark and tagline on the left, circular chef badge on the right.
class _BrandingHeader extends StatelessWidget {
  const _BrandingHeader({
    required this.width,
    required this.height,
    required this.sidePadding,
  });

  final double width;
  final double height;
  final double sidePadding;

  @override
  Widget build(BuildContext context) {
    final badgeSize = width * 0.44;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: width * 0.035,
          // Centred in the pale header band.
          top: (height * 0.345 - badgeSize) / 2 + height * 0.022,
          child: _ChefBadge(size: badgeSize),
        ),
        Positioned(
          left: sidePadding * 0.88,
          top: height * 0.138,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _Wordmark(fontSize: width * 0.113),
              SizedBox(height: height * 0.020),
              Text(
                'Good diet means\nGood health',
                style: TextStyle(
                  fontSize: width * 0.050,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                  color: AppColors.taglineGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// The two-colour Diet Pro brand name, kept as text so each word can carry
/// its own colour on a shared baseline.
class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.fontSize});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: -fontSize * 0.015,
      height: 1.0,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Diet',
            style: style.copyWith(color: AppColors.headingGreen),
          ),
          TextSpan(text: ' ', style: style),
          TextSpan(
            text: 'Pro',
            style: style.copyWith(color: AppColors.brandOrange),
          ),
        ],
      ),
    );
  }
}

/// The chef illustration inside a white ring with a soft drop shadow.
class _ChefBadge extends StatelessWidget {
  const _ChefBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.badgeCream,
        border: Border.all(color: AppColors.surface, width: size * 0.055),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: size * 0.08,
            offset: Offset(0, size * 0.02),
          ),
        ],
      ),
      child: ClipOval(
        // The whole logo fits inside the ring; nothing is cropped.
        child: Padding(
          padding: EdgeInsets.all(size * 0.055),
          child: Image.asset(AppAssets.chef, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: MediaQuery.sizeOf(context).width * 0.042,
        fontWeight: FontWeight.w400,
        color: AppColors.fieldLabel,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final textSize = width * 0.041;
    const radius = BorderRadius.all(Radius.circular(15));
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: color, width: 1.4),
    );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autocorrect: false,
      enableSuggestions: !obscureText,
      style: TextStyle(fontSize: textSize, color: const Color(0xFF2B2B2B)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: textSize, color: AppColors.fieldHint),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: width * 0.042,
          vertical: width * 0.045,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: AppColors.fieldHint,
          size: width * 0.058,
        ),
        suffixIcon: suffix,
        enabledBorder: border(AppColors.fieldBorder),
        border: border(AppColors.fieldBorder),
        focusedBorder: border(AppColors.waveGreen),
        errorBorder: border(const Color(0xFFD92D28)),
        focusedErrorBorder: border(const Color(0xFFD92D28)),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.width,
    required this.busy,
    required this.onPressed,
  });

  final double width;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final height = screenWidth * 0.148;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: busy ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonOrange,
          disabledBackgroundColor: AppColors.buttonOrange.withValues(
            alpha: 0.65,
          ),
          foregroundColor: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(height * 0.30)),
          ),
        ),
        child: busy
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in',
                    style: TextStyle(
                      fontSize: screenWidth * 0.052,
                      fontWeight: FontWeight.w500,
                      color: AppColors.surface,
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.028),
                  Icon(Icons.arrow_forward, size: screenWidth * 0.056),
                ],
              ),
      ),
    );
  }
}

/// Pale green header, the green transition wave and the botanical corners
/// behind the form.
class _LoginBackgroundPainter extends CustomPainter {
  const _LoginBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h * 0.42),
      Paint()..color = AppColors.loginHeader,
    );

    paintArt(
      canvas,
      size,
      LoginBackgroundArt.top,
      viewWidth: LoginBackgroundArt.viewWidth,
      viewHeight: LoginBackgroundArt.viewHeight,
    );

    _paintHeaderLeaves(canvas, w, h);

    // Green wave that connects the branding header to the form panel. It
    // stays a thin band on the left and opens up towards the right.
    final wave = Path()
      ..moveTo(0, h * 0.3215)
      ..cubicTo(w * 0.34, h * 0.3660, w * 0.60, h * 0.2470, w, h * 0.2240)
      ..lineTo(w, h * 0.42)
      ..lineTo(0, h * 0.42)
      ..close();
    canvas.drawPath(wave, Paint()..color = AppColors.waveGreen);

    _paintWaveLeaf(canvas, w, h);

    // White form sheet sitting on top of the wave. It spans the full width
    // with rounded top corners, so the green band stays visible above it.
    final corner = Radius.circular(w * 0.078);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTRB(0, h * 0.3425, w, h),
        topLeft: corner,
        topRight: corner,
      ),
      Paint()..color = AppColors.surface,
    );

    paintArt(
      canvas,
      size,
      LoginBackgroundArt.bottom,
      viewWidth: LoginBackgroundArt.viewWidth,
      viewHeight: LoginBackgroundArt.viewHeight,
    );
  }

  /// Soft leaves scattered through the pale green branding area.
  void _paintHeaderLeaves(Canvas canvas, double w, double h) {
    const soft = Color(0xFFCDE4A8);
    const highlight = Color(0xFFE4F1CE);

    // Kept above the chef badge, which reaches the right edge.
    paintLeaf(
      canvas,
      origin: Offset(w * 0.935, h * 0.048),
      length: w * 0.082,
      width: w * 0.030,
      angle: 2.75,
      color: soft,
      veinColor: highlight,
    );
  }

  /// A single leaf resting on the green wave, below the chef badge.
  void _paintWaveLeaf(Canvas canvas, double w, double h) {
    paintLeaf(
      canvas,
      origin: Offset(w * 0.912, h * 0.305),
      length: w * 0.086,
      width: w * 0.032,
      angle: 0.40,
      color: const Color(0xFFBBDC8A),
      veinColor: const Color(0xFFCFE7AA),
    );
  }

  @override
  bool shouldRepaint(covariant _LoginBackgroundPainter oldDelegate) => true;
}
