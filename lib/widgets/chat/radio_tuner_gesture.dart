import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class RadioTunerGestureWrapper extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  final Color themeColor;
  final bool isDark;

  const RadioTunerGestureWrapper({
    super.key,
    required this.child,
    required this.scrollController,
    required this.themeColor,
    required this.isDark,
  });

  @override
  State<RadioTunerGestureWrapper> createState() => _RadioTunerGestureWrapperState();
}

class _RadioTunerGestureWrapperState extends State<RadioTunerGestureWrapper> {
  bool _isActive = false;
  Timer? _dismissTimer;
  Timer? _soundTimer;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlayingSound = false;

  Offset? _center;
  double _lastAngle = 0;
  double _accumulatedAngle = 0;

  double _minX = double.infinity;
  double _maxX = double.negativeInfinity;
  double _minY = double.infinity;
  double _maxY = double.negativeInfinity;

  void _onPointerDown(PointerDownEvent event) {
    if (!_isActive) {
      _accumulatedAngle = 0;
      _minX = event.localPosition.dx;
      _maxX = event.localPosition.dx;
      _minY = event.localPosition.dy;
      _maxY = event.localPosition.dy;
      _center = null;
    } else {
      _dismissTimer?.cancel();
      if (_center != null) {
        _lastAngle = _getAngle(event.localPosition, _center!);
      }
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_isActive) {
      if (event.localPosition.dx < _minX) _minX = event.localPosition.dx;
      if (event.localPosition.dx > _maxX) _maxX = event.localPosition.dx;
      if (event.localPosition.dy < _minY) _minY = event.localPosition.dy;
      if (event.localPosition.dy > _maxY) _maxY = event.localPosition.dy;

      double width = _maxX - _minX;
      double height = _maxY - _minY;

      // Ensure the bounding box is large enough to be a deliberate circle
      if (width > 80 && height > 80) {
        _center = Offset(_minX + width / 2, _minY + height / 2);
        double angle = _getAngle(event.localPosition, _center!);
        
        if (_lastAngle != 0 && _center != null) {
          double delta = _angleDiff(_lastAngle, angle);
          _accumulatedAngle += delta;
          
          if (_accumulatedAngle.abs() >= 2 * pi * 0.9) { // 90% of a circle
            _activateTuner();
            _lastAngle = angle;
            return;
          }
        }
        _lastAngle = angle;
      }
    } else {
      if (_center != null) {
        double angle = _getAngle(event.localPosition, _center!);
        double delta = _angleDiff(_lastAngle, angle);
        _lastAngle = angle;
        _handleScroll(delta);
      }
    }
  }

