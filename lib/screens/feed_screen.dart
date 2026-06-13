import 'dart:math';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:amomimus/screens/chatroomhome.dart';
import 'package:amomimus/screens/fake_pdf_screen.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/widgets/feed/left_drawer_menu.dart';
import 'package:amomimus/widgets/feed/create_post_bottom_sheet.dart';
import 'package:amomimus/widgets/feed/feed_post_card.dart';

import '../amomimusdark.dart';
import '../services/chatmodel.dart';
import '../services/account_manager.dart';
import '../services/feed_manager.dart';
import '../services/notification_manager.dart';
import '../models/notification_model.dart';
import 'forum_page.dart';
import 'profile_screen.dart';
import '../language/language_manager.dart';

class AmomimusApp5 extends StatefulWidget {
  const AmomimusApp5({super.key});

  @override
  State<AmomimusApp5> createState() => _AmomimusApp5State();
}

class _AmomimusApp5State extends State<AmomimusApp5>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _waveController;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _showNotificationsSheet(BuildContext context, bool isDark) {
    final currentUser = Provider.of<AccountManager>(context, listen: false).currentUser;
    if (currentUser == null) return;
    
    final notifManager = Provider.of<NotificationManager>(context, listen: false);
    final notifications = notifManager.getNotificationsForUser(currentUser.amomimusId);

