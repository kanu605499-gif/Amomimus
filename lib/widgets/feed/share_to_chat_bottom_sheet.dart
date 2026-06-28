import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../helpers/gender_helpers.dart';
import '../../models/post_model.dart';
import '../../models/user_model.dart';
import '../../services/account_manager.dart';
import '../../services/chatmodel.dart';

void showShareToChatSheet(BuildContext context, FeedModel post, bool isDark) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ShareToChatBottomSheet(post: post, isDark: isDark);
    },
  );
}

class ShareToChatBottomSheet extends StatelessWidget {
  final FeedModel post;
  final bool isDark;

  const ShareToChatBottomSheet({
    super.key,
    required this.post,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final chatModel = context.watch<ChatModel>();
    final accountManager = context.watch<AccountManager>();
    final chatList = chatModel.chatList;

    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              t.share_to_chat,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: chatList.isEmpty
                  ? Center(
                      child: Text(
                        "No active chats to share to.",
                        style: TextStyle(color: subTextColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {
                        final chat = chatList[index];
                        final targetGender = GenderHelpers.extractGenderFromName(chat.name);
                        final dynamicTileIcon = GenderHelpers.getGenderIcon(targetGender);
                        final dynamicTileColor = GenderHelpers.getGenderColor(targetGender);
                        final displayName = GenderHelpers.getDisplayName(chat.name);

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          leading: Container(
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
                          title: Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            chat.username,
                            style: TextStyle(
                              fontSize: 11,
                              color: AmomimusDarkTheme.policeLineYellow
                                  .withValues(alpha: 0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.send_rounded),
                            color: dynamicTileColor,
                            onPressed: () {
                              chatModel.sendMessage(
                                chat.username,
                                '[SHARED_POST]:${post.id}',
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Post shared to chat!"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


