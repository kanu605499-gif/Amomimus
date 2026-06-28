import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/account_manager.dart';
import '../../models/user_credentials_model.dart';
import '../amomimusdark.dart';
import '../widgets/settings/blocked_users_section.dart';
import '../widgets/settings/security_auth_section.dart';
import '../widgets/settings/delete_account_dialog.dart';
import 'package:amomimus/i18n/strings.g.dart';
import 'package:amomimus/utils/jelly_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  UserCredentialsModel? _credentials;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final am = Provider.of<AccountManager>(context, listen: false);
    final user = am.currentUser;
    if (user != null) {
      final creds = await am.authService.getCredentials(user.email);
      setState(() {
        _credentials = creds;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _showDeleteAccountDialog() {
    if (_credentials == null) return;
    showJellyDialog(
      context: context,
      builder: (_) => DeleteAccountDialog(credentials: _credentials!),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final bgColor = isDark ? AmomimusDarkTheme.surfaceDark : Colors.white;
    final textColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;

    final am = Provider.of<AccountManager>(context);
    final currentUser = am.currentUser;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // remove back arrow
          iconTheme: IconThemeData(color: textColor),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null || _credentials == null) {
      return Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: Text(
            t.error_loading_account_data,
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // remove back arrow
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          t.privacy_settings,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Blocked Users
            BlockedUsersSection(currentUser: currentUser),

            const SizedBox(height: 32),
            Divider(color: textColor.withOpacity(0.3)),
            const SizedBox(height: 32),

            // 2. Security & Auth (Favorite Character / Reset Passcode)
            SecurityAuthSection(credentials: _credentials!),

            const SizedBox(height: 32),
            Divider(color: textColor.withOpacity(0.3)),
            const SizedBox(height: 32),

          if (am.isMasterProfile) ...[
            // 3. Danger Zone
            Text(
              t.danger_zone,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.delete_account_warning,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: _showDeleteAccountDialog,
                    child: Text(
                      t.delete_account,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
          ],
        ),
      ),
    );
  }
}
