import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/account_manager.dart';
import '../../services/chatmodel.dart';
import '../../amomimusdark.dart';
import '../../models/user_credentials_model.dart';
import '../../screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amomimus/i18n/strings.g.dart';
class DeleteAccountDialog extends StatefulWidget {
  final UserCredentialsModel credentials;

  const DeleteAccountDialog({super.key, required this.credentials});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _passcodeController = TextEditingController();
  final _favCharController = TextEditingController();
  final _reasonController = TextEditingController();
  String? _errorText;
  bool _isLoading = false;

  void _verifyAndDelete() async {
    final pass = _passcodeController.text.trim();
    final fav = _favCharController.text.trim();
    final am = Provider.of<AccountManager>(context, listen: false);

    final isGoogleUser = FirebaseAuth.instance.currentUser?.providerData
        .any((provider) => provider.providerId == 'google.com') ?? false;

    if (!isGoogleUser && pass.isEmpty) {
      setState(() => _errorText = Translations.of(context).error_loading_account_data); // Fallback
      return;
    }
    if (fav.isEmpty) {
      setState(() => _errorText = "Favorite character is required.");
      return;
    }

    if (fav.toLowerCase() != (widget.credentials.favoriteCharacter ?? '').toLowerCase()) {
      setState(() => _errorText = "Incorrect favorite character.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    // 1. Re-authenticate
    final reauthSuccess = await am.reauthenticate(isGoogleUser ? null : pass);
    if (!reauthSuccess) {
      setState(() {
        _isLoading = false;
        _errorText = "Authentication failed. Please try again.";
      });
      return;
    }

    // 2. Proceed with deletion
    final amomimusId = am.currentUser?.amomimusId;
    if (amomimusId != null) {
      Provider.of<ChatModel>(context, listen: false).clearAllChatsForUser(amomimusId);
    }
    await am.deleteAccount(widget.credentials.email ?? '');

    if (mounted) {
      // Send user to splash screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SplashScreen(isShutdown: true)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final textColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final hintColor = textColor.withOpacity(0.6);

    final isGoogleUser = FirebaseAuth.instance.currentUser?.providerData
        .any((provider) => provider.providerId == 'google.com') ?? false;

    return AlertDialog(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      title: Text(
        t.delete_account,
        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.delete_account_warning,
              style: TextStyle(color: textColor),
            ),
            const SizedBox(height: 16),
            if (!isGoogleUser) ...[
              TextField(
                controller: _passcodeController,
                obscureText: true,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: t.passcode,
                  hintText: t.passcode_hint_security,
                  hintStyle: TextStyle(color: hintColor, fontSize: 12),
                  labelStyle: TextStyle(color: hintColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: hintColor),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            TextField(
              controller: _favCharController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: t.favorite_character,
                hintText: t.favorite_char_hint_security,
                hintStyle: TextStyle(color: hintColor, fontSize: 12),
                labelStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: hintColor),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Reason for leaving (Optional)",
                labelStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: hintColor),
                ),
              ),
              maxLines: 2,
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorText!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: hintColor)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: _isLoading ? null : _verifyAndDelete,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  isGoogleUser ? t.reauthenticate_with_google : "Delete permanently",
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }
}
