import 'package:amomimus/i18n/strings.g.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../services/account_manager.dart';
import '../amomimusdark.dart';
import '../services/chatmodel.dart';
import 'fake_pdf_screen.dart';
import '../widgets/chat/chat_home_mini_island.dart';
import '../widgets/chat/chat_home_list_section.dart';
import '../widgets/chat/chat_home_account_switch_sheet.dart';
import '../widgets/chat/chat_home_requests_card.dart';
import '../widgets/effects/seamless_particle_background.dart';

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
      duration: const Duration(seconds: 48),
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
      if (accountManager.isRecentlyUnblockedByTarget(
        myAmomimusId,
        chat.username,
      )) {
        return chat.messages.isNotEmpty;
      }
      return true;
    }).toList();

    // Pin Local Sub-Profiles to the top
    final localSubProfiles = accountManager.accounts.where((acc) {
      return accountManager.currentUser != null &&
          acc.masterEmail == accountManager.currentUser!.masterEmail &&
          acc.amomimusId != myAmomimusId;
    }).toList();

    // Sort local profiles by recent interaction (their existing index in filteredChatList)
    localSubProfiles.sort((a, b) {
      int indexA = filteredChatList.indexWhere((c) => c.username == a.amomimusId);
      int indexB = filteredChatList.indexWhere((c) => c.username == b.amomimusId);
      int weightA = indexA == -1 ? 999999 : indexA;
      int weightB = indexB == -1 ? 999999 : indexB;
      return weightA.compareTo(weightB);
    });

    List<ChatPreview> finalChatList = List.from(filteredChatList);
    // Reverse the list so the first sub-profile ends up at the absolute top when inserted at 0
    for (var localProfile in localSubProfiles.reversed) {
      int existingIndex = finalChatList.indexWhere((c) => c.username == localProfile.amomimusId);
      ChatPreview preview;
      if (existingIndex != -1) {
        preview = finalChatList.removeAt(existingIndex);
      } else {
        preview = ChatPreview(
          name: localProfile.customUsername ?? localProfile.anonymousUsername,
          username: localProfile.amomimusId,
          initialLastMessage: "",
          initialTime: "",
        );
      }
      finalChatList.insert(0, preview);
    }
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
                                    if (context
                                            .watch<AccountManager>()
                                            .switchableAccounts
                                            .length >
                                        1)
                                      IconButton(
                                        icon: Icon(
                                          Icons.switch_account_outlined,
                                          color: dynamicAccentColor,
                                        ),
                                        onPressed: () {
                                          showAccountSwitchSheet(context);
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
                  ChatHomeRequestsCard(
                    pulseController: _pulseController,
                    themeProvider: themeProvider,
                    dynamicAccentColor: dynamicAccentColor,
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final chat = finalChatList[index];
                        return ChatListTileWidget(chat: chat);
                      }, childCount: finalChatList.length),
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
