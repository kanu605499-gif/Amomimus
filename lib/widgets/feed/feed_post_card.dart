import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:amomimus/amomimusdark.dart';
import 'package:amomimus/language/language_manager.dart';
import 'package:amomimus/models/post_model.dart';
import 'package:amomimus/services/account_manager.dart';
import 'package:amomimus/services/feed_manager.dart';
import 'package:amomimus/screens/profile_screen.dart';
import 'package:amomimus/helpers/gender_helpers.dart';
import 'package:amomimus/models/user_indicator_model.dart';
import 'package:amomimus/models/effects/breathing_effect.dart';
import 'package:amomimus/models/effects/card_blur_effect.dart';
import 'package:amomimus/services/chat_request_manager.dart';
import 'package:amomimus/widgets/report_dialog.dart';
import 'package:amomimus/widgets/chat_request_dialog.dart';
import 'package:amomimus/data/anonymous_names.dart';
import 'comment_bottom_sheet.dart';

class FeedCard extends StatefulWidget {
  final FeedModel model;
  final int feedIndex;

  const FeedCard({super.key, required this.model, required this.feedIndex});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDarkCard = amomimusTheme.isDarkMode;
    final currentUser = Provider.of<AccountManager>(context).currentUser;
    final userId = currentUser?.amomimusId ?? "unknown";
    
    final isResonated = widget.model.resonatedBy.contains(userId);
    final displayResonateCount = widget.model.resonatedBy.length;
    final displayCommentCount = widget.model.comments.length;
    final hasUserCommented = widget.model.comments.any((c) => c.authorId == userId);
    final accountManager = context.watch<AccountManager>();
    final realId = widget.model.realAuthorId ?? widget.model.id;
    
