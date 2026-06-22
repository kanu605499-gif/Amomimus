import 'package:amomimus/i18n/strings.g.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:amomimus/database/preference_handler.dart';
import 'package:amomimus/screens/login.dart'; // AmomimusApp2 (Login)
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:amomimus/models/user_indicator_model.dart'; // Colors
import '../widgets/particle_background.dart';

class OnboardingScreen extends StatefulWidget {
  final bool fromDrawer;
  const OnboardingScreen({super.key, this.fromDrawer = false});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  void _finishOnboarding() {
    PreferenceHandler.setHasSeenOnboarding(true);
    if (widget.fromDrawer) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AmomimusApp2()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Page View
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 3);
              });
            },
            children: [
              // Slide 1: Welcome Icons
              _Slide1WelcomeIcons(fromDrawer: widget.fromDrawer),
              // Slide 2: Identity Protection
              _Slide2IdentityProtection(fromDrawer: widget.fromDrawer),
              // Slide 3: The Indicators
              _Slide3TheIndicators(fromDrawer: widget.fromDrawer),
              // Slide 4: Safe & Respectful
              _Slide4SafeAndRespectful(fromDrawer: widget.fromDrawer),
            ],
          ),

          // Skip Button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  t.skip,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

          // Bottom Controls
          Container(
            alignment: const Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Empty space to balance the FAB
                const SizedBox(width: 56),

                // Dot Indicator
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: WormEffect(
                    activeDotColor: const Color(0xff8c72c4),
                    dotColor: Colors.grey.shade300,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),

                // Next / Get Started Button
                FloatingActionButton(
                  elevation: 0,
                  backgroundColor: const Color(0xff8c72c4),
                  onPressed: () {
                    if (onLastPage) {
                      _finishOnboarding();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Icon(
                    onLastPage ? Icons.done : Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------------
// SLIDE 1: Welcome Icons (Dancing icons)
// -------------------------------------------------------------------------
class _Slide1WelcomeIcons extends StatefulWidget {
  final bool fromDrawer;
  const _Slide1WelcomeIcons({required this.fromDrawer});
  @override
  State<_Slide1WelcomeIcons> createState() => _Slide1WelcomeIconsState();
}

class _Slide1WelcomeIconsState extends State<_Slide1WelcomeIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login-style rounded boxes for icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedBox(
                  icon: Icons.diamond_outlined,
                  iconColor: const Color(0xFFB388FF), // Vivid pastel purple
                  bgColor: const Color.fromARGB(
                    255,
                    250,
                    246,
                    255,
                  ), // Login screen purple bg
                  delay: 0.0,
                ),
                const SizedBox(width: 15),
                _buildAnimatedBox(
                  icon: Icons.android_outlined,
                  iconColor: const Color(0xFFFFCA28), // Visible amber yellow
                  bgColor: const Color.fromARGB(
                    255,
                    255,
                    251,
                    240,
                  ), // Login screen yellow bg
                  delay: 2.0,
                ),
                const SizedBox(width: 15),
                _buildAnimatedBox(
                  icon: Icons.water_outlined,
                  iconColor: const Color(0xFFBDBDBD), // Visible grey
                  bgColor: const Color.fromARGB(
                    255,
                    248,
                    248,
                    248,
                  ), // Login screen grey bg
                  delay: 4.0,
                ),
              ],
            ),
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: t.welcome_to,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  children: const [
                    TextSpan(
                      text: "Amomimus",
                      style: TextStyle(color: Color(0xff684ca3)),
                    ),
                    TextSpan(text: "!"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                t.safe_space_desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBox({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required double delay,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final offset = math.sin((_controller.value * 2 * math.pi) + delay) * 10;
        return Transform.translate(
          offset: Offset(0, -offset),
          child: Container(
            width: 80,
            height: 90,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(child: Icon(icon, size: 36, color: iconColor)),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------------------
// SLIDE 2: Identity Protection ("We ensure...")
// -------------------------------------------------------------------------
class _Slide2IdentityProtection extends StatefulWidget {
  final bool fromDrawer;
  const _Slide2IdentityProtection({required this.fromDrawer});
  @override
  State<_Slide2IdentityProtection> createState() =>
      _Slide2IdentityProtectionState();
}

class _Slide2IdentityProtectionState extends State<_Slide2IdentityProtection>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centered up
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  // Heartbeat scale effect
                  final scale = 1.0 + (_fadeController.value * 0.15);
                  return Transform.scale(scale: scale, child: child);
                },
                child: const Icon(
                  Icons.shield_outlined,
                  size: 120,
                  color: Color(0xFFFFD54F),
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: t.identity_hidden_desc_1,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  children: [
                    const TextSpan(
                      text: "Amomimus",
                      style: TextStyle(color: Color(0xff684ca3)),
                    ),
                    TextSpan(text: t.identity_hidden_desc_2),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t.identity_protected_desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 60), // Push it up a bit visually
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------
// SLIDE 3: The Indicators (Particle system)
// -------------------------------------------------------------------------
class _Slide3TheIndicators extends StatefulWidget {
  final bool fromDrawer;
  const _Slide3TheIndicators({required this.fromDrawer});
  @override
  State<_Slide3TheIndicators> createState() => _Slide3TheIndicatorsState();
}

class _Slide3TheIndicatorsState extends State<_Slide3TheIndicators>
    with SingleTickerProviderStateMixin {
  late AnimationController _sequenceController;

  Color _particleColor = UserIndicatorHelper.cloudyColor;
  String _currentIndicator = "CLOUDY";

  @override
  void initState() {
    super.initState();
    // Sequence to cycle between Cloudy -> Ghost -> Noise
    _sequenceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();
    _sequenceController.addListener(_updateSequence);
  }

  void _updateSequence() {
    final value = _sequenceController.value;
    if (value < 0.33) {
      if (_currentIndicator != "CLOUDY") {
        setState(() {
          _currentIndicator = "CLOUDY";
          _particleColor = UserIndicatorHelper.cloudyColor;
        });
      }
    } else if (value < 0.66) {
      if (_currentIndicator != "GHOST") {
        setState(() {
          _currentIndicator = "GHOST";
          _particleColor = UserIndicatorHelper.ghostColor;
        });
      }
    } else {
      if (_currentIndicator != "NOISE") {
        setState(() {
          _currentIndicator = "NOISE";
          _particleColor = UserIndicatorHelper.noiseColor;
        });
      }
    }
  }

  @override
  void dispose() {
    _sequenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Particle Background
          Positioned.fill(
            child: ParticleBackground(
              particleColor: _particleColor,
              maxParticles: 50,
              particleSize: 3.0,
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    left: 40,
                    right: 40,
                  ),
                  child: Text(
                    t.intro_indicators,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 600),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          position:
                              Tween<Offset>(
                                begin: const Offset(0.0, 0.5),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: Text(
                    _currentIndicator,
                    key: ValueKey<String>(_currentIndicator),
                    style: TextStyle(
                      color: _particleColor,
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: _buildDescriptionText(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionText() {
    if (_currentIndicator == "CLOUDY") {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
            letterSpacing: 0.3,
          ),
          children: [
            TextSpan(
              text: t.neutral,
              style: const TextStyle(
                color: UserIndicatorHelper.cloudyColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(text: t.users_participate_normally),
          ],
        ),
      );
    } else if (_currentIndicator == "GHOST") {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
            letterSpacing: 0.3,
          ),
          children: [
            TextSpan(
              text: t.amoral,
              style: const TextStyle(
                color: UserIndicatorHelper.ghostColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(text: t.users_nonchalant),
          ],
        ),
      );
    } else {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 15,
            height: 1.5,
            letterSpacing: 0.3,
          ),
          children: [
            TextSpan(
              text: t.toxic,
              style: const TextStyle(
                color: UserIndicatorHelper.noiseColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            TextSpan(text: t.users_flagged),
          ],
        ),
      );
    }
  }
}



// -------------------------------------------------------------------------
// SLIDE 4: Safe & Respectful (Rules)
// -------------------------------------------------------------------------
class _Slide4SafeAndRespectful extends StatefulWidget {
  final bool fromDrawer;
  const _Slide4SafeAndRespectful({required this.fromDrawer});
  @override
  State<_Slide4SafeAndRespectful> createState() =>
      _Slide4SafeAndRespectfulState();
}

class _Slide4SafeAndRespectfulState extends State<_Slide4SafeAndRespectful>
    with SingleTickerProviderStateMixin {
  late AnimationController _danceController;

  @override
  void initState() {
    super.initState();
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _danceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _danceController,
              builder: (context, child) {
                final angle =
                    math.sin(_danceController.value * math.pi * 2) * 0.2;
                return Transform.rotate(angle: angle, child: child);
              },
              child: const Icon(
                Icons.handshake_outlined,
                size: 100,
                color: Color(0xFFFFD54F),
              ),
            ),
            const SizedBox(height: 40),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: t.safe_and,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: t.respectful,
                    style: const TextStyle(color: Color(0xff684ca3)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.value_privacy_desc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

// End of Onboarding Screen
