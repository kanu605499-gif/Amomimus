import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/screens/feed_screen.dart';
import 'package:amomimus/database/preference_handler.dart';
import 'package:amomimus/screens/login.dart';
import 'package:amomimus/screens/onboarding_screen.dart' as amomimus_onboarding;
import 'package:amomimus/amomimusdark.dart';

class SplashScreen extends StatefulWidget {
  final bool isShutdown;
  const SplashScreen({super.key, this.isShutdown = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scanlineController;
  late AnimationController _glitchController;
  Timer? _noiseTimer;
  double _glitchOffset = 0.0;
  List<double> _noiseBars = [];
  bool _showColorBars = false;
  
  String _currentCaption = "";
  List<String> _captions = [];
  
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    if (widget.isShutdown) {
      _currentCaption = "SHUTTING DOWN...";
      _captions = ["SHUTTING DOWN...", "UNPLUG THE DYSTOPIA", "RETURNING TO REALITY"];
    } else {
      _currentCaption = "NO SIGNAL";
      _captions = ["NO SIGNAL", "STAND BY...", "EMBRACE THE NOISE"];
    }
    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    )..repeat(reverse: true);

    _noiseTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (mounted) {
        setState(() {
          _glitchOffset = (_random.nextDouble() - 0.5) * 15; // -7.5 to +7.5
          _noiseBars = List.generate(8, (_) => _random.nextDouble());
          // Randomly flash the RGB SMPTE color bars
          _showColorBars = _random.nextDouble() > 0.85; 
          
          // Glitch the caption text occasionally
          if (_random.nextDouble() > 0.8) {
            _currentCaption = _captions[_random.nextInt(_captions.length)];
          }
        });
      }
    });

    _checkSession();
  }

  @override
  void dispose() {
    _scanlineController.dispose();
    _glitchController.dispose();
    _noiseTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(milliseconds: 3500)); // Enjoy the TV static

    if (!mounted) return;

    if (widget.isShutdown) {
      // Validator: ensure logout is complete
      await PreferenceHandler.logOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AmomimusApp2(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
      return;
    }

    bool isLoggedIn = PreferenceHandler.isLogin;
    bool hasSeenOnboarding = PreferenceHandler.hasSeenOnboarding;

    if (mounted) {
      Widget nextScreen;
      if (isLoggedIn) {
        nextScreen = const AmomimusApp5(); // Home
      } else if (hasSeenOnboarding) {
        nextScreen = const AmomimusApp2(); // Login
      } else {
        nextScreen = const amomimus_onboarding.OnboardingScreen();
      }

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  Widget _buildLogo(Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.tv_off_rounded,
          size: 100,
          color: color,
        ),
        const SizedBox(height: 16),
        Text(
          "AMOMIMUS",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 14,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          color: color,
          child: Text(
            _currentCaption,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
              color: Colors.black,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.watch<AmomimusDarkTheme>().isDarkMode;

    // SMPTE Color Bars definition
    final List<Color> colorBars = [
      Colors.white,
      Colors.yellow,
      Colors.cyan,
      Colors.green,
      Colors.purpleAccent,
      Colors.red,
      Colors.blue,
    ];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background subtle noise pattern
          Container(color: isDark ? const Color(0xFF111111) : const Color(0xFFF5F5F5)),
          
          // SMPTE RGB Color Bars Error Screen (Flashes randomly)
          if (_showColorBars)
            Opacity(
              opacity: 0.15, // Subtle background flash
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: colorBars.map((color) => Expanded(
                  child: Container(color: color),
                )).toList(),
              ),
            ),
          
          // Glitchy Main Logo
          Center(
            child: AnimatedBuilder(
              animation: _glitchController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Chromatic Aberration - Red
                    Transform.translate(
                      offset: Offset(_glitchOffset * 1.5, _glitchOffset * 0.3),
                      child: _buildLogo(Colors.redAccent.withValues(alpha: 0.8)),
                    ),
                    // Chromatic Aberration - Cyan
                    Transform.translate(
                      offset: Offset(-_glitchOffset * 1.5, -_glitchOffset * 0.3),
                      child: _buildLogo(Colors.cyanAccent.withValues(alpha: 0.8)),
                    ),
                    // Main Logo
                    _buildLogo(
                      widget.isShutdown 
                          ? Colors.redAccent 
                          : (isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple)
                    ),
                  ],
                );
              },
            ),
          ),

          // Random RGB TV Static Bars (VHS Tracking)
          ..._noiseBars.map((pos) {
            // Mix of white and RGB colors for the static lines
            final colors = isDark 
                ? [Colors.redAccent, Colors.greenAccent, Colors.blueAccent, Colors.white]
                : [Colors.redAccent, Colors.red, Colors.deepOrangeAccent, AmomimusDarkTheme.primaryPurple];
            final rgbColor = colors[_random.nextInt(colors.length)];
            
            return Positioned(
              top: MediaQuery.of(context).size.height * pos,
              left: 0,
              right: 0,
              height: _random.nextDouble() * 12 + 2,
              child: Transform.translate(
                offset: Offset((_random.nextDouble() - 0.5) * 20, 0), // Horizontal tearing
                child: Container(
                  color: rgbColor.withValues(alpha: _random.nextDouble() * 0.25),
                ),
              ),
            );
          }),

          // Rolling Scanline
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scanlineController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, MediaQuery.of(context).size.height * _scanlineController.value - 30),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            isDark ? Colors.white.withValues(alpha: 0.15) : AmomimusDarkTheme.primaryPurple.withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // CRT TV Vignette (Dark edges for dark mode, subtle shadow for light mode)
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Colors.transparent,
                  isDark ? Colors.black.withValues(alpha: 0.95) : Colors.black.withValues(alpha: 0.2),
                ],
                radius: 1.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
