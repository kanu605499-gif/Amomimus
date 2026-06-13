import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../language/language_manager.dart';
import '../../models/message_model.dart';
import '../../services/account_manager.dart';
import '../../widgets/report_dialog.dart';

class MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final ChatMessage? repliedMessage;
  final VoidCallback? onReply;
  final bool isPinned;
  final VoidCallback? onTogglePin;
  final VoidCallback? onReplyTapped;

  const MessageBubble({
    super.key,
    required this.message,
    this.repliedMessage,
    this.onReply,
    this.isPinned = false,
    this.onTogglePin,
    this.onReplyTapped,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
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
    final String stickerAsset = isSticker ? widget.message.text.substring(10) : '';

    final textPainter = TextPainter(
      text: TextSpan(
        text: isSticker ? '' : widget.message.text,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 11.0),
      child: Row(
        mainAxisAlignment: isUserMessage
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUserMessage) ...[
            Text(
              widget.message.timeStamp,
              style: TextStyle(
                fontSize: 9,
                color: textSecondaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(width: 8),
          ],
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: isDark
                    ? AmomimusDarkTheme.backgroundDark
                    : Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (sheetContext) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.reply, color: customBorderColor),
                          title: Text(
                            context.read<LanguageManager>().getString('reply'),
                            style: TextStyle(color: textColor),
                          ),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            if (widget.onReply != null) widget.onReply!();
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
                                ? context.read<LanguageManager>().getString('unpin_memories')
                                : context.read<LanguageManager>().getString('pin_memories'),
                            style: TextStyle(color: textColor),
                          ),
                          onTap: () {
                            Navigator.pop(sheetContext);
                            if (widget.onTogglePin != null) {
                              widget.onTogglePin!();
                            }
                          },
                        ),
                        if (!isUserMessage)
                          ListTile(
                            leading: const Icon(
                              Icons.report_gmailerrorred,
                              color: Colors.redAccent,
                            ),
                            title: Text(
                              context.read<LanguageManager>().getString('report'),
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                            onTap: () {
                              Navigator.pop(sheetContext);
                              showDialog(
                                context: context,
                                builder: (context) => ReportDialog(
                                  targetId: widget.message.id ?? '',
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
                        widget.message.senderName!,
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
                    padding: isSticker 
                        ? EdgeInsets.zero 
                        : const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: isSticker 
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
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    backgroundColor: bubbleColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: customBorderColor.withValues(alpha: 0.1),
                                        width: 1.85,
                                      ),
                                    ),
                                    content: Text(
                                      widget.repliedMessage!.text,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 14,
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
                                  color: customBorderColor.withValues(alpha: 0.9),
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
                                  if (widget.repliedMessage!.text.startsWith('[STICKER]:'))
                                    Row(
                                      children: [
                                        Icon(Icons.sticky_note_2, size: 12, color: textSecondaryColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          context.read<LanguageManager>().getString('sticker'),
                                          style: TextStyle(
                                            color: textSecondaryColor,
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Image.asset(
                                          widget.repliedMessage!.text.replaceFirst('[STICKER]:', ''),
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
                        if (isOverflowing)
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
                                    _isExpanded ? context.read<LanguageManager>().getString('show_less') : context.read<LanguageManager>().getString('show_more'),
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
          if (!isUserMessage) ...[
            const SizedBox(width: 8),
            Text(
              widget.message.timeStamp,
              style: TextStyle(
                fontSize: 9,
                color: textSecondaryColor.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
