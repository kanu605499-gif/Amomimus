import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../amomimusdark.dart';
import '../../services/account_manager.dart';
import '../../services/chatmodel.dart';
import '../../helpers/gender_helpers.dart';
import '../../screens/master_account_screen.dart';
import 'package:amomimus/i18n/strings.g.dart';

void showAccountSwitchSheet(BuildContext context) {
  final t = Translations.of(context);
  final themeProvider = context.read<AmomimusDarkTheme>();
  final accountManager = context.read<AccountManager>();
  final accounts = List.of(accountManager.switchableAccounts);

  accounts.sort((a, b) {
    if (a.amomimusId == accountManager.currentUser?.amomimusId) return -1;
    if (b.amomimusId == accountManager.currentUser?.amomimusId) return 1;
    return 0;
  });

  final isDark = themeProvider.isDarkMode;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final sheetBg = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
      final textCol = isDark ? Colors.white : Colors.black87;
      final subCol = isDark ? AmomimusDarkTheme.textSecondary : Colors.black54;

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(ctx).size.height * 0.5,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.switch_account,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textCol,
              ),
            ),
            const SizedBox(height: 16),
            if (accounts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  t.no_accounts_registered,
                  style: TextStyle(color: subCol),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 225),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: accounts.map((acc) {
                      final isActive = acc.amomimusId == accountManager.currentUser?.amomimusId;
                      final genderColor = GenderHelpers.getGenderColor(acc.gender);
                      final genderIcon = GenderHelpers.getGenderIcon(acc.gender);

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () async {
                            await accountManager.switchAccount(acc);
                            // Sync ChatModel with the new account
                            if (ctx.mounted) {
                              ctx.read<ChatModel>().setCurrentUser(
                                acc.amomimusId,
                                acc.anonymousUsername,
                              );
                              Navigator.pop(ctx);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? genderColor.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isActive
                                    ? genderColor.withValues(alpha: 0.8)
                                    : (isDark ? Colors.white12 : Colors.black12),
                                width: isActive ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: genderColor,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Icon(
                                    genderIcon,
                                    color: genderColor,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        acc.anonymousUsername,
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: textCol,
                                        ),
                                      ),
                                      Text(
                                        '${acc.amomimusId} · ${acc.gender}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: genderColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isActive)
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: genderColor,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: genderColor.withValues(alpha: 0.4),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            if (accounts.length < 3)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MasterAccountScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: isDark
                        ? AmomimusDarkTheme.policeLineYellow
                        : AmomimusDarkTheme.primaryPurple,
                  ),
                  label: Text(
                    t.add_profile,
                    style: TextStyle(
                      color: isDark
                          ? AmomimusDarkTheme.policeLineYellow
                          : AmomimusDarkTheme.primaryPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
      );
    },
  );
}


