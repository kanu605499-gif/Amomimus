import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../amomimusdark.dart';
import '../language/language_manager.dart';

class ChatRequestDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final String targetUserName;
  final String myRegisteredName;
  final String myTemporaryName;

  const ChatRequestDialog({
    super.key, 
    required this.onConfirm,
    required this.targetUserName,
    required this.myRegisteredName,
    required this.myTemporaryName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
            ),
            const SizedBox(height: 16),
            Text(
              context.watch<LanguageManager>().getString('chat_request_title'),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AmomimusDarkTheme.primaryPurple : AmomimusDarkTheme.policeLineYellow,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AmomimusDarkTheme.textSecondary : Colors.black54,
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: context.watch<LanguageManager>().getString('chat_request_desc1')),
                  TextSpan(
                    text: myRegisteredName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                    ),
                  ),
                  TextSpan(text: context.watch<LanguageManager>().getString('chat_request_desc2')),
                  TextSpan(
                    text: myTemporaryName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? AmomimusDarkTheme.primaryPurple : AmomimusDarkTheme.policeLineYellow,
                    ),
                  ),
                  TextSpan(text: context.watch<LanguageManager>().getString('chat_request_desc3')),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    context.watch<LanguageManager>().getString('cancel'),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple,
                    foregroundColor: isDark ? AmomimusDarkTheme.primaryPurple : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    context.watch<LanguageManager>().getString('send_request'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
