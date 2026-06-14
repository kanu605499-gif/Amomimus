import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../amomimusdark.dart';
import '../helpers/gender_helpers.dart';
import '../models/message_model.dart';
import '../models/user_model.dart';
import '../services/account_manager.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../widgets/report_dialog.dart';

import 'profile_screen.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_bar.dart';
import 'fake_pdf_screen.dart';
import '../widgets/chat/room_chat_large_profile.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AmomimusDarkTheme()),
        ChangeNotifierProvider(create: (context) => ChatModel()),
      ],
      child: const MaterialApp(
        home: AmomimusApp6(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class AmomimusApp6 extends StatefulWidget {
  final String? username;
  final String? name;
  const AmomimusApp6({super.key, this.username, this.name});

  @override
  State<AmomimusApp6> createState() => _AmomimusApp6State();
}

class _AmomimusApp6State extends State<AmomimusApp6>
    with SingleTickerProviderStateMixin {
  final AutoScrollController _scrollController = AutoScrollController();

  ChatMessage? _replyingToMessage;

  double _headerProgress = 0.0;
  bool _isIslandExpanded = false;
  bool _isProfileMenuExpanded = false;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      try {
        double pixels = _scrollController.position.pixels;
        double linearProgress = (pixels / 80).clamp(0.0, 1.0).toDouble();

        setState(() {
          _headerProgress = Curves.easeInOut.transform(linearProgress);
          if (pixels > 15 && _isIslandExpanded) {
            _isIslandExpanded = false;
          }
        });
      } catch (_) {
        setState(() {
          _headerProgress = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _sendMessage(String text) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      text,
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendSticker(String assetPath) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      '[STICKER]:$assetPath',
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showMemoriesPopup(
    BuildContext context,
    String targetUsername,
    Color themeColor,
  ) {
    final themeProvider = context.read<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentBg = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: themeColor.withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.cloud, color: themeColor),
                        const SizedBox(width: 8),
                        Text(
                          Translations.of(context).memories,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: textSecondary),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Consumer<ChatModel>(
                  builder: (ctx, chatModel, child) {
                    final pinnedMessages = chatModel.getPinnedMessages(
                      targetUsername,
                    );

                    if (pinnedMessages.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            Translations.of(context).no_memories_pinned,
                            style: TextStyle(
                              color: textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: pinnedMessages.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final msg = pinnedMessages[index];

                          String detailedTime = msg.timeStamp;
                          if (msg.createdAt != null) {
                            try {
                              final dt = DateTime.parse(msg.createdAt!);
                              final hourVal = dt.hour % 12 == 0
                                  ? 12
                                  : dt.hour % 12;
                              final period = dt.hour >= 12 ? 'PM' : 'AM';
                              detailedTime =
                                  "$hourVal:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')} $period";
                            } catch (_) {}
                          }

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: themeColor.withValues(alpha: 0.3),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.02)
                                      : Colors.black.withValues(alpha: 0.03),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      msg.senderName ?? 'User',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: themeColor,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          detailedTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: textSecondary,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                chatModel.unpinMessage(
                                                  targetUsername,
                                                  msg.id!,
                                                );
                                              },
                                              child: Icon(
                                                Icons.cloud,
                                                size: 14,
                                                color: themeColor.withValues(
                                                  alpha: 0.7,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    height: 1.4,
                                    fontFamily: 'serif',
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final chatModel = context.watch<ChatModel>();
    final activeChat = chatModel.getChatByUsername(
      widget.username ?? '@partner_dev',
      targetName: widget.name ?? 'Unknown',
    );
    final messages = activeChat.messages;

    final currentBg = themeProvider.isDarkMode
        ? AmomimusDarkTheme.backgroundDark
        : Colors.white;
    final currentSurface = themeProvider.isDarkMode
        ? AmomimusDarkTheme.surfaceDark
        : Colors.grey[200]!;
    final currentText = themeProvider.isDarkMode
        ? AmomimusDarkTheme.textPrimary
        : Colors.black87;
    final currentTextSecondary = themeProvider.isDarkMode
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // Get the target user's gender for dynamic styling
    final accountManager = context.watch<AccountManager>();
    final targetAccount = accountManager.accounts.firstWhere(
      (acc) => acc.amomimusId == widget.username,
      orElse: () => UserAccount(
        email: '',
        realUsername: '',
        anonymousUsername: '',
        amomimusId: '',
        gender: 'Amo',
        registrationDate: '',
        isDemo: false,
      ),
    );
    final targetGender = targetAccount.gender;
    final dynamicHeaderIcon = GenderHelpers.getGenderIcon(targetGender);
    final dynamicHeaderColor = GenderHelpers.getGenderColor(targetGender);

    Widget expandableMiniIsland() {
      final Color dynamicOutlineColor = themeProvider.isDarkMode
          ? Colors.white.withValues(alpha: 0.2)
          : Colors.black87.withValues(alpha: 0.15);

      final Color islandBg = themeProvider.isDarkMode
          ? Colors.black54
          : const Color.fromARGB(221, 255, 255, 255);

      return GestureDetector(
        onTap: () {
          setState(() {
            _isIslandExpanded = !_isIslandExpanded;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 46,
          width: _isIslandExpanded ? 180 : 46,
          decoration: BoxDecoration(
            color: islandBg,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: dynamicOutlineColor, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: themeProvider.isDarkMode ? 0.2 : 0.05,
                ),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _isIslandExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              layoutBuilder:
                  (topChild, topChildKey, bottomChild, bottomChildKey) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(key: bottomChildKey, child: bottomChild),
                        Positioned(key: topChildKey, child: topChild),
                      ],
                    );
                  },
              firstChild: SizedBox(
                height: 44,
                width: 44,
                child: Center(
                  child: Icon(
                    dynamicHeaderIcon,
                    color: dynamicHeaderColor,
                    size: 22,
                  ),
                ),
              ),
              secondChild: Container(
                width: 180,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              dynamicHeaderIcon,
                              color: dynamicHeaderColor,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 18,
                        width: 1,
                        color: dynamicOutlineColor,
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(
                          themeProvider.isDarkMode
                              ? Icons.wb_sunny_rounded
                              : Icons.nightlight_round,
                          size: 20,
                        ),
                        color: themeProvider.isDarkMode
                            ? AmomimusDarkTheme.policeLineYellow
                            : AmomimusDarkTheme.primaryPurple,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () =>
                            context.read<AmomimusDarkTheme>().toggleTheme(),
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(
                          Icons.report_problem_outlined,
                          size: 20,
                        ),
                        color: Colors.orangeAccent,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ReportDialog(
                              targetId: widget.username ?? '',
                              isUserReport: true,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        color: Colors.redAccent,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              final isDark = Provider.of<AmomimusDarkTheme>(
                                context,
                                listen: false,
                              ).isDarkMode;
                              return AlertDialog(
                                backgroundColor: isDark
                                    ? AmomimusDarkTheme.surfaceDark
                                    : Colors.white,
                                title: Text(
                                  Translations.of(context).delete_chat_title,
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                                content: Text(
                                  Translations.of(
                                    context,
                                  ).delete_chat_room_confirm,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(dialogContext),
                                    child: Text(
                                      Translations.of(context).cancel,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        dialogContext,
                                      ); // close dialog
                                      context.read<ChatModel>().deleteChat(
                                        widget.username ?? '',
                                      );
                                      context
                                          .read<ChatRequestManager>()
                                          .deleteRequestWith(
                                            widget.username ?? '',
                                          );
                                      Navigator.pop(context); // exit room
                                    },
                                    child: Text(
                                      Translations.of(context).delete,
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                      IconButton(
                        icon: Icon(Icons.search, size: 20),
                        color: themeProvider.isDarkMode
                            ? AmomimusDarkTheme.textSecondary
                            : Colors.black54,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const FakePdfScreen(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
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
        ),
      );
    }

    return Theme(
      data: AmomimusDarkTheme.themeData,
      child: Builder(
        builder: (context) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
              statusBarBrightness: themeProvider.isDarkMode
                  ? Brightness.dark
                  : Brightness.light,
              systemNavigationBarColor: currentSurface,
              systemNavigationBarIconBrightness: themeProvider.isDarkMode
                  ? Brightness.light
                  : Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: currentBg,
              body: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return SizedBox(
                          height: 140,
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.1,
                                child: ClipPath(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  clipper: AmomimusWaveClipper(
                                    _waveController.value,
                                    0.0,
                                  ),
                                  child: Container(
                                    color: themeProvider.isDarkMode
                                        ? const Color.fromARGB(255, 255, 187, 0)
                                        : AmomimusDarkTheme.primaryPurple,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: 0.25,
                                child: ClipPath(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  clipper: AmomimusWaveClipper(
                                    _waveController.value,
                                    0.6,
                                  ),
                                  child: Container(
                                    color: themeProvider.isDarkMode
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
                    child: Column(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: CustomScrollView(
                              controller: _scrollController,
                              slivers: [
                                SliverPadding(
                                  padding: EdgeInsets.only(
                                    left: 14,
                                    right: 14,
                                    bottom: 14,
                                    top: statusBarHeight + 20,
                                  ),
                                  sliver: SliverList(
                                    delegate: SliverChildBuilderDelegate((
                                      context,
                                      index,
                                    ) {
                                      if (index == 0) {
                                        return Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 30,
                                            top: 15,
                                          ),
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: RoomChatLargeProfile(
                                            themeProvider: themeProvider,
                                            isProfileMenuExpanded:
                                                _isProfileMenuExpanded,
                                            waveController: _waveController,
                                            targetUsername: widget.username,
                                            dynamicHeaderColor:
                                                dynamicHeaderColor,
                                            dynamicHeaderIcon:
                                                dynamicHeaderIcon,
                                            currentTextSecondary:
                                                currentTextSecondary,
                                            currentText: currentText,
                                            currentBg: currentBg,
                                            targetAccount: targetAccount,
                                            activeChat: activeChat,
                                            onToggleProfileMenu: () {
                                              setState(() {
                                                _isProfileMenuExpanded =
                                                    !_isProfileMenuExpanded;
                                              });
                                            },
                                            onShowMemoriesPopup:
                                                _showMemoriesPopup,
                                          ),
                                        );
                                      }
                                      final msg = messages[index - 1];
                                      final repliedMsg =
                                          msg.replyMessageId != null
                                          ? messages.firstWhere(
                                              (m) => m.id == msg.replyMessageId,
                                              orElse: () => ChatMessage(
                                                text: Translations.of(
                                                  context,
                                                ).message_deleted,
                                                senderId: '',
                                                timeStamp: '',
                                              ),
                                            )
                                          : null;

                                      return AutoScrollTag(
                                        key: ValueKey(index),
                                        controller: _scrollController,
                                        index: index,
                                        child: MessageBubble(
                                          message: msg,
                                          repliedMessage: repliedMsg,
                                          isPinned: context
                                              .watch<ChatModel>()
                                              .isPinned(
                                                widget.username ??
                                                    '@partner_dev',
                                                msg.id ?? '',
                                              ),
                                          onTogglePin: () {
                                            final cm = context
                                                .read<ChatModel>();
                                            final target =
                                                widget.username ??
                                                '@partner_dev';
                                            final msgId = msg.id ?? '';
                                            if (cm.isPinned(target, msgId)) {
                                              cm.unpinMessage(target, msgId);
                                            } else {
                                              final success = cm.pinMessage(
                                                target,
                                                msgId,
                                              );
                                              if (!success) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      Translations.of(
                                                        context,
                                                      ).pin_limit_error,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                          onReply: () {
                                            setState(() {
                                              _replyingToMessage = msg;
                                            });
                                          },
                                          onReplyTapped: () {
                                            if (msg.replyMessageId != null) {
                                              final targetIndex = messages
                                                  .indexWhere(
                                                    (m) =>
                                                        m.id ==
                                                        msg.replyMessageId,
                                                  );
                                              if (targetIndex != -1) {
                                                _scrollController.scrollToIndex(
                                                  targetIndex + 1,
                                                  preferPosition:
                                                      AutoScrollPosition.middle,
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      );
                                    }, childCount: messages.length + 1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ChatInputBar(
                          replyingToMessage: _replyingToMessage,
                          onCancelReply: () {
                            setState(() {
                              _replyingToMessage = null;
                            });
                          },
                          onSendMessage: _sendMessage,
                          onSendSticker: _sendSticker,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.lerp(
                        Alignment.topRight,
                        Alignment.topCenter,
                        _headerProgress,
                      )!,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: statusBarHeight + 10,
                          right: 14 * (1 - _headerProgress),
                        ), // Add right margin when at top right
                        child: expandableMiniIsland(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
    double angle = (animationValue * 2 * pi) + (offset * pi);
    double waveSin = sin(angle);
    double waveCos = cos(angle);
    double startY = 55 + (waveSin * 22);
    double endY = 45 + (waveCos * 18);

    path.moveTo(0, size.height);
    path.lineTo(0, startY);
    double controlX = (size.width * 0.35) + (waveCos * 30);
    double controlY = 85 + (waveSin * 25);
    path.quadraticBezierTo(controlX, controlY, size.width, endY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant AmomimusWaveClipper oldClipper) => true;
}
