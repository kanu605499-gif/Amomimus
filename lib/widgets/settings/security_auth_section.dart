import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/account_manager.dart';
import '../../models/user_credentials_model.dart';
import '../../amomimusdark.dart';
import 'package:amomimus/i18n/strings.g.dart';

class SecurityAuthSection extends StatefulWidget {
  final UserCredentialsModel credentials;

  const SecurityAuthSection({super.key, required this.credentials});

  @override
  State<SecurityAuthSection> createState() => _SecurityAuthSectionState();
}

class _SecurityAuthSectionState extends State<SecurityAuthSection> {
  final _favCharController = TextEditingController();
  final _newPasscodeController = TextEditingController();
  bool _isEditingFavChar = false;
  bool _isResettingPasscode = false;
  bool _isLoading = false;

  void _saveFavChar() async {
    final newChar = _favCharController.text.trim();
    if (newChar.isEmpty) return;

    setState(() => _isLoading = true);
    final am = Provider.of<AccountManager>(context, listen: false);
    final success = await am.updateFavoriteCharacter(newChar);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _isEditingFavChar = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text("Can only edit once every 24 hours!")),
          );
        }
      });
    }
  }

  void _resetPasscode() async {
    final favInput = _favCharController.text.trim();
    final newPass = _newPasscodeController.text.trim();

    if (favInput.isEmpty || newPass.isEmpty) return;

    if (favInput.toLowerCase() !=
        (widget.credentials.favoriteCharacter ?? '').toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text("Incorrect favorite character.")),
      );
      return;
    }

    setState(() => _isLoading = true);
    final am = Provider.of<AccountManager>(context, listen: false);
    final success = await am.resetPassword(newPass);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _isResettingPasscode = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 100, left: 24, right: 24),content: Text("Passcode successfully reset.")),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final t = Translations.of(context);
    final isDark = Provider.of<AmomimusDarkTheme>(context).isDarkMode;
    final textColor = isDark
        ? AmomimusDarkTheme.policeLineYellow
        : AmomimusDarkTheme.primaryPurple;
    final cardColor = isDark ? AmomimusDarkTheme.backgroundDark : Colors.white;
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: isDark
          ? AmomimusDarkTheme.policeLineYellow
          : AmomimusDarkTheme.primaryPurple,
      foregroundColor: isDark ? Colors.black : Colors.white,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.security, color: textColor, size: 24),
            const SizedBox(width: 8),
            Text(
              t.security_auth,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Favorite Character View/Edit
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: textColor.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.favorite_character,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (!_isEditingFavChar) ...[
                Text(
                  widget.credentials.favoriteCharacter ?? "None",
                  style: TextStyle(color: textColor.withOpacity(0.8)),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    _favCharController.text =
                        widget.credentials.favoriteCharacter ?? "";
                    setState(() => _isEditingFavChar = true);
                  },
                  child: Text(t.edit_max_1_day),
                ),
              ] else ...[
                TextField(
                  controller: _favCharController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "New Favorite Character",
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => _isEditingFavChar = false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: _isLoading ? null : _saveFavChar,
                      child: _isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            )
                          : const Text("Save"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Reset Passcode
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: textColor.withOpacity(0.4), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.forget_passcode,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (!_isResettingPasscode) ...[
                Text(
                  t.reset_passcode_hint,
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: buttonStyle,
                  onPressed: () {
                    _favCharController.clear();
                    _newPasscodeController.clear();
                    setState(() => _isResettingPasscode = true);
                  },
                  child: Text(t.reset_passcode),
                ),
              ] else ...[
                TextField(
                  controller: _favCharController,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Favorite Character",
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _newPasscodeController,
                  style: TextStyle(color: textColor),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Passcode",
                    labelStyle: TextStyle(color: textColor.withOpacity(0.7)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: textColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () =>
                          setState(() => _isResettingPasscode = false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: _isLoading ? null : _resetPasscode,
                      child: _isLoading
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            )
                          : const Text("Reset"),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
