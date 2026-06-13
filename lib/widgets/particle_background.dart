import 'package:flutter/material.dart';
import 'dart:math' as math;

class Particle {
  double x;
  double y;
  double speed;
  Particle({required this.x, required this.y, required this.speed});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;
  final double particleSize;
  final double speedMultiplier;

  ParticlePainter(this.particles, this.progress, this.color, this.particleSize, this.speedMultiplier);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    
    final double time = DateTime.now().millisecondsSinceEpoch / 2000.0;
    
    for (var p in particles) {
      double currentY = (p.y - (time * p.speed * speedMultiplier)) % 1.0;
      if (currentY < 0) currentY += 1.0; // Wrap around safely
      
      canvas.drawCircle(
        Offset(p.x * size.width, currentY * size.height),
        particleSize, // Particle radius
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ParticleBackground extends StatefulWidget {
  final Color particleColor;
  final int maxParticles;
  final double particleSize;
  final double speedMultiplier;

  const ParticleBackground({
    Key? key,
    required this.particleColor,
    this.maxParticles = 30,
    this.particleSize = 3.0,
    this.speedMultiplier = 1.0,
  }) : super(key: key);

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground> with SingleTickerProviderStateMixin {
  late AnimationController _particleController;
  final List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _initParticles();
  }

  @override
  void didUpdateWidget(ParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.maxParticles != widget.maxParticles) {
      _initParticles();
    }
  }

  void _initParticles() {
    particles.clear();
    for (int i = 0; i < widget.maxParticles; i++) {
      particles.add(Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        speed: 0.2 + math.Random().nextDouble() * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(particles, _particleController.value, widget.particleColor, widget.particleSize, widget.speedMultiplier),
          child: Container(),
        );
      },
    );
  }
}
