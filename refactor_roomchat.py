import re

def refactor_roomchat():
    with open('lib/screens/roomchat.dart', 'r', encoding='utf-8') as f:
        content = f.read()

    # 1. Refactor _sendMessage and _sendSticker
    send_message_block = """  void _sendMessage(String text) {
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
  }"""
    
    replacement_send = """  void _sendPayload(String payload) {
    final username = widget.username ?? '@partner_dev';
    final activeUser = context.read<AccountManager>().currentUser;
    final senderName = activeUser?.anonymousUsername ?? 'You';

    context.read<ChatModel>().sendMessage(
      username,
      payload,
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

  void _sendMessage(String text) => _sendPayload(text);
  void _sendSticker(String assetPath) => _sendPayload('[STICKER]:$assetPath');"""
    
    if send_message_block in content:
        content = content.replace(send_message_block, replacement_send)
        print("Replaced _sendMessage and _sendSticker")

    # 2. Refactor _showMemoriesPopup and _showChatLogPopup
    dialog_helper = """  void _showCustomDialog({
    required BuildContext context,
    required Color themeColor,
    required IconData icon,
    required String title,
    required Widget contentWidget,
  }) {
    final themeProvider = context.read<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final currentBg = isDark ? AmomimusDarkTheme.backgroundDark : Colors.grey[100];
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondary = isDark ? AmomimusDarkTheme.textSecondary : Colors.black54;

    showJellyDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: currentBg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: themeColor.withOpacity(0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
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
                        Icon(icon, color: themeColor),
                        const SizedBox(width: 8),
                        Text(
                          title,
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
                contentWidget,
              ],
            ),
          ),
        );
      },
    );
  }"""

    # I'll just leave the dialog refactor for manual replacement using replace_file_content 
    # to avoid complex string matching in python. 
    # Or just write it back to the file now.
    
    with open('lib/screens/roomchat.dart', 'w', encoding='utf-8') as f:
        f.write(content)

if __name__ == '__main__':
    refactor_roomchat()
