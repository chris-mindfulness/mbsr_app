import 'package:flutter/material.dart';
import 'widgets/ambient_background.dart';
import 'widgets/branding_header.dart';
import 'core/app_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.85;

  @override
  void initState() {
    super.initState();
    // Fade-In Animation starten
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.bgColor,
      body: AmbientBackground(
        child: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOut,
            child: const BrandingHeader(),
          ),
        ),
        ),
      ),
    );
  }
}
