import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../models/message_model.dart';
import 'sticker_keyboard.dart';
import 'package:amomimus/i18n/strings.g.dart';

class ChatInputBar extends StatefulWidget {
  final ChatMessage? replyingToMessage;
  final VoidCallback onCancelReply;
  final Function(String) onSendMessage;
  final Function(String) onSendSticker;

  const ChatInputBar({
    super.key,
    required this.replyingToMessage,
    required this.onCancelReply,
    required this.onSendMessage,
    required this.onSendSticker,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _messageController = TextEditingController();
  bool _isStickerPickerExpanded = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      widget.onSendMessage(_messageController.text.trim());
      _messageController.clear();
      setState(() {
        _isStickerPickerExpanded = false;
      });
    }
  }

  void _sendSticker(String assetPath) {
    widget.onSendSticker(assetPath);
    setState(() {
      _isStickerPickerExpanded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentSurface = isDark
        ? AmomimusDarkTheme.surfaceDark
        : Colors.grey[200]!;
    final dynamicAccentColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final currentTextSecondary = isDark
        ? AmomimusDarkTheme.textSecondary
        : Colors.black54;
    final currentText = isDark ? AmomimusDarkTheme.textPrimary : Colors.black87;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.replyingToMessage != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: currentSurface,
              border: Border(
                top: BorderSide(
                  color: currentSurface.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: dynamicAccentColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${t.replying_to} ${widget.replyingToMessage!.senderName ?? 'User'}",
                        style: TextStyle(
                          color: dynamicAccentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (widget.replyingToMessage!.text.startsWith(
                        '[STICKER]:',
                      ))
                        Row(
                          children: [
                            Icon(
                              Icons.sticky_note_2,
                              size: 14,
                              color: currentTextSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              t.sticker,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Image.asset(
                              widget.replyingToMessage!.text.replaceFirst(
                                '[STICKER]:',
                                '',
                              ),
                              height: 20,
                              width: 20,
                            ),
                          ],
                        )
                      else
                        Text(
                          widget.replyingToMessage!.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: currentTextSecondary,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: currentTextSecondary,
                    size: 20,
                  ),
                  onPressed: widget.onCancelReply,
                ),
              ],
            ),
          ),
        StickerKeyboard(
          isExpanded: _isStickerPickerExpanded,
          messageController: _messageController,
          onSendSticker: _sendSticker,
        ),
        Container(
          constraints: BoxConstraints(maxHeight: screenHeight * 0.33),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(color: Colors.transparent),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isStickerPickerExpanded = !_isStickerPickerExpanded;
                    });
                  },
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    switchInCurve: Curves.easeOutBack,
                    switchOutCurve: Curves.easeIn,
                    child: Icon(
                      _isStickerPickerExpanded
                          ? Icons.keyboard_alt_outlined
                          : Icons.sentiment_satisfied_alt_outlined,
                      key: ValueKey<bool>(_isStickerPickerExpanded),
                      color: dynamicAccentColor,
                      size: 26,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: TextField(
                    controller: _messageController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    minLines: 1,
                    style: TextStyle(color: currentText, fontSize: 15),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      border: InputBorder.none,
                      hintText: t.write_message,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: currentTextSecondary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AmomimusDarkTheme.primaryPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Icon(
                      Icons.send,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
