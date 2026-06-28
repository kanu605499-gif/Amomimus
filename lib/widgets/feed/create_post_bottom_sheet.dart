import 'package:amomimus/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:amomimus/services/feed_manager.dart';
import 'package:amomimus/models/post_model.dart';
import 'package:provider/provider.dart';

void showCreatePostBottomSheet(
  BuildContext context,
  bool isDark,
  UserAccount currentUser,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _CreatePostForm(isDark: isDark, currentUser: currentUser);
    },
  );
}

class _CreatePostForm extends StatefulWidget {
  final bool isDark;
  final UserAccount currentUser;

  const _CreatePostForm({
    super.key,
    required this.isDark,
    required this.currentUser,
  });

  @override
  State<_CreatePostForm> createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<_CreatePostForm> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: screenHeight / 3,
        decoration: BoxDecoration(
          color: widget.isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: widget.isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              t.create_post,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.isDark
                    ? AmomimusDarkTheme.textPrimary
                    : const Color.fromARGB(255, 140, 113, 199),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _postController,
                maxLines: null,
                expands: true,
                maxLength: 300,
                textAlignVertical: TextAlignVertical.top,
                style: TextStyle(
                  color: widget.isDark
                      ? AmomimusDarkTheme.textPrimary
                      : Colors.black,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: t.whats_on_your_mind,
                  hintStyle: TextStyle(
                    color: widget.isDark
                        ? AmomimusDarkTheme.textSecondary
                        : Colors.grey[500],
                    fontSize: 16,
                  ),
                  filled: false,
                  contentPadding: const EdgeInsets.all(8),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  if (_postController.text.trim().isNotEmpty) {
                    AccountType accountType;
                    switch (widget.currentUser.gender) {
                      case 'Ami':
                        accountType = AccountType.ami;
                        break;
                      case 'Amom':
                        accountType = AccountType.amom;
                        break;
                      case 'Amo':
                        accountType = AccountType.amo;
                        break;
                      default:
                        accountType = AccountType.user;
                        break;
                    }

                    final newPost = FeedModel(
                      userName: widget.currentUser.anonymousUsername,
                      id: "#AMM-${DateTime.now().millisecondsSinceEpoch % 100000}",
                      type: accountType,
                      content: _postController.text,
                      timeStamp: DateTime.now().toIso8601String(),
                      realAuthorId: widget.currentUser.amomimusId,
                      realAuthorName: widget.currentUser.anonymousUsername,
                      authorIndicator: widget.currentUser.indicator,
                    );
                    final success = await Provider.of<FeedManager>(
                      context,
                      listen: false,
                    ).addPost(newPost);

                    if (!success) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.spam_cooldown_warning),
                            backgroundColor: Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                      return;
                    }

                    _postController.clear();
                    if (context.mounted) Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AmomimusDarkTheme.primaryPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  t.send_post,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

