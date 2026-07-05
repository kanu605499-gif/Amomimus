import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../models/message_model.dart';
import '../../services/feed_manager.dart';
import 'package:amomimus/helpers/gender_helpers.dart';
import '../../i18n/strings.g.dart';
import '../../services/account_manager.dart';
import '../../widgets/report_dialog.dart';
import 'chat_shared_post.dart';
import 'package:amomimus/utils/jelly_dialog.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final ChatMessage? repliedMessage;
  final VoidCallback? onReply;
  final bool isPinned;
  final VoidCallback? onTogglePin;
  final VoidCallback? onReplyTapped;
  final bool isSelectionMode;
  final bool isSelected;
  final int selectionIndex;
  final bool showSelectionNumbers;
  final VoidCallback? onSelectionTap;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    this.repliedMessage,
    this.onReply,
    this.isPinned = false,
    this.onTogglePin,
    this.onReplyTapped,
    this.isSelectionMode = false,
    this.isSelected = false,
    this.selectionIndex = 0,
    this.showSelectionNumbers = false,
    this.onSelectionTap,
    this.onLongPress,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  bool _showSuccessIcon = false;
  double _dragOffset = 0.0;
  bool _isDragging = false;
  late AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final activeUser = context.watch<AccountManager>().currentUser;
    final isDark = themeProvider.isDarkMode;
    final isUserMessage = widget.message.senderId == activeUser?.amomimusId;
    Color bubbleColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final Color customBorderColor = isUserMessage
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color textSecondaryColor = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;

    // Check if text is long enough to need collapsing
    final bool isSticker = widget.message.text.startsWith('[STICKER]:');
    final String stickerAsset = isSticker
        ? widget.message.text.substring(10)
        : '';

    final bool isSharedPost = widget.message.text.startsWith('[SHARED_POST]:');
    final String sharedPostId = isSharedPost
        ? widget.message.text.substring(14)
        : '';
    final feedManager = context.read<FeedManager>();
    final sharedPost = isSharedPost
        ? feedManager.getPostById(sharedPostId)
        : null;

    final textPainter = TextPainter(
      text: TextSpan(
        text: isSticker || isSharedPost ? '' : widget.message.text,
        style: TextStyle(
          color: textColor,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          height: 1.5,
          fontFamily: 'serif',
        ),
      ),
      maxLines: 4,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: MediaQuery.of(context).size.width * 0.62 - 32);
    final bool isOverflowing = textPainter.didExceedMaxLines;

    final bubbleContent = Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUserMessage) ...[
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: !widget.message.isSynced
                      ? widget.message.showResendOptions
                          ? Icon(
                              Icons.error_outline,
                              key: const ValueKey('error'),
                              size: 10,
                              color: textSecondaryColor.withValues(alpha: 0.6),
                            )
                          : RotationTransition(
                              key: const ValueKey('spin'),
                              turns: _spinController,
                              child: Icon(
                                Icons.hourglass_empty,
                                size: 10,
                                color: textSecondaryColor.withValues(alpha: 0.6),
                              ),
                            )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPress: widget.onLongPress,
            onTap: widget.isSelectionMode
                ? widget.onSelectionTap
                : () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: isDark
                          ? AmomimusDarkTheme.backgroundDark
                          : Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (sheetContext) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.reply,
                                  color: customBorderColor,
                                ),
                                title: Text(
                                  t.reply,
                                  style: TextStyle(color: textColor),
                                ),
                                onTap: () {
                                  Navigator.pop(sheetContext);
                                  if (widget.onReply != null) widget.onReply!();
                                },
                              ),
                              if (RegExp(
                                    r'(https?:\/\/[^\s]+|[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})',
                                  ).hasMatch(widget.message.text) &&
                                  !isSticker &&
                                  !isSharedPost)
                                ListTile(
                                  leading: Icon(
                                    Icons.copy,
                                    color: customBorderColor,
                                  ),
                                  title: Text(
                                    t.copy,
                                    style: TextStyle(color: textColor),
                                  ),
                                  onTap: () {
                                    Navigator.pop(sheetContext);
                                    Clipboard.setData(
                                      ClipboardData(text: widget.message.text),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),
                                        content: Text(
                                          t.copied_to_clipboard,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                ),
                              ListTile(
                                leading: Icon(
                                  widget.isPinned
                                      ? Icons.cloud
                                      : Icons.cloud_outlined,
                                  color: customBorderColor,
                                ),
                                title: Text(
                                  widget.isPinned
                                      ? t.unpin_memories
                                      : t.pin_memories,
                                  style: TextStyle(color: textColor),
                                ),
                                onTap: () {
                                  Navigator.pop(sheetContext);
                                  if (widget.onTogglePin != null) {
                                    widget.onTogglePin!();
                                  }
                                },
                              ),
                              if (!isUserMessage && !context.read<AccountManager>().accounts.any((acc) => acc.amomimusId == widget.message.senderId))
                                ListTile(
                                  leading: const Icon(
                                    Icons.report_gmailerrorred,
                                    color: Colors.redAccent,
                                  ),
                                  title: Text(
                                    t.report,
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.pop(sheetContext);
                                    showJellyDialog(
                                      context: context,
                                      builder: (context) => ReportDialog(
                                        targetId: widget.message.senderId,
                                        isUserReport: false,
                                      ),
                                    );
                                  },
                                ),
                            ],
                          ),
                        );
                      },
                    );
                  },
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.62,
              ),
              child: Column(
                crossAxisAlignment: isUserMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (widget.message.senderName != null)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: 3,
                        right: isUserMessage ? 4 : 0,
                        left: isUserMessage ? 0 : 4,
                      ),
                      child: Text(
                        GenderHelpers.getDisplayName(widget.message.senderName!),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isUserMessage
                              ? AmomimusDarkTheme.policeLineYellow
                              : AmomimusDarkTheme.primaryPurple,
                        ),
                      ),
                    ),
                  Container(
                    padding: (isSticker || isSharedPost)
                        ? EdgeInsets.zero
                        : const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                    decoration: (isSticker || isSharedPost)
                        ? null
                        : BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isUserMessage
                                  ? const Radius.circular(20)
                                  : const Radius.circular(4),
                              bottomRight: isUserMessage
                                  ? const Radius.circular(4)
                                  : const Radius.circular(20),
                            ),
                            border: Border.all(
                              color: customBorderColor.withValues(alpha: 0.7),
                              width: 1.85,
                            ),
                          ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.repliedMessage != null)
                          GestureDetector(
                            onTap: () {
                              if (widget.onReplyTapped != null) {
                                widget.onReplyTapped!();
                              } else if (widget.repliedMessage!.text.length > 100) {
                                showJellyDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    backgroundColor: bubbleColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: customBorderColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        width: 1.85,
                                      ),
                                    ),
                                    content: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                                      ),
                                      child: SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        child: Text(
                                          widget.repliedMessage!.text,
                                          style: TextStyle(
                                            color: textColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: customBorderColor.withValues(
                                    alpha: 0.9,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.02)
                                        : Colors.black.withValues(alpha: 0.005),
                                    offset: const Offset(0, 2),
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.repliedMessage!.senderName ?? 'User',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: customBorderColor,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  if (widget.repliedMessage!.text.startsWith(
                                    '[STICKER]:',
                                  ))
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.sticky_note_2,
                                          size: 12,
                                          color: textSecondaryColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          t.sticker,
                                          style: TextStyle(
                                            color: textSecondaryColor,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          widget.repliedMessage!.text
                                              .replaceFirst('[STICKER]:', ''),
                                          height: 20,
                                          width: 20,
                                        ),
                                      ],
                                    )
                                  else
                                    Text(
                                      widget.repliedMessage!.text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: textSecondaryColor,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        if (isSticker)
                          Image.asset(
                            stickerAsset,
                            width: 130,
                            fit: BoxFit.contain,
                          )
                        else if (isSharedPost && sharedPost != null)
                          ChatSharedPost(
                            sharedPost: sharedPost,
                            bubbleColor: bubbleColor,
                            customBorderColor: customBorderColor,
                            textColor: textColor,
                            isUserMessage: isUserMessage,
                          )
                        else if (isSharedPost && sharedPost == null)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bubbleColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: customBorderColor.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              'Post is no longer available.',
                              style: TextStyle(
                                color: textSecondaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        else
                          RichText(
                            maxLines: _isExpanded ? null : 4,
                            overflow: _isExpanded
                                ? TextOverflow.clip
                                : TextOverflow.ellipsis,
                            text: TextSpan(
                              text: widget.message.text,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                fontFamily: 'serif',
                              ),
                              children: [
                                if (widget.isPinned)
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Icon(
                                        Icons.cloud,
                                        size: 12,
                                        color: customBorderColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (!isSticker && !isSharedPost && isOverflowing)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _isExpanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 16,
                                    color: customBorderColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isExpanded ? t.show_less : t.show_more,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: customBorderColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (widget.isSelectionMode) {
      final checkbox = GestureDetector(
        onTap: widget.onSelectionTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isSelected ? customBorderColor : Colors.transparent,
            border: Border.all(
              color: widget.isSelected ? customBorderColor : Colors.grey,
              width: 2,
            ),
          ),
          width: 24,
          height: 24,
          child: widget.isSelected
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : null,
        ),
      );

      final mainWidget = AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        child: Row(
          mainAxisAlignment: isUserMessage
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: isUserMessage
              ? [Flexible(child: bubbleContent), checkbox]
              : [checkbox, Flexible(child: bubbleContent)],
        ),
      );

      return _buildSwipeableBubble(mainWidget, textSecondaryColor, isUserMessage);
    }

    return _buildSwipeableBubble(bubbleContent, textSecondaryColor, isUserMessage);
  }

  Widget _buildSwipeableBubble(Widget child, Color textSecondaryColor, bool isUserMessage) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.primaryDelta!;
          if (isUserMessage) {
            if (_dragOffset < -80) _dragOffset = -80;
            if (_dragOffset > 0) _dragOffset = 0;
          } else {
            if (_dragOffset > 80) _dragOffset = 80;
            if (_dragOffset < 0) _dragOffset = 0;
          }
          _isDragging = true;
        });
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _isDragging = false;
          _dragOffset = 0.0;
        });
      },
      onHorizontalDragCancel: () {
        setState(() {
          _isDragging = false;
          _dragOffset = 0.0;
        });
      },
      child: Stack(
        alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: isUserMessage ? 16 : null,
            left: !isUserMessage ? 16 : null,
            child: Opacity(
              opacity: (isUserMessage ? (_dragOffset / -80) : (_dragOffset / 80)).clamp(0.0, 1.0),
              child: Text(
                widget.message.timeStamp,
                style: TextStyle(
                  color: textSecondaryColor,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: _isDragging
                ? Duration.zero
                : const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(_dragOffset, 0, 0),
            child: child,
          ),
        ],
      ),
    );
  }
}