    // Mark as read when opened
    notifManager.markAllAsReadForUser(currentUser.amomimusId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.watch<LanguageManager>().getString('notifications'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AmomimusDarkTheme.textPrimary : Colors.black,
                ),
              ),
              const Divider(),
              Expanded(
                child: notifications.isEmpty
                    ? Center(
                        child: Text(
                          context.watch<LanguageManager>().getString('no_notifications'),
                          style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                        ),
                      )
                    : ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          IconData iconData;
                          Color iconColor = Colors.transparent;
                          String translatedMessage = "";
                          switch (notif.type) {
                            case NotificationType.resonate:
                              iconData = Icons.favorite;
                              iconColor = Colors.red;
                              translatedMessage = context.read<LanguageManager>().getString('notif_resonate');
                              break;
                            case NotificationType.comment:
                              iconData = Icons.chat_bubble;
                              iconColor = AmomimusDarkTheme.primaryPurple;
                              translatedMessage = context.read<LanguageManager>().getString('notif_comment');
                              break;
                            case NotificationType.reply:
                              iconData = Icons.reply;
                              iconColor = isDark ? Colors.yellow : Colors.amber.shade800;
                              translatedMessage = context.read<LanguageManager>().getString('notif_reply');
                              break;
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withValues(alpha: 0.2),
                              child: Icon(iconData, color: iconColor, size: 20),
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                                children: [
                                  TextSpan(text: "${notif.actorName} ", style: const TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text: translatedMessage),
                                ],
                              ),
                            ),
                            subtitle: Text(
                              context.read<LanguageManager>().getString('just_now'), // Ideally parse ISO string to time ago
                              style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 12),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              if (notif.feedId.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForumPage(feedId: notif.feedId),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final feedManager = Provider.of<FeedManager>(context);
    final currentUser = Provider.of<AccountManager>(context).currentUser;
    final isDark = amomimusTheme.isDarkMode;

    final blockedUsers = currentUser?.blockedUsers ?? [];
    final hiddenFeeds = currentUser?.hiddenFeeds ?? [];
    final feedData = feedManager.feeds.where((feed) {
      if (hiddenFeeds.contains(feed.id)) return false;
      if (feed.realAuthorId != null && blockedUsers.contains(feed.realAuthorId)) return false;
      if (blockedUsers.contains(feed.id)) return false;
      if (blockedUsers.contains(feed.userName)) return false;
      return true;
    }).toList();

    final currentScaffoldBg = isDark
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        
        DateTime now = DateTime.now();
        if (currentBackPressTime == null || 
            now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.read<LanguageManager>().getString('press_back_again')),
              duration: const Duration(seconds: 2),
            ),
          );
        } else {
          // Exit the app
          SystemNavigator.pop();
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          systemNavigationBarColor: isDark
              ? AmomimusDarkTheme.surfaceDark
              : Colors.white,
          systemNavigationBarIconBrightness: isDark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: currentScaffoldBg,
          body: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 80,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    return SizedBox(
                      height: 110,
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: 0.3,
                            child: ClipPath(
                              clipper: AmomimusWaveClipper(
                                _waveController.value,
                                0.0,
                              ),
                              child: Container(
                                color: isDark
                                    ? const Color.fromARGB(255, 255, 187, 0)
                                    : AmomimusDarkTheme.primaryPurple,
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: 0.8,
                            child: ClipPath(
                              clipper: AmomimusWaveClipper(
                                _waveController.value,
                                0.6,
                              ),
                              child: Container(
                                color: isDark
                                    ? AmomimusDarkTheme.policeLineYellow
                                    : AmomimusDarkTheme.primaryPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: feedData.isEmpty
                    ? Center(child: Text(context.watch<LanguageManager>().getString('no_feeds')))
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 95, bottom: 120),
                        itemCount: feedData.length,
                        itemBuilder: (context, index) => FeedCard(
                          model: feedData[index],
                          feedIndex: index,
                        ),
                      ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 30, right: 16, left: 16),
                  color: currentScaffoldBg.withValues(alpha: 0.9),
                  child: Row(
                    children: [
                      Builder(
                        builder: (scaffoldContext) {
                          return IconButton(
                            icon: Icon(
                              Icons.menu,
                              color: isDark
                                  ? AmomimusDarkTheme.textPrimary
                                  : Colors.black,
                            ),
                            onPressed: () =>
                                Scaffold.of(scaffoldContext).openDrawer(),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          amomimusTheme.toggleTheme();
                        },
                        child: const Text(
                          "Amomimus",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AmomimusDarkTheme.primaryPurple,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Builder(
                        builder: (context) {
                          final currentUser = Provider.of<AccountManager>(context).currentUser;
                          final notifManager = Provider.of<NotificationManager>(context);
                          final unreadCount = currentUser != null 
                              ? notifManager.getUnreadCountForUser(currentUser.amomimusId) 
                              : 0;

                          return Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.menu_book,
                                  color: isDark ? AmomimusDarkTheme.textSecondary : Colors.black54,
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
                              Stack(
                                clipBehavior: Clip.none,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.notifications_none,
                                  color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                                ),
                                onPressed: () => _showNotificationsSheet(context, isDark),
                              ),
                              if (unreadCount > 0)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Builder(
                          builder: (context) {
                            final chatModel = context.watch<ChatModel>();
                            return Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Icon(
                                  Icons.messenger_outline,
                                  color: isDark
                                      ? AmomimusDarkTheme.policeLineYellow
                                      : AmomimusDarkTheme.primaryPurple,
                                ),
                                if (chatModel.hasUnreadMessages)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AmomimusApp7(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 60),
                      IconButton(
                        icon: Icon(
                          Icons.person_outline,
                          color: isDark
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < -7) {
                        final currentUser = context.read<AccountManager>().currentUser;
                        if (currentUser != null) {
                          showCreatePostBottomSheet(context, isDark, currentUser);
                        }
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) => Transform.translate(
                        offset: Offset(0, -_animation.value),
                        child: child,
                      ),
                      child: SizedBox(
                        width: 63,
                        height: 63,
                        child: FloatingActionButton(
                          onPressed: () {
                            final currentUser = context.read<AccountManager>().currentUser;
                            if (currentUser != null) {
                              showCreatePostBottomSheet(context, isDark, currentUser);
                            }
                          },
                          backgroundColor: isDark
                              ? const Color(0xFF8C72C4)
                              : AmomimusDarkTheme.policeLineYellow,
                          shape: const CircleBorder(),
                          elevation: 6,
                          child: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: isDark
                                ? AmomimusDarkTheme.policeLineYellow
                                : AmomimusDarkTheme.primaryPurple,
                            size: 49,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          drawer: Builder(
            builder: (context) {
              final lang = context.watch<LanguageManager>();
              return LeftDrawerMenu(
                currentUser: currentUser,
                isDark: isDark,
                lang: lang,
              );
            }
          ),
        ),
      ),
    );
  }
}

class AmomimusWaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double offset;

  AmomimusWaveClipper(this.animationValue, this.offset);

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    for (double i = size.width; i >= 0; i--) {
      double angle =
          (animationValue * 2 * pi) + (i / size.width * 2 * pi) + (offset * pi);
      double y = sin(angle) * 12 + 35;
      path.lineTo(i, y);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
