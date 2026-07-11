import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../services/account_manager.dart';
import '../../services/chat_request_manager.dart';
import '../../amomimusdark.dart';
import '../../i18n/strings.g.dart';
import '../../services/chatmodel.dart';
import 'dart:async';

class BlockedUsersSection extends StatelessWidget {
  final UserAccount currentUser;

  const BlockedUsersSection({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final am = Provider.of<AccountManager>(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final textColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final subTextColor = textColor.withOpacity(0.7);
    final cardColor = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildExpandableSection(
          context: context,
          title: t.blocked_users,
          isEmpty: currentUser.blockedUsers.isEmpty,
          emptyMessage: t.no_blocked_users,
          items: currentUser.blockedUsers,
          isCurrentlyBlocked: true,
          am: am,
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
        const SizedBox(height: 16),
        _buildExpandableSection(
          context: context,
          title: t.previously_blocked,
          isEmpty: currentUser.exBlockedUsers.isEmpty,
          emptyMessage: t.no_previous_blocks,
          items: currentUser.exBlockedUsers,
          isCurrentlyBlocked: false,
          am: am,
          cardColor: cardColor,
          textColor: textColor,
          subTextColor: subTextColor,
        ),
      ],
    );
  }

  Widget _buildExpandableSection({
    required BuildContext context,
    required String title,
    required bool isEmpty,
    required String emptyMessage,
    required List<String> items,
    required bool isCurrentlyBlocked,
    required AccountManager am,
    required Color? cardColor,
    required Color textColor,
    required Color subTextColor,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Card(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: textColor.withOpacity(0.3)),
        ),
        child: ExpansionTile(
          iconColor: textColor,
          collapsedIconColor: textColor,
          title: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            if (isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
                child: Text(
                  emptyMessage,
                  style: TextStyle(color: subTextColor, fontStyle: FontStyle.italic),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 380),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return _buildUserRow(context, items[index], isCurrentlyBlocked, am, Colors.transparent, textColor);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow(
    BuildContext context,
    String rawEntry,
    bool isCurrentlyBlocked,
    AccountManager am,
    Color? cardColor,
    Color textColor,
  ) {
    final t = Translations.of(context);
    final displayId = rawEntry.split('|').first;
    final user = am.getAccountById(displayId);
    final displayName = user?.anonymousUsername ?? "Unknown User";

    return Card(
      color: cardColor,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: textColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isCurrentlyBlocked
                  ? Colors.redAccent.withOpacity(0.2)
                  : textColor.withOpacity(0.2),
              child: Icon(
                isCurrentlyBlocked ? Icons.block : Icons.history,
                color: isCurrentlyBlocked ? Colors.redAccent : textColor,
              ),
            ),
            title: Text(
              displayName,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayId,
                  style: TextStyle(color: textColor.withOpacity(0.6)),
                ),
                if (!isCurrentlyBlocked)
                  _ExBlockedCountdownTimer(targetId: displayId, textColor: Colors.redAccent),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 12.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: isCurrentlyBlocked
                  ? OutlinedButton(
                      onPressed: () => am.unblockUser(displayId),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      child: Text(
                        t.unblock,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: () {
                        am.blockUser(displayId);
                        Provider.of<ChatModel>(
                          context,
                          listen: false,
                        ).wipeRoomDueToBlock(displayId);
                        Provider.of<ChatRequestManager>(
                          context,
                          listen: false,
                        ).deleteRequestWith(displayId);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: textColor),
                      ),
                      child: Text(
                        t.block_again,
                        style: TextStyle(color: textColor),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExBlockedCountdownTimer extends StatefulWidget {
  final String targetId;
  final Color textColor;

  const _ExBlockedCountdownTimer({required this.targetId, required this.textColor});

  @override
  State<_ExBlockedCountdownTimer> createState() => _ExBlockedCountdownTimerState();
}

class _ExBlockedCountdownTimerState extends State<_ExBlockedCountdownTimer> {
  Timer? _timer;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    if (!mounted) return;
    final am = Provider.of<AccountManager>(context, listen: false);
    final remaining = am.getUnblockTimeRemaining(widget.targetId);
    setState(() {
      _remaining = remaining;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining == null || _remaining!.isNegative) return const SizedBox.shrink();

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(_remaining!.inHours);
    final minutes = twoDigits(_remaining!.inMinutes.remainder(60));
    final seconds = twoDigits(_remaining!.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        "$hours:$minutes:$seconds",
        style: TextStyle(
          color: widget.textColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
          fontSize: 13,
        ),
      ),
    );
  }
}
