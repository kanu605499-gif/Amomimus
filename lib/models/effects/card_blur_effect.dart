import 'dart:ui';
import 'package:flutter/material.dart';

class CardBlurEffect extends StatelessWidget {
  final bool isBlurred;
  final Widget child;
  final double blurSigma;

  const CardBlurEffect({
    super.key,
    required this.isBlurred,
    required this.child,
    this.blurSigma = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: isBlurred ? blurSigma : 0.0),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      builder: (context, sigma, childWidget) {
        return ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigma.clamp(0.001, 10.0), sigmaY: sigma.clamp(0.001, 10.0)),
          child: childWidget,
        );
      },
      child: child,
    );
  }
}
