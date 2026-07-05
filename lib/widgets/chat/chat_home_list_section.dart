import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../helpers/gender_helpers.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../../models/user_indicator_model.dart';
import '../../models/user_model.dart';
import '../../models/chat_preview_model.dart';
import '../profile/presence_picker_capsule.dart';
import '../../services/account_manager.dart';
import '../../services/chat_request_manager.dart';
import '../../services/chatmodel.dart';
import '../../screens/roomchat.dart';
import '../effects/glitch_effect.dart';
import 'package:amomimus/utils/jelly_dialog.dart';

class ChatListTileWidget extends StatelessWidget {
  final ChatPreview chat;
  const ChatListTileWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;

    final Color tileBg = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    // Get the target user's gender for dynamic styling
    final accountManager = context.watch<AccountManager>();
    final targetAccount = accountManager.accounts.firstWhere(
      (acc) => acc.amomimusId == chat.username,
      orElse: () {
        final extractedGender = GenderHelpers.extractGenderFromName(chat.name);
        return UserAccount(
          email: '',
          realUsername: '',
          anonymousUsername: '',
          amomimusId: '',
          gender: extractedGender,
          registrationDate: '',
          isDemo: false,
        );
      },
    );
    final targetGender = targetAccount.gender;
    final dynamicTileIcon = GenderHelpers.getGenderIcon(targetGender);
    final dynamicTileColor = GenderHelpers.getGenderColor(targetGender);

    final customBorderColor = (chat.unreadCount > 0)
        ? dynamicTileColor
        : dynamicTileColor.withValues(alpha: 0.5);

    final isRecentlyUnblocked = accountManager.isRecentlyUnblocked(
      chat.username,
    );
    final chatModel = context.watch<ChatModel>();
    final lastMsg = chat.lastMessageObject;

    // Only show pending if it's been slow (>2s) — fast sends show nothing
    final isLastMessagePending =
        lastMsg != null &&
        lastMsg.senderId == chatModel.currentUserId &&
        !lastMsg.isSynced &&
        lastMsg.isPendingSlow;
    final showSuccessMessage = lastMsg != null && 
                               lastMsg.showSuccess && 
                               lastMsg.senderId == chatModel.currentUserId;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Dismissible(
        key: Key(chat.username),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.redAccent.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white,
            size: 28,
          ),
        ),
        confirmDismiss: (direction) async {
          return await showJellyDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: isDark
                    ? AmomimusDarkTheme.surfaceDark
                    : Colors.white,
                title: Text(
                  t.delete_chat_title,
                  style: const TextStyle(
                    color: AmomimusDarkTheme.primaryPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  "${t.delete_chat_confirm_prefix}${chat.name}${t.delete_chat_confirm_suffix}",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    child: Text(
                      t.cancel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    child: Text(
                      t.delete,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          context.read<ChatModel>().deleteChatForUser(chat.username);
          context.read<ChatRequestManager>().deleteRequestWith(chat.username);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
              content: Text(
                '${t.chat_deleted_prefix}${chat.name}${t.chat_deleted_suffix}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: InkWell(
          onTap: () {
            final accountMgr = context.read<AccountManager>();
            final currentUser = accountMgr.currentUser;
            bool isBothSubProfiles = false;
            
            if (currentUser != null && accountMgr.accounts.any((acc) => acc.amomimusId == chat.username)) {
              final targetUser = accountMgr.accounts.firstWhere((acc) => acc.amomimusId == chat.username);
              if (targetUser.masterEmail == currentUser.masterEmail) {
                final groupAccounts = accountMgr.accounts.where((acc) => acc.masterEmail == currentUser.masterEmail).toList();
                if (groupAccounts.isNotEmpty) {
                  final masterId = groupAccounts.first.amomimusId;
                  final isCurrentMaster = currentUser.amomimusId == masterId;
                  final isTargetMaster = chat.username == masterId;
                  if (!isCurrentMaster && !isTargetMaster) {
                    isBothSubProfiles = true;
                  }
                }
              }
            }

            if (isBothSubProfiles) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
                  content: Text(
                    (Translations.of(context) as dynamic).sub_profile_chat_error ?? "Sub-profiles cannot chat with each other.",
                  ),
                ),
              );
              return;
            }

            context.read<ChatModel>().markAsRead(chat.username);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AmomimusApp6(username: chat.username, name: chat.name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: tileBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: customBorderColor.withValues(alpha: 0.7),
                width: 1.8,
              ),
            ),
            child: GlitchEffect(
              isActive: isRecentlyUnblocked,
              child: Row(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: dynamicTileColor,
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          dynamicTileIcon,
                          color: dynamicTileColor,
                          size: 28,
                        ),
                      ),
                      if (chat.isOnline || (targetAccount.presenceStatus != 'invisible' && targetAccount.presenceStatus != 'offline'))
                        Positioned(
                          bottom: -1,
                          right: -1,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: tileBg, width: 1.5),
                            ),
                            child: ClipOval(
                              child: Container(
                                color: tileBg,
                                child: PresencePickerCapsule.getPresenceIcon(
                                  targetAccount.presenceStatus,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  (targetAccount.anonymousUsername.isNotEmpty)
                                      ? targetAccount.anonymousUsername
                                      : GenderHelpers.getDisplayName(chat.name),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              chat.time,
                              style: TextStyle(
                                fontSize: 10,
                                color: subTextColor.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              chat.username,
                              style: TextStyle(
                                fontSize: 11,
                                color: AmomimusDarkTheme.policeLineYellow
                                    .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isRecentlyUnblocked) ...[
                              const SizedBox(width: 6),
                              GlitchEffect(
                                isActive: true,
                                isRedHorror: false,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.2,
                                    ),
                                    border: Border.all(
                                      color: Colors.redAccent,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    t.ex_blocked,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          isLastMessagePending
                              ? t.message_is_pending
                              : showSuccessMessage
                              ? t.message_successfully_sent
                              : chat.lastMessage == 'room_chat_resetted'
                              ? t.room_chat_resetted
                              : (chat.lastMessage.startsWith('[STICKER]:')
                                    ? '[STICKER]'
                                    : chat.lastMessage),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: chat.lastMessage == 'room_chat_resetted'
                                ? Colors.redAccent.withValues(alpha: 0.8)
                                : isLastMessagePending
                                ? Colors.redAccent
                                : showSuccessMessage
                                ? Colors.green
                                : subTextColor,
                            fontFamily: 'serif',
                            fontStyle:
                                (isLastMessagePending ||
                                    showSuccessMessage ||
                                    chat.lastMessage == 'room_chat_resetted')
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (isLastMessagePending) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ] else if (showSuccessMessage) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ] else if (chat.unreadCount > 0) ...[
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "${chat.unreadCount}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
