import 'dart:math' as math;
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/account_manager.dart';
import '../../services/auth_service.dart';
import '../../models/user_credentials_model.dart';
import '../../models/user_model.dart';
import '../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'login.dart';
import 'choose_amomimus_screen.dart';
import '../helpers/gender_helpers.dart';
import 'feed_screen.dart';

class MasterAccountScreen extends StatefulWidget {
  const MasterAccountScreen({super.key});

  @override
  State<MasterAccountScreen> createState() => _MasterAccountScreenState();
}

class _MasterAccountScreenState extends State<MasterAccountScreen>
    with SingleTickerProviderStateMixin {
  UserCredentialsModel? _credentials;
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
    
    // Check if password is empty or null (which means it's a Google Auth account)
    final bool isGoogleAuth = _credentials!.password?.isEmpty ?? true;
    
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
          isGoogleAuth: isGoogleAuth,
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
      MaterialPageRoute(builder: (_) => const AmomimusApp5()),
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
                              Builder(
                                builder: (context) {
                                  // Ensure 3 items can fit on screen (with 16px gaps)
                                  final screenWidth = MediaQuery.of(context).size.width;
                                  final maxAvailableWidth = screenWidth - 48; // accounting for 24px horizontal padding
                                  final itemWidth = math.min(100.0, (maxAvailableWidth - 32) / 3); // 32 is 2 gaps of 16px
                                  final iconSize = math.min(80.0, itemWidth);

                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      for (int index = 0; index < bindedAccounts.length; index++) ...[
                                        if (index > 0) const SizedBox(width: 16),
                                        SizedBox(
                                          width: itemWidth,
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () => _switchToAccount(context, bindedAccounts[index]),
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
                                                  child: Stack(
                                                    alignment: Alignment.bottomRight,
                                                    children: [
                                                      Container(
                                                        width: iconSize,
                                                        height: iconSize,
                                                        decoration: BoxDecoration(
                                                          color: GenderHelpers.getGenderColor(bindedAccounts[index].gender).withValues(alpha: 0.1),
                                                          borderRadius: BorderRadius.circular(18),
                                                          border: Border.all(color: GenderHelpers.getGenderColor(bindedAccounts[index].gender).withValues(alpha: 0.5), width: 1.5),
                                                        ),
                                                        child: Icon(GenderHelpers.getGenderIcon(bindedAccounts[index].gender), color: GenderHelpers.getGenderColor(bindedAccounts[index].gender), size: iconSize * 0.5),
                                                      ),
                                                      NotificationDot(
                                                        account: bindedAccounts[index],
                                                        allAccounts: bindedAccounts,
                                                        iconSize: iconSize,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                bindedAccounts[index].customUsername ?? bindedAccounts[index].anonymousUsername,
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
                                                bindedAccounts[index].amomimusId,
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              if (index == 0)
                                                Container(
                                                  height: 3,
                                                  width: itemWidth * 0.4,
                                                  decoration: BoxDecoration(
                                                    color: accentColor,
                                                    borderRadius: BorderRadius.circular(1.5),
                                                  ),
                                                )
                                              else
                                                const SizedBox(height: 3),
                                            ],
                                          ),
                                        ),
                                      ],
                                      
                                      // Add Profile Box
                                      if (bindedAccounts.length < 3) ...[
                                        if (bindedAccounts.isNotEmpty) const SizedBox(width: 16),
                                        SizedBox(
                                          width: itemWidth,
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: () => _handleAddProfile(context, isDark),
                                                borderRadius: BorderRadius.circular(18),
                                                child: CustomPaint(
                                                  painter: _DashedBorderPainter(color: accentColor),
                                                  child: Container(
                                                    width: iconSize,
                                                    height: iconSize,
                                                    alignment: Alignment.center,
                                                    child: Icon(Icons.add, color: accentColor, size: iconSize * 0.5),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              Text(
                                                t.add_profile,
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
                                    ],
                                  );
                                },
                              ),
        
                              const SizedBox(height: 80),
                              
                              // Switch Email
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: OutlinedButton.icon(
                                  onPressed: () => _handleSwitchMasterAccount(context),
                                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                                  label: Text(
                                    t.switch_email,
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

    for (ui.PathMetric measurePath in path.computeMetrics()) {
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

class NotificationDot extends StatelessWidget {
  final UserAccount account;
  final List<UserAccount> allAccounts;
  final double iconSize;

  const NotificationDot({
    super.key,
    required this.account,
    required this.allAccounts,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(account.amomimusId)
          .collection('notifications')
          .where('isRead', isEqualTo: false)
          .limit(10)
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        final siblingIds = allAccounts.map((a) => a.amomimusId).toSet();
        bool hasValidNotif = false;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data != null) {
            final senderId = data['senderUserId'] as String?;
            if (senderId == null || !siblingIds.contains(senderId)) {
              hasValidNotif = true;
              break;
            }
          }
        }

        if (!hasValidNotif) return const SizedBox.shrink();

        final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
        final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
        final dotColor = GenderHelpers.getGenderColor(account.gender);

        return Container(
          width: iconSize * 0.3,
          height: iconSize * 0.3,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: bgColor,
              width: 2.5,
            ),
          ),
        );
      },
    );
  }
}
