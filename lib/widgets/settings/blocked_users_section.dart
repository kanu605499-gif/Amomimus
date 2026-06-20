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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.blocked_users,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (currentUser.blockedUsers.isEmpty)
          Text(
            t.no_blocked_users,
            style: TextStyle(color: subTextColor, fontStyle: FontStyle.italic),
          )
        else
          ...currentUser.blockedUsers.map(
            (id) => _buildUserRow(context, id, true, am, cardColor, textColor),
          ),

        const SizedBox(height: 24),
        Text(
          t.previously_blocked,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (currentUser.exBlockedUsers.isEmpty)
          Text(
            t.no_previous_blocks,
            style: TextStyle(color: subTextColor, fontStyle: FontStyle.italic),
          )
        else
          ...currentUser.exBlockedUsers.map(
            (id) => _buildUserRow(context, id, false, am, cardColor, textColor),
          ),
      ],
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
