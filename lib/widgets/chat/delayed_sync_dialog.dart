import 'package:flutter/material.dart';
import '../../amomimusdark.dart';
import '../../i18n/strings.g.dart';

import 'package:provider/provider.dart';

class DelayedSyncDialog extends StatelessWidget {
  final String sourceType;
  const DelayedSyncDialog({super.key, this.sourceType = 'chat'});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AmomimusDarkTheme>();
    final isDark = themeProvider.isDarkMode;
    final t = Translations.of(context);

    return Dialog(
      backgroundColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: AmomimusDarkTheme.primaryPurple.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.wifi_tethering_error_rounded,
                  color: AmomimusDarkTheme.policeLineYellow,
                  size: 28,
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              sourceType == 'feed'
                  ? t.delayed_sync_feed_title
                  : t.delayed_sync_title,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              sourceType == 'feed'
                  ? t.delayed_sync_feed_msg
                  : t.delayed_sync_msg,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.black54,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