  void _handlePointerEnd() {
    _stopStaticSound();
    if (_isActive) {
      _dismissTimer?.cancel();
      _dismissTimer = Timer(const Duration(milliseconds: 750), () {
        if (mounted) {
          setState(() {
            _isActive = false;
            _accumulatedAngle = 0;
          });
        }
      });
    } else {
      _accumulatedAngle = 0;
      _lastAngle = 0;
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _handlePointerEnd();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _handlePointerEnd();
  }

  void _activateTuner() {
    setState(() {
      _isActive = true;
      _accumulatedAngle = 0;
    });
    HapticFeedback.heavyImpact(); // Vibrate when triggered
  }

  void _handleScroll(double angleDelta) {
    if (!widget.scrollController.hasClients) return;
    
    if (angleDelta.abs() > 0.005) {
      _handleTuningSound();
    }
    
    // Convert angle delta to scroll pixels.
    // Right (clockwise) means delta > 0 -> scroll down -> increase offset
    // Left (counter-clockwise) means delta < 0 -> scroll up -> decrease offset
    // 1 full rotation (2*pi) = 6000 pixels (fast scroll)
    double scrollPixels = (angleDelta / (2 * pi)) * 6000; 
    
    double newOffset = widget.scrollController.offset + scrollPixels;
    newOffset = newOffset.clamp(0.0, widget.scrollController.position.maxScrollExtent);
    
    widget.scrollController.jumpTo(newOffset);
  }

  double _getAngle(Offset point, Offset center) {
    return atan2(point.dy - center.dy, point.dx - center.dx);
  }

  double _angleDiff(double angle1, double angle2) {
    double diff = angle2 - angle1;
    while (diff > pi) diff -= 2 * pi;
    while (diff < -pi) diff += 2 * pi;
    return diff;
  }

  void _handleTuningSound() {
    _playStaticSound();
    _soundTimer?.cancel();
    _soundTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) _stopStaticSound();
    });
  }

  void _playStaticSound() async {
    if (!_isPlayingSound) {
      _isPlayingSound = true;
      try {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource('audio/radio_static.mp3'), volume: 0.15);
      } catch (e) {
        // Fallback or ignore if asset is missing
      }
    }
  }

  void _stopStaticSound() {
    if (_isPlayingSound) {
      _isPlayingSound = false;
      _audioPlayer.stop();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _soundTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Listener(
          onPointerDown: _onPointerDown,
          onPointerMove: _onPointerMove,
          onPointerUp: _onPointerUp,
          onPointerCancel: _onPointerCancel,
          child: widget.child,
        ),
        if (_isActive)
          Positioned.fill(
             child: GestureDetector(
               onPanUpdate: (e) {
                  // Absorbs the gesture so the underlying scroll view ignores it
               },
               onPanEnd: (e) {
                 // Trigger pointer up equivalent if needed
                 _onPointerUp(const PointerUpEvent());
               },
               onPanCancel: () {
                 _onPointerUp(const PointerUpEvent());
               },
               child: Container(
                 color: widget.isDark 
                     ? Colors.black.withValues(alpha: 0.7) 
                     : Colors.white.withValues(alpha: 0.8), // Adaptive overlay background
                 child: Center(
                   child: AnimatedBuilder(
                     animation: widget.scrollController,
                     builder: (context, child) {
                       return CustomPaint(
                         size: const Size(300, 100),
                         painter: _RadioTunerPainter(
                           scrollOffset: widget.scrollController.hasClients 
                               ? widget.scrollController.offset 
                               : 0.0,
                           maxScrollExtent: widget.scrollController.hasClients 
                               ? widget.scrollController.position.maxScrollExtent 
                               : 1.0,
                           themeColor: widget.themeColor,
                           isDark: widget.isDark,
                         ),
                       );
                     },
                   ),
                 ),
               ),
             ),
          ),
      ],
    );
  }
}

class _RadioTunerPainter extends CustomPainter {
  final double scrollOffset;
  final double maxScrollExtent;
  final Color themeColor;
  final bool isDark;

  _RadioTunerPainter({
    required this.scrollOffset, 
    required this.maxScrollExtent,
    required this.themeColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Color activeThemeColor = isDark ? const Color(0xFFFFD54F) : themeColor;

    final paint = Paint()
      ..color = activeThemeColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final highlightPaint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final bgPaint = Paint()
      ..color = activeThemeColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = activeThemeColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw tuner container
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height), 
      const Radius.circular(20)
    );
    canvas.drawRRect(rrect, bgPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Shift is based on scrollOffset directly so it scales perfectly with gesture speed.
    // 0.5 means every 80 pixels scrolled = 1 full tick cycle (40px)
    double shift = (scrollOffset * 0.5) % 40;
    
    // Draw fading edges
    canvas.save();
    canvas.clipRRect(rrect);

    for (double x = -40; x <= size.width + 40; x += 20) {
      double tickX = x - shift;
      
      // Calculate opacity based on distance from center for a fade effect
      double distanceToCenter = (tickX - size.width / 2).abs();
      double opacity = (1.0 - (distanceToCenter / (size.width / 2))).clamp(0.0, 1.0);
      
      if (opacity > 0) {
        paint.color = activeThemeColor.withValues(alpha: opacity * 0.8);
        
        // Every 4th tick is longer
        bool isLong = (x / 20).round() % 4 == 0;
        double tickHeight = isLong ? 40 : 20;
        
        canvas.drawLine(
          Offset(tickX, size.height / 2 - tickHeight / 2),
          Offset(tickX, size.height / 2 + tickHeight / 2),
          paint,
        );
      }
    }
    
    canvas.restore();

    // Draw static center needle
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - 45),
      Offset(size.width / 2, size.height / 2 + 45),
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadioTunerPainter oldDelegate) {
    return oldDelegate.scrollOffset != scrollOffset || oldDelegate.themeColor != themeColor;
  }
}
