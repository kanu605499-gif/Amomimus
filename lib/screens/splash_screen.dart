import 'package:amomimus/i18n/strings.g.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:amomimus/screens/feed_screen.dart';
import 'package:amomimus/services/preference_handler.dart';
import 'package:amomimus/screens/login.dart';
import 'package:amomimus/screens/onboarding_screen.dart' as amomimus_onboarding;
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/services/account_manager.dart';

class SplashScreen extends StatefulWidget {
  final bool isShutdown;
  const SplashScreen({super.key, this.isShutdown = false});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _scanlineController;
  late AnimationController _glitchController;
  Timer? _noiseTimer;
  double _glitchOffset = 0.0;
  List<double> _noiseBars = [];
  bool _showColorBars = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _currentCaption = "";
  List<String> _captions = [];

  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _audioPlayer.play(AssetSource('audio/splash_sound.mp3'));

    if (widget.isShutdown) {
      _currentCaption = "shutting_down";
      _captions = ["shutting_down", "unplug_dystopia", "returning_to_reality"];
    } else {
      _currentCaption = "no_signal";
      _captions = ["no_signal", "stand_by", "embrace_the_noise"];
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
    _audioPlayer.dispose();
    _scanlineController.dispose();
    _glitchController.dispose();
    _noiseTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkSession() async {
    final tasks = <Future>[
      Future.delayed(const Duration(milliseconds: 3500)), // Enjoy the TV static
    ];

    if (Platform.isAndroid) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        tasks.add(androidPlugin.requestNotificationsPermission() ?? Future.value());
      }
    }

    await Future.wait(tasks);

    if (!mounted) return;

    if (widget.isShutdown) {
      // Validator: ensure logout is complete
      context.read<AccountManager>().logout();
      await PreferenceHandler.logOut();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AmomimusApp2(),
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
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  Widget _buildLogo(Color color) {
    final t = Translations.of(context);
    String translatedCaption = _currentCaption;
    switch (_currentCaption) {
      case 'shutting_down':
        translatedCaption = t.splash_shutting_down;
        break;
      case 'unplug_dystopia':
        translatedCaption = t.splash_unplug;
        break;
      case 'returning_to_reality':
        translatedCaption = t.splash_returning;
        break;
      case 'no_signal':
        translatedCaption = t.splash_no_signal;
        break;
      case 'stand_by':
        translatedCaption = t.splash_stand_by;
        break;
      case 'embrace_the_noise':
        translatedCaption = t.splash_embrace;
        break;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.tv_off_rounded, size: 100, color: color),
        const SizedBox(height: 16),
        Text(
          "AMOMIMUS",
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            letterSpacing: 6,
            color: color,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(height: 24),
        // VHS Lower-Third + CRT Burn-In Hybrid
        SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top scan-line bar
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      color.withValues(alpha: 0.6),
                      color,
                      color.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
                  ),
                ),
              ),
              // Caption area with dark translucent backdrop
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  border: Border(
                    left: BorderSide(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    right: BorderSide(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  translatedCaption,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.5,
                    color: color,
                    fontFamily: 'monospace',
                    shadows: [
                      // Phosphor burn-in glow — inner
                      Shadow(
                        color: color.withValues(alpha: 0.9),
                        blurRadius: 4,
                      ),
                      // Phosphor burn-in glow — mid
                      Shadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                      // Phosphor burn-in glow — outer haze
                      Shadow(
                        color: color.withValues(alpha: 0.2),
                        blurRadius: 28,
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom scan-line bar
              Container(
                height: 1.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      color.withValues(alpha: 0.6),
                      color,
                      color.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.15, 0.5, 0.85, 1.0],
                  ),
                ),
              ),
            ],
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
          Container(
            color: isDark ? const Color(0xFF111111) : const Color(0xFFF5F5F5),
          ),

          // SMPTE RGB Color Bars Error Screen (Flashes randomly)
          if (_showColorBars)
            Opacity(
              opacity: 0.15, // Subtle background flash
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: colorBars
                    .map((color) => Expanded(child: Container(color: color)))
                    .toList(),
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
                      child: _buildLogo(
                        Colors.redAccent.withValues(alpha: 0.8),
                      ),
                    ),
                    // Chromatic Aberration - Cyan
                    Transform.translate(
                      offset: Offset(
                        -_glitchOffset * 1.5,
                        -_glitchOffset * 0.3,
                      ),
                      child: _buildLogo(
                        Colors.cyanAccent.withValues(alpha: 0.8),
                      ),
                    ),
                    // Main Logo
                    _buildLogo(
                      widget.isShutdown
                          ? Colors.redAccent
                          : (isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple),
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
                ? [
                    Colors.redAccent,
                    Colors.greenAccent,
                    Colors.blueAccent,
                    Colors.white,
                  ]
                : [
                    Colors.redAccent,
                    Colors.red,
                    Colors.deepOrangeAccent,
                    AmomimusDarkTheme.primaryPurple,
                  ];
            final rgbColor = colors[_random.nextInt(colors.length)];

            return Positioned(
              top: MediaQuery.of(context).size.height * pos,
              left: 0,
              right: 0,
              height: _random.nextDouble() * 12 + 2,
              child: Transform.translate(
                offset: Offset(
                  (_random.nextDouble() - 0.5) * 20,
                  0,
                ), // Horizontal tearing
                child: Container(
                  color: rgbColor.withValues(
                    alpha: _random.nextDouble() * 0.25,
                  ),
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
                  offset: Offset(
                    0,
                    MediaQuery.of(context).size.height *
                            _scanlineController.value -
                        30,
                  ),
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
                            isDark
                                ? Colors.white.withValues(alpha: 0.15)
                                : AmomimusDarkTheme.primaryPurple.withValues(
                                    alpha: 0.15,
                                  ),
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
                  isDark
                      ? Colors.black.withValues(alpha: 0.95)
                      : Colors.black.withValues(alpha: 0.2),
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
