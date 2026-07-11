import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/screens/register_screen.dart';
import 'package:amomimus/screens/splash_screen.dart';
import 'package:amomimus/screens/welcome_form_screen.dart';

import 'package:provider/provider.dart';
import 'package:amomimus/services/account_manager.dart';

import '../services/preference_handler.dart';
import '../widgets/custom_input_field.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/effects/static_tv_effect.dart';
import '../services/audio_manager.dart';

void main() {
  runApp(const AmomimusApp2());
}

class AmomimusApp2 extends StatelessWidget {
  const AmomimusApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfffdfbfe),
        fontFamily: 'Sans-Serif',
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatingController;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  String? _emailErrorMsg;
  String? _passwordErrorMsg;
  bool _showEasterEggBubble = false;
  bool _isGoogleLoading = false;
  bool _isRegularLoading = false;

  // We will load accounts directly from AccountManager
  // Future<List<UserCredentialsModel>>? _userListFuture;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _loadSavedPreferences();
    _refreshUserList();
  }

  void _refreshUserList() {
    // Rely on AccountManager to refresh list automatically via loadAccounts if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<AccountManager>(context, listen: false).loadAccounts();
      }
    });
  }

  Future<void> _loadSavedPreferences() async {
    if (!mounted) return;

    setState(() {
      _emailController.text = PreferenceHandler.savedEmail ?? '';
      _rememberMe = PreferenceHandler.rememberMe;
    });
  }

  Future<void> _saveLoginPreferences() async {
    await PreferenceHandler.setLogin(true);

    if (_rememberMe) {
      await PreferenceHandler.setSavedEmail(_emailController.text.trim());
    } else {
      await PreferenceHandler.setSavedEmail('');
    }

    await PreferenceHandler.setRememberMe(_rememberMe);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _triggerEasterEgg() {
    if (_showEasterEggBubble) return;
    setState(() {
      _showEasterEggBubble = true;
    });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showEasterEggBubble = false;
        });
      }
    });
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() {
      if (email.isEmpty) {
        _emailErrorMsg = 'Email cannot be empty';
      } else if (!email.contains('@')) {
        _emailErrorMsg = '@ is required.';
      } else {
        _emailErrorMsg = null;
      }

      if (password.isEmpty) {
        _passwordErrorMsg = 'Password cannot be empty';
      } else {
        _passwordErrorMsg = null;
      }
    });

    if (_emailErrorMsg != null || _passwordErrorMsg != null) {
      return;
    }

    setState(() {
      _isRegularLoading = true;
    });
    
    AudioManager().playIntro();

    final accountManager = Provider.of<AccountManager>(context, listen: false);

    // Removed 3-account limit check for login as requested

    try {
      final isSuccess = await accountManager.login(email, password);

      if (isSuccess) {
        await _saveLoginPreferences();
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      } else {
        if (!mounted) return;
        setState(() {
          _isRegularLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isRegularLoading = false;
      });
      if (e.toString().contains('email-not-verified')) {
        _showEmailNotVerifiedDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
            content: Text('Invalid email or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEmailNotVerifiedDialog() {
    final t = Translations.of(context);
    
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xfffdfbfe),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: Color(0xffe1dbec),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.email_verification_title,
                style: const TextStyle(
                  color: Color(0xff121212),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              t.email_not_verified_body,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSignUp() {
    // Removed 3-account limit check for signup as requested

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AmomimusApp3()),
    ).then((_) {
      _refreshUserList();
    });
  }

  void _handleGoogleLogin() async {
    final accountManager = context.read<AccountManager>();
    
    setState(() {
      _isGoogleLoading = true;
    });

    final result = await accountManager.loginWithGoogle();
    
    if (!mounted) return;

    setState(() {
      _isGoogleLoading = false;
    });

    if (result == null) {
      // User canceled or error occurred
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
          content: Text('Google Sign-In canceled or failed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (result.isNewUser) {
      // Proceed to WelcomeFormScreen (DOB + Privacy Policy) for new users
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmomimusApp4(
            email: result.email ?? '',
            realUsername: result.name ?? 'Amo',
            password: '', // No password for Google Auth
            favoriteCharacter: '',
            isGoogleAuth: true,
          ),
        ),
      );
    } else {
      // Existing user logged in
      await _saveLoginPreferences();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        backgroundColor: const Color(0xfffdfbfe),
        body: Stack(
        children: [
          // Background Animation Decor 1
          Positioned(
            top: 31,
            left: -40,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: -0.15, child: child),
                );
              },
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 250, 246, 255),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.diamond_outlined,
                      size: 48,
                      color: Color.fromARGB(255, 215, 192, 255),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Background Animation Decor 2
          Positioned(
            top: 150,
            bottom: 125,
            left: 25,
            right: 15,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: 0.15, child: child),
                );
              },
              child: Center(
                child: Opacity(
                  opacity: 0.3,
                  child: Container(
                    width: 140,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 251, 240),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.android_outlined,
                        size: 48,
                        color: Color(0xFFFFD54F),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Background Animation Decor 3
          Positioned(
            bottom: 31,
            right: -40,
            child: AnimatedBuilder(
              animation: _floatingController,
              builder: (context, child) {
                final double easeValue = Curves.easeInOut.transform(
                  _floatingController.value,
                );
                return Transform.translate(
                  offset: Offset(0, -12 * easeValue),
                  child: Transform.rotate(angle: 0.15, child: child),
                );
              },
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  width: 140,
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 248, 248, 248),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.water_outlined,
                      size: 48,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main Body
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amomimus',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff684ca3),
                        ),
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.favorite,
                              color: Color(0xFFF44336),
                            ),
                            onPressed: _triggerEasterEgg,
                          ),
                          if (_showEasterEggBubble)
                            Positioned(
                              top: 40,
                              right: 0,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF44336),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'You found the easter egg',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Welcome To ',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff121212),
                          fontFamily: 'Sans-Serif',
                        ),
                        children: [
                          TextSpan(
                            text: 'Amomimus',
                            style: TextStyle(color: Color(0xff684ca3)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text:
                            'Amomimus is a cathartic medium that allows users to surf with no need for a real identity',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 134, 134, 134),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomInputField(
                    label: 'EMAIL',
                    hintText: 'name@example.com',
                    controller: _emailController,
                    errorText: _emailErrorMsg,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _emailErrorMsg = null;
                        } else if (!value.contains('@')) {
                          _emailErrorMsg = '@ is required.';
                        } else {
                          _emailErrorMsg = null;
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomInputField(
                    label: 'PASSWORD',
                    hintText: '••••••••',
                    controller: _passwordController,
                    errorText: _passwordErrorMsg,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value ?? false;
                      });
                    },
                    title: const Text('Remember me'),
                    activeColor: const Color(0xff6c52a3),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isRegularLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6c52a3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: OutlinedButton(
                      onPressed: _handleGoogleLogin,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AmomimusDarkTheme.policeLineYellow,
                        side: const BorderSide(color: Color(0xffeaeaea)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 1,
                        shadowColor: Colors.black.withValues(alpha: 0.05),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/Social_Icons.png',
                            width: 20,
                            height: 20,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.g_mobiledata,
                                color: Color(0xff121212),
                                size: 24,
                              );
                            },
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              color: Color(0xff121212),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 21),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: const TextStyle(
                              color: Color(0xff6c52a3),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _navigateToSignUp,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          if (_isGoogleLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff6c52a3)),
                ),
              ),
            ),
            
          if (_isRegularLoading)
            const Positioned.fill(
              child: StaticTvEffect(),
            ),
        ],
      ),
    ),
    );
  }
}
