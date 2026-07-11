import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'package:amomimus/models/post_model.dart';
import 'package:amomimus/models/comment_model.dart';
import 'package:amomimus/models/user_model.dart';
import 'package:amomimus/models/notification_model.dart';
import 'package:amomimus/services/feed_manager.dart';
import 'package:amomimus/services/notification_manager.dart';
import 'package:amomimus/data/anonymous_names.dart';
import 'package:amomimus/screens/profile_screen.dart';
import 'package:amomimus/utils/utc_time_manager.dart';

void showCommentsSheet(
  BuildContext context,
  FeedModel model,
  bool isDarkCard,
  UserAccount? currentUser,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: isDarkCard ? AmomimusDarkTheme.surfaceDark : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return _CommentsSheetContent(
        model: model,
        isDarkCard: isDarkCard,
        currentUser: currentUser,
      );
    },
  );
}

class _CommentsSheetContent extends StatefulWidget {
  final FeedModel model;
  final bool isDarkCard;
  final UserAccount? currentUser;

  const _CommentsSheetContent({
    required this.model,
    required this.isDarkCard,
    required this.currentUser,
  });

  @override
  State<_CommentsSheetContent> createState() => _CommentsSheetContentState();
}

class _CommentsSheetContentState extends State<_CommentsSheetContent> {
  final TextEditingController _commentController = TextEditingController();
  CommentModel? _replyTarget;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 16
            : MediaQuery.of(context).padding.bottom + 16,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            Translations.of(context).comments,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: widget.isDarkCard ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<FeedManager>(
            builder: (context, feedManager, child) {
              final currentModel =
                  feedManager.getPostById(widget.model.id) ?? widget.model;
              if (currentModel.comments.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(Translations.of(context).no_comments),
                );
              }
              return Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.45,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: currentModel.comments.length,
                    itemBuilder: (context, index) {
                      final comment = currentModel.comments[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 4,
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                "${comment.authorName} (${comment.authorId})",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: widget.isDarkCard
                                      ? Colors.white70
                                      : Colors.black87,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              UTCTimeManager.formatTimeAgo(comment.timeStamp),
                              style: TextStyle(
                                color: widget.isDarkCard
                                    ? Colors.white54
                                    : Colors.black54,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (comment.replyToName != null &&
                                comment.replyToText != null)
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 4,
                                ),
                                padding: const EdgeInsets.only(left: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    left: BorderSide(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "${Translations.of(context).replying_to} ${comment.replyToName}:\n${comment.replyToText}",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Text(
                              comment.text,
                              style: TextStyle(
                                color: widget.isDarkCard
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(targetUserId: comment.authorId),
                            ),
                          );
                        },
                        onLongPress: () {
                          setState(() {
                            _replyTarget = comment;
                          });
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const Divider(),
          if (_replyTarget != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: widget.isDarkCard
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "${Translations.of(context).replying_to} ${_replyTarget!.authorName}:\n${_replyTarget!.text}",
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.isDarkCard
                            ? Colors.white70
                            : Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () {
                      setState(() {
                        _replyTarget = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: true,
                  maxLines: null,
                  style: TextStyle(
                    color: widget.isDarkCard ? Colors.white : Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: Translations.of(context).add_comment,
                    hintStyle: TextStyle(
                      color: widget.isDarkCard
                          ? Colors.white54
                          : Colors.black54,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.send,
                  color: AmomimusDarkTheme.primaryPurple,
                ),
                onPressed: () {
                  if (_commentController.text.trim().isNotEmpty &&
                      widget.currentUser != null) {
                    final generatedName =
                        AnonymousNames.getConsistentNameForPost(
                          widget.currentUser!.amomimusId,
                          widget.model.id,
                        );
                    final newComment = CommentModel(
                      authorId: widget.currentUser!.amomimusId,
                      authorName: generatedName,
                      text: _commentController.text,
                      timeStamp: DateTime.now().toIso8601String(),
                      replyToName: _replyTarget?.authorName,
                      replyToText: _replyTarget?.text,
                    );
                    Provider.of<FeedManager>(
                      context,
                      listen: false,
                    ).addComment(widget.model.id, newComment);

                    final notifManager = Provider.of<NotificationManager>(
                      context,
                      listen: false,
                    );
                    if (_replyTarget != null &&
                        _replyTarget?.authorId !=
                            widget.currentUser!.amomimusId) {
                      notifManager.addNotification(
                        NotificationModel(
                          targetUserId: _replyTarget!.authorId,
                          actorName: generatedName,
                          type: NotificationType.reply,
                          feedId: widget.model.id,
                          message: "replied to your comment",
                        ),
                      );
                    } else {
                      final targetId =
                          widget.model.realAuthorId ?? widget.model.id;
                      if (targetId != widget.currentUser!.amomimusId) {
                        notifManager.addNotification(
                          NotificationModel(
                            targetUserId: targetId,
                            actorName: generatedName,
                            type: NotificationType.comment,
                            feedId: widget.model.id,
                            message: "commented on your post",
                          ),
                        );
                      }
                    }

                    _commentController.clear();
                    setState(() {
                      _replyTarget = null;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
