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
import 'feed_screen.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../widgets/chat/chat_message_bubble.dart';
import '../widgets/chat/chat_input_bar.dart';
import 'fake_pdf_screen.dart';
import '../widgets/chat/room_chat_large_profile.dart';
import '../widgets/chat/floating_countdown_capsule.dart';
import '../widgets/chat/room_chat_mini_island.dart';
import '../widgets/chat/selection_action_bar.dart';
import '../widgets/effects/glitch_effect.dart';
import '../widgets/chat/amomimus_wave_clipper.dart';
import '../widgets/chat/radio_tuner_gesture.dart';
import 'package:amomimus/utils/jelly_dialog.dart';
import '../services/audio_manager.dart';

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

  bool _showResetGlitch = false;
  bool _hasTriggeredRead = false;

  bool _isSelectionMode = false;
  List<String> _selectedMessageIds = [];

  void _toggleSelection(String messageId) {
    setState(() {
      if (_selectedMessageIds.contains(messageId)) {
        _selectedMessageIds.remove(messageId);
        if (_selectedMessageIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMessageIds.add(messageId);
      }
    });
  }

  void _enterSelectionMode(String messageId) {
    setState(() {
      _isSelectionMode = true;
      _selectedMessageIds = [messageId];
    });
  }

  void _clearSelection() {
    setState(() {
      _isSelectionMode = false;
      _selectedMessageIds.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scrollController.addListener(_onScroll);
    
    // Play the old radio sound effect when entering the chat room
    AudioManager().playOldRadio();
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
    AudioManager().stop();
    super.dispose();
  }

  void _sendPayload(String payload) {
    final targetId = widget.username ?? '';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      targetId,
      payload,
      senderName: senderName,
      targetName: widget.name,
      replyMessageId: _replyingToMessage?.id,
    );

    setState(() {
      _replyingToMessage = null;
    });
    
    // Play the chat send sound
    AudioManager().playClickChat();

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

  void _sendMessage(String text) => _sendPayload(text);
  void _sendSticker(String assetPath) => _sendPayload('[STICKER]:$assetPath');

  void _showMemoriesPopup(
    BuildContext context,
    String targetUsername,
    Color themeColor,
  ) {
    final themeProvider = context.read<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentBg = isDark ? AmomimusDarkTheme.backgroundDark : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    showJellyDialog(
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
                                  : themeColor.withValues(alpha: 0.06),
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

  void _showChatLogPopup(
    BuildContext context,
    String targetUsername,
    Color themeColor,
  ) {
    final themeProvider = context.read<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentBg = isDark ? AmomimusDarkTheme.backgroundDark : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    final accountManager = context.read<AccountManager>();
    final currentUserId = accountManager.currentUser?.amomimusId;
    final currentUserName = GenderHelpers.getDisplayName(
        accountManager.currentUser?.anonymousUsername ?? 'Anda');

    final partnerName = GenderHelpers.getDisplayName(widget.name ?? 'Partner');

    showJellyDialog(
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
                        Icon(Icons.history, color: themeColor),
                        const SizedBox(width: 8),
                        Text(
                          t.chat_log_title,
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
                    final logs = chatModel.getChatLogs(targetUsername);

                    if (logs.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            t.chat_log_empty,
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
                        itemCount: logs.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (ctx, index) {
                          final entry = logs[index];

                          // Resolve Actor Display Name
                          String actorName = t.chat_log_system;
                          if (entry.actorId == currentUserId) {
                            actorName = currentUserName;
                          } else if (entry.actorId != 'system') {
                            actorName = partnerName;
                          }

                          // Format the entry action description
                          String description = "";
                          switch (entry.text) {
                            case 'room_created':
                              description = t.chat_log_room_created;
                              break;
                            case 'room_expired':
                              description = t.chat_log_room_expired;
                              break;
                            case 'delete_room':
                              description = t.chat_log_delete_room(actor: actorName);
                              break;
                            case 'pin':
                              description = t.chat_log_pin(actor: actorName);
                              break;
                            case 'unpin':
                              description = t.chat_log_unpin(actor: actorName);
                              break;
                            case 'erase':
                              description = t.chat_log_erase(actor: actorName);
                              break;
                            default:
                              description = "$actorName: ${entry.text}";
                          }

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: textColor,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                entry.timeStamp,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: textSecondary,
                                ),
                              ),
                            ],
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
    final themeProvider = Provider.of<AmomimusDarkTheme>(context);
    final accountManager = Provider.of<AccountManager>(context);

    final targetId = widget.username ?? '';
    final targetName = widget.name ?? 'Unknown';

    final isRecentlyUnblocked = targetId.isNotEmpty
        ? accountManager.isRecentlyUnblocked(targetId)
        : false;

    // Build the dynamic header style based on user indicator
    UserAccount targetAccount = accountManager.getAccountOrFallback(targetId, targetName);
    final chatModel = context.watch<ChatModel>();
    final activeChat = chatModel.getChatByUsername(
      targetId,
      targetName: targetName,
    );
    final currentUserId = accountManager.currentUser?.amomimusId;
    final messages = activeChat.messages
        .where((m) => currentUserId == null || !m.deletedBy.contains(currentUserId))
        .toList();

    if (!_hasTriggeredRead && widget.username != null) {
      _hasTriggeredRead = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ChatModel>().markAsRead(widget.username!);
      });
    }

    final iAmBlocker = widget.username != null && accountManager.currentUser?.blockedUsers.contains(widget.username) == true;
    final iAmBlocked = widget.username != null && accountManager.isBlockedBy(widget.username!);
    
    // Play glitch if blocked, or if blocker hasn't seen it
    final shouldPlayGlitch = iAmBlocked || (iAmBlocker && !activeChat.hasSeenResetAnimation);

    if (shouldPlayGlitch && !_showResetGlitch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _showResetGlitch = true;
          });
          
          if (targetId.isNotEmpty) {
            context.read<ChatModel>().markResetAnimationSeen(targetId);
          }

          final activeUserId = accountManager.currentUser?.amomimusId;
          final isCheater =
              activeChat.cheatDetectedUserId != null &&
              activeChat.cheatDetectedUserId == activeUserId;

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _showResetGlitch = false;
              });

              if (isCheater) {
                showJellyDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => AlertDialog(
                    backgroundColor: themeProvider.isDarkMode
                        ? AmomimusDarkTheme.surfaceDark
                        : Colors.white,
                    title: const Text("⚠️ Warning"),
                    content: Text(
                      Translations.of(context).cheat_detected_warning,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext); // Close dialog
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context); // Pop roomchat, back to list
                          }
                        },
                        child: const Text(
                          "OK",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (iAmBlocker) {
                context.read<ChatModel>().deleteChatForUser(widget.username!);
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Kick back to chat list
                }
              } else if (iAmBlocked) {
                context.read<ChatModel>().deleteChatForUser(widget.username!);
                // Kick to feed screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AmomimusApp5()),
                  (route) => false,
                );
              } else {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context); // Kick back to chat list
                }
              }
            }
          });
        }
      });
    }

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
    // We CANNOT use local AccountManager for remote users, as it will fallback to Amo.
    // Instead, extract the gender from the provided name or ID
    final targetGender = GenderHelpers.extractGenderFromName(widget.name ?? 'Unknown', widget.username);
    final dynamicHeaderIcon = GenderHelpers.getGenderIcon(targetGender);
    final dynamicHeaderColor = GenderHelpers.getGenderColor(targetGender);

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
                          child: RadioTunerGestureWrapper(
                            scrollController: _scrollController,
                            themeColor: dynamicHeaderColor,
                            isDark: themeProvider.isDarkMode,
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
                                      final allPending = _selectedMessageIds
                                          .every((id) {
                                            final m = messages.firstWhere(
                                              (m) => m.id == id,
                                              orElse: () => ChatMessage(
                                                text: '',
                                                senderId: '',
                                                timeStamp: '',
                                              ),
                                            );
                                            return m.showResendOptions;
                                          });
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
                                            onShowChatLogPopup:
                                                _showChatLogPopup,
                                          ),
                                        );
                                      }
                                      final msg = messages[index - 1];
                                      final repliedMsg =
                                          msg.replyMessageId != null
                                          ? activeChat.allMessages.firstWhere(
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
                                          onReply: () {
                                            setState(() {
                                              _replyingToMessage = msg;
                                            });
                                          },
                                          isPinned: chatModel.isPinned(
                                                targetId,
                                                msg.id ?? '',
                                              ),
                                          onTogglePin: () {
                                            if (msg.id != null) {
                                              if (chatModel.isPinned(
                                                targetId,
                                                msg.id!,
                                              )) {
                                                chatModel.unpinMessage(
                                                  targetId,
                                                  msg.id!,
                                                );
                                              } else {
                                                chatModel.pinMessage(targetId, msg.id!);
                                              }
                                            }
                                          },
                                          isSelectionMode: _isSelectionMode,
                                          isSelected: _selectedMessageIds
                                              .contains(msg.id),
                                          selectionIndex:
                                              _selectedMessageIds.indexOf(
                                                msg.id ?? '',
                                              ) +
                                              1,
                                          showSelectionNumbers: allPending,
                                          onSelectionTap: () => msg.id != null
                                              ? _toggleSelection(msg.id!)
                                              : null,
                                          onLongPress: () {
                                            if (!_isSelectionMode &&
                                                msg.id != null) {
                                              _enterSelectionMode(msg.id!);
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
                        ),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          crossFadeState: _isSelectionMode
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: RoomChatMiniIsland(
                            isExpanded: _isIslandExpanded,
                            onToggle: () {
                              setState(() {
                                _isIslandExpanded = !_isIslandExpanded;
                              });
                            },
                            themeProvider: themeProvider,
                            dynamicHeaderColor: dynamicHeaderColor,
                            dynamicHeaderIcon: dynamicHeaderIcon,
                            targetAccount: targetAccount,
                            targetUsername: widget.username ?? '',
                          ),
                          secondChild: SelectionActionBar(
                            selectedMessageIds: _selectedMessageIds,
                            messages: messages,
                            targetUsername: targetId,
                            onClearSelection: _clearSelection,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (activeChat.roomStartedAt != null &&
                      !activeChat.isResetIndicatorVisible)
                    FloatingCountdownCapsule(
                      startedAt:
                          DateTime.tryParse(activeChat.roomStartedAt ?? '') ??
                          DateTime.now(),
                      expiresAt:
                          DateTime.tryParse(activeChat.roomExpiresAt ?? '') ??
                          DateTime.now(),
                      isRecentlyUnblocked: isRecentlyUnblocked,
                      showResetGlitch: _showResetGlitch,
                    ),
                  if (_showResetGlitch)
                    const Positioned.fill(
                      child: GlitchEffect(
                        isRedHorror: true,
                        child: SizedBox.expand(),
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
