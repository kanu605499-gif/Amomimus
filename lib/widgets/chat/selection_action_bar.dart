import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../i18n/strings.g.dart';
import '../../models/message_model.dart';
import '../../services/chatmodel.dart';
import '../../amomimusdark.dart';
import 'package:amomimus/utils/jelly_dialog.dart';

class SelectionActionBar extends StatelessWidget {
  final List<String> selectedMessageIds;
  final List<ChatMessage> messages;
  final String targetUsername;
  final VoidCallback onClearSelection;

  const SelectionActionBar({
    super.key,
    required this.selectedMessageIds,
    required this.messages,
    required this.targetUsername,
    required this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final t = Translations.of(context);

    final bool allPending = selectedMessageIds.every((id) {
      final msg = messages.firstWhere(
        (m) => m.id == id,
        orElse: () => ChatMessage(text: '', senderId: '', timeStamp: ''),
      );
      return msg.showResendOptions;
    });

    final Color dynamicOutlineColor = themeProvider.isDarkMode
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black87.withValues(alpha: 0.15);

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: themeProvider.isDarkMode 
            ? Colors.black54 
            : const Color.fromARGB(221, 255, 255, 255),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: dynamicOutlineColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeProvider.isDarkMode ? 0.2 : 0.05,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClearSelection,
            ),
            const SizedBox(width: 8),
            Text(
              "${selectedMessageIds.length} Selected",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 16),
            if (allPending)
              TextButton.icon(
                icon: Icon(
                  Icons.refresh,
                  size: 18,
                  color: themeProvider.isDarkMode ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                ),
                label: Text(
                  t.resend,
                  style: TextStyle(color: themeProvider.isDarkMode ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple),
                ),
                onPressed: () {
                  _showResendDialog(context, themeProvider, t);
                },
              ),
            TextButton.icon(
              icon: const Icon(
                Icons.delete_outline,
                size: 18,
                color: Colors.redAccent,
              ),
              label: Text(
                t.delete_selected,
                style: const TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                _showDeleteDialog(context, themeProvider, t);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResendDialog(
    BuildContext context,
    AmomimusDarkTheme themeProvider,
    Translations t,
  ) {
    showJellyDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode
            ? AmomimusDarkTheme.surfaceDark
            : Colors.white,
        title: Text(t.resend_confirm_title),
        content: Text(t.resend_confirm_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              t.cancel,
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatModel>().resendSelectedMessages(
                targetUsername,
                selectedMessageIds,
                context,
              );
              onClearSelection();
            },
            child: Text(
              t.resend,
              style: TextStyle(color: themeProvider.isDarkMode ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    AmomimusDarkTheme themeProvider,
    Translations t,
  ) {
    showJellyDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: themeProvider.isDarkMode
            ? AmomimusDarkTheme.surfaceDark
            : Colors.white,
        title: Text(t.delete_chat_title),
        content: Text(t.delete_confirm_desc),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              t.cancel,
              style: TextStyle(color: themeProvider.isDarkMode ? Colors.white70 : Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ChatModel>().deleteSelectedMessages(
                targetUsername,
                selectedMessageIds,
              );
              onClearSelection();
            },
            child: Text(
              t.delete,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
