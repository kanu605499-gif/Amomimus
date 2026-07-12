import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../amomimusdark.dart';
import '../models/report_model.dart';
import '../services/account_manager.dart';
import '../services/chat_request_manager.dart';
import '../services/chatmodel.dart';
import '../utils/jelly_dialog.dart';

class ReportDialog extends StatefulWidget {
  final String targetId; // can be a messageId or userId
  final bool
  isUserReport; // true if reporting user profile, false if reporting message

  const ReportDialog({
    super.key,
    required this.targetId,
    this.isUserReport = false,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  ReportCategory _selectedCategory = ReportCategory.spamHarassment;
  final TextEditingController _commentController = TextEditingController();
  bool _banUser = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final comment = _commentController.text.trim();
    if (_banUser && comment.isEmpty) {
      // Should not happen as checkbox is disabled if comment is empty
      return;
    }

    final accountManager = context.read<AccountManager>();

    final blockReason = await accountManager.submitReport(
      widget.targetId,
      _selectedCategory,
      isChatBubbleReport: !widget.isUserReport,
      description: comment,
    );

    if (blockReason != null) {
      if (mounted) {
        // Token limit reached — inform user that only local perspective was updated
        final t = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              blockReason == 'daily_limit_reached'
                  ? t.report_limit_daily
                  : blockReason == 'category_limit_reached'
                      ? t.report_limit_category
                      : blockReason == 'weekly_hate_speech_limit'
                          ? t.report_limit_weekly_hate_speech
                          : t.report_limit_global,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    if (_banUser) {
      // Block the user locally. We assume targetId for isUserReport is the realAuthorId/userId.
      accountManager.blockUser(widget.targetId);
      if (mounted) {
        Provider.of<ChatModel>(
          context,
          listen: false,
        ).wipeRoomDueToBlock(widget.targetId);
        Provider.of<ChatRequestManager>(
          context,
          listen: false,
        ).deleteRequestWith(widget.targetId);
      }
    }

    if (!mounted) return;

    final amomimusTheme = context.read<AmomimusDarkTheme>();
    final t = Translations.of(context);
    final isDark = amomimusTheme.isDarkMode;
    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accentColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    await showJellyDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: accentColor,
                size: 54,
              ),
              const SizedBox(height: 16),
              Text(
                t.report_submitted,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _banUser
                    ? t.report_sent_user_blocked
                    : t.thank_you_safe,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    t.close,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (mounted) {
      Navigator.pop(context, true); // true = success
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final amomimusTheme = Provider.of<AmomimusDarkTheme>(context);
    final isDark = amomimusTheme.isDarkMode;

    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final textSecondaryColor = isDark ? Colors.white70 : Colors.black54;
    final accentColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final borderColor = isDark ? Colors.white24 : Colors.black12;

    return Dialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.isUserReport ? t.report_user : t.report_message,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              t.select_category,
              style: TextStyle(color: textSecondaryColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: ReportCategory.values.map((category) {
                  return RadioListTile<ReportCategory>(
                    title: Text(
                      ReportCategoryHelper.getLabel(category, t),
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                    value: category,
                    groupValue: _selectedCategory,
                    activeColor: accentColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.detailed_comment,
              style: TextStyle(color: textSecondaryColor, fontSize: 14),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.newline,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: true,
              maxLines: 3,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: t.provide_details,
                hintStyle: TextStyle(
                  color: textSecondaryColor.withValues(alpha: 0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: accentColor),
                ),
              ),
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Theme(
              data: ThemeData(unselectedWidgetColor: textSecondaryColor),
              child: CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                activeColor: accentColor,
                title: Text(
                  t.block_ban_user,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  t.comment_required_ban,
                  style: TextStyle(color: textSecondaryColor, fontSize: 12),
                ),
                value: _banUser,
                onChanged: _commentController.text.trim().isEmpty
                    ? null
                    : (val) {
                        setState(() => _banUser = val ?? false);
                      },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    t.cancel,
                    style: TextStyle(color: textSecondaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(t.submit_report),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