    // Check local perspective indicator
    final userAcc = accountManager.getAccountById(realId);
    String targetIndicator = accountManager.getDisplayIndicator(realId, userAcc?.indicator ?? 'cloudy');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDarkCard ? const Color(0xFF121212) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkCard
              ? AmomimusDarkTheme.policeLineYellow
              : AmomimusDarkTheme.primaryPurple,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            CardBlurEffect(
              isBlurred: isMenuOpen,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final realId = widget.model.realAuthorId ?? widget.model.id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(targetUserId: realId, feedModel: widget.model),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              GenderHelpers.getTypeIcon(widget.model.type),
                              color: GenderHelpers.getTypeColor(widget.model.type),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.model.id,
                              style: GenderHelpers.getTypeIdTextStyle(widget.model.type).copyWith(
                                color: GenderHelpers.getTypeColor(widget.model.type),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.model.timeStamp,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkCard
                              ? AmomimusDarkTheme.textSecondary
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Theme(
                        data: Theme.of(context).copyWith(
                          popupMenuTheme: PopupMenuThemeData(
                            color: isDarkCard
                                ? AmomimusDarkTheme.policeLineYellow
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 12,
                            shadowColor: Colors.black26,
                          ),
                        ),
                        child: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 24,
                            color: isDarkCard
                                ? AmomimusDarkTheme.textSecondary
                                : Colors.grey,
                          ),
                          padding: EdgeInsets.zero,
                          onOpened: () {
                            setState(() => isMenuOpen = true);
                          },
                          onCanceled: () {
                            setState(() => isMenuOpen = false);
                          },
                          onSelected: (value) async {
                            setState(() => isMenuOpen = false);
                            final currentUser = Provider.of<AccountManager>(context, listen: false).currentUser;
                            final targetId = widget.model.realAuthorId ?? widget.model.id;
                            
                            if (value == 'chat') {
                              if (currentUser != null && currentUser.amomimusId == targetId) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You cannot chat with yourself."))
                                );
                                return;
                              }
                              final chatReqMgr = Provider.of<ChatRequestManager>(context, listen: false);
                              if (chatReqMgr.hasPendingRequestWith(targetId)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(context.read<LanguageManager>().getString('chat_req_pending')))
                                );
                                return;
                              }
                              if (chatReqMgr.isChatAllowed(targetId)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You are already connected via chat."))
                                );
                                return;
                              }
                              
                              final myTempName = AnonymousNames.getConsistentNameForPost(userId, widget.model.id);

                              await showDialog(
                                context: context,
                                builder: (context) => ChatRequestDialog(
                                  targetUserName: widget.model.userName,
                                  myRegisteredName: currentUser?.customUsername ?? currentUser?.anonymousUsername ?? "Anonymous",
                                  myTemporaryName: myTempName,
                                  onConfirm: () {
                                    chatReqMgr.sendRequest(
                                      targetId, 
                                      widget.model.userName, 
                                      currentUser?.customUsername ?? currentUser?.anonymousUsername ?? "Anonymous"
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(context.read<LanguageManager>().getString('chat_req_sent')))
                                    );
                                  },
                                ),
                              );
                            } else if (value == 'hide') {
                              Provider.of<FeedManager>(context, listen: false).deletePostById(widget.model.id);
                            } else if (value == 'report') {
                              if (currentUser != null && currentUser.amomimusId == targetId) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("You cannot report your own post."))
                                );
                                return;
                              }
                              await showDialog(
                                context: context,
                                builder: (context) => ReportDialog(
                                  targetId: widget.model.id,
                                ),
                              );
                              if (mounted) setState(() {});
                            }
                          },
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'chat',
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.sentiment_satisfied_outlined, size: 20, color: isDarkCard ? Colors.black87 : Colors.black87),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.read<LanguageManager>().getString('chat_this_amomim'),
                                    style: TextStyle(
                                      color: isDarkCard ? Colors.black87 : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'hide',
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.visibility_off_outlined, size: 20, color: isDarkCard ? Colors.black87 : Colors.black87),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.read<LanguageManager>().getString('hide_feed'),
                                    style: TextStyle(
                                      color: isDarkCard ? Colors.black87 : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'report',
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Row(
                                children: [
                                  Icon(Icons.sentiment_very_dissatisfied_outlined, size: 20, color: isDarkCard ? Colors.redAccent : Colors.red),
                                  const SizedBox(width: 12),
                                  Text(
                                    context.read<LanguageManager>().getString('report_amomim'),
                                    style: TextStyle(
                                      color: isDarkCard ? Colors.redAccent : Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (widget.model.content.isNotEmpty)
                    Text(
                      widget.model.content,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkCard ? Colors.white : Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (userId != "unknown") {
                            Provider.of<FeedManager>(context, listen: false)
                                .toggleResonate(widget.model.id, userId);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: _buildButton(
                            isResonated ? Icons.favorite : Icons.favorite_border,
                            "$displayResonateCount ${isResonated ? 'resonated' : 'resonate'}",
                            isResonated
                                ? Colors.pink
                                : (isDarkCard
                                    ? AmomimusDarkTheme.textSecondary
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      GestureDetector(
                        onTap: () {
                          showCommentsSheet(context, widget.model, isDarkCard, currentUser);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: hasUserCommented
                              ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6)
                              : EdgeInsets.zero,
                          decoration: hasUserCommented
                              ? BoxDecoration(
                                  color: const Color(0xFFFFD54F),
                                  borderRadius: BorderRadius.circular(16),
                                )
                              : null,
                          child: _buildButton(
                            Icons.chat_bubble_outline,
                            "$displayCommentCount ${context.watch<LanguageManager>().getString('comments')}",
                            hasUserCommented
                                ? const Color(0xFF8D5A19)
                                : (isDarkCard
                                    ? AmomimusDarkTheme.textSecondary
                                    : Colors.grey),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (targetIndicator == 'ghost' || targetIndicator == 'noise')
                        BreathingEffect(
                          minOpacity: 0.5,
                          maxOpacity: 1.0,
                          duration: const Duration(seconds: 2),
                          child: Text(
                            targetIndicator.toUpperCase(),
                            style: TextStyle(
                              color: UserIndicatorHelper.getFeedCardLabelColor(UserIndicatorHelper.fromValue(targetIndicator), isDarkTheme: isDarkCard),
                              fontWeight: FontWeight.w900,
                              fontSize: 12,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: UserIndicatorHelper.getFeedCardLabelColor(UserIndicatorHelper.fromValue(targetIndicator), isDarkTheme: isDarkCard).withValues(alpha: 0.6),
                                  blurRadius: 8.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              ),
            ),
            // Indicator label at the bottom right if it's GHOST or NOISE
          ],
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: icon == Icons.favorite
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
