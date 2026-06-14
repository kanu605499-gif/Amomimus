import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/account_manager.dart';
import '../../amomimusdark.dart';
import '../../database/models/user_register_sql.dart';
import '../../screens/splash_screen.dart';

class DeleteAccountDialog extends StatefulWidget {
  final UserModelSql credentials;

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
    
    if (pass.isEmpty || fav.isEmpty) {
      setState(() => _errorText = "Passcode and favorite character are required.");
      return;
    }

    if (pass != widget.credentials.password || fav.toLowerCase() != (widget.credentials.favoriteCharacter ?? '').toLowerCase()) {
      setState(() => _errorText = "Incorrect passcode or favorite character.");
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    // Proceed with deletion
    final am = Provider.of<AccountManager>(context, listen: false);
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
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final textColor = isDark ? AmomimusDarkTheme.policeLineYellow : AmomimusDarkTheme.primaryPurple;
    final hintColor = textColor.withOpacity(0.6);

    return AlertDialog(
      backgroundColor: isDark ? AmomimusDarkTheme.backgroundDark : Colors.white,
      title: Text("Delete Account", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("This action is irreversible.", style: TextStyle(color: textColor)),
            const SizedBox(height: 16),
            TextField(
              controller: _passcodeController,
              obscureText: true,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Passcode",
                labelStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hintColor)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _favCharController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Favorite Character",
                labelStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hintColor)),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                labelText: "Reason for leaving (Optional)",
                labelStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hintColor)),
              ),
              maxLines: 2,
            ),
            if (_errorText != null) ...[
              const SizedBox(height: 16),
              Text(_errorText!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
            ]
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
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text("Delete permanently", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}
