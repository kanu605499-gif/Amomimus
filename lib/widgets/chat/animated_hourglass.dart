import 'package:flutter/material.dart';

class AnimatedHourglass extends StatefulWidget {
  final Color color;
  const AnimatedHourglass({super.key, required this.color});
  @override
  State<AnimatedHourglass> createState() => _AnimatedHourglassState();
}

class _AnimatedHourglassState extends State<AnimatedHourglass>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Transform.rotate(angle: _ctrl.value * 2 * 3.14159, child: child),
      child: Icon(Icons.hourglass_empty, size: 12, color: widget.color),
    );
  }
}
