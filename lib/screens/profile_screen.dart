import 'package:amomimus/i18n/strings.g.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/account_manager.dart';
import '../amomimusdark.dart';
import '../models/post_model.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../helpers/gender_helpers.dart';
import '../widgets/report_dialog.dart';
import '../models/user_model.dart';
import '../widgets/profile/profile_header_info.dart';
import '../widgets/profile/locked_profile_view.dart';
import '../widgets/profile/profile_bio_section.dart';
import '../widgets/profile/profile_vault_section.dart';
import '../widgets/profile/profile_recent_resonates.dart';
import '../widgets/profile/profile_indicator_card.dart';
import 'fake_pdf_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? targetUserId;
  final FeedModel? feedModel;

  const ProfileScreen({super.key, this.targetUserId, this.feedModel});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _bubbleController;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fabAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _bubbleController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final accountManager = Provider.of<AccountManager>(context);
    final reqManager = Provider.of<ChatRequestManager>(context);
    final chatModel = Provider.of<ChatModel>(context);

    dynamic user = accountManager.currentUser;
    bool isOtherUser = false;
    bool isLocked = false;

    if (widget.targetUserId != null &&
        widget.targetUserId != accountManager.currentUser?.amomimusId) {
      isOtherUser = true;

      // Check if locked
      if (!reqManager.isChatAllowed(widget.targetUserId!) &&
          chatModel.getChatByUsername(widget.targetUserId!).messages.isEmpty) {
        isLocked = true;
      }

      String normalizedTargetId = widget.targetUserId!;
      final match = RegExp(r'#(?:YOU|AMO|AMI|AMOM)-(\d+)').firstMatch(widget.targetUserId!);
      if (match != null) {
        int num = int.parse(match.group(1)!);
        if (num == 100) num = 110;
        normalizedTargetId = '#AMM-$num';
      } else {
        normalizedTargetId = widget.targetUserId!.replaceAll(RegExp(r'#AM[OMI]+-'), '#AMM-');
      }

      try {
        user = accountManager.accounts.firstWhere(
          (acc) => acc.amomimusId == widget.targetUserId || acc.amomimusId == normalizedTargetId,
        );
      } catch (e) {
        if (widget.feedModel != null) {
          String gender = "Amo";
          if (widget.feedModel!.type == AccountType.ami) gender = "Ami";
          if (widget.feedModel!.type == AccountType.amom) gender = "Amom";
          user = UserAccount.empty().copyWith(amomimusId: widget.targetUserId, gender: gender);
        } else {
          // Fallback to current user if not found
          user = accountManager.currentUser;
          isOtherUser = false;
        }
      }
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(t.profile)),
        body: Center(child: Text(t.no_active_user)),
      );
    }



    return Scaffold(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          t.profile,
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontWeight: FontWeight.bold,
            color: isDark
                ? AmomimusDarkTheme.policeLineYellow
                : AmomimusDarkTheme.primaryPurple,
          ),
        ),
        backgroundColor: isDark
            ? AmomimusDarkTheme.backgroundDark
            : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
            ),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const FakePdfScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          if (!isOtherUser)
            IconButton(
              icon: Icon(
                Icons.settings,
                color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          if (isOtherUser)
            IconButton(
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => ReportDialog(
                    targetId: user.amomimusId,
                    isUserReport: true,
                  ),
                );
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ProfileHeaderInfo(
              user: user,
              isDark: isDark,
              isOtherUser: isOtherUser,
              isLocked: isLocked,
            ),
            const SizedBox(height: 30),
            if (isLocked) ...[
              ProfileIndicatorCard(user: user, isDark: isDark),
              const SizedBox(height: 30),
              LockedProfileView(isDark: isDark),
            ] else ...[
              ProfileBioSection(
                user: user,
                isDark: isDark,
                isOtherUser: isOtherUser,
              ),
              const SizedBox(height: 30),
              if (!isOtherUser) ...[
                ProfileVaultSection(user: user, isDark: isDark),
                const SizedBox(height: 30),
              ],
              ProfileIndicatorCard(user: user, isDark: isDark),
              const SizedBox(height: 30),
              ProfileRecentResonates(
                user: user,
                isDark: isDark,
                isOtherUser: isOtherUser,
              ),
            ],
            const SizedBox(height: 100), // padding for FAB
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 24.0,
        ), // Adjust position to match feeds bottom:40
        child: AnimatedBuilder(
          animation: _fabAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, -_fabAnimation.value),
            child: child,
          ),
          child: SizedBox(
            width: 63,
            height: 63,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: isDark
                  ? AmomimusDarkTheme.policeLineYellow
                  : AmomimusDarkTheme.primaryPurple,
              shape: const CircleBorder(),
              elevation: 6,
              child: Icon(
                GenderHelpers.getGenderIcon(user.gender),
                color: isDark ? Colors.black : Colors.white,
                size: 39,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
