import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../utils/utc_time_manager.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../effects/glitch_effect.dart';

class FloatingCountdownCapsule extends StatefulWidget {
  final DateTime startedAt;
  final DateTime expiresAt;
  final bool isRecentlyUnblocked;
  final bool showResetGlitch;

  const FloatingCountdownCapsule({
    super.key,
    required this.startedAt,
    required this.expiresAt,
    this.isRecentlyUnblocked = false,
    this.showResetGlitch = false,
  });

  @override
  State<FloatingCountdownCapsule> createState() =>
      _FloatingCountdownCapsuleState();
}

class _FloatingCountdownCapsuleState extends State<FloatingCountdownCapsule>
    with TickerProviderStateMixin {
  late Timer _clockTimer;
  Timer? _floatTimer;
  Timer? _idleTimer;

  int _displayState = 0; // 0 = Countdown, 1 = Started At, 2 = End At

  double _posX = 50.0;
  double _posY = 100.0;
  bool _isDragging = false;
  Duration _currentDuration = const Duration(seconds: 6);
  Curve _currentCurve = Curves.easeInOut;

  late AnimationController _bounceCtrl;
  late Animation<double> _bounceAnim;

  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();

    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) _updateRemainingTime();
    });

    _bounceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnim = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeInOutSine),
    );

    // Initial random position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _randomizePosition();
      _startFloatingCycle();
    });
  }

  void _updateRemainingTime() {
    setState(() {
      _remaining = UTCTimeManager.getRemainingTime(widget.expiresAt);
    });
  }

  void _randomizePosition() {
    if (!mounted || _isDragging) return;
    final size = MediaQuery.of(context).size;
    final rand = Random();

    // Bounds: keep away from very top, very bottom, and edges
    final maxX = size.width - 150.0; // rough width of capsule
    final maxY = size.height - 200.0; // avoid keyboard/input area

    setState(() {
      _posX = 20.0 + rand.nextDouble() * max(0, maxX - 20.0);
      _posY = 100.0 + rand.nextDouble() * max(0, maxY - 100.0);
    });
  }

  void _startFloatingCycle() {
    _floatTimer?.cancel();
    _floatTimer = Timer.periodic(const Duration(seconds: 12), (timer) {
      _randomizePosition();
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    _floatTimer?.cancel();
    _idleTimer?.cancel();
    _bounceCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _displayState = (_displayState + 1) % 3;
    });
  }

  Offset? _dragOffset;

  void _handlePanStart(DragStartDetails details) {
    _floatTimer?.cancel();
    _idleTimer?.cancel();
    _dragOffset = details.localPosition;
    setState(() {
      _isDragging = true;
      _posX = details.globalPosition.dx - _dragOffset!.dx;
      _posY = details.globalPosition.dy - _dragOffset!.dy;
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_dragOffset == null) return;
    setState(() {
      _posX = details.globalPosition.dx - _dragOffset!.dx;
      _posY = details.globalPosition.dy - _dragOffset!.dy;
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    final size = MediaQuery.of(context).size;
    final maxX = size.width - 150.0;
    final maxY = size.height - 200.0;
    
    // Calculate glide target based on velocity
    double targetX = _posX + details.velocity.pixelsPerSecond.dx * 0.15;
    double targetY = _posY + details.velocity.pixelsPerSecond.dy * 0.15;
    
    // Clamp to screen bounds
    targetX = targetX.clamp(10.0, max(10.0, maxX));
    targetY = targetY.clamp(40.0, max(40.0, maxY));

    setState(() {
      _isDragging = false;
      _dragOffset = null;
      _posX = targetX;
      _posY = targetY;
      _currentDuration = const Duration(milliseconds: 800);
      _currentCurve = Curves.easeOutQuart;
    });

    // Stay idle at this position for 5 seconds before resuming float
    _idleTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentDuration = const Duration(seconds: 6);
          _currentCurve = Curves.easeInOut;
        });
        _randomizePosition();
        _startFloatingCycle();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;

    String displayText = "";
    if (_displayState == 0) {
      displayText = UTCTimeManager.formatDurationHHMMSS(_remaining);
    } else if (_displayState == 1) {
      displayText =
          "${t.started_at} ${UTCTimeManager.formatToLocalReadable(widget.startedAt)}";
    } else {
      displayText =
          "${t.end_at} ${UTCTimeManager.formatToLocalReadable(widget.expiresAt)}";
    }

    final capsuleBg = isDark
        ? Colors.black87
        : Colors.white.withValues(alpha: 0.9);
    final borderColor = isDark 
        ? AmomimusDarkTheme.policeLineYellow 
        : AmomimusDarkTheme.primaryPurple;
    final textColor = isDark ? Colors.white : Colors.black87;

    return AnimatedPositioned(
      duration: _isDragging ? Duration.zero : _currentDuration,
      curve: _currentCurve,
      left: _posX,
      top: _posY,
      child: AnimatedBuilder(
        animation: _bounceAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnim.value),
            child: child,
          );
        },
        child: GestureDetector(
          onTap: _handleTap,
          onPanStart: _handlePanStart,
          onPanUpdate: _handlePanUpdate,
          onPanEnd: _handlePanEnd,
          child: GlitchEffect(
            isActive: widget.isRecentlyUnblocked || widget.showResetGlitch,
            child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: capsuleBg,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: borderColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: borderColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Icon(
                  _displayState == 0
                      ? Icons.timer_outlined
                      : Icons.calendar_today_outlined,
                  size: 14,
                  color: AmomimusDarkTheme.policeLineYellow,
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                      child: child,
                    ),
                  ),
                  child: Text(
                    displayText,
                    key: ValueKey<String>(displayText),
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
      ),
    );
  }
}
