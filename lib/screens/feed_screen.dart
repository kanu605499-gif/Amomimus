import 'package:amomimus/i18n/strings.g.dart';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:amomimus/screens/chatroomhome.dart';
import 'package:amomimus/screens/fake_pdf_screen.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/widgets/feed/left_drawer_menu.dart';
import 'package:amomimus/widgets/feed/create_post_bottom_sheet.dart';
import 'package:amomimus/widgets/feed/feed_post_card.dart';
import 'package:amomimus/widgets/chat/amomimus_wave_clipper.dart';

import '../amomimusdark.dart';
import '../services/chatmodel.dart';
import '../services/account_manager.dart';
import '../services/feed_manager.dart';
import '../services/notification_manager.dart';
import '../models/notification_model.dart';
import 'forum_page.dart';
import 'roomchat.dart';
import 'profile_screen.dart';

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

  Future<void> _handleCreatePost(BuildContext context, bool isDark, UserAccount currentUser) async {
    if (currentUser.indicator == 'noise') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akun Anda berada di zona NOISE. Anda tidak dapat membuat postingan baru.')),
      );
      return;
    }

    // Check 10 posts per day limit
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day).toIso8601String();
    
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('feeds')
          .where('realAuthorId', isEqualTo: currentUser.amomimusId)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .get();
          
      if (snapshot.docs.length >= 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anda telah mencapai batas maksimal 10 postingan per hari.')),
        );
        return;
      }
    } catch (e) {
      print('Error checking post limit: $e');
    }

    if (context.mounted) {
      showCreatePostBottomSheet(context, isDark, currentUser);
    }
  }

  void _showNotificationsSheet(BuildContext context, bool isDark) {
    final t = Translations.of(context);
    final currentUser = Provider.of<AccountManager>(
      context,
      listen: false,
    ).currentUser;
    if (currentUser == null) return;

    final notifManager = Provider.of<NotificationManager>(
      context,
      listen: false,
    );
    final notifications = notifManager.getNotificationsForUser(
      currentUser.amomimusId,
    );

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
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).padding.bottom,
          ),
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
                t.notifications,
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
                          t.no_notifications,
                          style: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
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
                              translatedMessage = t.notif_resonate;
                              break;
                            case NotificationType.comment:
                              iconData = Icons.chat_bubble;
                              iconColor = AmomimusDarkTheme.primaryPurple;
                              translatedMessage = t.notif_comment;
                              break;
                            case NotificationType.reply:
                              iconData = Icons.reply;
                              iconColor = isDark
                                  ? Colors.yellow
                                  : Colors.amber.shade800;
                              translatedMessage = t.notif_reply;
                              break;
                            case NotificationType.chat:
                              iconData = Icons.chat;
                              iconColor = Colors.blue;
                              translatedMessage = t.notif_chat;
                              break;
                            case NotificationType.chatRequest:
                              iconData = Icons.mark_chat_unread;
                              iconColor = Colors.lightBlue;
                              translatedMessage = t.notif_chat_request;
                              break;
                            case NotificationType.blocked:
                              iconData = Icons.block;
                              iconColor = Colors.redAccent;
                              translatedMessage = t.notif_blocked;
                              break;
                            case NotificationType.unblocked:
                              iconData = Icons.check_circle_outline;
                              iconColor = Colors.green;
                              translatedMessage = t.notif_unblocked;
                              break;
                            case NotificationType.bioExpiry:
                              iconData = Icons.timer;
                              iconColor = Colors.orange;
                              translatedMessage = t.notif_bio_expiry;
                              break;
                          }
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 8.0,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withValues(alpha: 0.2),
                              child: Icon(iconData, color: iconColor, size: 20),
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                children: notif.type == NotificationType.bioExpiry
                                    ? [
                                        TextSpan(
                                          text: translatedMessage,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ]
                                    : [
                                        TextSpan(
                                          text: "${notif.actorName} ",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: translatedMessage),
                                      ],
                              ),
                            ),
                            subtitle: Text(
                              t.just_now, // Ideally parse ISO string to time ago
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontSize: 12,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              if (notif.type == NotificationType.chat) {
                                // For chat notifications, navigate to chat
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AmomimusApp6(), // Since we don't have the explicit constructor parameters handled here, might need to pass username
                                  ),
                                );
                              } else if (notif.feedId.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForumPage(feedId: notif.feedId),
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
    final blockedBy = currentUser?.blockedBy ?? [];
    final hiddenFeeds = currentUser?.hiddenFeeds ?? [];
    final feedData = feedManager.feeds.where((feed) {
      if (hiddenFeeds.contains(feed.id)) return false;
      if (feed.realAuthorId != null &&
          (blockedUsers.contains(feed.realAuthorId) ||
              blockedBy.contains(feed.realAuthorId)))
        return false;
      if (blockedUsers.contains(feed.id) || blockedBy.contains(feed.id))
        return false;
      if (blockedUsers.contains(feed.userName) ||
          blockedBy.contains(feed.userName))
        return false;
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
            now.difference(currentBackPressTime!) >
                const Duration(seconds: 2)) {
          currentBackPressTime = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(Translations.of(context).press_back_again),
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
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    CupertinoSliverRefreshControl(
                      refreshTriggerPullDistance: 115 + 80,
                      refreshIndicatorExtent: 115 + 65,
                      onRefresh: () async {
                        await Future.delayed(const Duration(milliseconds: 800));
                        await feedManager.loadFeeds();
                      },
                      builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
                        return Container(
                          alignment: Alignment.bottomCenter,
                          child: Transform.translate(
                            offset: const Offset(0, 28),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  Translations.of(context).reloading_whispers,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SliverPadding(padding: EdgeInsets.only(top: 95)),
                    SliverPadding(
                      padding: const EdgeInsets.only(bottom: 120),
                      sliver: feedData.isEmpty
                          ? SliverFillRemaining(
                              child: Center(child: Text(Translations.of(context).no_feeds)),
                            )
                          : SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => FeedCard(model: feedData[index], feedIndex: index),
                                childCount: feedData.length,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 90,
                      padding: const EdgeInsets.only(
                        top: 30,
                        right: 16,
                        left: 16,
                      ),
                      color: currentScaffoldBg.withValues(alpha: 0.6),
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
                              final currentUser = Provider.of<AccountManager>(
                                context,
                              ).currentUser;
                              final notifManager =
                                  Provider.of<NotificationManager>(context);
                              final unreadCount = currentUser != null
                                  ? notifManager.getUnreadCountForUser(
                                      currentUser.amomimusId,
                                    )
                                  : 0;

                              return Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: isDark
                                          ? AmomimusDarkTheme.policeLineYellow
                                          : AmomimusDarkTheme.primaryPurple,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => const FakePdfScreen(),
                                          transitionDuration: Duration.zero,
                                          reverseTransitionDuration:
                                              Duration.zero,
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
                                          color: isDark
                                              ? AmomimusDarkTheme
                                                    .policeLineYellow
                                              : AmomimusDarkTheme.primaryPurple,
                                        ),
                                        onPressed: () =>
                                            _showNotificationsSheet(
                                              context,
                                              isDark,
                                            ),
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
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AmomimusDarkTheme.surfaceDark.withValues(
                                alpha: 0.6,
                              )
                            : Colors.white.withValues(alpha: 0.6),
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
                                final accountManager = context.watch<AccountManager>();
                                final blockedUsers = accountManager.currentUser?.blockedUsers ?? [];
                                final blockedByUsers = accountManager.currentUser?.blockedBy ?? [];
                                return Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      Icons.messenger_outline,
                                      color: isDark
                                          ? AmomimusDarkTheme.policeLineYellow
                                          : AmomimusDarkTheme.primaryPurple,
                                    ),
                                    if (chatModel.hasUnreadMessages(blockedUsers, blockedByUsers))
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
                                              color: isDark
                                                  ? AmomimusDarkTheme
                                                        .surfaceDark
                                                  : Colors.white,
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
                        final currentUser = context
                            .read<AccountManager>()
                            .currentUser;
                        if (currentUser != null) {
                          _handleCreatePost(
                            context,
                            isDark,
                            currentUser,
                          );
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
                            final currentUser = context
                                .read<AccountManager>()
                                .currentUser;
                            if (currentUser != null) {
                              _handleCreatePost(
                                context,
                                isDark,
                                currentUser,
                              );
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
              return LeftDrawerMenu(currentUser: currentUser, isDark: isDark);
            },
          ),
        ),
      ),
    );
  }
}
