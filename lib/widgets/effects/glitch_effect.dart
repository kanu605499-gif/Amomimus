import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GlitchEffect extends StatefulWidget {
  final Widget child;
  final bool isActive;

  const GlitchEffect({super.key, required this.child, this.isActive = true});

  @override
  State<GlitchEffect> createState() => _GlitchEffectState();
}

class _GlitchEffectState extends State<GlitchEffect> with SingleTickerProviderStateMixin {
  late Timer _timer;
  final Random _random = Random();
  double _xOffset1 = 0;
  double _yOffset1 = 0;
  double _xOffset2 = 0;
  double _yOffset2 = 0;
  bool _isGlitching = false;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _startGlitchTimer();
    }
  }

  @override
  void didUpdateWidget(covariant GlitchEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _startGlitchTimer();
    } else if (!widget.isActive && oldWidget.isActive) {
      _timer.cancel();
      setState(() {
        _isGlitching = false;
        _xOffset1 = 0;
        _yOffset1 = 0;
        _xOffset2 = 0;
        _yOffset2 = 0;
      });
    }
  }

  void _startGlitchTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted) return;
      
      // Randomly decide whether to glitch on this tick (e.g. 30% chance)
      if (_random.nextDouble() > 0.7) {
        setState(() {
          _isGlitching = true;
          _xOffset1 = (_random.nextDouble() - 0.5) * 6;
          _yOffset1 = (_random.nextDouble() - 0.5) * 6;
          _xOffset2 = (_random.nextDouble() - 0.5) * 6;
          _yOffset2 = (_random.nextDouble() - 0.5) * 6;
        });
        
        // Return to normal very quickly
        Future.delayed(const Duration(milliseconds: 80), () {
          if (mounted) {
            setState(() {
              _isGlitching = false;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    if (widget.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || !_isGlitching) {
      return widget.child;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Base child (mostly invisible or slightly dimmed)
        Opacity(
          opacity: 0.8,
          child: widget.child,
        ),
        // Red shift
        Transform.translate(
          offset: Offset(_xOffset1, _yOffset1),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.red, Colors.red],
            ).createShader(bounds),
            child: Opacity(
              opacity: 0.6,
              child: widget.child,
            ),
          ),
        ),
        // Cyan shift
        Transform.translate(
          offset: Offset(_xOffset2, _yOffset2),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.cyan, Colors.cyan],
            ).createShader(bounds),
            child: Opacity(
              opacity: 0.6,
              child: widget.child,
            ),
          ),
        ),
      ],
    );
  }
}
