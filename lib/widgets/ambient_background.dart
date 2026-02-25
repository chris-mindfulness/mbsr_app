import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/app_styles.dart';

/// Ambient Background Animation - Subtile, organische Bewegungen
/// 
/// Erstellt langsam fließende, farbige "Blobs" im Hintergrund
/// für einen beruhigenden, modernen Look (2026 Design)
class AmbientBackground extends StatefulWidget {
  final Widget child;
  
  const AmbientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AmbientBackground> createState() => _AmbientBackgroundState();
}

class _AmbientBackgroundState extends State<AmbientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;

  @override
  void initState() {
    super.initState();
    
    // Drei unabhängige Animationen für organische Bewegung
    _controller1 = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
    
    _controller2 = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
    
    _controller3 = AnimationController(
      duration: const Duration(seconds: 18),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Ambient Blobs im Hintergrund
        Positioned.fill(
          child: AnimatedBuilder(
            animation: Listenable.merge([_controller1, _controller2, _controller3]),
            builder: (context, child) {
              return CustomPaint(
                painter: _AmbientPainter(
                  progress1: _controller1.value,
                  progress2: _controller2.value,
                  progress3: _controller3.value,
                ),
              );
            },
          ),
        ),
        // Inhalt darüber
        widget.child,
      ],
    );
  }
}

class _AmbientPainter extends CustomPainter {
  final double progress1;
  final double progress2;
  final double progress3;

  _AmbientPainter({
    required this.progress1,
    required this.progress2,
    required this.progress3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppStyles.primaryOrange.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    
    final paint2 = Paint()
      ..color = AppStyles.successGreen.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    
    final paint3 = Paint()
      ..color = AppStyles.accentPink.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Blob 1 - Bewegt sich von links oben nach rechts unten
    final x1 = size.width * 0.2 + (size.width * 0.3) * math.sin(progress1 * 2 * math.pi);
    final y1 = size.height * 0.2 + (size.height * 0.2) * math.cos(progress1 * 2 * math.pi);
    final radius1 = size.width * 0.4 + (size.width * 0.1) * math.sin(progress1 * 4 * math.pi);
    
    canvas.drawCircle(
      Offset(x1, y1),
      radius1,
      paint1,
    );

    // Blob 2 - Bewegt sich von rechts oben nach links unten
    final x2 = size.width * 0.8 - (size.width * 0.25) * math.cos(progress2 * 2 * math.pi);
    final y2 = size.height * 0.3 + (size.height * 0.25) * math.sin(progress2 * 2 * math.pi);
    final radius2 = size.width * 0.35 + (size.width * 0.08) * math.cos(progress2 * 3 * math.pi);
    
    canvas.drawCircle(
      Offset(x2, y2),
      radius2,
      paint2,
    );

    // Blob 3 - Bewegt sich langsam in der Mitte
    final x3 = size.width * 0.5 + (size.width * 0.2) * math.sin(progress3 * 2 * math.pi);
    final y3 = size.height * 0.7 - (size.height * 0.15) * math.cos(progress3 * 2 * math.pi);
    final radius3 = size.width * 0.3 + (size.width * 0.1) * math.sin(progress3 * 5 * math.pi);
    
    canvas.drawCircle(
      Offset(x3, y3),
      radius3,
      paint3,
    );
  }

  @override
  bool shouldRepaint(_AmbientPainter oldDelegate) {
    return oldDelegate.progress1 != progress1 ||
        oldDelegate.progress2 != progress2 ||
        oldDelegate.progress3 != progress3;
  }
}
