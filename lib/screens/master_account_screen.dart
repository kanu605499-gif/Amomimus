import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/account_manager.dart';
import '../../services/auth_service.dart';
import '../../database/models/user_register_sql.dart';
import '../../models/user_model.dart';
import '../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'login.dart';
import 'choose_amomimus_screen.dart';
import '../helpers/gender_helpers.dart';
import 'chatroomhome.dart';

class MasterAccountScreen extends StatefulWidget {
  const MasterAccountScreen({super.key});

  @override
  State<MasterAccountScreen> createState() => _MasterAccountScreenState();
}

class _MasterAccountScreenState extends State<MasterAccountScreen>
    with SingleTickerProviderStateMixin {
  UserModelSql? _credentials;
  bool _isLoading = true;
  late AnimationController _danceController;

  @override
  void initState() {
    super.initState();
    _danceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();
    _loadCredentials();
  }

  @override
  void dispose() {
    _danceController.dispose();
    super.dispose();
  }

  Future<void> _loadCredentials() async {
    final am = Provider.of<AccountManager>(context, listen: false);
    final user = am.currentUser;
    if (user != null) {
      final authService = context.read<AuthService>();
      final creds = await authService.getCredentials(user.masterEmail);
      setState(() {
        _credentials = creds;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _handleAddProfile(BuildContext context, bool isDark) {
    if (_credentials == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseAmomusPage(
          email: _credentials!.email ?? "",
          realUsername: _credentials!.fullName ?? "",
          password: _credentials!.password ?? "",
          favoriteCharacter: _credentials!.favoriteCharacter ?? "",
          dateOfBirth: "Unknown", // Bypassing for sub-profiles
          isDarkMode: false, // Force Light Theme for auth flow
        ),
      ),
    );
  }

  Future<void> _handleSwitchMasterAccount(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _switchToAccount(BuildContext context, UserAccount targetUser) async {
    final am = Provider.of<AccountManager>(context, listen: false);
    await am.switchAccount(targetUser);
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AmomimusApp7()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accentColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    final am = Provider.of<AccountManager>(context);
    final bindedAccounts = am.switchableAccounts;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: accentColor),
        title: Text(
          t.switch_account,
          style: TextStyle(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accentColor))
          : _credentials == null
              ? Center(
                  child: Text(
                    "Error loading master account",
                    style: TextStyle(color: textColor),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight - 80),
                        child: IntrinsicHeight(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Wrap(
                                spacing: 24,
                                runSpacing: 40,
                                alignment: WrapAlignment.center,
                                children: [
                                  ...List.generate(bindedAccounts.length, (index) {
                                    final acc = bindedAccounts[index];
                                    final genderColor = GenderHelpers.getGenderColor(acc.gender);
                                    final genderIcon = GenderHelpers.getGenderIcon(acc.gender);
                                    return SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () => _switchToAccount(context, acc),
                                            borderRadius: BorderRadius.circular(18),
                                            child: AnimatedBuilder(
                                              animation: _danceController,
                                              builder: (context, child) {
                                                final delay = index * 2.0;
                                                final offset = math.sin((_danceController.value * 2 * math.pi) + delay) * 8;
                                                return Transform.translate(
                                                  offset: Offset(0, -offset),
                                                  child: child,
                                                );
                                              },
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: genderColor.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(18),
                                                  border: Border.all(color: genderColor.withValues(alpha: 0.5), width: 1.5),
                                                ),
                                                child: Icon(genderIcon, color: genderColor, size: 40),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            acc.customUsername ?? acc.anonymousUsername,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            acc.amomimusId,
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Container(
                                            height: 3,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: accentColor,
                                              borderRadius: BorderRadius.circular(1.5),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  
                                  // Add Profile Box
                                  if (bindedAccounts.length < 3)
                                    SizedBox(
                                      width: 100,
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () => _handleAddProfile(context, isDark),
                                            borderRadius: BorderRadius.circular(18),
                                            child: CustomPaint(
                                              painter: _DashedBorderPainter(color: accentColor),
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                alignment: Alignment.center,
                                                child: Icon(Icons.add, color: accentColor, size: 40),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Add Profile",
                                            textAlign: TextAlign.center,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: accentColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
        
                              const SizedBox(height: 80),
                              
                              // Switch Email
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton.icon(
                                  onPressed: () => _handleSwitchMasterAccount(context),
                                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                                  label: const Text(
                                    "Switch Email",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.redAccent),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const double dashWidth = 8;
    const double dashSpace = 6;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(18),
    );

    Path path = Path()..addRRect(rrect);
    Path dashPath = Path();

    for (PathMetric measurePath in path.computeMetrics()) {
      double distance = 0;
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
