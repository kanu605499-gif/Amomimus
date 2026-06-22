import 'dart:math';
import 'package:flutter/material.dart';

// --- Sistem Engine Partikel Melayang (Dari Bawah) ---
class ParticleBackgroundPainter extends CustomPainter {
  final double progress;
  final Color color;

  static final List<StaticParticle> _cachedParticles = _generateParticles();

  static List<StaticParticle> _generateParticles() {
    Random seedRand = Random(2026);
    return List.generate(30, (index) {
      return StaticParticle(
        xPercent: seedRand.nextDouble(),
        yBasePercent: seedRand.nextDouble(),
        size: seedRand.nextDouble() * 4.0 + 2.5,
        speedFactor: (seedRand.nextInt(4) + 2).toDouble(), // 2.0 to 5.0 (integers only for seamless loop)
        opacityFactor: seedRand.nextDouble() * 0.7 + 0.3,
      );
    });
  }

  ParticleBackgroundPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in _cachedParticles) {
      // Menggerakkan partikel ke atas secara mulus (mengurangi progress)
      double yFraction =
          (particle.yBasePercent - (progress * particle.speedFactor)) % 1.0;

      double x = particle.xPercent * size.width;
      double y = yFraction * size.height;

      paint.color = color.withValues(alpha: color.a * particle.opacityFactor);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBackgroundPainter oldDelegate) => true;
}

class StaticParticle {
  final double xPercent;
  final double yBasePercent;
  final double size;
  final double speedFactor;
  final double opacityFactor;

  StaticParticle({
    required this.xPercent,
    required this.yBasePercent,
    required this.size,
    required this.speedFactor,
    required this.opacityFactor,
  });
}
