import 'dart:math';
import 'package:flutter/material.dart';

class StaticTvEffect extends StatefulWidget {
  final Widget? child;
  const StaticTvEffect({super.key, this.child});

  @override
  State<StaticTvEffect> createState() => _StaticTvEffectState();
}

class _StaticTvEffectState extends State<StaticTvEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _StaticTvPainter(Random().nextInt(1000)),
          child: widget.child,
        );
      },
    );
  }
}

class _StaticTvPainter extends CustomPainter {
  final int seed;
  _StaticTvPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final rand = Random(seed);
    final paint = Paint();
    
    // Grid of small noise blocks
    final int cols = 50;
    final double blockW = size.width / cols;
    final int rows = (size.height / blockW).ceil();
    final double blockH = blockW;

    for (int y = 0; y < rows; y++) {
      for (int x = 0; x < cols; x++) {
        final val = rand.nextInt(256);
        paint.color = Color.fromARGB(255, val, val, val);
        canvas.drawRect(
          Rect.fromLTWH(x * blockW, y * blockH, blockW, blockH),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StaticTvPainter oldDelegate) => true;
}
