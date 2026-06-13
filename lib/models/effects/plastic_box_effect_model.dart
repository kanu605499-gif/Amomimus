import 'package:flutter/material.dart';

class PlasticBoxEffect extends StatelessWidget {
  final Widget child;
  final double borderRadius;

  const PlasticBoxEffect({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        // The plastic glare overlay
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.15, 0.25, 0.8, 1.0],
                  colors: [
                    Colors.white.withValues(alpha: 0.5), // Strong highlight corner
                    Colors.white.withValues(alpha: 0.1), // Fade
                    Colors.transparent,            // Flat plastic
                    Colors.transparent,            // Flat plastic
                    Colors.black.withValues(alpha: 0.1), // Slight shadow on opposite corner
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
