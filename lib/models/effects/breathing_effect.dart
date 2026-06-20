import 'package:flutter/material.dart';

class BreathingEffect extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;

  const BreathingEffect({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.minOpacity = 0.4,
    this.maxOpacity = 1.0,
  });

  @override
  State<BreathingEffect> createState() => _BreathingEffectState();
}

class _BreathingEffectState extends State<BreathingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);

    _opacityAnimation =
        Tween<double>(begin: widget.minOpacity, end: widget.maxOpacity).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacityAnimation, child: widget.child);
  }
}
