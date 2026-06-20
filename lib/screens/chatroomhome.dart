import 'package:amomimus/i18n/strings.g.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/account_manager.dart';
import '../amomimusdark.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../helpers/gender_helpers.dart';
import 'fake_pdf_screen.dart';
import '../widgets/chat/chat_home_requests_sheet.dart';
import '../widgets/chat/chat_home_mini_island.dart';
import '../widgets/chat/chat_home_list_section.dart';

class AmomimusApp7 extends StatefulWidget {
  const AmomimusApp7({super.key});

  @override
  State<AmomimusApp7> createState() => _AmomimusApp7State();
}

class _AmomimusApp7State extends State<AmomimusApp7>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 0.0;
  bool _isIslandExpanded = false;

  late AnimationController _particleController;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      try {
        double pixels = _scrollController.position.pixels;
        double linearOpacity = ((pixels - 40) / 60).clamp(0.0, 1.0).toDouble();

        setState(() {
          _headerOpacity = Curves.easeInOut.transform(linearOpacity);
          if (pixels > 15 && _isIslandExpanded) {
            _isIslandExpanded = false;
          }
        });
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final chatModel = context.watch<ChatModel>();
    final accountManager = context.watch<AccountManager>();
    final blockedUsers = accountManager.currentUser?.blockedUsers ?? [];
    final blockedBy = accountManager.currentUser?.blockedBy ?? [];

    final myAmomimusId = accountManager.currentUser?.amomimusId ?? '';

    final rawChatList = chatModel.chatList;
    final chatList = rawChatList
        .where(
          (c) =>
              !blockedUsers.contains(c.username) &&
              (!blockedBy.contains(c.username) || !c.hasSeenResetAnimation),
        )
        .toList();

    // Filter chat list so the unblocked user (Ex-Blocked) doesn't see the empty room trigger.
    // They will only see the room once the unblocker sends a real message (for replying).
    final filteredChatList = chatList.where((chat) {
      if (myAmomimusId.isEmpty) return true;
      if (accountManager.isRecentlyUnblockedByTarget(myAmomimusId, chat.username)) {
        return chat.messages.isNotEmpty;
      }
      return true;
    }).toList();
    final currentBg = themeProvider.isDarkMode
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;
    final currentSurface = themeProvider.isDarkMode
        ? AmomimusDarkTheme.surfaceDark
        : Colors.grey[200]!;
    final dynamicAccentColor = themeProvider.isDarkMode
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeProvider.isDarkMode
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: currentSurface,
      ),
      child: Scaffold(
        backgroundColor: currentBg,
        body: Stack(
          children: [
            // --- Background Partikel Melayang ---
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _particleController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ParticleBackgroundPainter(
                      progress: _particleController.value,
                      color: dynamicAccentColor.withValues(alpha: 0.12),
                    ),
                  );
                },
              ),
            ),

            // --- Konten Utama ---
            Positioned.fill(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: statusBarHeight + 40,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      t.amomus_list,
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: themeProvider.isDarkMode
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
                                    IconButton(
                                      icon: Icon(
                                        Icons.switch_account_outlined,
                                        color: dynamicAccentColor,
                                      ),
                                      onPressed: () {
                                        final accountManager = context
                                            .read<AccountManager>();
                                        final accounts = accountManager.accounts
                                            .where((acc) => !acc.isDemo)
                                            .toList();
                                        
                                        accounts.sort((a, b) {
                                          if (a.id == accountManager.currentUser?.id) return -1;
                                          if (b.id == accountManager.currentUser?.id) return 1;
                                          return 0;
                                        });

                                        final isDark = themeProvider.isDarkMode;

                                        showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (ctx) {
                                            final sheetBg = isDark
                                                ? AmomimusDarkTheme.surfaceDark
                                                : Colors.white;
                                            final textCol = isDark
                                                ? Colors.white
                                                : Colors.black87;
                                            final subCol = isDark
                                                ? AmomimusDarkTheme
                                                      .textSecondary
                                                : Colors.black54;

                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 16,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: sheetBg,
                                                borderRadius:
                                                    const BorderRadius.vertical(
                                                      top: Radius.circular(24),
                                                    ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 40,
                                                    height: 5,
                                                    decoration: BoxDecoration(
                                                      color: isDark
                                                          ? Colors.white24
                                                          : Colors.black12,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            2.5,
                                                          ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Text(
                                                    t.switch_account,
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: textCol,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  if (accounts.isEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            20,
                                                          ),
                                                      child: Text(
                                                        t.no_accounts_registered,
                                                        style: TextStyle(
                                                          color: subCol,
                                                        ),
                                                      ),
                                                    )
                                                  else
                                                    ConstrainedBox(
                                                      constraints:
                                                          const BoxConstraints(
                                                            maxHeight: 225,
                                                          ),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: accounts.map((
                                                            acc,
                                                          ) {
                                                            final isActive =
                                                                acc.id ==
                                                                accountManager
                                                                    .currentUser
                                                                    ?.id;
                                                            final genderColor =
                                                                GenderHelpers.getGenderColor(
                                                                  acc.gender,
                                                                );
                                                            final genderIcon =
                                                                GenderHelpers.getGenderIcon(
                                                                  acc.gender,
                                                                );

                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical: 4,
                                                                  ),
                                                              child: InkWell(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16,
                                                                    ),
                                                                onTap: () {
                                                                  accountManager
                                                                      .switchAccount(
                                                                        acc,
                                                                      );
                                                                  // Sync ChatModel with the new account
                                                                  context
                                                                      .read<
                                                                        ChatModel
                                                                      >()
                                                                      .setCurrentUser(
                                                                        acc.amomimusId,
                                                                        acc.anonymousUsername,
                                                                      );
                                                                  Navigator.pop(
                                                                    ctx,
                                                                  );
                                                                },
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            14,
                                                                        vertical:
                                                                            12,
                                                                      ),
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                        isActive
                                                                        ? genderColor.withValues(
                                                                            alpha:
                                                                                0.12,
                                                                          )
                                                                        : Colors
                                                                              .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          16,
                                                                        ),
                                                                    border: Border.all(
                                                                      color:
                                                                          isActive
                                                                          ? genderColor.withValues(
                                                                              alpha: 0.8,
                                                                            )
                                                                          : (isDark
                                                                                ? Colors.white12
                                                                                : Colors.black12),
                                                                      width:
                                                                          isActive
                                                                          ? 1.5
                                                                          : 1,
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            40,
                                                                        height:
                                                                            40,
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            12,
                                                                          ),
                                                                          border: Border.all(
                                                                            color:
                                                                                genderColor,
                                                                            width:
                                                                                1.2,
                                                                          ),
                                                                        ),
                                                                        child: Icon(
                                                                          genderIcon,
                                                                          color:
                                                                              genderColor,
                                                                          size:
                                                                              22,
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              acc.anonymousUsername,
                                                                              style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: textCol,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              '${acc.amomimusId} · ${acc.gender}',
                                                                              style: TextStyle(
                                                                                fontSize: 11,
                                                                                color: genderColor,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      if (isActive)
                                                                        Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          color:
                                                                              genderColor,
                                                                          size:
                                                                              20,
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }).toList(),
                                                        ),
                                                      ),
                                                    ),
                                                  const SizedBox(height: 8),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // List Orang Menggunakan Kustom ListTile dengan Border Melengkung
                  Consumer<ChatRequestManager>(
                    builder: (context, reqManager, child) {
                      final requests = reqManager.incomingRequests;
                      if (requests.isEmpty) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }

                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          child: InkWell(
                            onTap: () => showRequestsBottomSheet(
                              context,
                              reqManager,
                              themeProvider,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 65,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode
                                    ? AmomimusDarkTheme.surfaceDark
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: dynamicAccentColor.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  AnimatedBuilder(
                                    animation: _pulseController,
                                    builder: (context, child) {
                                      // Vibrate animation: rapid slight rotation
                                      final double angle =
                                          sin(
                                            _pulseController.value *
                                                3.14159 *
                                                20,
                                          ) *
                                          0.15;
                                      return Transform.rotate(
                                        angle: angle,
                                        child: child,
                                      );
                                    },
                                    child: Icon(
                                      Icons.mark_email_unread_rounded,
                                      color: dynamicAccentColor,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${t.chat_requests} (${requests.length})',
                                      style: TextStyle(
                                        color: themeProvider.isDarkMode
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: dynamicAccentColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chevron_right,
                                      color: themeProvider.isDarkMode
                                          ? Colors.black
                                          : Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final chat = filteredChatList[index];
                        return ChatListTileWidget(chat: chat);
                      }, childCount: filteredChatList.length),
                    ),
                  ),
                ],
              ),
            ),

            // Mini Floating Island di Atas pas di-scroll kebawah
            if (_headerOpacity > 0.0)
              Positioned(
                top: statusBarHeight + 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: _headerOpacity,
                    child: ChatHomeMiniIsland(
                      isExpanded: _isIslandExpanded,
                      onToggle: () {
                        setState(() {
                          _isIslandExpanded = !_isIslandExpanded;
                        });
                      },
                      themeProvider: themeProvider,
                      currentSurface: currentSurface,
                      dynamicAccentColor: dynamicAccentColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// --- Sistem Engine Partikel Melayang (Dari Bawah) ---
class ParticleBackgroundPainter extends CustomPainter {
  final double progress;
  final Color color;
  late List<StaticParticle> particles;

  ParticleBackgroundPainter({required this.progress, required this.color}) {
    Random seedRand = Random(
      2026,
    ); // Mengunci seed supaya titik tidak lompat acak
    particles = List.generate(30, (index) {
      return StaticParticle(
        xPercent: seedRand.nextDouble(),
        yBasePercent: seedRand.nextDouble(),
        size: seedRand.nextDouble() * 3.5 + 1.5,
        speedFactor: seedRand.nextDouble() * 0.4 + 0.6,
        opacityFactor: seedRand.nextDouble() * 0.7 + 0.3,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      // Menggerakkan partikel ke atas secara mulus (mengurangi progress)
      double yFraction =
          (particle.yBasePercent - (progress * particle.speedFactor)) % 1.0;

      double x = particle.xPercent * size.width;
      double y = yFraction * size.height;

      paint.color = color.withValues(alpha: color.a * particle.opacityFactor);
      canvas.drawCircle(Offset(x, y), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticleBackgroundPainter oldDelegate) => true;
}

class StaticParticle {
  final double xPercent;
  final double yBasePercent;
  final double size;
  final double speedFactor;
  final double opacityFactor;

  StaticParticle({
    required this.xPercent,
    required this.yBasePercent,
    required this.size,
    required this.speedFactor,
    required this.opacityFactor,
  });
}
