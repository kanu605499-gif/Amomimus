
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../i18n/strings.g.dart';
import '../amomimusdark.dart';
import '../services/account_manager.dart';
import 'dart:async';

enum BugCategory { uiGlitch, appCrash, featureNotWorking, other }

class BugCategoryHelper {
  static String getLabel(BugCategory category, Translations t) {
    switch (category) {
      case BugCategory.uiGlitch:
        return t.bug_category_ui;
      case BugCategory.appCrash:
        return t.bug_category_crash;
      case BugCategory.featureNotWorking:
        return t.bug_category_feature;
      case BugCategory.other:
        return t.bug_category_other;
    }
  }
}

class ReportBugDialog extends StatefulWidget {
  const ReportBugDialog({super.key});

  @override
  State<ReportBugDialog> createState() => _ReportBugDialogState();
}

class _ReportBugDialogState extends State<ReportBugDialog> {
  BugCategory _selectedCategory = BugCategory.uiGlitch;
  final TextEditingController _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    setState(() => _isSubmitting = true);

    final accountManager = context.read<AccountManager>();
    final success = await accountManager.submitBugReport(
      _selectedCategory.toString(),
      comment,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100.0, left: 24.0, right: 24.0),
        content: Text(
          success ? t.bug_report_success : t.bug_report_fail_limit,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );

    if (success) {
      Navigator.of(context).pop();
    }
  }

  String _getWaitTime(DateTime lastDate) {
    final now = DateTime.now();
    final resetDate = lastDate.add(const Duration(days: 7));
    if (now.isAfter(resetDate)) return '0d 0h';
    final diff = resetDate.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    return '${days}d ${hours}h';
  }

  @override
  Widget build(BuildContext context) {
    final amomimusTheme = context.read<AmomimusDarkTheme>();
    final t = Translations.of(context);
    final isDark = amomimusTheme.isDarkMode;
    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accentColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
        
    final accountManager = context.watch<AccountManager>();
    final currentUser = accountManager.currentUser;

    // Read real count from user model, reset if over 7 days
    int currentCount = currentUser?.bugReportWeeklyCount ?? 0;
    DateTime? lastDate;
    if (currentUser?.lastBugReportDate != null) {
      lastDate = DateTime.tryParse(currentUser!.lastBugReportDate!);
      if (lastDate != null && DateTime.now().difference(lastDate).inDays >= 7) {
        currentCount = 0;
        lastDate = null;
      }
    }

    final remainingSlots = 3 - currentCount;
    final isLimitReached = remainingSlots <= 0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            if (isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report_rounded, color: accentColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    t.report_bug,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: textColor.withOpacity(0.6)),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t.bug_report_describe,
              style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 14),
            ),
            const SizedBox(height: 16),
            
            // Limit Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isLimitReached ? Colors.red.withOpacity(0.1) : accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isLimitReached ? Colors.red.withOpacity(0.3) : accentColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isLimitReached ? Icons.timer : Icons.assessment_outlined, 
                    color: isLimitReached ? Colors.red : accentColor, 
                    size: 16
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isLimitReached && lastDate != null 
                        ? "${t.bug_report_wait} ${_getWaitTime(lastDate)}"
                        : '$remainingSlots / 3',
                      style: TextStyle(
                        color: isLimitReached ? Colors.red : textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            if (!isLimitReached) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey[300]!,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<BugCategory>(
                    value: _selectedCategory,
                    isExpanded: true,
                    dropdownColor: isDark ? AmomimusDarkTheme.surfaceDark : Colors.white,
                    icon: Icon(Icons.keyboard_arrow_down, color: accentColor),
                    items: BugCategory.values.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          BugCategoryHelper.getLabel(category, t),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCategory = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _commentController,
                maxLines: 4,
                maxLength: 500,
                style: TextStyle(color: textColor, fontSize: 14),
                onChanged: (v) => setState(() {}),
                decoration: InputDecoration(
                  hintText: '...',
                  hintStyle: TextStyle(
                    color: textColor.withOpacity(0.4),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: accentColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  counterStyle: TextStyle(
                    color: textColor.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: (_commentController.text.trim().isEmpty || _isSubmitting)
                      ? null
                      : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: isDark
                        ? Colors.white12
                        : Colors.grey[300],
                  ),
                  child: _isSubmitting 
                    ? const SizedBox(
                        height: 20, width: 20, 
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                      )
                    : Text(
                        t.submit_report,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              Center(
                child: Text(
                  isDark 
                    ? ((t as dynamic).magick_depleted ?? 'Magick depleted.') 
                    : ((t as dynamic).report_limit_reached ?? 'Report limit reached.'),
                  style: TextStyle(color: textColor.withOpacity(0.5)),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
