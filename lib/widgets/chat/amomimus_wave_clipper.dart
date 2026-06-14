import 'dart:math';
import 'package:flutter/material.dart';

class AmomimusWaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double offset;
  AmomimusWaveClipper(this.animationValue, this.offset);

  @override
  Path getClip(Size size) {
    Path path = Path();
    double angle = (animationValue * 2 * pi) + (offset * pi);
    double waveSin = sin(angle);
    double waveCos = cos(angle);
    double startY = 55 + (waveSin * 22);
    double endY = 45 + (waveCos * 18);

    path.moveTo(0, size.height);
    path.lineTo(0, startY);
    double controlX = (size.width * 0.35) + (waveCos * 30);
    double controlY = 85 + (waveSin * 25);
    path.quadraticBezierTo(controlX, controlY, size.width, endY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant AmomimusWaveClipper oldClipper) => true;
}
