import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';
import '../../models/user_model.dart';
import '../../services/account_manager.dart';
import '../../services/chat_request_manager.dart';
import '../../services/chatmodel.dart';
import '../../helpers/gender_helpers.dart';

void showRequestsBottomSheet(
  BuildContext context,
  ChatRequestManager reqManager,
  AmomimusDarkTheme themeProvider,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final isDark = themeProvider.isDarkMode;
      final bgCol = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
      final textCol = isDark ? Colors.white : Colors.black87;

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(ctx).size.height * 0.65,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: bgCol,
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
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              t.incoming_requests,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textCol,
              ),
            ),
            const SizedBox(height: 16),
            if (reqManager.incomingRequests.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  t.no_incoming_requests,
                  style: TextStyle(color: textCol.withValues(alpha: 0.6)),
                ),
              ),
            
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  ...reqManager.incomingRequests.where((req) {
                    final accountManager = context.read<AccountManager>();
                    final blockedUsers = accountManager.currentUser?.blockedUsers ?? [];
                    final blockedBy = accountManager.currentUser?.blockedBy ?? [];
                    return !blockedUsers.contains(req.senderId) && !blockedBy.contains(req.senderId);
                  }).map((req) {
                    final accountManager = context.read<AccountManager>();
                    final senderAccount = accountManager.accounts.firstWhere(
                      (acc) => acc.amomimusId == req.senderId,
                      orElse: () => UserAccount(
                        email: '',
                        realUsername: '',
                        anonymousUsername: '',
                        amomimusId: '',
                        gender: 'Amo',
                        registrationDate: '',
                        isDemo: false,
                      ),
                    );
                    final senderGender = senderAccount.gender;
                    final senderIcon = GenderHelpers.getGenderIcon(senderGender);
                    final senderColor = GenderHelpers.getGenderColor(senderGender);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: senderColor, width: 1.5),
                        ),
                        child: Icon(senderIcon, color: senderColor, size: 22),
                      ),
                      title: Text(
                        senderAccount.anonymousUsername.isNotEmpty
                            ? senderAccount.anonymousUsername
                            : req.senderName,
                        style: TextStyle(color: textCol, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'ID: ${req.senderId}',
                        style: TextStyle(
                          color: textCol.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.redAccent),
                            onPressed: () {
                              reqManager.rejectRequest(req.id);
                              Navigator.pop(ctx);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              reqManager.acceptRequest(req.id);
                              context.read<ChatModel>().sendMessage(
                                req.senderId,
                                t.chat_req_accepted,
                                targetName: req.senderName,
                              );
                              Navigator.pop(ctx);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
                  
                ],
              ),
            ),
          ],
        ),
      ),
      );
    },
  );
}

